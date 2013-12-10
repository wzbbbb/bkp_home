ECHO OFF
REM  ==========================================================================
REM  ORSYP.Sa           
REM              ------------------------------------------------------
REM    Procedure for declaring a UNIVERSE environment
REM        Defining variables
REM        Defining REM aliases
REM 
REM 
REM    The following declarations are part of the common login
REM    UNIVERSE for the company TESTET
REM    (file created at installation)
REM  ==========================================================================
REM 
REM if (-e \etc\UNIVERSE_DQM_QCL500 ) then 
REM       set     UXDQM  \etc\UNIVERSE_DQM_QCL500
REM    REM alias   uxdqm  "cd $UXDQM;set prompt='$UXDQMREM  '"
REM  endif 
REM 
   set    U_MASK_UPR="u=rwx,g=rw,o=x" 
   set    UXDIR_ROOT=d:\du\cluster\QCL500
REM   
   set    UXEXE=d:\du\cluster\QCL500\exec
   set    UXMGR=d:\du\cluster\QCL500\mgr
   set    UXDAP=d:\du\cluster\QCL500\app\data
   set    UXDIN=d:\du\cluster\QCL500\int\data
   set    UXDSI=d:\du\cluster\QCL500\sim\data
   set    UXDEX=d:\du\cluster\QCL500\exp\data
   set    UXPAP=d:\du\cluster\QCL500\app\upr
   set    UXPIN=d:\du\cluster\QCL500\int\upr
   set    UXPSI=d:\du\cluster\QCL500\sim\upr
   set    UXPEX=d:\du\cluster\QCL500\exp\upr
   set    UXLAP=d:\du\cluster\QCL500\app\log
   set    UXLIN=d:\du\cluster\QCL500\int\log
   set    UXLSI=d:\du\cluster\QCL500\sim\log
   set    UXLEX=d:\du\cluster\QCL500\exp\log
   set    UXLOG=d:\du\cluster\QCL500\exp\log
REM
   set    U_LOG_FILE=d:\du\cluster\QCL500\exp\log\universe.log
   set    U_MSG_FILE=d:\du\cluster\QCL500\exec\uni_msg.txt
   set    U_LIC_FILE=d:\du\cluster\QCL500\mgr\u_fali01.txt
REM
REM   set    U_EDITEUR_R "vi -R "
REM   set    U_EDITEUR_W "vi "
REM
   set    SRVNET_DIR=d:\du\cluster\QCL500\mgr
   set    S_CODPROF=PROFADM
   set    S_SOCIETE=QCL500
   set    S_U_LANGUE=EN
   set    S_TIMEOUT=60
   set    S_ESPEXE=X
   set    S_UNIVERS=E
   set    S_APPLI=U_
   set    VersionCompany=50
REM 
   set    U_FMT_DATE=MM/DD/YYYY
REM
   set    S_NOEUD=DA_US_W_07
   set    S_CODCENTRAL=N
   set    S_PLAGEHORAIRE="0:0/23:59"
REM  
REM 
REM  warning : U_PMP_DISABLE U_CDJ_DISABLE and UNIVERSE_DQM_QCL500 
REM            UNIVERSE_USERALIAS_QCL500 UNIVERSE_SECURITY_QCL500
REM             are also defined in 
REM            universe.def and QCL500.def 
REM 
   set    UNIVERSE_DQM_QCL500=yes
   set    UNIVERSE_USERALIAS_QCL500=d:\du\cluster\QCL500\mgr\useralias.txt 
   set    UNIVERSE_SECURITY_QCL500=d:\du\cluster\QCL500\mgr\security.txt
   set    U_CDJ_DISABLE=no
   set    U_PMP_DISABLE=yes
   if     NOT "%UNIVERSE_DQM_QCL500%"=="no"    set START_DQM=Y
set DQM_COPY_LOG=Y 
set U_AGTSAP_VERSION_REQUEST=N 
