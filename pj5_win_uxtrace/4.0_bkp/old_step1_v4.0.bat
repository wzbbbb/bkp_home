@echo off
rem ## Creation v4.0 ZWA (Orsyp) 2004/12/27
rem ## Based on Windows Uxtrace 3.5, which is created by FSO and modified by GMU
rem ## The binary "ISMEMBER - (C) 2001-2004 by Bill Stewart (bstewart@iname.com)"
rem
rem
rem
rem set area=%1%
set file_level=%2%
set target=%3%
rem echo "area is " %area%
rem echo "file_level is " %file_level%
rem echo "target is " %target%

rem structure: 
rem get the date;
rem create the directory,
rem launch the dir, uxlst, uxshw , etc, according to the area selected 
rem get the files according to the file_level; a "case" 
rem then launch the step2_v4.0
rem
 
REM **************** Program Version
set PROG_VERSION=ux_trace_v4.0
set ver_short=v40
REM **************** Dollar Universe environment #TO#GMU#
if NOT "%UXMGR%" == "" goto ENV_LOADED
rem if "%UXMGR%" == "" goto ENV_LOADED
if exist uxsetenv.bat call uxsetenv.bat
set error_mes="UNIVERSE Environment not found. Please unpack this Windows uxtrace procedure in the "mgr" directory"
if NOT exist uxsetenv.bat GOTO FIN_ERR
:ENV_LOADED
call %uxmgr%\uxsetenv.bat
rem call e:\QCL500\mgr\uxsetenv.bat

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
rem echo starstopx is: %starstopx%
set io_up=no
if %1% == X set Area=EXP
if %1% == S set Area=SIM
if %1% == I set Area=INT 
if %1% == A set Area=APP
if %Area% == EXP set io_up=%starstopx%
if %Area% == SIM set io_up=%starstops%
if %Area% == INT set io_up=%starstopi%
if %Area% == APP set io_up=%starstopa%
rem echo io_up is: %io_up%
REM ************ Define the name of the uxtrace directory
set U_DIR_ANALYSIS=%UXMGR%\WIN_TRACE_%S_NOEUD%_%TRACE_DATE%_%1%2%3_%ver_short%

REM ************ Creation of the uxtrace directory
if exist %U_DIR_ANALYSIS% rd /q /s %U_DIR_ANALYSIS% 
mkdir %U_DIR_ANALYSIS%
set error=%errorlevel%
set error_mes=error creating analize directory
if %error% GEQ 1 GOTO FIN_ERR
mkdir %U_DIR_ANALYSIS%\DLS
mkdir %U_DIR_ANALYSIS%\DQM
mkdir %U_DIR_ANALYSIS%\DUFILES
mkdir %U_DIR_ANALYSIS%\FILES 
mkdir %U_DIR_ANALYSIS%\LST
mkdir %U_DIR_ANALYSIS%\LOG
mkdir %U_DIR_ANALYSIS%\SYS

if "%starstopx%" == "yes" goto B_DU_ADM_LISTING
:B_DU_ADM_LISTING
call :tsp > %U_DIR_ANALYSIS%\LST\admin_mu_shw.lst
%UXEXE%\uxshw mu mu=* >> %U_DIR_ANALYSIS%\LST\admin_mu_shw.lst
call :tsp >> %U_DIR_ANALYSIS%\LST\admin_mu_shw.lst
call :tsp > %U_DIR_ANALYSIS%\LST\admin_node_shw.lst
%UXEXE%\uxshw node tnode=* >> %U_DIR_ANALYSIS%\LST\admin_node_shw.lst
call :tsp >> %U_DIR_ANALYSIS%\LST\admin_node_shw.lst
%UXEXE%\uxshw user user=* > %U_DIR_ANALYSIS%\LST\admin_user_shw.lst
%UXEXE%\uxlst prof prof=* > %U_DIR_ANALYSIS%\LST\admin_profile_lst.lst
:E_DU_ADM_LISTING

if "%io_up%" == "no" goto E_DU_AREA_LISTING
if %target%==S goto E_DU_AREA_LISTING

%UXEXE%\uxgetnla %S_SOCIETE% X %S_NOEUD% > %U_DIR_ANALYSIS%\LST\%Area%_uxgetnla.txt 2>&1
%UXEXE%\uxlst atm %Area% all partage > %U_DIR_ANALYSIS%\LST\%Area%_atm_lst.lst
%UXEXE%\uxshw upr %Area% upr=* vupr=*  > %U_DIR_ANALYSIS%\LST\%Area%_upr_shw.lst
%UXEXE%\uxshw tsk %Area% upr=* vupr=* ses=* vses=* mu=* > %U_DIR_ANALYSIS%\LST\%Area%_tsk_shw.lst
%UXEXE%\uxshw ses %Area% ses=* vses=* lnk > %U_DIR_ANALYSIS%\LST\%Area%_ses_shw.lst
%UXEXE%\uxlst fla %Area% full > %U_DIR_ANALYSIS%\LST\%Area%_fla_lst.lst

%UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* full > %U_DIR_ANALYSIS%\LST\%Area%_ctl_full.lst
%UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* hst > %U_DIR_ANALYSIS%\LST\%Area%_ctl_hst.lst
%UXEXE%\uxlst ctl %Area% ses=* vses=* upr=* vupr=* mu=* log > %U_DIR_ANALYSIS%\LST\%Area%_ctl_log.lst
%UXEXE%\uxlst evt %Area% full > %U_DIR_ANALYSIS%\LST\%Area%_ctl_log.lst
:E_DU_AREA_LISTING

REM ************ Analyse.log creation
echo "%PROG_VERSION%" >> %U_DIR_ANALYSIS%\analyse.log

echo "Recuperation de l'environnements incidente" >> %U_DIR_ANALYSIS%\analyse.log
echo "                ENVIRONNEMENT"               >> %U_DIR_ANALYSIS%\analyse.log

REM ************ Executes the uxgethrd binary
if exist %uxmgr%\%COMPUTERNAME%.txt copy %uxmgr%\%COMPUTERNAME%.txt  %U_DIR_ANALYSIS%\%COMPUTERNAME%.txt_old
if exist %UXMGR%\uxgethrd.exe %UXMGR%\uxgethrd
if exist %uxmgr%\%COMPUTERNAME%.txt copy %uxmgr%\%COMPUTERNAME%.txt  %U_DIR_ANALYSIS%\%COMPUTERNAME%.txt

if exist %uxmgr%\uxsetenv.bat    copy %uxmgr%\uxsetenv.bat    %U_DIR_ANALYSIS%\FILES\.  
if exist %uxmgr%\uxstartup*.*    copy %uxmgr%\uxstartup*.*    %U_DIR_ANALYSIS%\FILES\.  
if exist %uxmgr%\u_batch         copy %uxmgr%\u_batch         %U_DIR_ANALYSIS%\FILES\.  
if exist %uxmgr%\uxsrsrv*.*      copy %uxmgr%\uxsrsrv*.*      %U_DIR_ANALYSIS%\FILES\.  
if exist %UXMGR%\uxlnm*.dat      copy %uxmgr%\uxlnm*.dat      %U_DIR_ANALYSIS%\FILES\.  
if exist %uxmgr%\U_POST_UPROC.*  copy %uxmgr%\U_POST_UPROC.*  %U_DIR_ANALYSIS%\FILES\.  
if exist %uxmgr%\U_ANTE_UPROC.*  copy %uxmgr%\U_ANTE_UPROC.*  %U_DIR_ANALYSIS%\FILES\.  
if exist %UXMGR%\u_fail01*.*     copy %uxmgr%\u_fail01*.*     %U_DIR_ANALYSIS%\FILES\.  
if exist %uxmgr%\useralias.txt   copy %uxmgr%\useralias.txt   %U_DIR_ANALYSIS%\FILES\.  
if exist %uxmgr%\security.txt    copy %uxmgr%\security.txt    %U_DIR_ANALYSIS%\FILES\.  
if exist %uxexe%\UNIVERSE.def    copy %uxexe%\UNIVERSE.def    %U_DIR_ANALYSIS%\FILES\.  
if exist %uxexe%\%S_SOCIETE%.def copy %uxexe%\%S_SOCIETE%.def %U_DIR_ANALYSIS%\FILES\.  
if exist %uxexe%\u_batch.*       copy %uxexe%\u_batch.*       %U_DIR_ANALYSIS%\FILES\.  

if exist %windir%\system32\drivers\etc\*  copy %windir%\system32\drivers\etc\* %U_DIR_ANALYSIS%\FILES\*

echo.                                  >> %U_DIR_ANALYSIS%\analyse.log
echo  DATE                             >> %U_DIR_ANALYSIS%\analyse.log
echo Date of the trace : %UXDATE%       >> %U_DIR_ANALYSIS%\analyse.log
echo Time of the trace : %UXTIME%       >> %U_DIR_ANALYSIS%\analyse.log
echo.                                  >> %U_DIR_ANALYSIS%\analyse.log
echo.                                  >> %U_DIR_ANALYSIS%\analyse.log

echo ENVIRONMENT                       >> %U_DIR_ANALYSIS%\analyse.log
set                                    >> %U_DIR_ANALYSIS%\analyse.log
echo.                                  >> %U_DIR_ANALYSIS%\analyse.log

