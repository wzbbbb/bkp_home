echo off
call %4/uxsetenv.bat
set area=%1% 
set file_level=%2% 
set target=%3%
echo %area% %file_level% %target%
cscript //nologo //E:vbscript  ./uxtrace_step2.vbs %area% %file_level% %target% 
rem cscript //nologo //E:vbscript  ./step2_v4.0.vbs X 0 CS
rem echo i am here...
