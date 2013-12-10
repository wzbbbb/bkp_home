@echo off

net start|findstr FLS500_IO
if not %errorlevel% == 0 goto MNT
call d:\lddu.bat F
call %UXMGR%\uxshutdown.bat

:MNT
net start|findstr MNT500_IO
if not %errorlevel% == 0 goto QCL
call d:\lddu.bat M
call %UXMGR%\uxshutdown.bat

:QCL
net start|findstr QCL500_IO
if not %errorlevel% == 0 goto SUP
call d:\lddu.bat Q
call %UXMGR%\uxshutdown.bat

:SUP
net start|findstr SUP500_IO
if not %errorlevel% == 0 goto MNT_C
call d:\lddu.bat S
call %UXMGR%\uxshutdown.bat

:MNT_C
net start|findstr MNT500_CLUSTER_IO
if not %errorlevel% == 0 goto QCL_C
call d:\lddu.bat CM
call %UXMGR%\uxshutdown.bat

:QCL_C
net start|findstr QCL500_CLUSTER_IO
if not %errorlevel% == 0 goto SUP_C
call d:\lddu.bat CQ
call %UXMGR%\uxshutdown.bat

:SUP_C
net start|findstr SUP500_CLUSTER_IO
if not %errorlevel% == 0 goto end
call d:\lddu.bat CS
call %UXMGR%\uxshutdown.bat

:end
