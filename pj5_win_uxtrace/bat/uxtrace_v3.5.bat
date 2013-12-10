@echo off

:STARTPROC
echo ************************************************************
echo *
echo * WARNING: You must run this program as ADMINISTRATOR and
echo * you must either run UXSETENV.bat before launching this program
echo * or have this procedure located in the mgr directory of your company.
echo * DOLLAR UNIVERSE must be running in this computer. 
echo *
echo ************************************************************
REM ## Creation     v2.0 FSO  (Orsyp) 2002/04/04 
REM ## Modification v2.1 GMU  (Orsyp) 2003/01/19 
REM ##    Allow an automatic without the uxsetenv loaded if this procedure
REM ##       is located in the mgr directory of the considered company
REM ##    If no date are specified, do not do any filter on the date.
REM ##    Add the listing of :
REM ##       the management units
REM ##       the nodes
REM ##    Put the netstat result in a different file
REM ##    Put more information in the trace namet 
REM ##    Others details
REM ## Modification v3.1 FSO  (Orsyp) 2003/01/09 
REM ##    Check if the company is started or not in Application
REM ##    Add several listings
REM ## Modification v3.3 GMU  (Orsyp) 2003/03/04 
REM ##    Merge of the modifications v2.1 v3.1
REM ##    Check if the company is started or not in every areas
REM ##    Others details
REM ## Modification v3.4 GMU  (Orsyp) 2004/04/01 
REM ##    Include some trace tools
REM ##    Others details
REM ## Modification v3.5 GMU  (Orsyp) 2004/05/10
REM ##    Modify the uxshw ses
REM ## Modification v4.0 ZWA  (Orsyp) 2004/12/27
REM ##    
REM ##  
pause
set DATE_FILTER=
REM **************** Program Version
set PROG_VERSION=ux_trace_v4.0

if "%1" == "help"  goto FIN_HELP
REM **************** Dollar Universe environment #TO#GMU#
if NOT "%UXMGR%" == "" goto ENV_LOADED
if exist uxsetenv.bat call uxsetenv.bat
set error_mes="UNIVERSE Environment not found. You should run uxsetenv.bat"
if NOT exist uxsetenv.bat GOTO FIN_ERR
:ENV_LOADED
call %uxmgr%\uxsetenv.bat
REM **************** Define the date filter mode
if "%1" == ""  set DATE_FILTER=NO

REM **************** Define the actual date #GMU#To Move
date /T > date.tmp
time /T >> date.tmp
type date.tmp | uxsed -e "s/\///g" | uxsed -e "s/ //g" | uxsed -e "s/://g" | uxsed -e "s/[ a-zA-Z]*//" > dateclean.tmp
uxsetenvfromfile UXDATE dateclean.tmp 1 0 20 uxdatetemp.bat > setdate.log
call uxdatetemp
del uxdatetemp.bat
uxsetenvfromfile UXTIME dateclean.tmp 2 0 20 uxtimetemp.bat > settime.log
call uxtimetemp
del uxtimetemp.bat
del settime.log
del setdate.log
del date.tmp
set TRACE_DATE=%UXDATE%_%UXTIME%

if "%DATE_FILTER%" == "NO" GOTO END_DATE_CHECK

if "%4" == ""  goto FIN_HELP
REM  Less than 4 arguments
set DATE_FILTER=YES
set  DATE_DEB=%1%
set  HEURE_DEB=%2%
set  DATE_FIN=%3%
set  HEURE_FIN=%4%
set error=1

:BEGIN_DATE_CHECK #Not#Used#
REM **************** Date's verification

uxdate yyyy-mm-dd %DATE_DEB% yyyy-mm-dd
set error=%errorlevel%
set error_mes=Wrong initial date: %DATE_DEB%. Right format: yyyy-mm-dd
if %error% GEQ 1 GOTO FIN_ERR

uxdate yyyy-mm-dd %DATE_FIN% yyyy-mm-dd
set error=%errorlevel%
set error_mes=Wrong end date: %DATE_FIN%. Right format: yyyy-mm-dd
if %error% GEQ 1 GOTO FIN_ERR

