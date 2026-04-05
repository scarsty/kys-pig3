#pragma once
// lua52.h - Lua compatibility wrapper
// The original Pascal project used Lua 5.2 bindings (lua52.pas).
// This wraps the system Lua headers (5.2/5.3/5.4 compatible).

extern "C" {
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}
