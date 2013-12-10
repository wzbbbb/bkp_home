echo off
set PATH=%PATH%;d:\Tools

if not P%1%==P goto no_message
echo "Which environment Company do you want to load ?"
echo "If Yes relaunch this program with the following parameter"
:: echo "0 for COMM50"
echo "A for AVALID"
echo "G for GCO210"
echo "M for MNT500"
echo "Q for QCL500"
echo "S for SUP500"
echo "P for PSA500"
: echo "Z for GMUZ50"
:no_message
if P%1%==P goto end
if P%1%==P0 set uxcomp=COMM50
if P%1%==PA set uxcomp=AVALID
if P%1%==PG set uxcomp=GCO210
if P%1%==PB set uxcomp=GMUB50
if P%1%==PM set uxcomp=MNT500
if P%1%==PP set uxcomp=PSA500
if P%1%==PQ set uxcomp=QCL500
if P%1%==PS set uxcomp=SUP500
if P%1%==PZ set uxcomp=GMUZ50
echo Environment of the company %uxcomp%
echo Version of the company: 
if not exist e:\%uxcomp%\exec\uxversion.bat goto uxver_not_exist
call e:\%uxcomp%\exec\uxversion.bat
goto uxver_done
:uxver_not_exist
echo No patch applied on the %uxcomp%
:uxver_done
if P%uxcomp%==P goto end
set PATH=%PATH%;e:\%uxcomp%\exec\;e:\%uxcomp%\mgr\
call e:\%uxcomp%\mgr\uxsetenv.bat
:end
