
rem 修改下面4个值
set path_ct=D:\kys-all\codetyphon\
set path_project=D:\kys-all\pig3\kys-pig3\pig3\bin\
set project=kys_pig3.lpr
set output=libkys_pig3.so

md tmp
%path_ct%\fpc\fpc64\bin\x86_64-win64\fpc.exe -Tandroid -Paarch64 -MDelphi -Scghi -CX -Os3 -Xs -XX -l -vewnhibq -Fi%path_project%tmp\android -Fl%path_project%lib -Fl%path_ct%arm64-android -Fu%path_project%lib -Fu%path_ct%\typhon\lcl\units\aarch64-android\customdrawn -Fu%path_ct%\typhon\lcl\units\aarch64-android -Fu%path_ct%\typhon\components\BaseUtils\lib\aarch64-android -FUtmp -FE. -o%output% -dLCL -dadLCL -dLCLcustomdrawn %path_project%%project%

#自动复制so到所需目录
copy %output% .\lib\arm64-v8a  

pause