REM ************* Verification of times
echo %HEURE_DEB% | uxgawk -F: "$1 ~ /[0-2][0-9]/ && $2 ~ /[0-5][0-9]/ && $3 ~ /[0-5][0-9]/  {print $0}" | find ":"
set error=%errorlevel%
set error_mes=Wrong initial time: %HEURE_DEB%. Right format: hh:mm:ss
if %error% GEQ 1 GOTO FIN_ERR

echo %HEURE_FIN% | uxgawk -F: "$1 ~ /[0-2][0-9]/ && $2 ~ /[0-5][0-9]/ && $3 ~ /[0-5][0-9]/  {print $0}" | find ":"
set error=%errorlevel%
set error_mes=Wrong end time: %HEURE_FIN%. Right format: hh:mm:ss
if %error% GEQ 1 GOTO FIN_ERR

:END_DATE_CHECK
REM **************** Status of the Dollar Universe Company
set starstopa=no
set starstopi=no
set starstops=no
set starstopx=no
net start > temp.log && findstr /i %S_SOCIETE%_IO_A temp.log && set starstopa=yes
net start > temp.log && findstr /i %S_SOCIETE%_IO_I temp.log && set starstopi=yes
net start > temp.log && findstr /i %S_SOCIETE%_IO_S temp.log && set starstops=yes
net start > temp.log && findstr /i %S_SOCIETE%_IO_X temp.log && set starstopx=yes
del /q temp.log

REM ************ Define the name of the uxtrace directory
set U_DIR_ANALYSIS=%UXMGR%\WIN_TRACE_%S_NOEUD%_%TRACE_DATE%
if "%DATE_FILTER%" == "NO" GOTO DIRECTORY_NO_FILTER
set U_DIR_ANALYSIS=%U_DIR_ANALYSIS%_%DATE_DEB%
:DIRECTORY_NO_FILTER

REM ************ Creation of the uxtrace directory
if exist %U_DIR_ANALYSIS% rd /q /s %U_DIR_ANALYSIS% 
mkdir %U_DIR_ANALYSIS%
set error=%errorlevel%
set error_mes=error creating analize directory
if %error% GEQ 1 GOTO FIN_ERR

:BEGIN_MOD_TIME_STAMP ## not used
REM ************ Modfication of the time stamps
if "%DATE_FILTER%" == "NO" GOTO END_MOD_TIME_STAMP
set DATE_AUX=%U_FMT_DATE:M=m%
set DATE_AUX=%DATE_AUX:D=d%
set DATE_AUX=%DATE_AUX:Y=y%

for /f "tokens=1" %%i in ('uxdate yyyy-mm-dd %DATE_DEB% %DATE_AUX%') do set DATE_DEB_AUX=%%i
for /f "tokens=1" %%i in ('uxdate yyyy-mm-dd %DATE_FIN% %DATE_AUX%') do set DATE_FIN_AUX=%%i

for /f "tokens=1-3 delims=:" %%i in ('echo %HEURE_DEB%') do set HEURE_DEB_AUX=%%i%%j
for /f "tokens=1-3 delims=:" %%i in ('echo %HEURE_FIN%') do set HEURE_FIN_AUX=%%i%%j
if %DATE_FIN_AUX% LSS %DATE_DEB_AUX% set error_mes="End Date must be ulterior than Start Date" && goto FIN_ERR
:END_MOD_TIME_STAMP
if "%starstopx%" == "no" goto E_LISTING_DU
:B_LISTING_DU

:B_DU_ADM_LISTING
%UXEXE%\uxshw mu mu=* > %U_DIR_ANALYSIS%\cmd_adm_mu_shw.lst
%UXEXE%\uxshw node tnode=* > %U_DIR_ANALYSIS%\cmd_adm_node_shw.lst
%UXEXE%\uxshw user user=* > %U_DIR_ANALYSIS%\cmd_adm_user_shw.lst
%UXEXE%\uxlst prof prof=* > %U_DIR_ANALYSIS%\cmd_adm_profile_lst.lst
:E_DU_ADM_LISTING


:B_DU_EXP_LISTING
set Area=exp
if "%starstopx%" == "no" goto E_DU_EXP_LISTING

