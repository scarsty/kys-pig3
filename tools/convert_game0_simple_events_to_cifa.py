from __future__ import annotations

import argparse
from pathlib import Path

import convert_lua_events_no_goto_to_cifa as base


def line_code(line: str) -> str:
    return base.split_comment(line)[0].strip().rstrip(";")


def is_exit(line: str) -> bool:
    return line_code(line).lower() == "exit()"


def convert_lines(lines: list[str]) -> list[str]:
    non_empty = [line for line in lines if line.strip()]
    common_indent = min((len(line) - len(line.lstrip()) for line in non_empty), default=0)
    output: list[str] = []
    for line in lines:
        statement = base.convert_statement(line[common_indent:].rstrip())
        if statement.strip():
            output.extend(statement.splitlines())
    return output


def finish_output(output: list[str]) -> str:
    cleaned: list[str] = []
    index = 0
    while index < len(output):
        if output[index].strip() == "} else {" and index + 1 < len(output) and output[index + 1].strip() == "}":
            cleaned.append(output[index].replace("else {", "").rstrip())
            index += 2
            continue
        cleaned.append(output[index])
        index += 1
    return "\n".join(cleaned).rstrip() + "\n"


def strip_section_exit(lines: list[str]) -> tuple[list[str], bool]:
    depths = base.lua_nesting_depths(lines)
    exit_indexes = [index for index, line in enumerate(lines) if is_exit(line)]
    if any(depths[index] != 0 for index in exit_indexes):
        raise base.ConvertError("exit inside Lua block")
    non_empty = [index for index, line in enumerate(lines) if line.strip()]
    if not exit_indexes:
        return lines, False
    if not non_empty or exit_indexes != [non_empty[-1]]:
        raise base.ConvertError("non-terminal exit")
    return lines[: exit_indexes[0]], True


def find_control_flow(lines: list[str]) -> tuple[dict[str, int], list[tuple[int, str, str]]]:
    depths = base.lua_nesting_depths(lines)
    labels: dict[str, int] = {}
    jumps: list[tuple[int, str, str]] = []
    for index, (line, depth) in enumerate(zip(lines, depths)):
        code, _comment = base.split_comment(line)
        label_match = base.GOTO_LABEL_PATTERN.match(code)
        jump_match = base.CONDITIONAL_GOTO_PATTERN.match(code)
        if "goto" in code and not jump_match:
            raise base.ConvertError("unsupported goto syntax")
        if label_match:
            if depth != 0:
                raise base.ConvertError("goto label is inside a Lua block")
            label = label_match.group(1)
            if label in labels:
                raise base.ConvertError("duplicate goto label")
            labels[label] = index
        elif jump_match:
            if depth != 0:
                raise base.ConvertError("goto is inside a Lua block")
            jumps.append((index, jump_match.group(1), jump_match.group(2)))

    return labels, jumps


def prune_unreachable_lines(lines: list[str]) -> list[str]:
    labels, _jumps = find_control_flow(lines)
    reachable: set[int] = set()
    pending = [0] if lines else []
    while pending:
        index = pending.pop()
        if index in reachable or index >= len(lines):
            continue
        reachable.add(index)
        code, _comment = base.split_comment(lines[index])
        jump_match = base.CONDITIONAL_GOTO_PATTERN.match(code)
        if is_exit(lines[index]):
            continue
        if jump_match:
            target_label = jump_match.group(2)
            if target_label not in labels:
                raise base.ConvertError("unknown goto label")
            pending.append(labels[target_label])
        pending.append(index + 1)
    return [line for index, line in enumerate(lines) if index in reachable]


def validate_supported(lines: list[str]) -> None:
    text = "\n".join(lines)
    unsupported = base.find_unsupported(text)
    if unsupported:
        raise base.ConvertError(unsupported)
    if "instruct_50" in text.lower():
        raise base.ConvertError("legacy instruct_50")


def validate_control_flow_body(lines: list[str]) -> None:
    body = []
    for line in lines:
        code, _comment = base.split_comment(line)
        if is_exit(line) or base.GOTO_LABEL_PATTERN.match(code) or base.CONDITIONAL_GOTO_PATTERN.match(code):
            continue
        body.append(line)
    validate_supported(body)


