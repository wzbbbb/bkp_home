echo off 
call %4\unienv.bat
echo U_ROOT_DIR is %U_ROOT_DIR%
set area=%1% 
set file_level=%2% 
set target=%3%
set S_U_LANGUE=EN
echo %area% %file_level% %target%
cscript //nologo //E:vbscript  ./uxtrace_step2.vbs %area% %file_level% %target% 
rem cscript //nologo //E:vbscript  ./step2_v4.0.vbs X 0 CS
