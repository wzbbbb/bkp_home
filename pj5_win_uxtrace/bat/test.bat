@echo off

call :function1
echo after function1

rem if "%1" == "bb"  echo %1 is bb
rem set  s=sss
rem echo 1st time %s%
rem if %s% == ssss goto afterecho
rem set s=ddd
rem :afterecho 
rem echo %s%

goto :eof


:function1
date /t >date.tmp
time /t >>date.tmp
rem type date.tmp | uxsed -e "s/\///g" | uxsed -e "s/ //g" | uxsed -e "s/://g" | uxsed -e "s/[ a-zA-Z]*//" > dateclean.tmp
rem type date.tmp | uxsed -e "s/\r\r//g"     > dateclean.tmp
uxsetenvfromfile day date.tmp 1 0 20 uxdatetemp.bat > setdate.log
call uxdatetemp
rem del uxdatetemp.bat
uxsetenvfromfile time date.tmp 2 0 20 uxtimetemp.bat > settime.log
call uxtimetemp
echo %UXDATE% %UXTIME%
rem type dateclean.tmp
del uxtimetemp.bat
del settime.log
del setdate.log
del date.tmp
goto :eof

:tmp
date /T > date.tmp
time /T >> date.tmp
rem type date.tmp | uxsed -e "s/\///g" | uxsed -e "s/ //g" | uxsed -e "s/://g" | uxsed -e "s/[ a-zA-Z]*//" > dateclean.tmp
rem type date.tmp | uxsed -e "s/\///g" | uxsed -e "s/ //g" | uxsed -e "s/://g" | uxsed -e "s/[ a-zA-Z]*//" > dateclean.tmp
uxsetenvfromfile day date.tmp 1 0 20 uxdatetemp.bat > setdate.log
call uxdatetemp
rem del uxdatetemp.bat
uxsetenvfromfile time dateclean.tmp 2 0 20 uxtimetemp.bat > settime.log
call uxtimetemp
del uxtimetemp.bat
del settime.log
del setdate.log
del date.tmp
set TRACE_DATE=%UXDATE%_%UXTIME%
echo %UXDATE% %UXTIME%
goto :eof