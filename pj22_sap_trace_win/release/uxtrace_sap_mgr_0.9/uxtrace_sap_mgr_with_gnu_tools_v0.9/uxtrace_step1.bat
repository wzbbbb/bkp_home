echo off
rem call %4/uxsetenv.bat
call %2/uxsetenv.bat
rem set area=%1% 
set file_level=%1% 
rem set target=%3%
set S_U_LANGUE=EN
rem echo %area% %file_level% %target%
echo  %file_level% 
cscript //nologo //E:vbscript  ./uxtrace_step2.vbs  %file_level%  
rem cscript //nologo //E:vbscript  ./step2_v4.0.vbs X 0 CS
rem echo i am here...
