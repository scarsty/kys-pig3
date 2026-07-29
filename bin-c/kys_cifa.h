#pragma once
// kys_cifa.h - Cifa script interface

#include "kys_type.h"
#include <string>

void InitialCifaScript();
void DestroyCifaScript();
void ExecCifaScript(const std::string& filename, const std::string& functionname = "");
void ExecCifaScriptString(const std::string& script, const std::string& functionname = "");