echo COMPUTERNAME                      >> %U_DIR_ANALYSIS%\analyse.log
echo %COMPUTERNAME%                    >> %U_DIR_ANALYSIS%\analyse.log
echo.                                  >> %U_DIR_ANALYSIS%\analyse.log
echo User groups                       >> %U_DIR_ANALYSIS%\analyse.log
ismember -l			       >> %U_DIR_ANALYSIS%\analyse.log
echo
echo Started services on the node      >> %U_DIR_ANALYSIS%\analyse.log
net start                              >> %U_DIR_ANALYSIS%\analyse.log
echo.                                  >> %U_DIR_ANALYSIS%\analyse.log
echo Getting network info ...
echo      NETSTAT -a                     >> %U_DIR_ANALYSIS%\SYS\netstat_a.lst
netstat -a                               >> %U_DIR_ANALYSIS%\SYS\netstat_a.lst
echo.                                  >> %U_DIR_ANALYSIS%\SYS\netstat_a.lst

echo      NETSTAT -na                     >> %U_DIR_ANALYSIS%\SYS\netstat_na.lst
netstat -na                               >> %U_DIR_ANALYSIS%\SYS\netstat_na.lst
echo.                                  >> %U_DIR_ANALYSIS%\SYS\netstat_na.lst

echo liste des process depuis le demarage du systeme > %U_DIR_ANALYSIS%\SYS\ps-ef.lst 
uxpulist.exe                                           >> %U_DIR_ANALYSIS%\SYS\ps-ef.lst

rem # ne pas oublier dqm  

echo   UNILEVEL                       >> %U_DIR_ANALYSIS%\analyse.log
type %uxmgr%\u_fali01.txt             >> %U_DIR_ANALYSIS%\analyse.log
echo.                                 >> %U_DIR_ANALYSIS%\analyse.log

echo   VERSION                        >> %U_DIR_ANALYSIS%\analyse.log
call %uxexe%\uxversion.bat            >> %U_DIR_ANALYSIS%\analyse.log
echo.                                 >> %U_DIR_ANALYSIS%\analyse.log

echo ENVIRONNEMENT DES EXE DE DOLLAR UNIVERSE >> %U_DIR_ANALYSIS%\analyse.log