def convert_forward_region(
    lines: list[str], labels: dict[str, int], start: int, end: int
) -> tuple[list[str], bool, bool]:
    """Return Cifa lines plus (may_terminate, always_terminate) for [start, end)."""
    output: list[str] = []
    chunk_start = start
    index = start

    def append_chunk(chunk_end: int) -> None:
        nonlocal chunk_start
        output.extend(convert_lines(lines[chunk_start:chunk_end]))
        chunk_start = chunk_end

    while index < end:
        code, _comment = base.split_comment(lines[index])
        if base.GOTO_LABEL_PATTERN.match(code):
            append_chunk(index)
            chunk_start = index + 1
            index += 1
            continue
        jump_match = base.CONDITIONAL_GOTO_PATTERN.match(code)
        if jump_match:
            append_chunk(index)
            condition, target_label = jump_match.groups()
            if target_label not in labels:
                raise base.ConvertError("unknown goto label")
            target = labels[target_label]
            if target <= index:
                raise base.ConvertError("backward goto")
            if target > end:
                raise base.ConvertError("crossing forward goto")

            skipped, skipped_may_terminate, skipped_always_terminate = convert_forward_region(
                lines, labels, index + 1, target
            )
            suffix, suffix_may_terminate, suffix_always_terminate = convert_forward_region(
                lines, labels, target + 1, end
            )
            condition = base.normalize_expr(condition)
            if skipped_always_terminate:
                output.append(f"if ({condition}) {{")
                output.extend("    " + line for line in suffix)
                output.append("} else {")
                output.extend("    " + line for line in skipped)
                output.append("}")
                return output, True, suffix_always_terminate
            if skipped_may_terminate:
                raise base.ConvertError("mixed terminating forward goto")

            output.append(f"if (!({condition})) {{")
            output.extend("    " + line for line in skipped)
            output.append("}")
            output.extend(suffix)
            return output, suffix_may_terminate, suffix_always_terminate
        if is_exit(lines[index]):
            append_chunk(index)
            trailing = [line for line in lines[index + 1 : end] if line.strip()]
            if trailing:
                raise base.ConvertError("non-terminal exit")
            return output, True, True
        index += 1

    append_chunk(end)
    return output, False, False


def convert_forward_jumps(lines: list[str]) -> str:
    labels, jumps = find_control_flow(lines)
    if not jumps:
        raise base.ConvertError("unexpected no-jump event")
    validate_control_flow_body(lines)
    output, _may_terminate, _always_terminate = convert_forward_region(lines, labels, 0, len(lines))
    return finish_output(output)


def convert_no_jump(lines: list[str]) -> str:
    labels, jumps = find_control_flow(lines)
    if jumps:
        raise base.ConvertError("unexpected goto")
    # With no jump, a top-level exit makes the following code unreachable.
    # Drop that exit and its unreachable tail; Cifa naturally ends the event.
    depths = base.lua_nesting_depths(lines)
    exit_indexes = [index for index, line in enumerate(lines) if is_exit(line)]
    if any(depths[index] != 0 for index in exit_indexes):
        raise base.ConvertError("exit inside Lua block")
    if exit_indexes:
        lines = lines[: exit_indexes[0]]
    lines = [line for line in lines if not base.GOTO_LABEL_PATTERN.match(base.split_comment(line)[0])]
    validate_supported(lines)
    return "\n".join(convert_lines(lines)).rstrip() + "\n"


def convert_single_forward_jump(lines: list[str]) -> str:
    labels, jumps = find_control_flow(lines)
    if len(labels) != 1 or len(jumps) != 1:
        raise base.ConvertError("not a single jump")
    jump_index, condition, target_label = jumps[0]
    if target_label not in labels:
        raise base.ConvertError("unknown goto label")
    target_index = labels[target_label]
    if target_index <= jump_index:
        raise base.ConvertError("backward goto")

    prefix = lines[:jump_index]
    skipped = lines[jump_index + 1 : target_index]
    suffix = lines[target_index + 1 :]
    prefix, prefix_terminates = strip_section_exit(prefix)
    if prefix_terminates:
        raise base.ConvertError("exit before goto")
    skipped, skipped_terminates = strip_section_exit(skipped)
    suffix, _suffix_terminates = strip_section_exit(suffix)
    validate_supported(prefix + skipped + suffix)

    output = convert_lines(prefix)
    output.append(f"if ({base.normalize_expr(condition)}) {{")
    output.extend("    " + line for line in convert_lines(suffix))
    output.append("} else {")
    output.extend("    " + line for line in convert_lines(skipped))
    if not skipped_terminates:
        output.extend("    " + line for line in convert_lines(suffix))
    output.append("}")
    return finish_output(output)


