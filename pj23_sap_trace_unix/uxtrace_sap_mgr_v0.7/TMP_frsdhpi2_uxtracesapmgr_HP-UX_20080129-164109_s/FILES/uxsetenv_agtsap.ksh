#! /bin/ksh
# ==========================================================================
#                         SAP JOB CONTROL SERVER
#
# Product : Dollar Universe Manager for SAP Solutions
# Component : SAP Job Control Server
# Author: ORSYP
#
# This file contains the environment variables for 
# the server or the commands
# 
# # $Revision: 1.21 $, $Date: 2005/08/17 13:28:35 $
# ==========================================================================

# ---------------------------------------------------
# Dollar Universe-like standard variables
# ---------------------------------------------------
UXSAP=/apps/DUSAP42/
export UXSAP

U_TMP_PATH=/apps/DUSAP42//temp
export U_TMP_PATH

UXDIR_ROOT=$UXSAP
export UXDIR_ROOT

UXEXE=$UXSAP/exec
export UXEXE

UXLOG=$UXSAP/log
export UXLOG

UXMGR=$UXSAP/mgr
export UXMGR

SRVNET_DIR=$UXMGR
export SRVNET_DIR

UNODE="frsdhpi2"
export UNODE

UCOMPANY="TST511"
export UCOMPANY

S_NOEUD=$UNODE
export S_NOEUD

U_LOCALHOSTNAME="frsdhpi2"
export U_LOCALHOSTNAME

U_LOG_FILE=/apps/DUSAP42//log/sapjcs.log
export U_LOG_FILE

U_MSG_FILE=$UXEXE/uni_msg.txt
export U_MSG_FILE

U_LIC_FILE=$UXMGR/u_fali01.txt
export U_LIC_FILE

# ------------------------------------------------------------------
# Add path for dynamic libraries
# ------------------------------------------------------------------
# HP-UX
if [ "${SHLIB_PATH}" = "" ]
then
   SHLIB_PATH=${UXSAP}/lib
else
   SHLIB_PATH=${UXSAP}/lib:${SHLIB_PATH}
fi
export SHLIB_PATH
# AIX
if [ "${LIBPATH}" = "" ]
then
   LIBPATH=${UXSAP}/lib
else
   LIBPATH=${UXSAP}/lib:${LIBPATH}
fi
export LIBPATH

# SUN, LINUX, DEC
if [ "${LD_LIBRARY_PATH}" = "" ]
then
   LD_LIBRARY_PATH=${UXSAP}/lib
else
   LD_LIBRARY_PATH=${UXSAP}/lib:${LD_LIBRARY_PATH}
fi
export LD_LIBRARY_PATH

# ---------------------------------------------------
# General parameters
# ---------------------------------------------------
UXSAP_CYCLE_AGT=10
export UXSAP_CYCLE_AGT
UXSAP_MAX_LOGLINE="1000"
export UXSAP_MAX_LOGLINE

# ---------------------------------------------------
# Port number 
# (if not defined, look at /etc/services file)
# (also declared in /etc/services on the client side,
#  it must be the same value)
# ---------------------------------------------------
# U_SAPAGT_NUMPORT="13250"
# export U_SAPAGT_NUMPORT

# ---------------------------------------------------
# Log
# ---------------------------------------------------
U_AGT_LOG="/apps/DUSAP42//log/sapjcs.log"
export U_AGT_LOG

U_AGT_LOG_LEVEL=0
export U_AGT_LOG_LEVEL

UXSAP_LOG_BAPIERROR="N"
export UXSAP_LOG_BAPIERROR

# ---------------------------------------------------
# To activate trace mode for BAPI_XBP function calls,
# use the following variable
# '0' (by default) : no trace
# greater than '0' : trace
# 'E'              : SAP debug mode
# ---------------------------------------------------
# AGTSAP_TRACE_DEVTRC="0"
# export AGTSAP_TRACE_DEVTRC

# ---------------------------------------------------
# Manager data files
# ---------------------------------------------------
UXSAP_RFC_INI_FILE=$UXMGR/uxsaprfc.ini
export UXSAP_RFC_INI_FILE
UXSAP_JNL_FILE=$UXEXE/uxsapjnl.dat
export UXSAP_JNL_FILE
UXSAP_HST_FILE=$UXEXE/uxsaphst.dat
export UXSAP_HST_FILE
UXSAP_EVT_FILE=$UXEXE/uxsapevt.dat
export UXSAP_EVT_FILE

# ---------------------------------------------------
# Automatic jobs specific variables
# ---------------------------------------------------
UXSAP_AUTO_MODE="NO"
export UXSAP_AUTO_MODE
UXSAP_AUTOPATH=$UXMGR
export UXSAP_AUTOPATH
UXSAP_FILTER_ORDER="JUS"
export UXSAP_FILTER_ORDER
UXSAP_START_AUTO_NOW="NO"
export UXSAP_START_AUTO_NOW

# ---------------------------------------------------
# SAP specific parameters
# ---------------------------------------------------
U_REPORT_DEFAULT="RSPARAM"
export U_REPORT_DEFAULT
U_VARIANT_DEFAULT="TEST"
export U_VARIANT_DEFAULT

# ---------------------------------------------------
# Advanced parameters
# ---------------------------------------------------
# U_AGT_NOTHREAD="NO"
# export U_AGT_NOTHREAD
# UXSAP_RETRY_NB=10
# export UXSAP_RETRY_NB
# U_RFC_TIMEOUT=360000
# export U_RFC_TIMEOUT=
# UXSAP_HST_FILE_RESET="NO"
# export UXSAP_HST_FILE_RESET
# UXSAP_AUTO_NBCYCLE=1
# export UXSAP_AUTO_NBCYCLE

alias agtsap="cd $UXSAP;PS1='$UXSAP# '"
alias agtlog="cd $UXLOG;PS1='$UXLOG# '"
alias agtsts="$UXMGR/uxagtsts.ksh"

