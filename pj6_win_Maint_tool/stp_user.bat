@echo off

if not "%1%" == "" goto no_message
echo Which user services do you want to stop ?
echo Launch this program again and specify one of the following parameters: 
:: echo 0 for COMM50
echo M for MNT500
echo Q for QCL500
echo S for SUP500
echo F for FLS500
echo CM for CLUSTER MNT500
echo CQ for CLUSTER QCL500
echo CS for CLUSTER SUP500
goto end
:no_message

rem if %1 == M goto mnt
if %1==M set usr=mnt
if %1==Q set usr=qcl
if %1==S set usr=sup
if %1==F set usr=fls
if %1==CM set usr=mnt
if %1==CQ set usr=qcl
if %1==CS set usr=sup

net start|findstr "Universe "
set rc=%errorlevel%
if not %rc% == 0 echo "Univer$e Universe " is not started
if %rc% == 0 net stop "Univer$e Universe "

:user_services
net start|findstr "%usr%500a"
set rc=%errorlevel%
if not %rc% == 0 echo "Univer$e %usr%500a" is not started
if %rc% == 0 net stop "Univer$e %usr%500a"

net start|findstr "%usr%500d"
set rc=%errorlevel%
if not %rc% == 0 echo "Univer$e %usr%500d" is not started
if %rc% == 0 net stop "Univer$e %usr%500d"

net start|findstr "%usr%500e"
set rc=%errorlevel%
if not %rc% == 0 echo "Univer$e %usr%500e" is not started
if %rc% == 0 net stop "Univer$e %usr%500e"

:end