%UXEXE%\uxgetnla %S_SOCIETE% X %S_NOEUD% > %U_DIR_ANALYSIS%\cmd_%Area%_uxgetnla.txt 2>&1
%UXEXE%\uxlst atm %Area% all partage > %U_DIR_ANALYSIS%\cmd_%Area%_atm_lst.lst
%UXEXE%\uxshw upr %Area% upr=* vupr=*  > %U_DIR_ANALYSIS%\cmd_%Area%_upr_shw.lst
%UXEXE%\uxshw tsk %Area% upr=* vupr=* mu=* > %U_DIR_ANALYSIS%\cmd_%Area%_tsk_shw.lst
%UXEXE%\uxshw ses %Area% ses=* vses=* lnk > %U_DIR_ANALYSIS%\cmd_%Area%_ses_shw.lst
%UXEXE%\uxlst fla %Area% full > %U_DIR_ANALYSIS%\cmd_%Area%_fla_lst.lst

if "%DATE_FILTER%" == "NO" GOTO B_DU_EXP_NO_DATE_LISTING
:B_DU_EXP_DATE_LISTING
%UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* full since=%DATE_DEB_AUX%,%HEURE_DEB_AUX% before=%DATE_FIN_AUX%,%HEURE_FIN_AUX% > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_full.lst
%UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* hst since=%DATE_DEB_AUX%,%HEURE_DEB_AUX% before=%DATE_FIN_AUX%,%HEURE_FIN_AUX% > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_hst.lst
%UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* log since=%DATE_DEB_AUX%,%HEURE_DEB_AUX% before=%DATE_FIN_AUX%,%HEURE_FIN_AUX% > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_log.lst
:E_DU_EXP_DATE_LISTING

if "%DATE_FILTER%" == "YES" GOTO E_DU_EXP_NO_DATE_LISTING
:B_DU_EXP_NO_DATE_LISTING
%UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* full > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_full.lst
%UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* hst > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_hst.lst
%UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* log > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_log.lst
:E_DU_EXP_NO_DATE_LISTING
:E_DU_EXP_LISTING

:B_DU_SIM_LISTING
set Area=sim
if "%starstops%" == "no" goto E_DU_SIM_LISTING
%UXEXE%\uxgetnla %S_SOCIETE% S %S_NOEUD% > %U_DIR_ANALYSIS%\cmd_%Area%_uxgetnla.txt 2>&1
%UXEXE%\uxlst atm %Area% all partage > %U_DIR_ANALYSIS%\cmd_%Area%_atm_lst.lst
%UXEXE%\uxshw upr %Area% upr=* vupr=*  > %U_DIR_ANALYSIS%\cmd_%Area%_upr_shw.lst
%UXEXE%\uxshw tsk %Area% upr=* vupr=* mu=* > %U_DIR_ANALYSIS%\cmd_%Area%_tsk_shw.lst
%UXEXE%\uxshw ses %Area% ses=* vses=* lnk > %U_DIR_ANALYSIS%\cmd_%Area%_ses_shw.lst
%UXEXE%\uxlst fla %Area% full > %U_DIR_ANALYSIS%\cmd_%Area%_fla_lst.lst

if "%DATE_FILTER%" == "NO" GOTO B_DU_SIM_NO_DATE_LISTING
:B_DU_SIM_DATE_LISTING
%UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* full since=%DATE_DEB_AUX%,%HEURE_DEB_AUX% before=%DATE_FIN_AUX%,%HEURE_FIN_AUX% > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_full.lst
REM %UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* hst since=%DATE_DEB_AUX%,%HEURE_DEB_AUX% before=%DATE_FIN_AUX%,%HEURE_FIN_AUX% > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_hst.lst
REM %UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* log since=%DATE_DEB_AUX%,%HEURE_DEB_AUX% before=%DATE_FIN_AUX%,%HEURE_FIN_AUX% > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_log.lst
:E_DU_SIM_DATE_LISTING

if "%DATE_FILTER%" == "YES" GOTO E_DU_SIM_NO_DATE_LISTING
:B_DU_SIM_NO_DATE_LISTING
%UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* full > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_full.lst
REM %UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* hst > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_hst.lst
REM %UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* log > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_log.lst
:E_DU_SIM_NO_DATE_LISTING
:E_DU_SIM_LISTING