rem echo /etc/*DQM*          >>  analyse.log
rem ls -ltr /etc/*DQM*       >>  analyse.log
rem echo "\n"                >>  analyse.log

echo  ENVIRONNEMENT DE DONNEES  DOLLAR UNIVERSE  >> %U_DIR_ANALYSIS%\analyse.log

echo UXDIR_ROOT: creation time:       > %U_DIR_ANALYSIS%\DLS\creation_time.log
call :tsp        	             >> %U_DIR_ANALYSIS%\DLS\creation_time.log
dir /tc /q /o /s   %UXDIR_ROOT%      >> %U_DIR_ANALYSIS%\DLS\creation_time.log
call :tsp        	             >> %U_DIR_ANALYSIS%\DLS\creation_time.log
echo.                                >> %U_DIR_ANALYSIS%\DLS\creation_time.log
echo Listing file creationg time ... 
echo UXDIR_ROOT: last access time:    > %U_DIR_ANALYSIS%\DLS\last_access.log
call :tsp        	             >> %U_DIR_ANALYSIS%\DLS\last_access.log
dir /ta /q /o /s   %UXDIR_ROOT%      >> %U_DIR_ANALYSIS%\DLS\last_access.log
call :tsp        	             >> %U_DIR_ANALYSIS%\DLS\last_access.log
echo.                                >> %U_DIR_ANALYSIS%\DLS\last_access.log
echo Listing last access time ...
echo UXDIR_ROOT: last written time:   > %U_DIR_ANALYSIS%\DLS\last_writen.log
call :tsp        	             >> %U_DIR_ANALYSIS%\DLS\last_writen.log
dir /tw /q /o /s   %UXDIR_ROOT%      >> %U_DIR_ANALYSIS%\DLS\last_writen.log
call :tsp        	             >> %U_DIR_ANALYSIS%\DLS\last_writen.log
echo.                                >> %U_DIR_ANALYSIS%\DLS\last_writen.log
echo Listing last writtine time ...
echo UXDIR_ROOT access right:	      > %U_DIR_ANALYSIS%\DLS\access_right.log
cacls %UXDIR_ROOT% /t 		     >> %U_DIR_ANALYSIS%\DLS\access_right.log
echo.

rem echo            INCIDENT             >> %U_DIR_ANALYSIS%\analyse.log

rem if exist %UXLEX%\* copy %UXLEX%\*  %U_DIR_ANALYSIS%\LOG\UXLEX_*
rem if exist %UXLSI%\* copy %UXLSI%\*  %U_DIR_ANALYSIS%\LOG\UXLSI_*
rem if exist %UXLIN%\* copy %UXLIN%\*  %U_DIR_ANALYSIS%\LOG\UXLIN_*
rem if exist %UXLAP%\* copy %UXLAP%\*  %U_DIR_ANALYSIS%\LOG\UXLAP_*
if %target%==S goto E_LOG_COPY
if %Area% == EXP copy %UXLEX%\*  %U_DIR_ANALYSIS%\LOG\*
if %Area% == SIM copy %UXLSI%\*  %U_DIR_ANALYSIS%\LOG\*
if %Area% == INT copy %UXLIN%\*  %U_DIR_ANALYSIS%\LOG\*
if %Area% == APP copy %UXLAP%\*  %U_DIR_ANALYSIS%\LOG\*
:E_LOG_COPY
rem if exist %U_DIR_ANALYSIS%\universe.log del /f %U_DIR_ANALYSIS%\universe.log
rem if exist %U_LOG_FILE% copy %U_LOG_FILE%  %U_DIR_ANALYSIS%\u_universe.log
echo SERVEUR IO                                         >  %U_DIR_ANALYSIS%\SYS\pid_fic.lst
uxgawk "/UXLK_SetShmLck/ {print $0}" %U_LOG_FILE%         >> %U_DIR_ANALYSIS%\SYS\pid_fic.lst
uxgawk "/UXIO_SrvInit/ {print $0}"  %U_LOG_FILE%          >> %U_DIR_ANALYSIS%\SYS\pid_fic.lst    
echo ORDOS                                              >> %U_DIR_ANALYSIS%\SYS\pid_fic.lst
uxgawk "/UxOrd/ {print $0}" %U_LOG_FILE%                  >> %U_DIR_ANALYSIS%\SYS\pid_fic.lst
echo.                                                   >> %U_DIR_ANALYSIS%\SYS\pid_fic.lst
echo SURV                                               >> %U_DIR_ANALYSIS%\SYS\pid_fic.lst
uxgawk "/uxsurv/ {print $0}" %U_LOG_FILE%                 >> %U_DIR_ANALYSIS%\SYS\pid_fic.lst
echo.                                                   >> %U_DIR_ANALYSIS%\SYS\pid_fic.lst

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

:FIN_OK

rem echo %S_PROCEXE% : Normal END
set resexe=0
REM cls

goto FIN

:FIN
if %target%==C goto E_LAUNCH_STEP2
:LAUNCH_STEP2
echo Getting disk info ...
cscript //nologo //E:vbscript  ./step2_v4.0 df > %U_DIR_ANALYSIS%\SYS\df.txt
echo Getting Windows event log ...
cscript //nologo //E:vbscript  ./step2_v4.0 get_evtlog > %U_DIR_ANALYSIS%\SYS\eventlog.txt
echo Getting Window Hotfix info ...
cscript //nologo //E:vbscript  ./step2_v4.0 HOTFIX > %U_DIR_ANALYSIS%\SYS\hotfix.txt"
echo Getting Dollar Universe registry ...
cscript //nologo //E:vbscript  ./step2_v4.0 list_reg > %U_DIR_ANALYSIS%\SYS\registry_list.txt
echo Getting system info ...
cscript //nologo //E:vbscript  ./step2_v4.0 nic > %U_DIR_ANALYSIS%\SYS\system.txt
cscript //nologo //E:vbscript  ./step2_v4.0 OS >> %U_DIR_ANALYSIS%\SYS\system.txt
cscript //nologo //E:vbscript  ./step2_v4.0 PC >> %U_DIR_ANALYSIS%\SYS\system.txt
echo Getting process info ...
cscript //nologo //E:vbscript  ./step2_v4.0 ps > %U_DIR_ANALYSIS%\SYS\processes.txt
echo Getting service info ...
cscript //nologo //E:vbscript  ./step2_v4.0 service > %U_DIR_ANALYSIS%\SYS\services.txt

:E_LAUNCH_STEP2
echo *****************************************************************
echo *
echo * THE DIRECTORY %U_DIR_ANALYSIS% HAS BEEN CREATED
echo * PLEASE, COMPRESS IT AND SEND THE FILE TO YOUR TECHNICAL SUPPORT
echo *
echo *****************************************************************

pause
goto :eof

:tsp
date /t >date.tmp
time /t >>date.tmp
uxsetenvfromfile d date.tmp 1 0 20 uxdatetemp.bat > setdate.log
call uxdatetemp
uxsetenvfromfile t date.tmp 2 0 20 uxtimetemp.bat > settime.log
call uxtimetemp
echo #TSP: %d% %t% %cmd_name% >>%U_DIR_ANALYSIS%\timestamp.txt 
del uxtimetemp.bat
del settime.log
del setdate.log
del date.tmp
goto :eof