def convert_ka676(lines: list[str]) -> str:
    expected = "if instruct_50(138, 139, 140, 141, 142, 1, 0) == 0 then"
    if not lines or line_code(lines[0]).lower() != expected:
        raise base.ConvertError("unexpected five-item check")
    try:
        end_index = next(index for index, line in enumerate(lines[1:], 1) if line_code(line).lower() == "end")
    except StopIteration as error:
        raise base.ConvertError("unterminated five-item check") from error

    missing_items = lines[1:end_index]
    if len(missing_items) != 2 or not is_exit(missing_items[-1]):
        raise base.ConvertError("unexpected five-item missing branch")
    success_lines, _success_terminates = strip_section_exit(lines[end_index + 1 :])
    validate_supported(success_lines)

    output = [
        "if (GetItemAmount(138) > 0 && GetItemAmount(139) > 0 && GetItemAmount(140) > 0 && GetItemAmount(141) > 0 && GetItemAmount(142) > 0) {",
    ]
    output.extend("    " + line for line in convert_lines(success_lines))
    output.append("} else {")
    output.extend("    " + line for line in convert_lines(missing_items[:-1]))
    output.append("}")
    return finish_output(output)


def require_line(lines: list[str], index: int, expected: str) -> None:
    if index >= len(lines) or line_code(lines[index]) != expected:
        raise base.ConvertError("unexpected manual event layout")


def convert_ka320(lines: list[str]) -> str:
    require_line(lines, 23, "if TeamIsFull() == false then goto label0 end")
    require_line(lines, 26, "if TeamIsFull() == true then goto label1 end")
    require_line(lines, 41, "if TeamIsFull() == true then goto label2 end")
    require_line(lines, 44, "if InTeam(26) == false then goto label3 end")
    require_line(lines, 45, "if TryBattle(57) == true then goto label4 end")
    require_line(lines, 47, "if TryBattle(54) == true then goto label5 end")
    require_line(lines, 57, "if InTeam(26) == false then goto label6 end")

    output = convert_lines(lines[:23])
    output.append("if (TeamIsFull()) {")
    output.extend("    " + line for line in convert_lines(lines[24:25]))
    output.append("} else {")
    output.extend("    " + line for line in convert_lines(lines[27:28]))
    output.append("}")
    output.extend(convert_lines(lines[29:41]))
    output.append("if (!TeamIsFull()) {")
    output.extend("    " + line for line in convert_lines(lines[42:43]))
    output.append("}")
    output.append("if ((InTeam(26) && TryBattle(57)) || TryBattle(54)) {")
    output.extend("    " + line for line in convert_lines(lines[52:57]))
    output.append("    if (InTeam(26)) {")
    output.extend("        " + line for line in convert_lines(lines[58:59]))
    output.append("    }")
    output.extend("    " + line for line in convert_lines(lines[60:119]))
    output.append("} else {")
    output.append("    dead();")
    output.append("}")
    return finish_output(output)


def convert_ka530(lines: list[str]) -> str:
    require_line(lines, 0, "if InTeam(51) == false then goto label0 end")
    require_line(lines, 3, "if InTeam(51) == true then goto label1 end")
    require_line(lines, 10, "if InTeam(51) == true then goto label2 end")
    require_line(lines, 12, "if JudgeScenePic(52, 3, 6310, 0, 14) == true then goto label2 end")
    require_line(lines, 16, "if InTeam(76) == false then goto label4 end")
    require_line(lines, 18, "if InTeam(53) == false then goto label5 end")
    require_line(lines, 28, "if TryBattle(85) == true then goto label6 end")
    require_line(lines, 38, "if InTeam(51) == false then goto label7 end")
    require_line(lines, 44, "if JudgeScenePic(-2, 23, 6298, 1, 0) == true then goto label8 end")
    require_line(lines, 51, "if JudgeScenePic(-2, 24, 6314, 46, 0) == true then goto label9 end")

    output: list[str] = ["if (InTeam(51)) {"]
    output.extend("    " + line for line in convert_lines(lines[1:2]))
    output.append("} else {")
    output.extend("    " + line for line in convert_lines(lines[4:5]))
    output.append("}")
    output.extend(convert_lines(lines[6:10]))
    output.append("if (!InTeam(51)) {")
    output.extend("    " + line for line in convert_lines(lines[11:12]))
    output.append("    if (!JudgeScenePic(52, 3, 6310, 0, 14)) {")
    output.extend("        " + line for line in convert_lines(lines[13:14]))
    output.append("    }")
    output.append("}")
    output.append("if (InTeam(76)) {")
    output.extend("    " + line for line in convert_lines(lines[17:18]))
    output.append("    if (InTeam(53)) {")
    output.extend("        " + line for line in convert_lines(lines[19:20]))
    output.append("    }")
    output.append("}")
    output.extend(convert_lines(lines[22:28]))
    output.append("if (TryBattle(85)) {")
    output.extend("    " + line for line in convert_lines(lines[32:38]))
    output.append("    if (InTeam(51)) {")
    output.extend("        " + line for line in convert_lines(lines[39:40]))
    output.append("    }")
    output.extend("    " + line for line in convert_lines(lines[41:44]))
    output.append("    if (JudgeScenePic(-2, 23, 6298, 1, 0)) {")
    output.extend("        " + line for line in convert_lines(lines[47:51]))
    output.append("        if (JudgeScenePic(-2, 24, 6314, 46, 0)) {")
    output.extend("            " + line for line in convert_lines(lines[62:69]))
    output.append("            if (InTeam(53)) {")
    output.extend("                " + line for line in convert_lines(lines[70:71]))
    output.append("            }")
    output.append("            if (InTeam(76)) {")
    output.extend("                " + line for line in convert_lines(lines[73:74]))
    output.append("            }")
    output.extend("            " + line for line in convert_lines(lines[75:84]))
    output.append("        } else {")
    output.extend("            " + line for line in convert_lines(lines[52:55]))
    output.append("            if (InTeam(76)) {")
    output.extend("                " + line for line in convert_lines(lines[56:57]))
    output.append("            }")
    output.extend("            " + line for line in convert_lines(lines[58:60]))
    output.append("        }")
    output.append("    }")
    output.append("} else {")
    output.append("    dead();")
    output.append("}")
    return finish_output(output)