:B_DU_INT_LISTING
set Area=int
if "%starstopi%" == "no" goto E_DU_INT_LISTING
%UXEXE%\uxgetnla %S_SOCIETE% I %S_NOEUD% > %U_DIR_ANALYSIS%\cmd_%Area%_uxgetnla.txt 2>&1
%UXEXE%\uxlst atm %Area% all partage > %U_DIR_ANALYSIS%\cmd_%Area%_atm_lst.lst
%UXEXE%\uxshw upr %Area% upr=* vupr=*  > %U_DIR_ANALYSIS%\cmd_%Area%_upr_shw.lst
%UXEXE%\uxshw tsk %Area% upr=* vupr=* mu=* > %U_DIR_ANALYSIS%\cmd_%Area%_tsk_shw.lst
%UXEXE%\uxshw ses %Area% ses=* vses=* lnk > %U_DIR_ANALYSIS%\cmd_%Area%_ses_shw.lst
%UXEXE%\uxlst fla %Area% full > %U_DIR_ANALYSIS%\cmd_%Area%_fla_lst.lst

if "%DATE_FILTER%" == "NO" GOTO B_DU_INT_NO_DATE_LISTING
:B_DU_INT_DATE_LISTING
%UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* full since=%DATE_DEB_AUX%,%HEURE_DEB_AUX% before=%DATE_FIN_AUX%,%HEURE_FIN_AUX% > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_full.lst
REM %UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* hst since=%DATE_DEB_AUX%,%HEURE_DEB_AUX% before=%DATE_FIN_AUX%,%HEURE_FIN_AUX% > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_hst.lst
REM %UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* log since=%DATE_DEB_AUX%,%HEURE_DEB_AUX% before=%DATE_FIN_AUX%,%HEURE_FIN_AUX% > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_log.lst
:E_DU_INT_DATE_LISTING

if "%DATE_FILTER%" == "YES" GOTO E_DU_INT_NO_DATE_LISTING
:B_DU_INT_NO_DATE_LISTING
%UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* full > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_full.lst
REM %UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* hst > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_hst.lst
REM %UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* log > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_log.lst
:E_DU_INT_NO_DATE_LISTING
:E_DU_INT_LISTING

:B_DU_APP_LISTING
set Area=app
if "%starstopa%" == "no" goto E_DU_APP_LISTING
%UXEXE%\uxgetnla %S_SOCIETE% A %S_NOEUD% > %U_DIR_ANALYSIS%\cmd_%Area%_uxgetnla.txt 2>&1
%UXEXE%\uxlst atm %Area% all partage > %U_DIR_ANALYSIS%\cmd_%Area%_atm_lst.lst
%UXEXE%\uxshw upr %Area% upr=* vupr=*  > %U_DIR_ANALYSIS%\cmd_%Area%_upr_shw.lst
%UXEXE%\uxshw tsk %Area% upr=* vupr=* mu=* > %U_DIR_ANALYSIS%\cmd_%Area%_tsk_shw.lst
%UXEXE%\uxshw ses %Area% ses=* vses=* lnk > %U_DIR_ANALYSIS%\cmd_%Area%_ses_shw.lst
%UXEXE%\uxlst fla %Area% full > %U_DIR_ANALYSIS%\cmd_%Area%_fla_lst.lst

if "%DATE_FILTER%" == "NO" GOTO B_DU_APP_NO_DATE_LISTING
:B_DU_APP_DATE_LISTING
%UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* full since=%DATE_DEB_AUX%,%HEURE_DEB_AUX% before=%DATE_FIN_AUX%,%HEURE_FIN_AUX% > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_full.lst
REM %UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* hst since=%DATE_DEB_AUX%,%HEURE_DEB_AUX% before=%DATE_FIN_AUX%,%HEURE_FIN_AUX% > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_hst.lst
REM %UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* log since=%DATE_DEB_AUX%,%HEURE_DEB_AUX% before=%DATE_FIN_AUX%,%HEURE_FIN_AUX% > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_log.lst
:E_DU_APP_DATE_LISTING

if "%DATE_FILTER%" == "YES" GOTO E_DU_APP_NO_DATE_LISTING
:B_DU_APP_NO_DATE_LISTING
%UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* full > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_full.lst
REM %UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* hst > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_hst.lst
REM %UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* log > %U_DIR_ANALYSIS%\cmd_%Area%_ctl_log.lst
:E_DU_APP_NO_DATE_LISTING
:E_DU_APP_LISTING
:E_LISTING_DU

