copy D:\_sty\_bak\project\_c#\sfe2\sfeConsole\bin\Release\*.exe . /y
rem sfeConsole.exe -rangerw -auto -gbk ranger.xlsx ranger.grp ranger.idx
7za a -tzip 0.zip ranger.grp allsin.grp alldef.grp ranger.idx
pause