def convert_ka655(lines: list[str]) -> str:
    require_line(lines, 0, "if JudgeAttack(0, 90, 1000) == true then goto label0 end")
    require_line(lines, 4, "if HaveItem(106) == true then goto label1 end")
    require_line(lines, 5, "if HaveItem(109) == true then goto label1 end")
    require_line(lines, 6, "if HaveItem(117) == true then goto label1 end")

    output = ["if (JudgeAttack(0, 90, 1000) && (HaveItem(106) || HaveItem(109) || HaveItem(117))) {"]
    output.extend("    " + line for line in convert_lines(lines[10:15]))
    output.append("} else {")
    output.extend("    " + line for line in convert_lines(lines[1:2]))
    output.append("}")
    return finish_output(output)


def convert_event(text: str) -> str:
    original_lines = text.splitlines()
    if "instruct_50(138, 139, 140, 141, 142, 1, 0)" in text:
        return convert_ka676(original_lines)
    if len(original_lines) == 120 and "TryBattle(57)" in text and "TryBattle(54)" in text:
        return convert_ka320(original_lines)
    if len(original_lines) == 86 and "TryBattle(85)" in text and "JudgeScenePic(52, 3, 6310, 0, 14)" in text:
        return convert_ka530(original_lines)
    if len(original_lines) == 16 and "HaveItem(106)" in text and "HaveItem(109)" in text and "HaveItem(117)" in text:
        return convert_ka655(original_lines)
    lines = prune_unreachable_lines(original_lines)
    _labels, jumps = find_control_flow(lines)
    if not jumps:
        return convert_no_jump(lines)
    return convert_forward_jumps(lines)


def event_number(path: Path) -> str:
    if not path.stem.startswith("ka") or not path.stem[2:].isdigit():
        raise base.ConvertError("unexpected event filename")
    return path.stem[2:]


def main() -> int:
    parser = argparse.ArgumentParser(description="Convert simple game0 Lua events to helper-free Cifa.")
    parser.add_argument("--src", type=Path, default=Path("game0/script/event"))
    parser.add_argument("--dst", type=Path, default=Path("game0/script/event-cifa"))
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--overwrite-existing", action="store_true")
    parser.add_argument("--skip-report", type=Path)
    args = parser.parse_args()

    converted = 0
    empty_outputs = 0
    skipped: list[tuple[Path, str]] = []
    if not args.dry_run:
        args.dst.mkdir(parents=True, exist_ok=True)
    for path in sorted(args.src.glob("ka*.lua")):
        try:
            output = convert_event(path.read_text(encoding="utf-8-sig"))
        except base.ConvertError as error:
            skipped.append((path, str(error)))
            continue
        output = base.format_cifa_indentation(base.strip_cifa_comments(output))
        destination = args.dst / f"{event_number(path)}.cifa"
        if not output.strip():
            empty_outputs += 1
            if not args.dry_run and destination.exists():
                destination.unlink()
            continue
        converted += 1
        if not args.dry_run:
            if not destination.exists() or args.overwrite_existing:
                destination.write_text(output, encoding="utf-8")

    print(f"converted={converted}")
    print(f"empty_outputs={empty_outputs}")
    print(f"skipped={len(skipped)}")
    for path, reason in skipped[:50]:
        print(f"skip {path.name}: {reason}")
    if len(skipped) > 50:
        print(f"... {len(skipped) - 50} more skipped")
    if args.skip_report:
        args.skip_report.parent.mkdir(parents=True, exist_ok=True)
        args.skip_report.write_text(
            "".join(f"{event_number(path)}: {reason}\n" for path, reason in skipped),
            encoding="utf-8",
        )
        print(f"skip_report={args.skip_report}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())