REM ************ Analyse.log creation
echo "%PROG_VERSION%" >> %U_DIR_ANALYSIS%\analyse.log

echo "Recuperation de l'environnements incidente" >> %U_DIR_ANALYSIS%\analyse.log
echo "                ENVIRONNEMENT"               >> %U_DIR_ANALYSIS%\analyse.log

REM ************ Executes the uxgethrd binary
if exist %uxmgr%\%COMPUTERNAME%.txt copy %uxmgr%\%COMPUTERNAME%.txt  %U_DIR_ANALYSIS%\%COMPUTERNAME%.txt_old
if exist %UXMGR%\uxgethrd.exe %UXMGR%\uxgethrd
if exist %uxmgr%\%COMPUTERNAME%.txt copy %uxmgr%\%COMPUTERNAME%.txt  %U_DIR_ANALYSIS%\%COMPUTERNAME%.txt

if exist %uxmgr%\uxsetenv.bat    copy %uxmgr%\uxsetenv.bat    %U_DIR_ANALYSIS%\.  
if exist %uxmgr%\uxstartup*.*    copy %uxmgr%\uxstartup*.*    %U_DIR_ANALYSIS%\.
if exist %uxmgr%\u_batch         copy %uxmgr%\u_batch         %U_DIR_ANALYSIS%\.
if exist %uxmgr%\uxsrsrv*.*      copy %uxmgr%\uxsrsrv*.*      %U_DIR_ANALYSIS%\.
if exist %UXMGR%\uxlnm*.dat      copy %uxmgr%\uxlnm*.dat      %U_DIR_ANALYSIS%\.
if exist %uxmgr%\U_POST_UPROC.*  copy %uxmgr%\U_POST_UPROC.*  %U_DIR_ANALYSIS%\.
if exist %uxmgr%\U_ANTE_UPROC.*  copy %uxmgr%\U_ANTE_UPROC.*  %U_DIR_ANALYSIS%\.
if exist %UXMGR%\u_fail01*.*     copy %uxmgr%\u_fail01*.*     %U_DIR_ANALYSIS%\.
if exist %uxmgr%\useralias.txt   copy %uxmgr%\useralias.txt   %U_DIR_ANALYSIS%\.  
if exist %uxmgr%\security.txt    copy %uxmgr%\security.txt    %U_DIR_ANALYSIS%\.  
if exist %uxexe%\UNIVERSE.def    copy %uxexe%\UNIVERSE.def    %U_DIR_ANALYSIS%\.  
if exist %uxexe%\%S_SOCIETE%.def copy %uxexe%\%S_SOCIETE%.def %U_DIR_ANALYSIS%\.  
if exist %uxexe%\u_batch.*       copy %uxexe%\u_batch.*       %U_DIR_ANALYSIS%\.  

if exist %windir%\system32\drivers\etc\*  copy %windir%\system32\drivers\etc\* %U_DIR_ANALYSIS%\. 

echo.                                  >> %U_DIR_ANALYSIS%\analyse.log
echo  DATE                             >> %U_DIR_ANALYSIS%\analyse.log
if "%DATE_FILTER%" == "YES" echo %DATE_DEB%                        >> %U_DIR_ANALYSIS%\analyse.log
if "%DATE_FILTER%" == "YES" echo %DATE_FIN%                        >> %U_DIR_ANALYSIS%\analyse.log
if "%DATE_FILTER%" == "NO" echo Date of the trace : %UXDATE%       >> %U_DIR_ANALYSIS%\analyse.log
if "%DATE_FILTER%" == "NO" echo Time of the trace : %UXTIME%       >> %U_DIR_ANALYSIS%\analyse.log
echo.                                  >> %U_DIR_ANALYSIS%\analyse.log

if "%DATE_FILTER%" == "YES" echo PLAGE HORAIRE                     >> %U_DIR_ANALYSIS%\analyse.log
if "%DATE_FILTER%" == "YES" echo %HEURE_DEB%                       >> %U_DIR_ANALYSIS%\analyse.log
if "%DATE_FILTER%" == "YES" echo %HEURE_FIN%                       >> %U_DIR_ANALYSIS%\analyse.log
echo.                                  >> %U_DIR_ANALYSIS%\analyse.log

echo ENVIRONMENT                       >> %U_DIR_ANALYSIS%\analyse.log
set                                    >> %U_DIR_ANALYSIS%\analyse.log
echo.                                  >> %U_DIR_ANALYSIS%\analyse.log

echo COMPUTERNAME                      >> %U_DIR_ANALYSIS%\analyse.log
echo %COMPUTERNAME%                    >> %U_DIR_ANALYSIS%\analyse.log
echo.                                  >> %U_DIR_ANALYSIS%\analyse.log


echo Started services on the node      >> %U_DIR_ANALYSIS%\analyse.log
net start                              >> %U_DIR_ANALYSIS%\analyse.log
echo.                                  >> %U_DIR_ANALYSIS%\analyse.log

echo      NETSTAT -a                     >> %U_DIR_ANALYSIS%\netstat_a.lst
netstat -a                               >> %U_DIR_ANALYSIS%\netstat_a.lst
echo.                                  >> %U_DIR_ANALYSIS%\netstat_a.lst

echo      NETSTAT -na                     >> %U_DIR_ANALYSIS%\netstat_na.lst
netstat -na                               >> %U_DIR_ANALYSIS%\netstat_na.lst
echo.                                  >> %U_DIR_ANALYSIS%\netstat_na.lst


echo liste des process depuis le demarage du systeme > %U_DIR_ANALYSIS%\ps-ef.lst 
uxpulist.exe                                           >> %U_DIR_ANALYSIS%\ps-ef.lst

rem # ne pas oublier dqm  

echo   UNILEVEL                       >> %U_DIR_ANALYSIS%\analyse.log
type %uxmgr%\u_fali01.txt             >> %U_DIR_ANALYSIS%\analyse.log
echo.                                 >> %U_DIR_ANALYSIS%\analyse.log

echo   VERSION                        >> %U_DIR_ANALYSIS%\analyse.log
call %uxexe%\uxversion.bat            >> %U_DIR_ANALYSIS%\analyse.log
echo.                                 >> %U_DIR_ANALYSIS%\analyse.log


echo ENVIRONNEMENT DES EXE DE DOLLAR UNIVERSE >> %U_DIR_ANALYSIS%\analyse.log

echo dir /od UXEXE                    >> %U_DIR_ANALYSIS%\analyse.log
dir  /od %UXEXE%                      >> %U_DIR_ANALYSIS%\analyse.log
echo.                                 >> %U_DIR_ANALYSIS%\analyse.log

echo dir /od UXMGR                    >> %U_DIR_ANALYSIS%\analyse.log
dir  /od %UXMGR%                      >> %U_DIR_ANALYSIS%\analyse.log
echo.                                 >> %U_DIR_ANALYSIS%\analyse.log


rem echo /etc/*DQM*          >>  analyse.log
rem ls -ltr /etc/*DQM*       >>  analyse.log
rem echo "\n"                >>  analyse.log

echo  ENVIRONNEMENT DE DONNEES  DOLLAR UNIVERSE  >> %U_DIR_ANALYSIS%\analyse.log

echo    dir UXDIR_ROOT: %UXDIR_ROOT% >> %U_DIR_ANALYSIS%\analyse.log
dir /od %UXDIR_ROOT%                 >> %U_DIR_ANALYSIS%\analyse.log
echo.                                >> %U_DIR_ANALYSIS%\analyse.log

echo  dir UXLOG: %UXLOG%             >> %U_DIR_ANALYSIS%\analyse.log
dir /od %UXLOG%                      >> %U_DIR_ANALYSIS%\analyse.log
echo.                                >> %U_DIR_ANALYSIS%\analyse.log

echo  dir UXDEX: %UXDEX%             >> %U_DIR_ANALYSIS%\analyse.log
dir /od %UXDEX%                      >> %U_DIR_ANALYSIS%\analyse.log
echo.                                >> %U_DIR_ANALYSIS%\analyse.log

echo  dir UXPEX: %UXPEX%             >> %U_DIR_ANALYSIS%\analyse.log
dir /od  %UXPEX%                     >> %U_DIR_ANALYSIS%\analyse.log
echo.                                >> %U_DIR_ANALYSIS%\analyse.log

echo    dir UXLEX: %UXLEX%           >> %U_DIR_ANALYSIS%\analyse.log
dir /od  %UXLEX%                     >> %U_DIR_ANALYSIS%\analyse.log
echo.                                >> %U_DIR_ANALYSIS%\analyse.log

echo  dir UXDSI: %UXDSI%             >> %U_DIR_ANALYSIS%\analyse.log
dir /od %UXDSI%                      >> %U_DIR_ANALYSIS%\analyse.log
echo.                                >> %U_DIR_ANALYSIS%\analyse.log

echo dir UXPSI: %UXPSI%              >> %U_DIR_ANALYSIS%\analyse.log
dir /od  %UXPSI%                     >> %U_DIR_ANALYSIS%\analyse.log
echo.                                >> %U_DIR_ANALYSIS%\analyse.log

echo dir UXLSI: %UXLSI%              >> %U_DIR_ANALYSIS%\analyse.log
dir /od %UXLSI%                      >> %U_DIR_ANALYSIS%\analyse.log
echo.                                >> %U_DIR_ANALYSIS%\analyse.log

echo dir UXDIN: %UXDIN%              >> %U_DIR_ANALYSIS%\analyse.log
dir /od %UXDIN%                      >> %U_DIR_ANALYSIS%\analyse.log
echo.                                >> %U_DIR_ANALYSIS%\analyse.log

echo dir UXPIN: %UXPIN%              >> %U_DIR_ANALYSIS%\analyse.log
dir /od %UXPIN%                      >> %U_DIR_ANALYSIS%\analyse.log
echo.                                >> %U_DIR_ANALYSIS%\analyse.log

echo dir UXLIN: %UXLIN%              >> %U_DIR_ANALYSIS%\analyse.log
dir /od %UXLIN%                      >> %U_DIR_ANALYSIS%\analyse.log
echo.                                >> %U_DIR_ANALYSIS%\analyse.log

echo dir UXDAP: %UXDAP%              >> %U_DIR_ANALYSIS%\analyse.log
dir /od  %UXDAP%                     >> %U_DIR_ANALYSIS%\analyse.log
echo.                                >> %U_DIR_ANALYSIS%\analyse.log

echo dir UXPAP: %UXPAP%              >> %U_DIR_ANALYSIS%\analyse.log
dir /od  %UXPAP%                     >> %U_DIR_ANALYSIS%\analyse.log
echo.                                >> %U_DIR_ANALYSIS%\analyse.log

echo dir UXLAP: %UXLAP%              >> %U_DIR_ANALYSIS%\analyse.log
dir  /od %UXLAP%                     >> %U_DIR_ANALYSIS%\analyse.log
echo.                                >> %U_DIR_ANALYSIS%\analyse.log

echo            INCIDENT             >> %U_DIR_ANALYSIS%\analyse.log

if exist %UXLEX%\*.log copy %UXLEX%\*.log  %U_DIR_ANALYSIS%\.
if exist %UXLSI%\*.log copy %UXLSI%\*.log  %U_DIR_ANALYSIS%\.
if exist %UXLIN%\*.log copy %UXLIN%\*.log  %U_DIR_ANALYSIS%\.
if exist %UXLAP%\*.log copy %UXLAP%\*.log  %U_DIR_ANALYSIS%\.

REM *********************** Universe.log analysis
if "%DATE_FILTER%" == "NO" GOTO E_U_LOG_FILE_ANALYSIS_DATE_FILTERED
:B_U_LOG_FILE_ANALYSIS_DATE_FILTERED
echo  PLAGE HORAIRE                   > %U_DIR_ANALYSIS%\u_universe.log
echo %DATE_DEB% %HEURE_DEB%           >> %U_DIR_ANALYSIS%\u_universe.log
echo %DATE_FIN% %HEURE_FIN%           >> %U_DIR_ANALYSIS%\u_universe.log

if %DATE_DEB% == %DATE_FIN% goto EQUALDAY

uxgawk -v a=%DATE_DEB% -v b=%DATE_FIN% "$2 >= a  && $2 < b {print $0}" %U_LOG_FILE% > %U_DIR_ANALYSIS%\u_uni1.log
uxgawk -v a=%HEURE_DEB% "$3 >= a {print $0}" %U_DIR_ANALYSIS%\u_uni1.log >> %U_DIR_ANALYSIS%\u_universe.log
uxgawk -v a=%DATE_DEB% -v b=%DATE_FIN% "$2 > a && $2 <=b {print $0}" %U_LOG_FILE% > %U_DIR_ANALYSIS%\u_uni1.log
uxgawk -v a=%HEURE_FIN% "$3 <= a {print $0}" %U_DIR_ANALYSIS%\u_uni1.log >> %U_DIR_ANALYSIS%\u_universe.log
goto CONTINUE

:EQUALDAY
uxgawk -v a=%DATE_DEB% -v b=%HEURE_DEB% -v c=%HEURE_FIN% "$2 == a && $3 >= b && $3 <= c {print $0}" %U_LOG_FILE% >> %U_DIR_ANALYSIS%\u_universe.log
goto CONTINUE

:CONTINUE
if exist %U_DIR_ANALYSIS%\u_uni1.log del /f %U_DIR_ANALYSIS%\u_uni1.log

:E_U_LOG_FILE_ANALYSIS_DATE_FILTERED
if exist %U_DIR_ANALYSIS%\universe.log del /f %U_DIR_ANALYSIS%\universe.log

if "%DATE_FILTER%" == "YES" GOTO E_U_LOG_FILE_ANALYSIS_NO_DATE_FILTERED
:B_U_LOG_FILE_ANALYSIS_NO_DATE_FILTERED
if exist %U_LOG_FILE% copy %U_LOG_FILE%  %U_DIR_ANALYSIS%\u_universe.log
:E_U_LOG_FILE_ANALYSIS_NO_DATE_FILTERED

echo SERVEUR IO                                         >  %U_DIR_ANALYSIS%\pid_fic.lst
uxgawk "/UXLK_SetShmLck/ {print $0}" %U_LOG_FILE%         >> %U_DIR_ANALYSIS%\pid_fic.lst
uxgawk "/UXIO_SrvInit/ {print $0}"  %U_LOG_FILE%          >> %U_DIR_ANALYSIS%\pid_fic.lst            
echo ORDOS                                              >> %U_DIR_ANALYSIS%\pid_fic.lst
uxgawk "/UxOrd/ {print $0}" %U_LOG_FILE%                  >> %U_DIR_ANALYSIS%\pid_fic.lst
echo.                                                   >> %U_DIR_ANALYSIS%\pid_fic.lst

echo SURV                                               >> %U_DIR_ANALYSIS%\pid_fic.lst
uxgawk "/uxsurv/ {print $0}" %U_LOG_FILE%                 >> %U_DIR_ANALYSIS%\pid_fic.lst
echo.                                                   >> %U_DIR_ANALYSIS%\pid_fic.lst

rem if exist %U_DIR_ANALYSIS%    compact /c %U_DIR_ANALYSIS%

goto FIN_OK

:FIN_ERR
REM cls
echo *********************************************************************
echo *
echo *  ERROR: %error% 
echo *  MESSAGE TEXT: %error_mes%
echo *
echo *********************************************************************

set resexe=1
goto FIN

:FIN_HELP
REM cls
echo *****************************************************************************
echo *  There are 2 way to launch %PROG_VERSION%
echo *  -1- Without filtering on the date :
echo *     Format of command: %PROG_VERSION%
echo *  -2- With date filtering :
echo *     Format of command:    %PROG_VERSION% start_date  star_time  end_date    end_time
echo *     Format of parameters:          yyyy-mm-dd  hh:mm:ss   yyyy-mm-dd  hh:mm:ss
echo *     For example                       2003-01-01  00:00:00    2003-01-07  00:00:00
echo *     Please use at least one week difference between the start_date and the end_date
echo *
echo *****************************************************************************

set resexe=1
goto FIN

:FIN_OK

echo %S_PROCEXE% : Normal END
set resexe=0
REM cls
echo *****************************************************************
echo *
echo * THE DIRECTORY %U_DIR_ANALYSIS% HAS BEEN CREATED
echo * PLEASE, COMPRESS IT AND SEND THE FILE TO YOUR TECHNICAL SUPPORT
echo *
echo *****************************************************************

goto FIN

:FIN
pause
