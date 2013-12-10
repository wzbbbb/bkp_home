#! /bin/ksh
###################################################################
#                       UXTRACE UNIX                              #
###################################################################
# @(#) script sh but executed in ksh
# @(#) created by  : Guy MULLER (Orsyp)
###################################################################
##
# revision : 2.6.0
# date     : 20050606
# author   : Zhibing Wang (Orsyp Inc)
# modifs   : Minor enhancements
#	   : Adding uxlst, uxshw res, and uxlst cal
#          : Adding the "ls -L" option for /etc/hosts and the log directories 
#          : A better way to detecting if the Dollar Universe Company is up
#          : Adding the library link check for V510
UXTRACEVERSION="2.6.0"
##
# revision : 2.5.9
# date     : 20040721
# author   : Guy Muller (Orsyp Inc)
# modifs   : Minor Correction
##
# revision : 2.5.8
# date     : 20040720
# author   : Guy Muller (Orsyp Inc)
# modifs   : Enhancements
# 	   : Gets additionnal files
# 	   : Includes the nis commands
# 	   : Collect the statistic files
##
# revision : 2.5.7
# date     : 20040322
# author   : Guy Muller (Orsyp Inc)
# modifs   : Minor Corrections
# 	   : Executes the uxgethrd cmd
# 	   : Executes the top cmd
##
# revision : 2.5.6
# date     : 20040310
# author   : Guy Muller (Orsyp Inc)
# modifs   : Minor Corrections
##
# revision : 2.5.5
# date     : 20040302
# author   : Guy Muller (Orsyp Inc)
# modifs   : Enhancements
#          : Introduce a log pickup management to avoid the collection of all the job logs
#          : Introduce the files collection option instead of doing a listing
#	   : Variabalize the BG time out delay
#	   : Backup of the dffdob file (-c option)
#          : Minor Corrections
##
# revision : 2.5.4
# date     : 20040226
# author   : Guy Muller (Orsyp Inc)
# modifs   : Enhancements
#          : Introduce the -L option
##
# revision : 2.5.3
# date     : 20031211
# author   : Guy Muller (Orsyp Inc)
# modifs   : Minor Corrections
#          : Get also the information related to a task based on a session
#          : Add a time stamp in all logs
#          : Add some traces in the UX_BG command
#          : Get the result of the uxgetnla command (if exists)
##
# revision : 2.5.1
# date     : 20030924-1003
# author   : Guy Muller (Orsyp Inc)
# modifs   : Minor Corrections
#          : Exit before the final packaging when using the -d parameter
#          : Force the execution in ksh
#          : Correction of an issue linked to the specific behavior of the which command on Suze Linux
#          : Changed the way to display the uxtrace help
##
# revision : 2.5
# date     : 20030807
# author   : Guy Muller (Orsyp Inc)
# modifs   : Packaging
##
# revision : 2.4
# date     : 20030611
# author   : Guy Muller (Orsyp Inc)
# modifs   : Major Enhancements
##
# revision : 2.3
# date     : 20030412
# author   : Guy Muller (Orsyp Inc)
# modifs   : Average Enhancements
##
# revision : 2.2
# date     : 11/03/2002 - 15/03/2002
# author   : Guy Muller (Orsyp)
# modifs   : Minor Corrections
##
# revision : 2.1
# date     : ??/??/????
# author   : Guy Muller (Orsyp)
# modifs   : Average Enhancements
##
# revision : 2.0
# date     : ??/??/????
# author   : Guy Muller (Orsyp)
# modifs   : Global Redisign
##
# creation : 1.0
# date     : ??/??/????
# auteur   : ???
############################################################################
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
#--------------------------------------------------------#
# Parametrisation variables
#--------------------------------------------------------#
# 	* modify the folder location of the created uxtrace package
#	* Default value 		${UXMGR}
#	* Other values possibles	the absolute path of an existant folder
# UXTRACELOCATE="/tmp"

# 	* modify the number of job logs collected. 
#	* Default value 		25
#	* Other values possibles	a number between 0 and 500 (0 means no job log collected)
# UXLOGNB=100

# 	* modify the number days the job log are collected.
#	* Default value 		7
#	* Other values possibles	a number between 0 and 100 (0 means no job log collected)
# UXLOGDELAY=1

# 	* modify limit size, above which a collection of the file is done (instead of a listing of the content) (in Kb)
#	* Default value 		10000
#	* Other values possibles	a number between 0 and 1000000
# UXDUFILESIZELIM=20000

# 	* Definition of the main area
#	* Default value 		X
#	* Other values possibles	A,I,S
# UXMAINAREA=S

# 	* Specific list of files to get
#	* Default value 		""
#	* Other values possibles	A list of name of $U files (without the extension)
#         A cp *<file name>*<extension> will be done.
# UXFILESTOGET="fmsb fttg fupr"

# 	* modify the sytem's screenshots taken
#	* Default value 		4 
#	* Other values possibles	a number between 1 and 80
# UXLOOPNUMBER=10

# 	* Delay before declaring that the system does not answer (in secondes)
#	* Default value 		20
#	* Other values possibles	a number between 1 and 100
# UXBGTIMEOUT=30

# 	* modify the waiting time between 2 system's screenshots
#	* Default value 		15 
#	* Other values possibles	a number between 1 and 600
# UXSLEEPTIME=30

# 	* keep the created uxtrace folder
#	* Default value 		N
#	* Other values possibles	Y or y
# UXKEEPUXTRACEFOLDER=Y

# 	* disable the compression of the created uxtrace package
#	* Default value 		Y
#	* Other values possibles	N or n
# UXCOMPRESSUXTRACEFOLDER=N

# 	* Name of the customized script which is submitted at the end of the uxtrace
#	* Default value 		${UXMGR}/uxtrace_cust
#	* Other values possibles	<Complete path of a customized script>"
# UXCUSTSCRIPT=/tmp/uxtrace_cust

# 	* Submission mode of the customized script (sourced by default)
#	* Default value 		s
#	* Other values possibles	k
# UXLAUNCHCUSTSCRIPT=k

#--------------------------------------------------------#
# Debug Variables
#--------------------------------------------------------#
#UXTRACEMODEX=ON
#UXTRACEMODEV=ON

#--------------------------------------------------------#
# Internal variables (Do not modify them)
#--------------------------------------------------------#
UXLISTAREA="X S I A"
UXLIB=${UXEXE}/lib
UXENGINESLIST="CAL ECH ORD SUR"
UXCONFFOLDERALIAS="UXMGR UXEXE UXLIB"
eval ux_path_log=\$${UXLOG}
eval ux_path_lex=\$${UXLEX}
if [ "${ux_path_log}" = "${ux_path_lex}" ]; then
	UXLOGFOLDERALIAS="UXLEX UXLSI UXLIN UXLAP"
else
	UXLOGFOLDERALIAS="UXLOG UXLEX UXLSI UXLIN UXLAP"
fi
UXDUDATAFOLDERALIAS="UXDEX UXDSI UXDIN UXDAP UXDIR_ROOT"
UXDATAFOLDERALIAS="UXPEX UXPSI UXPIN UXPAP ${UXLOGFOLDERALIAS} U_TMP_PATH"
UXFOLDERALIAS="${UXDUDATAFOLDERALIAS} ${UXCONFFOLDERALIAS} ${UXDATAFOLDERALIAS}"
UXLSTFILESOTHER="/etc/services /etc/hosts /etc/*release /etc/resolv.conf /proc/version ${U_PROXY_FILE} ${U_IO_PROXY_FILE} ${UXMVS_HOSTS_FILE} ${UXSAP_HOSTS_FILE}"
UXGETFILESUXMGR="uxsetenv* uxstartup* uxsrsrv.* uxlnm*.dat u_*.txt uxshutdown* U_ANTE_UPROC U_POST_UPROC U_SPV_JOB ux_vrf_rgz_rst* *dta install*"
UXGETFILESOTHER="/etc/UNIVERSE_SECURITY_* /etc/UNIVERSE_USERALIAS_* /etc/hosts /etc/services /etc/*release /etc/resolv.conf /proc/version /etc/passwd /etc/group /etc/networks /etc/protocols"
UXGETFILESUXEXE="u_batch uxversion U_SPV_JOB *COM"
UXGETFILESUXDQM="uxshutdown* uxsrsrv.* uxstart* *.log *.dat u_*.txt ux*version"
UXGETFILESSAP="*.ini ux*version uxsetenv* uxshutdown* uxsrsrv* uxstart* uxsapjnldump *.log *.dat u_sap* dev_rfc *.txt *.ext *.ksh" 
UXGETFILESRFC="uxsrsrv* uxsetenv* *.log *.ksh *.ini dev_rfc u_*.txt ux*version"
UXLOGFILELIST="universe.log uxcdjsrv.log uxcmdsrv.log uxioserv.log uxstartdqm.log *_CAL*.LOG *_ORD*.LOG *_ECH*.LOG *_SUR*.LOG uxiotrns.log"

#--------------------------------------------------------#
# Technical variables (Do not modify them)
#--------------------------------------------------------#
UXINITIALFOLDER=`pwd`
UXOS=`uname | sed  's/\//_/g'`
UXTRACEDATE=`date +%Y%m%d-%H%M%S`
UXTRACECOMPD0="$0"
UXTRACEDIRD0=`dirname "${UXTRACECOMPD0}"`
UXTRACEBASD0=`basename "${UXTRACECOMPD0}"`
if [ "${UXOS}" = "Linux" ]; then
	print "Test String" > /dev/null 2>&1
	[ $? -eq 0 ] && UX_PRINT=OK
fi

[ ${UXTRACEMODEX:-OFF} = ON ] && set +x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set +v
#########################################################
# Functions
#########################################################
# ----------------------------------------------- #
# MESSAGE FUNCTION
# ----------------------------------------------- #
UX_MESSAGE ()
{
loc_os=`uname`
case ${loc_os} in
	Linux )
		if [ ${UX_PRINT:-KO} = OK ]; then
			print "$1"
		else
			echo "$1"
		fi;;
	* )
		echo "$1"
	;;
esac
}
# ----------------------------------------------- #
# Upper to Lower Case Function
# ----------------------------------------------- #
UX_UP_LOW ()
{
echo "$*" |  tr " [a-z] " " [A-Z] "
}
# ----------------------------------------------- #
# Lower to Upper Case Function
# ----------------------------------------------- #
UX_LOW_UP ()
{
echo "$*" |  tr " [A-Z] " " [a-z] "
}
# ----------------------------------------------- #
# Help Function
# ----------------------------------------------- #
HELP()
{
help_level=${1}
[ ${help_level:-0} -gt 0 ] && UX_MESSAGE "Unix uxtrace procedure version ${UXTRACEVERSION}"
UX_MESSAGE "Syntax : ${UXTRACECOMPD0} [-s] [-c] [-L] [-d] [-b] [-h <string>] [ -o] [-p <string>] [-l <num>] [-P] [-a <string>]"
UX_MESSAGE "	Trace flags :"
UX_MESSAGE " 	 -s : Traces issues with system symptoms"
UX_MESSAGE " 	 -c : Traces issues with Dollar Universe misconfiguration symptoms"
UX_MESSAGE " 	 -L : Lights traces"
UX_MESSAGE " 	 -p : Will run the specific procedure (variabalized by an argument) at the end of the uxtrace"
UX_MESSAGE " 	      [-p <variabilisation of the script>]"
UX_MESSAGE "	 -P : Won't run the standard specific procedure at the end of the uxtrace"
UX_MESSAGE "	 -l : Nb of days of job log collect (Default : ${UXLOGDELAY:-${UXLOGDELAYDFT}}"
UX_MESSAGE " 	      [-l <nb of days of job log collect>]"
UX_MESSAGE "	 -a : Define the main area"
UX_MESSAGE " 	 -o : Considers that the Dollar Universe company is shutdowned (not recommended)"
UX_MESSAGE " 	      type ${UXTRACECOMPD0} -h for more information"
UX_MESSAGE "	Execution modes :"
UX_MESSAGE " 	 -d : Will divide the uxtrace result into 3 packages instead of one package"
UX_MESSAGE " 	 -b : Will run the uxtrace in batch mode (No interactive questions)"
UX_MESSAGE " 	 -h : Displays short help"
UX_MESSAGE " 	 -h full : Displays global help (More details about the different options)"
UX_MESSAGE " 	      type ${UXTRACECOMPD0} -h full for more information"
[ ${help_level:-0} -eq 0 ] && return 1
UX_MESSAGE "Details for the different trace flags"
UX_MESSAGE " 	 -s : Traces issues with system symptoms"
UX_MESSAGE "		Defined as issues with system symptoms and/or an issue where Dollar Universe exhibits :"
UX_MESSAGE "		  - an abnormally long response time"
UX_MESSAGE "		  - a disproportionate amount of CPU consumption"
UX_MESSAGE "		  - no longer reacts"
UX_MESSAGE " 	 -c : Traces issues with Dollar Universe misconfiguration symptoms"
UX_MESSAGE "		Defined as issues with Dollar Universe misconfiguration symptoms,"
UX_MESSAGE "		issues regarding dependencies between uprocs, processing date etc ..."
UX_MESSAGE " 	 -L : Light traces"
UX_MESSAGE "		Get some light traces to get a low level screenshot of the Dollar Universe company."
UX_MESSAGE "		This option disables the -s and the -c options."
UX_MESSAGE " 	 -p : Will run a specific procedure (using a variable argument) at the end of the uxtrace"
UX_MESSAGE " 	 	For example if you wanted to source the following script at the end of the uxtrace :"
UX_MESSAGE "		${UXCUSTSCRIPTDFT}_01"
UX_MESSAGE "		Use the -p parameter such as -p01, for example ${UXTRACECOMPD0} -scp01"
UX_MESSAGE "		Please notice that the following default script is always executed (if present) unless -P is specified."
UX_MESSAGE "		${UXCUSTSCRIPTDFT}"
UX_MESSAGE "	 -P : Won't run the standard specific procedure at the end of the uxtrace"
UX_MESSAGE "	 -l : Nb of days of job log collect (Default : ${UXLOGDELAY:-UXLOGDELAYDFT})"
UX_MESSAGE " 	 	Will collect all the job logs older than the specified value"
UX_MESSAGE " 	 	Define it to 0 to no collect any job log"
UX_MESSAGE "	 -a : Define the main area"
UX_MESSAGE "	 	To use if your issue does not occur in the production area"
UX_MESSAGE "	 	for example for APP, it accepts A,a,app,APP"
UX_MESSAGE " 	 -o : Considers that the Dollar Universe company is shutdowned"
UX_MESSAGE " 	      A function in the ${UXTRACECOMPD0} procedure automaticaly tests the status of the Dollar Universe Company."
UX_MESSAGE " 	      Onlys use the -o flag at DollarAccess's request."
UX_MESSAGE " 	      This flag automatically switches the -s flag on"
UX_MESSAGE "Details for the different execution modes :"
UX_MESSAGE "	 -d : Will divide the uxtrace result in 3 packages instead of one package"
UX_MESSAGE "		To facilitate sending the results by e-mail"
UX_MESSAGE " 	 -b : Will run the uxtrace in batch mode (No interactive questions)"
UX_MESSAGE "Prerequisites"
UX_MESSAGE "	It is recommended to copy the uxtrace procedure into the xxx/mgr directory of the "
UX_MESSAGE "	Dollar Universe company you want to trace"
UX_MESSAGE "	If the trace procedure is not located there, the Dollar Universe environment must be loaded"
UX_MESSAGE "	for the company you want to trace."
}
# ----------------------------------------------- #
# Calculate the absolute time in second (hour limit)
# $1 : time in +%Y%m%d-%H%M%S format
# ----------------------------------------------- #
UX_ABS_TIME ()
{
ux_seconds=`echo $1 | cut -c14-15`
ux_minutes=`echo $1 | cut -c12-13`
ux_hours=`echo $1 | cut -c10-11`
ux_abs_time=`expr ${ux_seconds} + 60 * ${ux_minutes} + 60 * 60 * ${ux_hours}`
echo ${ux_abs_time}
}

# ----------------------------------------------- #
# Create a time stamp trace for time optimization
# ----------------------------------------------- #
UX_TIME_STAMP ()
{
loc_output="$1"
loc_message="$2"
loc_function="$3"
ux_time=`date +%Y%m%d-%H%M%S`
UX_MESSAGE "#TSP# ${loc_message} ${ux_time} ${loc_function}" >> ${loc_output} 2>&1
}

# ----------------------------------------------- #
# Check and launch a command
# ----------------------------------------------- #
UX_CMD()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
loc_path="$1" #npth if the command is not specified with an absolut path
loc_command="$2"
loc_output_file="$3"
loc_time_stamp="$4" #tspn for no time stamp, everything else for a time stamp


if [ "${loc_path:-npth}" = "npth" ]; then
	loc_command_to_test=`echo ${loc_command} | cut -d" " -f1`
	which ${loc_command_to_test} > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		[ ${loc_time_stamp:-tsp} = tspn ] || UX_TIME_STAMP ${UXTSPLOG} "#BEG#"
		UX_MESSAGE "#CMD# ${loc_command}" >> ${UXTSPLOG} 2>&1
		UX_MESSAGE "#CMD# ${loc_command}" >> ${loc_output_file} 2>&1
		[ ${loc_time_stamp:-tsp} = tspn ] || UX_TIME_STAMP ${loc_output_file}
		eval ${loc_command}               >> ${loc_output_file} 2>&1
		loc_return=$?
		[ ${loc_time_stamp:-tsp} = tspn ] || UX_TIME_STAMP ${UXTSPLOG} "#END#"
		return ${loc_return}
	else
		UX_MESSAGE "The command ${loc_command_to_test} is not in the PATH of `id`" 
		UX_MESSAGE "#REM# The command ${loc_command_to_test} is not in the PATH of `id`" >> ${UXTRACELOG}
		UX_MESSAGE "#REM# Value of the PATH : ${PATH}" >> ${UXTRACELOG}
		which ${loc_command_to_test} >> ${UXTRACELOG}
		which ${loc_command_to_test} 
		return 127
	fi
else
	[ ${loc_time_stamp:-tsp} = tspn ] || UX_TIME_STAMP ${UXTSPLOG} "#BEG#"
	UX_MESSAGE "#CMD# ${loc_path}/${loc_command}" >> ${UXTSPLOG} 2>&1
	UX_MESSAGE "#CMD# ${loc_path}/${loc_command}" >> ${loc_output_file} 2>&1
	[ ${loc_time_stamp:-tsp} = tspn ] || UX_TIME_STAMP ${loc_output_file}
	eval ${loc_path}/${loc_command}               >> ${loc_output_file} 2>&1
	loc_return=$?
	[ ${loc_time_stamp:-tsp} = tspn ] || UX_TIME_STAMP ${UXTSPLOG} "#END#"
	return ${loc_return}
fi
}

# ----------------------------------------------- #
# Launch a command in Background and abort it
# if it does not complete after a certain delay
# $1 : Command to get executed between quotes
# $2 : Output file of the command
# $3 : Maximum execution time
# $4 : Time Stamp flag :tspn for no time stamp, everything else for a time stamp
# ----------------------------------------------- #
UX_BG_CMD()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
# Local variable definition
loc_command="$1"
loc_output_file="$2"
loc_sup_time="$3"
loc_time_stamp="$4" #tspn for no time stamp, everything else for a time stamp
loc_command_to_test=`echo ${loc_command} | cut -d" " -f1`
loc_shell_pid=$$
loc_sleep=5

#Calculation of the number of loops
loc_numb_end=`expr ${loc_sup_time} / ${loc_sleep}`
loc_loop_time=`expr ${loc_sleep} \* ${loc_numb_end}`
loc_numb=0

#Test/submission of the command
[ ${loc_time_stamp:-tsp} = tspn ] || UX_TIME_STAMP ${UXTSPLOG} "#BEG#"
UX_MESSAGE "#CMD# ${loc_command}" >> ${UXTSPLOG} 2>&1
UX_MESSAGE "#CMD# ${loc_command}" >> ${loc_output_file} 2>&1
[ ${loc_time_stamp:-tsp} = tspn ] || UX_TIME_STAMP ${loc_output_file}
eval "${loc_command}               >> ${loc_output_file} 2>&1 " &
loc_bg_cmd_pid=$!
UX_MESSAGE "#REM# Pid of the bg command : ${loc_bg_cmd_pid}" >> ${UXTSPLOG} 2>&1

#Loop beginning
ux_bg_jobs=`ps -ef | grep ${loc_bg_cmd_pid} | grep ${loc_shell_pid} | grep -v grep | grep ${loc_command_to_test}`
if [ ! "${ux_bg_jobs}nv" = "nv" ]; then
	until [ ${loc_numb} -ge ${loc_numb_end} ]
	do
		sleep ${loc_sleep}
		UX_MESSAGE "#CMD# ps -ef | grep ${loc_bg_cmd_pid} | grep ${loc_shell_pid} | grep -v grep | grep ${loc_command_to_test}" >> ${UXTSPLOG} 2>&1
		ps -ef | grep ${loc_bg_cmd_pid} | grep ${loc_shell_pid} | grep -v grep | grep ${loc_command_to_test} >> ${UXTSPLOG} 2>&1
		ux_bg_jobs=`ps -ef | grep ${loc_bg_cmd_pid} | grep ${loc_shell_pid} | grep -v grep | grep ${loc_command_to_test}`
	        loc_numb=`expr ${loc_numb} + 1`
		if [ "${ux_bg_jobs}nv" = "nv" ]; then
			break
		fi
	done
fi
ux_bg_jobs=`ps -ef | grep ${loc_bg_cmd_pid} | grep ${loc_shell_pid} | grep -v grep | grep ${loc_command_to_test}`
if [ ! "${ux_bg_jobs}nv" = "nv" ]; then
	UX_MESSAGE "#REM# Aborting the following process : " >> ${UXTRACELOG}
	UX_MESSAGE "#REM# ${ux_bg_jobs} " >> ${UXTRACELOG}
	UX_MESSAGE "#CMD# kill ${loc_bg_cmd_pid}" >> ${UXTRACELOG}
	kill ${loc_bg_cmd_pid} >> ${UXTRACELOG} 2>&1
	if [ $? -eq 0 ]; then
		UX_MESSAGE "#REM# The command ${loc_command} has been aborted after ${loc_loop_time} seconds" >> ${loc_output_file} 2>&1
		UX_MESSAGE "#REM# The command ${loc_command} has been aborted after ${loc_loop_time} seconds" >> ${UXTSPLOG} 2>&1
	else
		UX_MESSAGE "#REM# Some issue occurs in the aborting attempt of the command ${loc_command}" >> ${UXTRACELOG} 2>&1
	fi
	[ ${loc_time_stamp:-tsp} = tspn ] || UX_TIME_STAMP ${UXTSPLOG} "#END#"
	return 2
else
	[ ${loc_time_stamp:-tsp} = tspn ] || UX_MESSAGE "#REM# The BG job completed by itself" >> ${UXTSPLOG} 2>&1
	[ ${loc_time_stamp:-tsp} = tspn ] || UX_MESSAGE "#REM# END DETECTED at s:${loc_sleep} l:${loc_numb}" >> ${UXTSPLOG} 2>&1
	[ ${loc_time_stamp:-tsp} = tspn ] || UX_TIME_STAMP ${UXTSPLOG} "#END#"
	wait ${loc_bg_cmd_pid}
	l_return=$?
	if [ ${l_return:-0} = 127 ]; then
		l_return=0
		UX_MESSAGE "#REM# The wait command returned 127" >> ${UXTRACELOG}
		UX_MESSAGE "#REM# The return code of the command has been lost" >> ${UXTRACELOG}
		UX_MESSAGE "#REM# It will be forced to 0." >> ${UXTRACELOG}
	fi
	return ${l_return:-0}
fi
}

# ----------------------------------------------- #
# Check and assign default values to variables
# ----------------------------------------------- #
UX_CHECK_VARIABLES()
{
# $1 Name of the considered variable
eval ux_contain_value=\$${1}
[ ${ux_contain_value:-nv} = nv ] && eval ${1}=\$${1}DFT
export ${1}
}

# ----------------------------------------------- #
# Create a directory and manage the return code
# ----------------------------------------------- #
UX_CREATE_DIR ()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
loc_dir_name="$1"
loc_exit_way="$2"
l_pwd_init=`pwd`
if [ -d ${loc_dir_name} ]; then
	cd ${loc_dir_name}
	l_ret_code=$?
	if [ ${l_ret_code} -ne 0 ]; then
		UX_MESSAGE "The following directory already exists : ${loc_dir_name}"
		UX_MESSAGE "But not with the proper rights : `ls -ld ${loc_dir_name}`"
		[ ${loc_exit_way:-R} = E ] && exit 2
		[ ${loc_exit_way:-R} = E ] || return 2
	else
		cd ${l_pwd_init}
		return 0
	fi	
else
	mkdir ${loc_dir_name}
	l_ret_code=$?
	if [ ${l_ret_code} -ne 0 ]; then
		UX_MESSAGE "The following directory cannot be created : ${loc_dir_name}"
		UX_MESSAGE "Please check if `dirname ${UXTRACELOCATE}` exists well and has at least 10Mb free"
		[ ${loc_exit_way:-R} = E ] && exit 1
		[ ${loc_exit_way:-R} = E ] || return 1  
	else
		return 0
	fi
fi
}

# ----------------------------------------------- #
# Check if the Dollar Universe environment is loaded
#  or if the uxtrace script is located in the mgr
#  directory of the Dollar Universe company.
# ----------------------------------------------- #
UX_CHECK_ENV()
{
UX_MESSAGE "Dollar Universe environment verification"
if [ ${UXMGR:-nv} = nv ]; then
	if [ ! -r ./uxsetenv ] && [ ! -r ${UXTRACEDIRD0}/uxsetenv ]; then
		UX_MESSAGE "The Dollar Universe environment is not loaded"
		UX_MESSAGE "Please load it before launching this script"
		UX_MESSAGE "For more information please type : ${UXTRACECOMPD0} -h"
		exit 1
	else
		UX_MESSAGE "Loading the local uxsetenv environment file"
		[ -r ./uxsetenv ] && . ./uxsetenv
		[ -r ${UXTRACEDIRD0}/uxsetenv ] && . ${UXTRACEDIRD0}/uxsetenv
	fi
else
	UX_MESSAGE "Loading the uxsetenv environment file located in the directory :"
	UX_MESSAGE "	$UXMGR"
	. ${UXMGR}/uxsetenv
fi
}
# ----------------------------------------------- #
# Check if the user is root
# ----------------------------------------------- #
UX_CHECK_USER()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
loc_check_user=${1}
UX_MESSAGE "#REM# User Verification" >> ${UXTRACELOG}
UX_MESSAGE "#CMD# id " >> ${UXTRACELOG}
id >> ${UXTRACELOG} 2>&1
UX_CMD npth "id" ${UXTRACELOG} tspn
loc_admin_user=`grep S_USER_AUTOMATE ${UXMGR}/uxlnm${S_SOCIETE}.dat | cut -d= -f4 | sed 's/\"//g'` >> ${UXTRACELOG} 2>&1
UX_MESSAGE "#REM# Admin User ${loc_admin_user}" >> ${UXTRACELOG}
loc_id_root=`id | grep ${loc_check_user}` >> ${UXTRACELOG} 2>&1
loc_id_admin=`id | grep ${loc_admin_user}` >> ${UXTRACELOG} 2>&1
if [ "${loc_id_root:-nv}" = "nv" ] && [ "${loc_id_admin:-nv}" = "nv" ]; then
	UX_MESSAGE "#-----------------------WARNING------------------------#"
	UX_MESSAGE "It is recommended to launch this procedure with the root user account"
	UX_MESSAGE "or with the Dollar Universe Administrator user account :  ${loc_admin_user}"
	UX_MESSAGE "to have enough rights to get the required traces"
	UX_MESSAGE "the result of the id command is : "
	id
	UX_MESSAGE ""
	UX_MESSAGE "If you do not have the possibility to get connected with one of these both users"
	UX_MESSAGE "and to relaunch this trace procedure, let the trace procedure complete"
	UX_MESSAGE "and send the result to Dollar Access"
	UX_MESSAGE "But please notice that we may not have all the required traces to analyse this issue"
	UX_MESSAGE ""
	UX_MESSAGE "#WAR# User prerequisite not validated" >> ${UXTRACELOG} 2>&1
	uname -a >> ${UXTRACELOG} 2>&1
	UX_MESSAGE "" >> ${UXTRACELOG} 2>&1
	UX_MESSAGE "Waiting 10 seconds before starting to trace"
	sleep 10
fi
}

# ----------------------------------------------- #
# Get the list of processes for the Dollar Universe Company
# ----------------------------------------------- #
UX_GET_COMPANY_PROCESSES ()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
if [ ${UXOS:-nv} = AIX ]; then
	ps -ef -o "%U %p %P %a" | cut -c 1-2000 | grep -v "grep"
else
	ps -ef | cut -c 1-2000 | grep -v "grep"
fi
}
# ----------------------------------------------- #
# Check if company is started
#   $1 : Dollar Universe Area
# ----------------------------------------------- #
UX_CHECK_COMPANY ()
{
ux_loc_area=$1
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
ux_company_nb=`UX_GET_COMPANY_PROCESSES | grep "uxioserv ${S_SOCIETE} ${ux_loc_area}" | wc -l`
if [ ! ${ux_company_nb} -eq 0 ]; then
	echo "ON"
else
	UX_MESSAGE "#REM# Dollar Universe is stopped in the ${ux_loc_area} area"  >> ${UXTRACELOG}
	echo "OFF"
fi
}
# ----------------------------------------------- #
# Get Dollar Universe Informations
# ----------------------------------------------- #
UX_GET_COMPANY_LISTING()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
loc_du_trace_level=${1}
# 0 : no $U commands launched
# 3 : Minimum $U commands launched for a production issue
# 7 : All $U commands launched for the production area and less for the other areas
# 10 : All $U commands launched for all areas
[ ${loc_du_trace_level:-0} = 0 ] && return 1
#Internal Variables
OUTLOG=${UXTRACELOG}
g_file_size_lim=${UXDUFILESIZELIM}
for ux_area in ${UXLISTAREA}
do
	ux_company_status=`UX_CHECK_COMPANY ${ux_area}`
	if  [ ${ux_company_status:-OFF} = ON  ]; then
		UX_CREATE_DIR ${UXTRACELSTFOLDER} >> ${UXTRACELOG} 2>&1
		[ ! $? -eq 0 ] && return 1
		cd ${UXTRACELSTFOLDER}
		case ${ux_area} in
			X ) S_ESPEXE=EXP; area=EXP; l_data_dir=UXDEX;;
			S ) S_ESPEXE=SIM; area=SIM; l_data_dir=UXDSI;;
			A ) S_ESPEXE=APP; area=APP; l_data_dir=UXDAP;;
			I ) S_ESPEXE=INT; area=INT; l_data_dir=UXDIN;;
	        esac
		UX_MESSAGE "	Considering the ${area} area"
		if [ ${ux_area} = X ]; then
			if [ ${loc_du_trace_level} -ge 3 ]; then
				UX_CMD "${UXEXE}" "uxlst NODE TNODE=* full" ./admin_node_lst.txt >> ${OUTLOG} 2>&1
				UX_CMD "${UXEXE}" "uxlst MU MU=* full"      ./admin_mu_lst.txt   >> ${OUTLOG} 2>&1
				UX_CMD "${UXEXE}" "uxlst hdp full"          ./admin_hdp_lst.txt  >> ${OUTLOG} 2>&1
				UX_CMD "${UXEXE}" "uxshw MU MU=*"           ./admin_mu_shw.txt   >> ${OUTLOG} 2>&1
				UX_CMD "${UXEXE}" "lstproxy"                ./admin_lstproxy.txt >> ${OUTLOG} 2>&1
			fi
			if [ ${loc_du_trace_level} -ge 7 ]; then
				UX_CMD "${UXEXE}" "uxlst prof prof=* "      ./admin_prof_lst.txt >> ${OUTLOG} 2>&1
				UX_CMD "${UXEXE}" "uxlst user user=* full"  ./admin_user_lst.txt >> ${OUTLOG} 2>&1
				UX_CMD "${UXEXE}" "uxshw user user=*"       ./admin_user_shw.txt >> ${OUTLOG} 2>&1
				UX_CMD "${UXEXE}" "uxshw NODE TNODE=*"      ./admin_node_shw.txt >> ${OUTLOG} 2>&1
			fi
		fi	
		UX_CMD "${UXEXE}" "uxlst atm ${area} all partage"                         ./${area}_atm_lst.txt >> ${OUTLOG} 2>&1
		if [ ${loc_du_trace_level} -ge 3 ]; then
			if [ -x ${UXEXE}/uxgetnla ]; then
				UX_CMD "${UXEXE}" "uxgetnla ${S_SOCIETE} ${ux_area} ${S_NOEUD}"                   ./${area}_uxgetnla.txt >> ${OUTLOG} 2>&1
			else
				echo "#REM# uxgetnla not present or not executable" >> ${OUTLOG} 2>&1
				echo "#CMD# ls -l ${UXEXE}/uxgetnla" >> ${OUTLOG} 2>&1
				ls -l ${UXEXE}/uxgetnla >> ${OUTLOG} 2>&1
			fi
		fi

		eval l_data_dir_path=\$${l_data_dir}
		l_list_file="fmlp fmsb fmsp fmtp fmcx fmfu"
		if [ ${ux_area} = ${UXMAINAREA:-X} ] || [ ${loc_du_trace_level} -ge 10 ]; then
			l_list_file="${l_list_file} fmhs fmph"
		fi
		l_data_size_max=0
		for l_file in ${l_list_file}
		do
			l_data_size=`du -sk ${l_data_dir_path}/u_${l_file}[0-9][0-9].dta | cut -f1`
			UX_MESSAGE "#REM# The size of the files ${l_file} is : ${l_data_size} " >>  ${UXTRACELOG}
			[ ${l_data_size_max} -lt ${l_data_size:-0} ] && l_data_size_max=${l_data_size:-0}
		done

		if [ ${loc_du_trace_level} -ge 7 ]; then
			UX_CMD "${UXEXE}" "uxlst upr ${area} upr=* vupr=* full"                   ./${area}_upr_lst.txt >> ${OUTLOG} 2>&1
			UX_CMD "${UXEXE}" "uxlst tsk ${area} ses=* vses=* upr=* vupr=* mu=* full" ./${area}_tsk_lst.txt >> ${OUTLOG} 2>&1
			UX_CMD "${UXEXE}" "uxlst ses ${area} ses=* vses=* full"                   ./${area}_ses_lst.txt >> ${OUTLOG} 2>&1
			UX_CMD "${UXEXE}" "uxlst res ${area} "                   ./${area}_res_lst.txt >> ${OUTLOG} 2>&1
			UX_CMD "${UXEXE}" "uxlst cal ${area} "                   ./${area}_cal_lst.txt >> ${OUTLOG} 2>&1
			if [ ${l_data_size_max:-0} -ge ${g_file_size_lim} ]; then
				UX_GET_DU_FILES 0 ${ux_area} "${l_list_file}"
				UX_MESSAGE "#REM# One of the following file ${l_list_file} was too big, a collect of these files has been done in order to save time" >>  ./${area}_ctl_lst.txt 
				UX_MESSAGE "#REM# The maximume size is (in Kb) : ${l_data_size_max}" >>  ./${area}_ctl_lst.txt 
				UX_MESSAGE "#REM# One of the following file ${l_list_file} was too big, a collect of these files has been done in order to save time" >>  ./${area}_fla_lst.txt 
				UX_MESSAGE "#REM# The maximume size is (in Kb) : ${l_data_size_max}" >>  ./${area}_fla_lst.txt 
				UX_MESSAGE "#REM# One of the following file ${l_list_file} was too big, a collect of these files has been done in order to save time" >>  ./${area}_evt_lst.txt 
				UX_MESSAGE "#REM# The maximume size is (in Kb) : ${l_data_size_max}" >>  ./${area}_evt_lst.txt 
			else
				UX_CMD "${UXEXE}" "uxlst ctl ${area} ses=* vses=* upr=* vupr=* mu=* full" ./${area}_ctl_lst.txt >> ${OUTLOG} 2>&1
				UX_CMD "${UXEXE}" "uxlst fla ${area} full"                                ./${area}_fla_lst.txt >> ${OUTLOG} 2>&1
				UX_CMD "${UXEXE}" "uxlst evt ${area} full"                                ./${area}_evt_lst.txt >> ${OUTLOG} 2>&1
			fi
			UX_CMD "${UXEXE}" "uxlst ctl ${area} ses=* vses=* upr=IU_PUR full"        ./${area}_ctl_lst_upr_IU_PUR.txt >> ${OUTLOG} 2>&1
			if [ ${ux_area} = ${UXMAINAREA:-X} ] || [ ${loc_du_trace_level} -ge 10 ]; then
				UX_CMD "${UXEXE}" "uxshw ses ${area} ses=* vses=* lnk"                    ./${area}_ses_shw.txt >> ${OUTLOG} 2>&1
				UX_CMD "${UXEXE}" "uxshw tsk ${area} ses=* vses=* upr=* vupr=* mu=*"      ./${area}_tsk_shw.txt >> ${OUTLOG} 2>&1
				UX_CMD "${UXEXE}" "uxshw upr ${area} upr=* vupr=*"                        ./${area}_upr_shw.txt >> ${OUTLOG} 2>&1
				UX_CMD "${UXEXE}" "uxshw res ${area} res=* "                        ./${area}_res_shw.txt >> ${OUTLOG} 2>&1
				UX_CMD "${UXEXE}" "uxshw res ${area} res=* full"                        ./${area}_res_ful_shw.txt >> ${OUTLOG} 2>&1
				eval l_data_dir_path=\$${l_data_dir}
				if [ ${l_data_size_max:-0} -ge ${g_file_size_lim} ]; then
					UX_MESSAGE "#REM# One of the following file ${l_list_file} was too big, a collect of these files has been done in order to save time" >>  ./${area}_ctl_hst.txt 
					UX_MESSAGE "#REM# The maximume size is (in Kb) : ${l_data_size_max}" >>  ./${area}_ctl_hst.txt 
				else
					UX_CMD "${UXEXE}" "uxlst ctl ${area} ses=* vses=* upr=* vupr=* mu=* hst"  ./${area}_ctl_hst.txt >> ${OUTLOG} 2>&1
				fi
				UX_GET_DU_FILES 0 ${ux_area} "dffdob"
			fi	
		fi
		if [ ${loc_du_trace_level} -ge 3 ] && [ ${loc_du_trace_level} -lt 7 ]; then
			if [ ${l_data_size_max:-0} -ge ${g_file_size_lim} ]; then
				UX_GET_DU_FILES 0 ${ux_area} "${l_list_file}"
				UX_MESSAGE "#REM# One of the following file ${l_list_file} was too big, a collect of these files has been done in order to save time" >>  ./${area}_ctl_lst.txt 
				UX_MESSAGE "#REM# The maximume size is (in Kb) : ${l_data_size_max}" >>  ./${area}_ctl_lst.txt 
				UX_MESSAGE "#REM# One of the following file ${l_list_file} was too big, a collect of these files has been done in order to save time" >>  ./${area}_fla_lst.txt 
				UX_MESSAGE "#REM# The maximume size is (in Kb) : ${l_data_size_max}" >>  ./${area}_fla_lst.txt 
				UX_MESSAGE "#REM# One of the following file ${l_list_file} was too big, a collect of these files has been done in order to save time" >>  ./${area}_evt_lst.txt 
				UX_MESSAGE "#REM# The maximume size is (in Kb) : ${l_data_size_max}" >>  ./${area}_evt_lst.txt 
			else
				U_FMT_DATE="mm/dd/yyyy"; export U_FMT_DATE
				loc_since_date=`date +%m/%d/%Y`
				UX_CMD "${UXEXE}" "uxlst fla ${area} full since=\"(${loc_since_date},0000)\""                                ./${area}_fla_lst_lim.txt >> ${OUTLOG} 2>&1
				UX_CMD "${UXEXE}" "uxlst evt ${area} full since=\"(${loc_since_date},0000)\""                                ./${area}_evt_lst_lim.txt >> ${OUTLOG} 2>&1
				UX_CMD "${UXEXE}" "uxlst ctl ${area} ses=* vses=* upr=* vupr=* mu=* full since=\"(${loc_since_date},0000)\"" ./${area}_ctl_lst_lim.txt >> ${OUTLOG} 2>&1
			fi
		fi
	fi
done
UX_MESSAGE ""
}


# ----------------------------------------------- #
# List the job logs to be collected
# ----------------------------------------------- #
UX_LIST_LOG()
{
l_nb_log_backup=$1
l_uproc=$2

[ -f ${l_log_lst_tmp}_tmp ] && rm -f ${l_log_lst_tmp}_tmp
ls -t ./${l_area}*${l_uproc}* >> ${l_log_lst_tmp}_tmp 2>> ${UXTRACELOG}
l_ret_code=$?
if [ ${l_ret_code} -ne 0 ]; then
	[ -f ${l_log_lst_tmp}_tmp ] && rm -f ${l_log_lst_tmp}_tmp
	find . -name "${l_area}*${l_uproc}*" >> ${l_log_lst_tmp}_tmp 2>> ${UXTRACELOG}
	UX_MESSAGE "#WAR# Too many ${l_uproc} logs are present in the log directory, the ls function could be used" >> ${l_log_lst} 2>&1
	UX_MESSAGE "#WAR# The extracted logs may not be the ${l_nb_log_backup} oldest and the ${l_nb_log_backup} most recents logs" >> ${l_log_lst} 2>&1
	UX_MESSAGE "" >> ${l_log_lst} 2>&1
fi
UX_MESSAGE "#REM# ${l_nb_log_backup} first ${l_uproc} logs files " >> ${l_log_lst} 2>&1
UX_MESSAGE "#REM# from ${l_trsf_value} " >> ${l_log_lst} 2>&1
tail -${l_nb_log_backup} ${l_log_lst_tmp}_tmp >> ${l_log_lst} 2>> ${UXTRACELOG}
UX_MESSAGE "#REM# ${l_nb_log_backup} last ${l_uproc} logs files " >> ${l_log_lst} 2>&1
UX_MESSAGE "#REM# from ${l_trsf_value} " >> ${l_log_lst} 2>&1
head -${l_nb_log_backup} ${l_log_lst_tmp}_tmp >> ${l_log_lst} 2>> ${UXTRACELOG}
}

# ----------------------------------------------- #
# Pick Up Some Dollar Universe LOG Files (new)
# ----------------------------------------------- #
UX_PICK_LOG()
{
l_area=$1
l_nb_log_backup=$2
case ${l_area} in
	X ) l_log_dir=UXLEX;;
	S ) l_log_dir=UXLSI;;
	I ) l_log_dir=UXLIN;;
	A ) l_log_dir=UXLAP;;
esac
l_log_lst_name=./list_log.txt
l_log_lst=${UXTRACELOGFOLDER}/${l_log_dir}/${l_log_lst_name}
l_log_lst_tmp=${UXTRACELOGFOLDER}/${l_log_dir}/${l_log_lst_name}_tmp
eval l_trsf_value=\$${l_log_dir}

UX_TIME_STAMP ${UXTSPLOG} "#BEG#DEF#" "Defining which logs to collect from the ${l_log_dir} directory"
l_nb_log_backup=${l_nb_log_backup_main}

UX_LIST_LOG ${l_nb_log_backup} ""

l_nb_log_backup=`expr ${l_nb_log_backup} / 10`
[ ${l_nb_log_backup} -eq 0 ] && l_nb_log_backup=1
UX_LIST_LOG ${l_nb_log_backup} IU_PUR
UX_LIST_LOG ${l_nb_log_backup} IU_RTS

grep -v '^#' ${l_log_lst} > ${l_log_lst_tmp}_tmp
sort -u ${l_log_lst_tmp}_tmp > ${l_log_lst_tmp}
rm -f ${l_log_lst_tmp}_tmp >> ${UXTRACELOG} 2>&1
UX_TIME_STAMP ${UXTSPLOG} "#END#DEF#" "Defining which logs to collect from the ${l_log_dir} directory"
UX_TIME_STAMP ${UXTSPLOG} "#BEG#BKP#" "Backuping the logs from the ${l_log_dir} directory"
while read l_line; do
	[ ! "${l_line:-nv}" = "nv" ] && UX_CMD npth "cp -p ${l_line} ${UXTRACELOGFOLDER}/${l_log_dir} " ${UXTRACELOG}
done < ${l_log_lst_tmp}
rm -f ${l_log_lst_tmp}
UX_TIME_STAMP ${UXTSPLOG} "#END#BKP#" "Backuping the logs from the ${l_log_dir} directory"
UX_TIME_STAMP ${UXTSPLOG} "#BEG#FND1#" "Old logs files transfert from ${l_log_dir}"
find ${l_trsf_value} -name '*.LOG' -exec cp -p {} ${UXTRACELOGFOLDER}/${l_log_dir} \; >> ${UXTRACELOG} 2>&1
find ${l_trsf_value} -name '*.log' -exec cp -p {} ${UXTRACELOGFOLDER}/${l_log_dir} \; >> ${UXTRACELOG} 2>&1
UX_TIME_STAMP ${UXTSPLOG} "#END#FND1#" "Old logs files transfert from ${l_log_dir}"
}

# ----------------------------------------------- #
# Get Dollar Universe LOG Files (new)
# ----------------------------------------------- #
UX_GET_LOG()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
l_nb_log_backup_gen=$1
l_nb_days_bkp=$2
[ ${l_nb_log_backup_gen} -ge 500 ] && l_nb_log_backup_gen=500
l_nb_log_backup_main=`expr ${l_nb_log_backup_gen} \* 2`
l_log_lst_name=./list_log.txt

UX_CREATE_DIR ${UXTRACELOGFOLDER} >> ${UXTRACELOG} 2>&1
[ ! $? -eq 0 ] && return 1
for l_area in ${UXLISTAREA}
do
	case ${l_area} in
		X ) l_log_dir=UXLEX;;
		S ) l_log_dir=UXLSI;;
		I ) l_log_dir=UXLIN;;
		A ) l_log_dir=UXLAP;;
	esac
	UX_MESSAGE "	Considering the ${l_area} area"
	UX_MESSAGE "#REM# Considering the ${l_area} area" >> ${UXTRACELOG}
	UX_TIME_STAMP ${UXTSPLOG} "#BEG#" "Logs files transfert from ${l_log_dir}"
	eval l_trsf_value=\$${l_log_dir}
	if [ -x ${l_trsf_value} ]; then
		UX_CREATE_DIR ${UXTRACELOGFOLDER}/${l_log_dir} >> ${UXTRACELOG} 2>&1
		[ ! $? -eq 0 ] && return 1
		cd ${l_trsf_value}
		l_log_lst=${UXTRACELOGFOLDER}/${l_log_dir}/${l_log_lst_name}
		l_log_lst_tmp=${UXTRACELOGFOLDER}/${l_log_dir}/${l_log_lst_name}_tmp
		if [ ${log_flag:-off} = on ]; then
			if [ ${l_area} = ${UXMAINAREA:-X} ]; then
				if [  ${l_nb_days_bkp} -eq 0 ]; then
					UX_TIME_STAMP ${UXTSPLOG} "#BEG#FND1#" "Old logs files transfert from ${l_log_dir}"
					find . -name '*.stat' -exec cp -p {} ${UXTRACELOGFOLDER}/${l_log_dir} \; >> ${UXTRACELOG} 2>&1
					find . -name '*.LOG' -exec cp -p {} ${UXTRACELOGFOLDER}/${l_log_dir} \; >> ${UXTRACELOG} 2>&1
					find . -name '*.log' -exec cp -p {} ${UXTRACELOGFOLDER}/${l_log_dir} \; >> ${UXTRACELOG} 2>&1
					find . -name '*IU_RTS*' -exec cp -p {} ${UXTRACELOGFOLDER}/${l_log_dir} \; >> ${UXTRACELOG} 2>&1
					find . -name '*IU_PUR*' -exec cp -p {} ${UXTRACELOGFOLDER}/${l_log_dir} \; >> ${UXTRACELOG} 2>&1
					UX_TIME_STAMP ${UXTSPLOG} "#END#FND1#" "Old logs files transfert from ${l_log_dir}"
				else
					UX_TIME_STAMP ${UXTSPLOG} "#BEG#FND1#" "Old logs files transfert from ${l_log_dir}"
					find . -mtime +${l_nb_days_bkp} -a -name '*.stat' -exec cp -p {} ${UXTRACELOGFOLDER}/${l_log_dir} \; >> ${UXTRACELOG} 2>&1
					find . -mtime +${l_nb_days_bkp} -a -name '*.LOG' -exec cp -p {} ${UXTRACELOGFOLDER}/${l_log_dir} \; >> ${UXTRACELOG} 2>&1
					find . -mtime +${l_nb_days_bkp} -a -name '*.log' -exec cp -p {} ${UXTRACELOGFOLDER}/${l_log_dir} \; >> ${UXTRACELOG} 2>&1
					find . -mtime +${l_nb_days_bkp} -a -name '*IU_RTS*' -exec cp -p {} ${UXTRACELOGFOLDER}/${l_log_dir} \; >> ${UXTRACELOG} 2>&1
					find . -mtime +${l_nb_days_bkp} -a -name '*IU_PUR*' -exec cp -p {} ${UXTRACELOGFOLDER}/${l_log_dir} \; >> ${UXTRACELOG} 2>&1
					UX_TIME_STAMP ${UXTSPLOG} "#END#FND1#" "Old logs files transfert from ${l_log_dir}"
					UX_TIME_STAMP ${UXTSPLOG} "#BEG#FND2#" "Last logs files transfert from ${l_log_dir}"
					find . -mtime -${l_nb_days_bkp} -exec cp -p {} ${UXTRACELOGFOLDER}/${l_log_dir} \; >> ${UXTRACELOG} 2>&1
					UX_TIME_STAMP ${UXTSPLOG} "#END#FND2#" "Last logs files transfert from ${l_log_dir}"
				fi
			else
				UX_PICK_LOG ${l_area} ${l_nb_log_backup_main}
			fi
		else
			UX_PICK_LOG ${l_area} ${l_nb_log_backup_gen}
		fi
		for l_log_file in ${UXLOGFILELIST}
		do
			if [ -f ${UXTRACELOGFOLDER}/${l_log_dir}/${l_log_file} ]; then
				mv ${UXTRACELOGFOLDER}/${l_log_dir}/${l_log_file} ${UXTRACELOGFOLDER}/${l_log_dir}_${l_log_file}
			else
				UX_MESSAGE "#REM# ${l_log_file} not collected by the find procedures" >> ${UXTRACELOG} 2>&1
			fi
		done
		UX_TIME_STAMP ${UXTSPLOG} "#BEG#TAR#" "Packaging the ${l_log_dir} directory"
		UX_COMPRESS_FOLDER ${UXTRACELOGFOLDER} ${l_log_dir} Y  N >> ${UXTRACELOG} 2>&1
		UX_TIME_STAMP ${UXTSPLOG} "#END#TAR#" "Packaging the ${l_log_dir} directory"
	else
		UX_MESSAGE "#REM# ${l_trsf_value} folder is unreachable or does not exist" >> ${UXTRACELOG} 2>&1
	fi
	UX_TIME_STAMP ${UXTSPLOG} "#END#" "Logs files transfert from ${l_log_dir}"
done
eval l_path_log=\$${UXLOG}
eval l_path_lex=\$${UXLEX}
if [ ! "${l_path_log}" = "${l_path_lex}" ]; then
	l_log_dir=UXLOG
	UX_TIME_STAMP ${UXTSPLOG} "#BEG#" "Logs files transfert from ${l_log_dir}"
	l_trsf_value=${l_path_log}
	if [ -x ${l_trsf_value} ]; then
		UX_CREATE_DIR ${UXTRACELOGFOLDER}/${l_log_dir} >> ${UXTRACELOG} 2>&1
		[ ! $? -eq 0 ] && return 1
		cd ${l_trsf_value}
		UX_TIME_STAMP ${UXTSPLOG} "#BEG#FND1#" "Old logs files transfert from ${l_log_dir}"
		find ${l_trsf_value} -name '*.log' -exec cp -p {} ${UXTRACELOGFOLDER}/${l_log_dir} \; >> ${UXTRACELOG} 2>&1
		find ${l_trsf_value} -name '*.LOG' -exec cp -p {} ${UXTRACELOGFOLDER}/${l_log_dir} \; >> ${UXTRACELOG} 2>&1
		UX_TIME_STAMP ${UXTSPLOG} "#END#FND1#" "Old logs files transfert from ${l_log_dir}"
		for l_log_file in ${UXLOGFILELIST}
		do
			if [ -f ${UXTRACELOGFOLDER}/${l_log_dir}/${l_log_file} ]; then
				mv ${UXTRACELOGFOLDER}/${l_log_dir}/${l_log_file} ${UXTRACELOGFOLDER}/${l_log_dir}_${l_log_file}
			else
				UX_MESSAGE "#REM# ${l_log_file} not collected by the find procedures" >> ${UXTRACELOG} 2>&1
			fi
		done
		UX_TIME_STAMP ${UXTSPLOG} "#BEG#TAR#" "Packaging the ${l_log_dir} directory"
		UX_COMPRESS_FOLDER ${UXTRACELOGFOLDER} ${l_log_dir} Y  N >> ${UXTRACELOG} 2>&1
		UX_TIME_STAMP ${UXTSPLOG} "#END#TAR#" "Packaging the ${l_log_dir} directory"
	else
		UX_MESSAGE "#REM# ${l_trsf_value} folder is unreachable or does not exist" >> ${UXTRACELOG} 2>&1
	fi
	UX_TIME_STAMP ${UXTSPLOG} "#END#" "Logs files transfert from ${l_log_dir}"
fi
if [ ! -f "${UXLEX}/universe.log" ] && [ ! -f "${UXLOG}/universe.log" ]; then
	UX_MESSAGE "#REM# ${UXLEX}/universe.log or ${UXLOG}/universe.log do not exist" >> ${UXTRACELOG} 2>&1
	if [ -f ${U_LOG_FILE} ]; then
		UX_MESSAGE "#REM# ${U_LOG_FILE} exists we collect it" >> ${UXTRACELOG} 2>&1
		cp -p ${U_LOG_FILE} ${UXTRACELOGFOLDER}
	else
		UX_MESSAGE "#REM# ${U_LOG_FILE} does not exist" >> ${UXTRACELOG} 2>&1
	fi
fi

}
# ----------------------------------------------- #
# Get Dollar Universes Files
# ----------------------------------------------- #
UX_GET_FILES()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
UX_CREATE_DIR ${UXTRACEFILESFOLDER} >> ${UXTRACELOG} 2>&1
[ ! $? -eq 0 ] && return 1
UX_MESSAGE "#REM# Beginning of the copy of the MGR files" >> ${UXTRACELOG}
cd ${UXMGR}
for ux_file_name in ${UXGETFILESUXMGR}
do
	ls ${UXMGR}/${ux_file_name} > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		UX_MESSAGE "#CMD# cp -p ${UXMGR}/${ux_file_name} ${UXTRACEFILESFOLDER}/" >> ${UXTRACELOG}
		cp -p ${UXMGR}/${ux_file_name} ${UXTRACEFILESFOLDER}/ >> ${UXTRACELOG} 2>&1
	else
		UX_MESSAGE "#REM# The file ${UXMGR}/${ux_file_name} does exist" >> ${UXTRACELOG}
	fi
done
UX_MESSAGE "#REM# Beginning of the copy of the EXEC files" >> ${UXTRACELOG}
for ux_file_name in ${UXGETFILESUXEXE}
do
	ls ${UXEXE}/${ux_file_name} > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		UX_MESSAGE "#CMD# cp -p ${UXEXE}/${ux_file_name} ${UXTRACEFILESFOLDER}/" >> ${UXTRACELOG}
		cp -p ${UXEXE}/${ux_file_name} ${UXTRACEFILESFOLDER}/ >> ${UXTRACELOG} 2>&1
	else
		UX_MESSAGE "#REM# The file ${UXEXE}/${ux_file_name} does not exist" >> ${UXTRACELOG}
	fi
done
#UX_MESSAGE "" >> ${UXTRACELOG}
#UX_MESSAGE "#REM# Beginning of the copy of the /etc files" >> ${UXTRACELOG}
#for ux_file_name in ${UXGETFILESETC}
#do
#	ls /etc/${ux_file_name} > /dev/null 2>&1
#	if [ $? -eq 0 ]; then
#		UX_MESSAGE "#CMD# cp -p /etc/${ux_file_name} ${UXTRACEFILESFOLDER}/" >> ${UXTRACELOG}
#		cp -p /etc/${ux_file_name} ${UXTRACEFILESFOLDER}/ >> ${UXTRACELOG} 2>&1
#	else
#		UX_MESSAGE "#REM# The file /etc/${ux_file_name} does not exist" >> ${UXTRACELOG}
#	fi
#done
UX_MESSAGE "#REM# Beginning of the copy of system files" >> ${UXTRACELOG}
for ux_file_name in ${UXGETFILESOTHER}
do
	ls ${ux_file_name} > /dev/null 2>&1
	if [ $? -eq 0 ]; then
		UX_MESSAGE "#CMD# cp -p ${ux_file_name} ${UXTRACEFILESFOLDER}/" >> ${UXTRACELOG}
		cp -p ${ux_file_name} ${UXTRACEFILESFOLDER}/ >> ${UXTRACELOG} 2>&1
	else
		UX_MESSAGE "#REM# The file ${ux_file_name} does not exist" >> ${UXTRACELOG}
	fi
done
UX_MESSAGE "" >> ${UXTRACELOG}
UX_MESSAGE "#REM# Backup of the used trace procedure" >> ${UXTRACELOG}
UX_MESSAGE "#CMD# cd ${UXINITIALFOLDER}" >> ${UXTRACELOG}
UX_MESSAGE "#CMD# cp -p ${UXTRACECOMPD0} ${UXTRACEFILESFOLDER}" >> ${UXTRACELOG}
cd ${UXINITIALFOLDER}
cp -p ${UXTRACECOMPD0} ${UXTRACEFILESFOLDER}
if [ -r ${UXCUSTSCRIPT} ]; then
	UX_MESSAGE "#REM# Beginning of the copy of the ${UXCUSTSCRIPT} file" >> ${UXTRACELOG}
	UX_MESSAGE "#CMD# cp -p ${UXCUSTSCRIPT} ${UXTRACEFILESFOLDER}" >> ${UXTRACELOG}
	cp -p ${UXCUSTSCRIPT} ${UXTRACEFILESFOLDER} >> ${UXTRACELOG} 2>&1
else
	UX_MESSAGE "#REM# ${UXCUSTSCRIPT} file does not exist" >> ${UXTRACELOG}
fi
UX_MESSAGE "" >> ${UXTRACELOG}
}
# ----------------------------------------------- #
# List the rights of on folder
# ----------------------------------------------- #
UX_ANALYSE_FOLDER()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
#$1 the path of the folder to analyse
ux_locate=/
ux_field_position=2
until [ `echo ${1} | cut -d / -f ${ux_field_position}`_nv = _nv ]
do
	eval ux_pwd_${ux_field_position}=`echo ${1} | cut -d/ -f ${ux_field_position}`
        eval ux_transfert_value=\${ux_pwd_${ux_field_position}}
	UX_MESSAGE "#REM# Rights of the folder ${ux_locate}${ux_transfert_value}/"
        ux_rights=`ls -l ${ux_locate} | grep ' '${ux_transfert_value}'$' | wc -l `
	if [ ${ux_rights} -eq 0 ]; then
		ls -l ${ux_locate} | grep ' '${ux_transfert_value}' '
	else
		ls -l ${ux_locate} | grep ' '${ux_transfert_value}'$'
	fi
        ux_locate=${ux_locate}${ux_transfert_value}/
        ux_field_position=`expr ${ux_field_position} + 1`
done
}
# ----------------------------------------------- #
# List the rights of all the Dollar Universe folders
# ----------------------------------------------- #
UX_RIGHTS_ANALYSIS()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
loc_output_file=$1
UX_MESSAGE "The analysis of the rights of the Dollar Universe folders" >> ${loc_output_file}
UX_MESSAGE "" >> ${loc_output_file}
UX_MESSAGE "#REM# Analysis of the / folder" >> ${loc_output_file}
UX_MESSAGE "" >> ${loc_output_file}
ls -al / | grep "\.\."'$' >> ${loc_output_file} 2>&1
UX_MESSAGE "" >> ${loc_output_file}
UX_MESSAGE "#REM# The available place in / is" >> ${loc_output_file}
df -k / >> ${loc_output_file} 2>&1

for ux_folder in ${UXFOLDERALIAS}
do
        if [ ${ux_folder:-nv} != nv ]; then
                UX_MESSAGE "" >> ${loc_output_file}
                UX_MESSAGE "#REM# Analysis of the ${ux_folder} folder" >> ${loc_output_file}
                eval PATHPROG=\$${ux_folder} >> ${loc_output_file} 2>&1
		UX_ANALYSE_FOLDER ${PATHPROG} >> ${loc_output_file} 2>&1
                UX_MESSAGE "" >> ${loc_output_file}
                UX_MESSAGE "#REM# The available place in ${PATHPROG} is" >> ${loc_output_file}
                UX_CMD npth "df -k ${PATHPROG}" ${loc_output_file}
                UX_MESSAGE "" >> ${loc_output_file}
                UX_MESSAGE "#REM# The place occupied by ${PATHPROG} is" >> ${loc_output_file}
                UX_CMD npth "du -sk ${PATHPROG}" ${loc_output_file}
        fi
done
}
# ----------------------------------------------- #
# Scann DQM Installation
# ----------------------------------------------- #
UX_SCANN_DQM()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
loc_du_trace_level=${1}  #0 : no dqm commands launched, -gt 0 : dqm commands launched
if [ ${UXDQM:-nv} != nv ]; then
	UX_CREATE_DIR ${UXTRACEDQMFOLDER} >> ${UXTRACELOG} 2>&1
	[ ! $? -eq 0 ] && return 1
	loc_all_dqm_ls=${UXTRACEDQMFOLDER}/DQM_all_ls_ltrai.txt
	UX_MESSAGE "" >> ${loc_all_dqm_ls}
	UX_MESSAGE "#REM# LISTING OF ALL THE DQM DIRECTORIES" >> ${loc_all_dqm_ls}
	UX_CMD npth "ls -l /etc | grep UNIVERSE_DQM" ${loc_all_dqm_ls} tspn
	for ux_folder_name in `ls /etc | grep DQM 2> /dev/null`
	do
		if [ -x /etc/${ux_folder_name} ]; then
			UX_MESSAGE "#REM# LISTING OF THE /etc/${ux_folder_name}" >> ${loc_all_dqm_ls}
			UX_MESSAGE "#CMD# ls -l /etc | grep \"${ux_folder_name} \"" >> ${loc_all_dqm_ls}
			ls -l /etc | grep "${ux_folder_name} " >> ${loc_all_dqm_ls}
			UX_MESSAGE "#CMD# ls -ltrai /etc/${ux_folder_name}/*" >> ${loc_all_dqm_ls}
			ls -ltrai /etc/${ux_folder_name}/* >> ${loc_all_dqm_ls} 2>&1
			UX_MESSAGE "#CMD# ls -ltruai /etc/${ux_folder_name}/*" >> ${loc_all_dqm_ls}
			ls -ltruai /etc/${ux_folder_name}/* >> ${loc_all_dqm_ls} 2>&1
		else
			UX_MESSAGE "#REM# /etc/${ux_folder_name} is unreachable" >> ${loc_all_dqm_ls} 2>&1
			ls -l /etc/${ux_folder_name} >> ${loc_all_dqm_ls} 2>&1
		fi
		UX_MESSAGE "" >> ${loc_all_dqm_ls}
	done
	ls -l ${UXDQM} >> ${UXTRACELOG} 2>&1
	ux_folder_alias=UXDQM
	eval ux_transfert_value=\$${ux_folder_alias}
	loc_output=${UXTRACEDQMFOLDER}/DQM_${ux_folder_alias}_ls_ltrai.txt
	UX_MESSAGE "#REM# LISTING OF THE DOLLAR UNIVERSE ${ux_folder_alias} DIRECTORY (Sorted by time stamp)" >> ${loc_output}
	UX_CMD npth "ls -ltrai ${ux_transfert_value}" ${loc_output}
	loc_output=${UXTRACEDQMFOLDER}/DQM_${ux_folder_alias}_ls_ltruai.txt
	UX_MESSAGE "#REM# LISTING OF THE DOLLAR UNIVERSE ${ux_folder_alias} DIRECTORY (Sorted by time stamp)" >> ${loc_output}
	UX_CMD npth "ls -ltruai ${ux_transfert_value}" ${loc_output}
	if [ -x ${UXDQM} ]; then
		cd ${UXDQM}
		UX_MESSAGE "#REM# Beginning of the copy of the DQM files" >> ${UXTRACELOG}
		for ux_file_name in ${UXGETFILESUXDQM}
		do
			if [ -f ${UXDQM}/${ux_file_name} ]; then
				UX_MESSAGE "#CMD# cp -p ${UXDQM}/${ux_file_name} ${UXTRACEDQMFOLDER}/" >> ${UXTRACELOG}
				cp -p ${UXDQM}/${ux_file_name} ${UXTRACEDQMFOLDER}/ >> ${UXTRACELOG} 2>&1
			else
				UX_MESSAGE "#REM# The file ${UXDQM}/${ux_file_name} does not exist" >> ${UXTRACELOG}
			fi
		done
		ux_company_nb=`UX_GET_COMPANY_PROCESSES | grep "uxdqmsrv" | wc -l`
		if [ ! ${ux_company_nb} -eq 0 ] && [ ${loc_du_trace_level:-0} -gt 0 ]; then
			UX_BG_CMD "${UXDQM}/uxshwque queue=ALL" ${UXTRACEDQMFOLDER}/uxshw_queue_all.txt ${UXBGTIMEOUT}  >> ${UXTRACELOG} 2>&1
		fi
	else
		UX_MESSAGE "${UXDQM} does not exits or is unreachable"
	fi
fi
UX_MESSAGE ""
}
# ----------------------------------------------- #
# Scann Patrol Installation
# ----------------------------------------------- #
UX_GET_PAT_FILES()
{
UX_CREATE_DIR ${UXTRACEPATFOLDER} >> ${UXTRACELOG} 2>&1 
[ ! $? -eq 0 ] && return 1
if [ "${PATROL_HOME:-nv}" = "nv" ]; then
	UX_MESSAGE "#REM# The PATROL_HOME variable is not defined" >> ${UXTRACEPATFOLDER}/patrol.txt
	UX_MESSAGE "#REM# Value of \${PATROL_HOME} : ${PATROL_HOME}" >> ${UXTRACEPATFOLDER}/patrol.txt
else
	UX_MESSAGE "#REM# The PATROL_HOME variable is defined" >> ${UXTRACEPATFOLDER}/patrol.txt
	UX_MESSAGE "#REM# Value of \${PATROL_HOME} : ${PATROL_HOME}" >> ${UXTRACEPATFOLDER}/patrol.txt
	UX_CMD npth "ls -ltrai ${PATROL_HOME}/bin/UNI_*"           ${UXTRACEPATFOLDER}/patrol_ls_var.txt 
	UX_CMD npth "ls -ltrai ${PATROL_HOME}/lib/knowledge/UNI_*" ${UXTRACEPATFOLDER}/patrol_ls_var.txt
	UX_CMD npth "ls -ltrai ${PATROL_HOME}/lib/psl/UNI_*"       ${UXTRACEPATFOLDER}/patrol_ls_var.txt
	UX_CMD npth "cp -pR ${PATROL_HOME}/universe ${UXTRACEPATFOLDER}" ${UXTRACELOG}
	if [ ${?} -eq 0 ]; then
		UX_CMD npth "mv ${UXTRACEPATFOLDER}/universe ${UXTRACEPATFOLDER}/universe_var" ${UXTRACELOG}
		UX_COMPRESS_FOLDER ${UXTRACEPATFOLDER} universe_var Y  N >> ${UXTRACELOG} 2>&1
	fi
fi
if [ "${U_PATROL_HOME:-nv}" = "nv" ]; then
	UX_MESSAGE "#REM# The U_PATROL_HOME variable is not defined" >> ${UXTRACEPATFOLDER}/patrol.txt
	UX_MESSAGE "#REM# Value of \${U_PATROL_HOME} : ${U_PATROL_HOME}" >> ${UXTRACEPATFOLDER}/patrol.txt
else
	UX_MESSAGE "#REM# The U_PATROL_HOME variable is defined" >> ${UXTRACEPATFOLDER}/patrol.txt
	UX_MESSAGE "#REM# Value of \${U_PATROL_HOME} : ${U_PATROL_HOME}" >> ${UXTRACEPATFOLDER}/patrol.txt
	if [ ! "${PATROL_HOME:-nv}" = "${U_PATROL_HOME:-nv}" ]; then
		UX_MESSAGE "#REM# The PATROL_HOME and U_PATROL_HOME variables do not have the same value" >> ${UXTRACEPATFOLDER}/patrol.txt
		UX_CMD npth "ls -ltrai ${U_PATROL_HOME}/bin/UNI_*"           ${UXTRACEPATFOLDER}/patrol_ls_u_var.txt 
		UX_CMD npth "ls -ltrai ${U_PATROL_HOME}/lib/knowledge/UNI_*" ${UXTRACEPATFOLDER}/patrol_ls_u_var.txt
		UX_CMD npth "ls -ltrai ${U_PATROL_HOME}/lib/psl/UNI_*"       ${UXTRACEPATFOLDER}/patrol_ls_u_var.txt
		UX_CMD npth "cp -pR ${U_PATROL_HOME}/universe ${UXTRACEPATFOLDER}" ${UXTRACELOG}
		if [ ${?} -eq 0 ]; then
			UX_CMD npth "mv ${UXTRACEPATFOLDER}/universe ${UXTRACEPATFOLDER}/universe_u_var" ${UXTRACELOG}
			UX_COMPRESS_FOLDER ${UXTRACEPATFOLDER} universe_u_var Y  N >> ${UXTRACELOG} 2>&1
		fi
	else
		UX_MESSAGE "#REM# The PATROL_HOME and U_PATROL_HOME variables have the same value" >> ${UXTRACEPATFOLDER}/patrol.txt
	fi
fi
if [ ! -d /UNIVERSE/Patrol ]; then
	UX_MESSAGE "#REM# /UNIVERSE/Patrol does not exist" >> ${UXTRACEPATFOLDER}/patrol.txt
	UX_CMD npth "ls -ltrai /UNIVERSE" ${UXTRACEPATFOLDER}/patrol.txt 
else
	UX_MESSAGE "#REM# /UNIVERSE/Patrol does exist" >> ${UXTRACEPATFOLDER}/patrol.txt
	UX_CMD npth "ls -ltrai /UNIVERSE/Patrol/bin/UNI_*"           ${UXTRACEPATFOLDER}/patrol_ls_univ.txt 
	UX_CMD npth "ls -ltrai /UNIVERSE/Patrol/lib/knowledge/UNI_*" ${UXTRACEPATFOLDER}/patrol_ls_univ.txt
	UX_CMD npth "ls -ltrai /UNIVERSE/Patrol/lib/psl/UNI_*"       ${UXTRACEPATFOLDER}/patrol_ls_univ.txt
	UX_CMD npth "cp -pR /UNIVERSE/Patrol/universe ${UXTRACEPATFOLDER}" ${UXTRACELOG}
	if [ ${?} -eq 0 ]; then
		UX_CMD npth "mv ${UXTRACEPATFOLDER}/universe ${UXTRACEPATFOLDER}/universe_UNIV" ${UXTRACELOG}
		UX_COMPRESS_FOLDER ${UXTRACEPATFOLDER} universe_UNIV Y  N >> ${UXTRACELOG} 2>&1
	fi
fi
}
# ----------------------------------------------- #
# Scann TNG Installation
# ----------------------------------------------- #
UX_GET_TNG_FILES()
{
[ "${UXTNG_CAWTO:-nv}" = "nv" ] && return 1
UX_CREATE_DIR ${UXTRACETNGFOLDER} >> ${UXTRACELOG} 2>&1 
[ ! $? -eq 0 ] && return 1
UX_CMD npth "cp -p ${UXTNG_CAWTO} ${UXTRACETNGFOLDER}"  ${UXTRACELOG} >> ${UXTRACELOG} 2>&1
UX_MESSAGE "#REM# The value of \${UXTNG_CAWTO} is ${UXTNG_CAWTO}" >> ${UXTRACETNGFOLDER}/tng.txt
UX_CMD npth "ls -ldai /usr/lib/libux*/libuxspv*" ${UXTRACETNGFOLDER}/tng.txt tspn
}
# ----------------------------------------------- #
# Scann ITO Installation
# ----------------------------------------------- #
UX_GET_ITO_FILES()
{
[ "${UXITO_OPCMSG:-nv}" = "nv" ] && return 1
UX_CREATE_DIR ${UXTRACEITOFOLDER} >> ${UXTRACELOG} 2>&1 
[ ! $? -eq 0 ] && return 1
UX_CMD npth "cp -p ${UXITO_OPCMSG} ${UXTRACEITOFOLDER}"  ${UXTRACELOG} >> ${UXTRACELOG} 2>&1
UX_MESSAGE "#REM# The value of \${UXITO_OPCMSG} is ${UXITO_OPCMSG}" >> ${UXTRACEITOFOLDER}/ito.txt
UX_CMD npth "ls -ldai /usr/lib/libux*/libuxspv*" ${UXTRACEITOFOLDER}/ito.txt tspn
}
# ----------------------------------------------- #
# Scann COM Installation
# ----------------------------------------------- #
UX_GET_COM_FILES()
{
[ "${UXSPV_MSGJOB:-nv}" = "nv" ] && return 1
UX_CREATE_DIR ${UXTRACECOMFOLDER} >> ${UXTRACELOG} 2>&1 
[ ! $? -eq 0 ] && return 1
UX_CMD npth "cp -p ${UXSPV_MSGJOB} ${UXTRACECOMFOLDER}"  ${UXTRACELOG} >> ${UXTRACELOG} 2>&1
UX_MESSAGE "#REM# The value of \${UXSPV_MSGJOB} is ${UXSPV_MSGJOB}" >> ${UXTRACECOMFOLDER}/com.txt
UX_CMD npth "ls -ldai /usr/lib/libux*/libuxspv*" ${UXTRACECOMFOLDER}/com.txt tspn
}
# ----------------------------------------------- #
# Scann SAP Installation
# ----------------------------------------------- #
UX_GET_SAP_RFC_FILES()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
UXSAPAGTFOLDER="/etc/UNIVERSE_AGENT_SAP"
UXSRVRFCFOLDER="/etc/UNIVERSE_SERVER_RFC"
if [ ! -d ${UXSAPAGTFOLDER} ]; then
	UX_MESSAGE "	SAP Agent not considered"
	UX_MESSAGE "#REM# Can not access to the SAP folder :" >> ${UXTRACELOG}
	ls -l ${UXSAPAGTFOLDER} >> ${UXTRACELOG} 2>&1
	UX_MESSAGE "#REM# /etc/UNIVERSE_AGENT_SAP is unreachable" >> ${UXTRACELOG} 2>&1
	UX_CMD npth "ls -ld /etc/UNIVERSE_AGENT_SAP" ${UXTRACELOG} tspn
else 
	UX_CREATE_DIR ${UXTRACESAPFOLDER} >> ${UXTRACELOG} 2>&1
	[ ! $? -eq 0 ] && return 1
	UX_MESSAGE "#REM# LISTING OF THE /etc/UNIVERSE_AGENT_SAP" >> ${loc_sap_output}
	UX_CMD npth "ls -ld /etc/UNIVERSE_AGENT_SAP" ${loc_sap_output} tspn
	UX_CMD npth "ls -ltrR /etc/UNIVERSE_AGENT_SAP" ${loc_sap_output} tspn
	UX_MESSAGE "#REM# Beginning of the copy of the SAP files" >> ${UXTRACELOG}
	for ux_file_name in ${UXGETFILESSAP}
	do
		if [ -f ./${ux_file_name} ]; then
		UX_MESSAGE "#CMD# cp -p ${UXSAPAGTFOLDER}/${ux_file_name} ${UXTRACESAPFOLDER}/" >> ${UXTRACELOG}
			cp -p ${UXSAPAGTFOLDER}/${ux_file_name} ${UXTRACESAPFOLDER}/ >> ${UXTRACELOG} 2>&1
		else
			UX_MESSAGE "#REM# The file ${UXSAPAGTFOLDER}/${ux_file_name} does not exist" >> ${UXTRACELOG}
		fi
	done
fi

if [ ! -d ${UXSRVRFCFOLDER} ]; then
	UX_MESSAGE "	RFC Server not considered"
	UX_MESSAGE "#REM# Can not access to the RFC folder :" >> ${UXTRACELOG}
	ls -l ${UXSRVRFCFOLDER} >> ${UXTRACELOG} 2>&1
	UX_MESSAGE "#REM# /etc/UNIVERSE_SERVER_RFC is unreachable" >> ${UXTRACELOG} 2>&1
	UX_CMD npth "ls -ld /etc/UNIVERSE_SERVER_RFC" ${UXTRACELOG} tspn
else 
	UX_CREATE_DIR ${UXTRACERFCFOLDER} >> ${UXTRACELOG} 2>&1
	[ ! $? -eq 0 ] && return 1
	UX_MESSAGE "#REM# LISTING OF THE /etc/UNIVERSE_SERVER_RFC" >> ${loc_rfc_output}
	UX_CMD npth "ls -ld /etc/UNIVERSE_SERVER_RFC" ${loc_rfc_output} tspn
	UX_CMD npth "ls -ltrR /etc/UNIVERSE_SERVER_RFC" ${loc_rfc_output} tspn
	UX_MESSAGE "#REM# Beginning of the copy of the RFC files" >> ${UXTRACELOG}
	for ux_file_name in ${UXGETFILESRFC}
	do
		if [ -f ./${ux_file_name} ]; then
			UX_MESSAGE "#CMD# cp -p ${UXSRVRFCFOLDER}/${ux_file_name} ${UXTRACERFCFOLDER}/" >> ${UXTRACELOG}
			cp -p ${UXSRVRFCFOLDER}/${ux_file_name} ${UXTRACERFCFOLDER}/ >> ${UXTRACELOG} 2>&1
		else
			UX_MESSAGE "#REM# The file ${UXSRVRFCFOLDER}/${ux_file_name} does not exist" >> ${UXTRACELOG}
		fi
	done
fi
UX_MESSAGE ""
}

# ----------------------------------------------- #
# List the system
# ----------------------------------------------- #
UX_SYS_LISTING ()
{
loc_output=$1
UX_MESSAGE "#REM# LISTING OF THE TCP/IP FILES" >> ${loc_output}
for ux_file in ${UXLSTFILESOTHER}
do
	UX_CMD npth "ls -ltr ${ux_file}*" ${loc_output} tspn
	if [ $ux_file="/etc/hosts"  ]; then
		UX_CMD npth "ls -lL ${ux_file}*" ${loc_output} tspn
	fi

done


UX_MESSAGE "#REM# LISTING OF THE UNIVERSE LINKS" >> ${loc_output}
UX_CMD npth "ls -l / | grep -i UNI"       ${loc_output} tspn
UX_CMD npth "ls -l /etc | grep -i UNI"    ${loc_output} tspn
UX_MESSAGE "#REM# LISTING OF THE RFC SERVER DIRECTORY" >> ${loc_output}
UX_CMD npth "ls -l /etc | grep UNIVERSE_SERVER_RFC" ${loc_output} tspn
UX_MESSAGE "#REM# LISTING OF THE SAP AGENT DIRECTORY" >> ${loc_output}
UX_CMD npth "ls -l /etc | grep UNIVERSE_AGENT_SAP" ${loc_output} tspn
UX_MESSAGE "#REM# LISTING OF THE ALL DQM DIRECTORIES" >> ${loc_output}
UX_CMD npth "ls -l /etc | grep UNIVERSE_DQM" ${loc_output} tspn
UX_MESSAGE "#REM# LISTING OF THE libux STRUCTURE" >> ${loc_output}
UX_CMD npth "ls -l /usr/lib | grep libux" ${loc_output} tspn
UX_CMD npth "ls -lRai /usr/lib/libux*/*" ${loc_output} tspn
}

# ----------------------------------------------- #
# Create the analyse.log file
# ----------------------------------------------- #
UX_CREATE_ANALYZE()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v

UX_CMD npth "uname -as"                   ${ANALYZEFILE} tspn
UX_MESSAGE "" >> ${ANALYZEFILE}

ls /etc/*release > /dev/null 2>&1
if [ $? -eq 0 ]; then
	UX_CMD npth "head -100 /etc/*release"                   ${ANALYZEFILE} tspn
	UX_MESSAGE "" >> ${ANALYZEFILE}
fi

UX_CMD npth "hostname"                    ${ANALYZEFILE} tspn
UX_MESSAGE "#CMD# unilevel" >> ${ANALYZEFILE}
UX_MESSAGE "" >> ${ANALYZEFILE}
${UXEXE}/unilevel >> ${ANALYZEFILE} 2>&1
UX_MESSAGE "" >> ${ANALYZEFILE}

UX_MESSAGE "#CMD# uxversion" >> ${ANALYZEFILE}
${UXEXE}/uxversion >> ${ANALYZEFILE} 2>&1
UX_MESSAGE "" >> ${ANALYZEFILE}
UX_CMD npth "ls -l /usr/lib | grep libux" ${ANALYZEFILE} tspn
UX_MESSAGE "" >> ${ANALYZEFILE}
loc_link_name=libux_v500
if [ -f /usr/lib/${loc_link_name}/../uxversion ]; then
	UX_MESSAGE "#REM# ${loc_link_name} Library version of the Dollar Universe Company" >> ${ANALYZEFILE}
	UX_CMD "/usr/lib/${loc_link_name}/.." "uxversion" ${ANALYZEFILE} tspn
else
	UX_MESSAGE "#REM# /usr/lib/${loc_link_name}/../uxversion does not exists" >> ${ANALYZEFILE}
	UX_MESSAGE "#REM# /usr/lib/${loc_link_name}/../uxversion does not exists" >> ${UXTRACELOG}
	UX_CMD npth "ls -l /usr/lib/${loc_link_name}/../uxversion" ${UXTRACELOG} tspn
fi	
loc_link_name=libux_v510
if [ -f /usr/lib/${loc_link_name}/../uxversion ]; then
	UX_MESSAGE "#REM# ${loc_link_name} Library version of the Dollar Universe Company" >> ${ANALYZEFILE}
	UX_CMD "/usr/lib/${loc_link_name}/.." "uxversion" ${ANALYZEFILE} tspn
else
	UX_MESSAGE "#REM# /usr/lib/${loc_link_name}/../uxversion does not exists" >> ${ANALYZEFILE}
	UX_MESSAGE "#REM# /usr/lib/${loc_link_name}/../uxversion does not exists" >> ${UXTRACELOG}
	UX_CMD npth "ls -l /usr/lib/${loc_link_name}/../uxversion" ${UXTRACELOG} tspn
fi	
UX_MESSAGE "" >> ${ANALYZEFILE}
loc_link_name=libux_m_v500
if [ -f /usr/lib/${loc_link_name}/../uxversion ]; then
	UX_MESSAGE "#REM# ${loc_link_name} Library version of the Dollar Universe Company" >> ${ANALYZEFILE}
	UX_CMD "/usr/lib/${loc_link_name}/.." "uxversion" ${ANALYZEFILE} tspn
else
	UX_MESSAGE "#REM# /usr/lib/${loc_link_name}/../uxversion does not exists" >> ${ANALYZEFILE}
	UX_MESSAGE "#REM# /usr/lib/${loc_link_name}/../uxversion does not exists" >> ${UXTRACELOG}
	UX_CMD npth "ls -l /usr/lib/${loc_link_name}/../uxversion" ${UXTRACELOG} tspn
fi	
UX_MESSAGE "" >> ${ANALYZEFILE}
UX_CMD npth "df -k"                       ${ANALYZEFILE} tspn
}
# ----------------------------------------------- #
# Get system traces
# ----------------------------------------------- #
UX_SYS_ANALYZE()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
loc_trace_level=${1}
loc_output_number=${2}
UX_CMD npth "ps -efl | grep ux" ${UXTRACESYSFOLDER}/ps_efl_ux_${loc_output_number}.txt
for ux_folder_alias in ${UXDUDATAFOLDERALIAS}
do
	eval ux_transfert_value=\$${ux_folder_alias}
	loc_output=${UXTRACEDLSFOLDER}/${ux_folder_alias}_ls_ltrai_${loc_output_number}.txt
	UX_MESSAGE "#REM# LISTING OF THE DOLLAR UNIVERSE ${ux_folder_alias} DIRECTORY (Sorted by time stamp)" >> ${loc_output}
	UX_CMD npth "ls -ltrai ${ux_transfert_value}" ${loc_output}
	loc_output=${UXTRACEDLSFOLDER}/${ux_folder_alias}_ls_ltruai_${loc_output_number}.txt
	UX_MESSAGE "#REM# LISTING OF THE DOLLAR UNIVERSE ${ux_folder_alias} DIRECTORY (Sorted by time stamp)" >> ${loc_output}
	UX_CMD npth "ls -ltruai ${ux_transfert_value}" ${loc_output}
done
[ ${loc_trace_level} -ge 3 ] && UX_CMD npth "netstat -a" ${UXTRACESYSFOLDER}/netstat_a_${loc_output_number}.txt
[ ${loc_trace_level} -ge 3 ] && UX_CMD npth "netstat -na" ${UXTRACESYSFOLDER}/netstat_na_${loc_output_number}.txt
[ ${loc_trace_level} -ge 2 ] && UX_CMD npth "ps -ef" ${UXTRACESYSFOLDER}/ps_ef_${loc_output_number}.txt
[ ${loc_trace_level} -ge 2 ] && UX_CMD npth "df -k" ${UXTRACESYSFOLDER}/df_k_${loc_output_number}.txt
[ ${loc_trace_level} -ge 2 ] && UX_CMD npth "ps -ef | grep ux" ${UXTRACESYSFOLDER}/ps_ef_ux_${loc_output_number}.txt
[ ${loc_trace_level} -ge 2 ] && UX_CMD npth "ps -efl" ${UXTRACESYSFOLDER}/ps_efl_${loc_output_number}.txt
[ ${loc_trace_level} -ge 2 ] &&	UX_CMD npth "vmstat 1 5" ${UXTRACESYSFOLDER}/vmstat_${loc_output_number}.txt
if [ ${loc_trace_level} -ge 3 ]; then
	case ${UXOS:-nv} in
		AIX )
			UX_CMD npth "ps -ef -o \"%U %p %P %a\" | cut -c 1-2000 | sed 's/ *$//'" ${UXTRACESYSFOLDER}/ps_ef_aix_${loc_output_number}.txt
			UX_CMD npth "ps -ef -o \"%U %p %P %a\" | cut -c 1-2000 | grep ux | sed 's/ *$//'" ${UXTRACESYSFOLDER}/ps_ef_aix_ux_${loc_output_number}.txt
			UX_CMD npth "top -bud3" ${UXTRACESYSFOLDER}/top_bud3_${loc_output_number}.txt
		;;
		SunOS )
			UX_CMD "/usr/proc/bin" "ptree" ${UXTRACESYSFOLDER}/ptree_${loc_output_number}.txt
			UX_CMD npth "top -bud3" ${UXTRACESYSFOLDER}/top_bud3_${loc_output_number}.txt
		;;
		HP-UX )
			UX_CMD npth "top -d3 -n40 -f ${UXTRACESYSFOLDER}/top_bud3_${loc_output_number}.txt" ${UXTRACESYSFOLDER}/.err_top_bud3_${loc_output_number}.txt
		;;
		Linux )
			UX_CMD npth "ps -efw" ${UXTRACESYSFOLDER}/ps_efw_${loc_output_number}.txt
			UX_CMD npth "ps -efw | grep ux" ${UXTRACESYSFOLDER}/ps_efw_ux_${loc_output_number}.txt
			UX_CMD npth "ps -efHwl" ${UXTRACESYSFOLDER}/ps_efwHl_${loc_output_number}.txt
			UX_CMD npth "ps -efHwl | grep ux" ${UXTRACESYSFOLDER}/ps_efwHl_ux_${loc_output_number}.txt
			UX_CMD npth "pstree -ap" ${UXTRACESYSFOLDER}/pstree_ap_${loc_output_number}.txt
			UX_CMD npth "top -bn3" ${UXTRACESYSFOLDER}/top_bud3_${loc_output_number}.txt
			UX_CMD npth "netstat -aeep" ${UXTRACESYSFOLDER}/netstat_aeep_${loc_output_number}.txt
		;;
		* )
			UX_CMD npth "top -bn3" ${UXTRACESYSFOLDER}/top_bud3_${loc_output_number}.txt
		;;
	esac
fi
if [ ${loc_trace_level} -ge 9 ]; then
	UX_CMD npth "ipcs -ma"  ${UXTRACESYSFOLDER}/shared_memory.txt tspn
	for ux_area in ${UXLISTAREA}
	do
		UX_CMD "${UXEXE}" "uxlnmlst ${S_SOCIETE} ${ux_area} ${S_NOEUD}" ${UXTRACESYSFOLDER}/shared_memory.txt tspn
	done
	UX_CMD npth "env" ${UXTRACESYSFOLDER}/env.txt
	UX_CMD npth "netstat -i" ${UXTRACESYSFOLDER}/netstat_i.txt
	UX_CMD npth "ypcat services" ${UXTRACESYSFOLDER}/nis_ypcat_services.txt
	UX_CMD npth "ypcat passwd" ${UXTRACESYSFOLDER}/nis_ypcat_passwd.txt
	UX_CMD npth "ypcat group" ${UXTRACESYSFOLDER}/nis_ypcat_group.txt
	UX_CMD npth "ypcat hosts" ${UXTRACESYSFOLDER}/nis_ypcat_hosts.txt
	UX_CMD npth "ypcat networks" ${UXTRACESYSFOLDER}/nis_ypcat_networks.txt
	UX_CMD npth "ypcat protocols" ${UXTRACESYSFOLDER}/nis_ypcat_protocols.txt
	UX_CMD npth "who -b " ${UXTRACESYSFOLDER}/who_b.txt tspn 
	cp ${U_TMP_PATH}/u_gethrd_report.log ${UXTRACESYSFOLDER}/u_gethrd_report.log_old >> ${UXTRACELOG} 2>&1
	${UXMGR}/uxgethrd >> ${UXTRACELOG} 2>&1
	cp ${U_TMP_PATH}/u_gethrd_report.log ${UXTRACESYSFOLDER} >> ${UXTRACELOG} 2>&1
fi
}

# ----------------------------------------------- #
# Takes several pictures of the system
#  $1 : Starting number
#  $2 : Ending Number
#  $3 : sleeping time between each loop
# ----------------------------------------------- #
UX_LOOP_SYSTEM_TRACES ()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
ux_numb_beg=$1
ux_loop_number=$2
ux_sleep=$3
ux_numb_end=`expr ${ux_numb_beg} + ${ux_loop_number}`
UX_MESSAGE "${ux_loop_number} brief pictures of the system will be taken, with a ${ux_sleep} second sleep in between"
ux_numb=`expr ${ux_numb_beg} + 1`
until [ ${ux_numb} -ge ${ux_numb_end} ]
do
	[ ${ux_numb} -le 9 ] && UX_SYS_ANALYZE 1 0${ux_numb}
	[ ! ${ux_numb} -le 9 ] && UX_SYS_ANALYZE 1 ${ux_numb}
	[ ! ${ux_numb} -eq ${ux_numb_end} ] && UX_MESSAGE "	Waiting ${ux_sleep} seconds"
	[ ! ${ux_numb} -eq ${ux_numb_end} ] && sleep ${ux_sleep}
	ux_numb=`expr ${ux_numb} + 1`
done
UX_MESSAGE ""
}
# ----------------------------------------------- #
# Get the listing of the diretories
# ----------------------------------------------- #
UX_DIRECTORY_LISTING()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
for ux_folder_alias in ${UXCONFFOLDERALIAS}
do
	loc_output=${UXTRACEDLSFOLDER}/${ux_folder_alias}_ls_ltrai.txt
	UX_MESSAGE "#REM# LISTING OF THE DOLLAR UNIVERSE ${ux_folder_alias} DIRECTORY (Sorted by time stamp)" >> ${loc_output}
	eval ux_transfert_value=\$${ux_folder_alias}
	UX_CMD npth "ls -ltrai ${ux_transfert_value}" ${loc_output}
	loc_output=${UXTRACEDLSFOLDER}/${ux_folder_alias}_ls_lai.txt
	UX_MESSAGE "#REM# LISTING OF THE DOLLAR UNIVERSE ${ux_folder_alias} DIRECTORY (Sorted by name)" >> ${loc_output}
	eval ux_transfert_value=\$${ux_folder_alias}
	UX_CMD npth "ls -lai ${ux_transfert_value}" ${loc_output}
	loc_output=${UXTRACEDLSFOLDER}/${ux_folder_alias}_ls_lRai.txt
	UX_MESSAGE "#REM# RECURSIV LISTING OF THE DOLLAR UNIVERSE ${ux_folder_alias} DIRECTORY (Sorted by name)" >> ${loc_output}
	UX_CMD npth "ls -lRai ${ux_transfert_value}" ${loc_output}
done

for ux_folder_alias in ${UXDATAFOLDERALIAS}
do
	eval ux_transfert_value=\$${ux_folder_alias}
	loc_output=${UXTRACEDLSFOLDER}/${ux_folder_alias}_ls_ltrai.txt
	UX_MESSAGE "#REM# LISTING OF THE DOLLAR UNIVERSE ${ux_folder_alias} DIRECTORY (Sorted by time stamp)" >> ${loc_output}
	UX_CMD npth "ls -ltrai ${ux_transfert_value}" ${loc_output}
	loc_output=${UXTRACEDLSFOLDER}/${ux_folder_alias}_ls_ltraiL.txt
	UX_MESSAGE "#REM# LISTING OF THE DOLLAR UNIVERSE ${ux_folder_alias} DIRECTORY (following symbolic links and Sorted by time stamp)" >> ${loc_output}
	UX_CMD npth "ls -ltraiL ${ux_transfert_value}" ${loc_output}
done
}
# ----------------------------------------------- #
# Check the status of the Dollar Universe Company
# ----------------------------------------------- #
UX_CHECK_COMPANY_OK()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
loc_off_flag=${1:-off}
loc_comp_status=`UX_CHECK_COMPANY X`
tmp_atm_log=/tmp/tmp_atm_log
if [ ${loc_comp_status:-OFF} = ON ]; then
	UX_BG_CMD "${UXEXE}/uxlst atm" ${tmp_atm_log} ${UXBGTIMEOUT} >> ${UXTRACELOG} 2>&1
	loc_comp_test=$?
	cat ${tmp_atm_log} >> ${UXTRACELOG} 
else
        UX_MESSAGE "#REM# The Company was shutdowned" >> ${UXTRACELOG}
	UX_MESSAGE "#REM# The result of ps -ef | cut -c 1-2000 | grep ux is :" >> ${UXTRACELOG}
	ps -ef | cut -c 1-2000 | grep ux >> ${UXTRACELOG}
	loc_comp_test=2
fi
if [ ${loc_comp_test} -eq 0 ]; then
	grep Launcher ${tmp_atm_log} > /dev/null 2>&1
	loc_comp_test=$?
	if [ ${loc_comp_test} -eq 0 ]; then
		if [ ${loc_off_flag} = on ]; then
			UX_MESSAGE "The -o option has been used but the Dollar Universe seems to react"
			UX_MESSAGE "If you have sometime you can relaunch the ${UXTRACEBASD0} trace procedure without"
			UX_MESSAGE "the -o parameter"
			UX_MESSAGE "#REM# The -o option has been used but the Dollar Universe seems to react" >> ${UXTRACELOG}
			UX_MESSAGE "#REM# If you have sometime you can relaunch the ${UXTRACEBASD0} trace procedure without" >> ${UXTRACELOG}
			UX_MESSAGE "#REM# the -o parameter" >> ${UXTRACELOG}
			return 1
		fi
		return 0
	fi
else
        UX_MESSAGE "The Company will be considered as shutdowned"
        UX_MESSAGE "#REM# The Company will be considered as shutdowned" >> ${UXTRACELOG}
        UX_MESSAGE "#REM# The uxlst atm command did not complete in 20 seconds" >> ${UXTRACELOG}
	return 2
fi
}
# ----------------------------------------------- #
# Taz the Folder
# ----------------------------------------------- #
UX_COMPRESS_FOLDER ()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
loc_comp_folder_locate="${1:-nv}"
loc_comp_folder_name="${2:-nv}"
loc_comp_compress_package=${3:-Y}
loc_comp_keep_folder=${4:-N}
if [ -d ${loc_comp_folder_locate}/${loc_comp_folder_name} ]; then
	cd ${loc_comp_folder_locate}
	chmod -R u+rw,g+rw,o+rw ./${loc_comp_folder_name}
	tar -cf  ./${loc_comp_folder_name}.tar ./${loc_comp_folder_name}
	chmod u+rw,g+rw,o+rw ./${loc_comp_folder_name}.tar
else
	UX_MESSAGE "The ${loc_comp_folder_locate}/${loc_comp_folder_name} folder does not exist"
	return 1
fi
if [ ${loc_comp_compress_package} = Y ]; then
	which compress  > /dev/null 2>&1 && loc_compress=OK
	which gzip      > /dev/null 2>&1 && loc_gzip=OK
	if [ ${loc_gzip:-KO} = OK ]; then
		gzip ${loc_comp_folder_locate}/${loc_comp_folder_name}.tar
		loc_extension=tar.gz
	elif [ ${loc_compress:-KO} = OK ]; then
		compress ${loc_comp_folder_locate}/${loc_comp_folder_name}.tar
		if [ $? -eq 2 ]; then
			loc_extension=tar
		else
			mv ${loc_comp_folder_locate}/${loc_comp_folder_name}.tar.Z ${loc_comp_folder_locate}/${loc_comp_folder_name}.taz
			loc_extension=taz
		fi
	else
		loc_extension=tar
	fi
else
	loc_extension=tar
fi
UX_MESSAGE "The file ${loc_comp_folder_locate}/${loc_comp_folder_name}.${loc_extension} has been created"
loc_size=`du -sk ${loc_comp_folder_locate}/${loc_comp_folder_name}.${loc_extension} | cut -f1 2>> ${UXTRACELOG}`
UX_MESSAGE "It's size in Kb is : ${loc_size}"
UX_MESSAGE ""
chmod u+rw,g+rw,o+rw ${loc_comp_folder_locate}/${loc_comp_folder_name}.${loc_extension}
if [ ${loc_comp_keep_folder} = N ]; then
	rm -rf ${loc_comp_folder_locate}/${loc_comp_folder_name}
else
	UX_MESSAGE "The folder ${loc_comp_folder_locate}/${loc_comp_folder_name} has not been deleted"
fi
}
# ----------------------------------------------- #
# UX_CREATE_ALL_INFO
# ----------------------------------------------- #
UX_CREATE_ALL_INFO()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
cat ${ANALYZEFILE} > ${g_ai_file} 2>&1
UX_MESSAGE "" >> ${g_ai_file} 2>&1
UX_MESSAGE "#REM# More information can be found in the DLS subdirectory" >> ${g_ai_file} 2>&1
UX_MESSAGE "" >> ${g_ai_file} 2>&1
cat ${UXTRACESYSFOLDER}/shared_memory.txt >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/base_sys_lst.txt >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXMGR_ls_lai.txt >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXEXE_ls_lai.txt >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXLIB_ls_lai.txt >> ${g_ai_file} 2>&1
UX_MESSAGE "" >> ${g_ai_file} 2>&1
UX_MESSAGE "#REM# More information can be found in the DQM subdirectory" >> ${g_ai_file} 2>&1
UX_MESSAGE "" >> ${g_ai_file} 2>&1
cat ${UXTRACEDQMFOLDER}/DQM_all_ls_ltrai.txt >> ${g_ai_file} 2>&1
UX_MESSAGE "" >> ${g_ai_file} 2>&1
UX_MESSAGE "#REM# More information can be found in the SAP and RFC subdirectories" >> ${g_ai_file} 2>&1
UX_MESSAGE "" >> ${g_ai_file} 2>&1
[ -f ${loc_sap_output} ] && cat ${loc_sap_output} >> ${g_ai_file} 2>&1
[ -f ${loc_sap_output} ] || UX_MESSAGE "#REM# SAP not configured" >> ${g_ai_file} 2>&1
[ -f ${loc_rfc_output} ] && cat ${loc_rfc_output} >> ${g_ai_file} 2>&1
[ -f ${loc_rfc_output} ] || UX_MESSAGE "#REM# SAP not configured" >> ${g_ai_file} 2>&1
UX_MESSAGE "" >> ${g_ai_file} 2>&1
UX_MESSAGE "#REM# More information can be found in the DLS subdirectory" >> ${g_ai_file} 2>&1
UX_MESSAGE "" >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/DQM_all_ls_ltrai.txt >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXDIR_ROOT_ls_ltrai_01G.txt >> ${g_ai_file} 2>&1
UX_MESSAGE "" >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXDEX_ls_ltrai_01G.txt >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXDSI_ls_ltrai_01G.txt >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXDIN_ls_ltrai_01G.txt >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXDAP_ls_ltrai_01G.txt >> ${g_ai_file} 2>&1
UX_MESSAGE "" >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXPEX_ls_ltrai.txt >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXPSI_ls_ltrai.txt >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXPIN_ls_ltrai.txt >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXPAP_ls_ltrai.txt >> ${g_ai_file} 2>&1
UX_MESSAGE "" >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXLEX_ls_ltrai.txt >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXLEX_ls_ltrai.txt >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXLIN_ls_ltrai.txt >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/UXLAP_ls_ltrai.txt >> ${g_ai_file} 2>&1
UX_MESSAGE "" >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/U_TMP_PATH_ls_ltrai.txt >> ${g_ai_file} 2>&1
UX_MESSAGE "" >> ${g_ai_file} 2>&1
cat ${UXTRACEDLSFOLDER}/du_dir_analysis.txt >> ${g_ai_file} 2>&1
UX_MESSAGE "" >> ${g_ai_file} 2>&1
UX_MESSAGE "#REM# More information can be found in the SYS subdirectory" >> ${g_ai_file} 2>&1
UX_MESSAGE "" >> ${g_ai_file} 2>&1
cat ${UXTRACESYSFOLDER}/env.txt >> ${g_ai_file} 2>&1
cat ${UXTRACESYSFOLDER}/ps_ef_01G.txt >> ${g_ai_file} 2>&1
cat ${UXTRACESYSFOLDER}/netstat_a_01G.txt >> ${g_ai_file} 2>&1
cat ${UXTRACESYSFOLDER}/netstat_na_01G.txt >> ${g_ai_file} 2>&1
}
# ----------------------------------------------- #
# UX_PACKAGE_LIGHT
# ----------------------------------------------- #
UX_PACKAGE_LIGHT()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
UX_COMPRESS_FOLDER ${UXTRACEFOLDER} DLS N  N >> ${UXTRACELOG} 2>&1
UX_COMPRESS_FOLDER ${UXTRACEFOLDER} SYS N  N >> ${UXTRACELOG} 2>&1
UX_COMPRESS_FOLDER ${UXTRACEFOLDER} DQM N  N >> ${UXTRACELOG} 2>&1
[ -d ${UXTRACEFOLDER}/LST ] && UX_COMPRESS_FOLDER ${UXTRACEFOLDER} LST N  N >> ${UXTRACELOG} 2>&1
[ -d ${UXTRACEFOLDER}/LST ] && UX_COMPRESS_FOLDER ${UXTRACEFOLDER} LST N  N >> ${UXTRACELOG} 2>&1
[ -d ${UXTRACEFOLDER}/DUFILES ] && UX_COMPRESS_FOLDER ${UXTRACEFOLDER} DUFILES N  N >> ${UXTRACELOG} 2>&1
}
# ----------------------------------------------- #
# UX_PACKAGE_FOLDER
# ----------------------------------------------- #
UX_PACKAGE_FOLDER()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
loc_folder_locate="${1:-nv}"
loc_folder_name="${2:-nv}"
loc_compress_package=${3:-Y}
loc_keep_folder=${4:-N}
loc_dividing_level=${5:-0}
if [ ${loc_dividing_level} -ge 5 ]; then
	UX_CREATE_DIR ${UXTRACEFOLDER2} >> ${UXTRACELOG} 2>&1
	UX_CMD npth "mv ${UXTRACELOGFOLDER}/UX*taz ${UXTRACEFOLDER2}" ${UXTRACELOG}
	UX_COMPRESS_FOLDER ${loc_folder_locate} ${UXTRACENAME2} ${loc_compress_package} ${loc_keep_folder}
	[ ${file_flag:-off} = on ] && UX_COMPRESS_FOLDER ${loc_folder_locate} ${UXTRACENAME4} ${loc_compress_package} ${loc_keep_folder}
fi
if [ ${loc_dividing_level} -ge 10 ]; then
	UX_COMPRESS_FOLDER ${loc_folder_locate} ${UXTRACENAME3} ${loc_compress_package} ${loc_keep_folder}
fi
UX_COMPRESS_FOLDER ${loc_folder_locate} ${loc_folder_name} ${loc_compress_package} ${loc_keep_folder}
}
# ----------------------------------------------- #
# Get a copy of the Dollar Universe files
# ----------------------------------------------- #
UX_GET_DU_FILES ()
{
loc_file_level=${1}
loc_area=${2:-${UXMAINAREA}}
loc_file_list="${3}"

case ${loc_file_level} in
	0|00|10)
	    if [ "${UXFILESTOGET:-nv}" = "nv" ] && [ "${loc_file_list:-nv}" = "nv" ]; then
	    	UX_MESSAGE "#REM# Error in the UX_GET_DU_FILES function"  >> ${UXTRACELOG}
	    	UX_MESSAGE "#REM# The level is equal to ${loc_file_level}" >> ${UXTRACELOG}
	    	UX_MESSAGE "#REM# And the variable UXFILESTOGET is not defined" >> ${UXTRACELOG}
	    	return 1
	    else
		[ "${loc_file_list:-nv}" = "nv" ] && loc_file_list="${UXFILESTOGET}"
	    fi
	    ;;
	1|01|11)
	    loc_file_list="ftts fttg ftru fuec fsec"
	    ;;
	2|02|12)
	    loc_file_list="fupr frup fmse fmta fmca fmpl fmrl"
	    ;;
	3|03|13)
	    loc_file_list="fmsp fmtp fmer"
	    ;;
	4|04|14)
	    loc_file_list="fmsb fmev"
	    ;;
	5|05|15)
	    loc_file_list="fmpi fecl fecd fmev"
	    ;;
	6|06|16)
	    loc_file_list="fmpi fmsb fmhs fmph fmcx fmfu"
	    ;;
	7|07|17)
	    loc_file_list="fmpi fecl fecd fmev fmsb fmlp fmhs fmph"
	    ;;
	8|08|18)
	    loc_file_list="fecd fmev fmlc fmph fmsb fecl fmcx fmlp fmpi fmtp fmpf fmpl fmsp fmtr fseu fmfu fmhs"
	    ;;
	9|09|19)
	    loc_file_list="fecd fecl fmca fmcm fmcx fmer fmev fmfu fmhs fmlc fmlp fmpf fmph fmpi fmpl fmsb fmse fmsp fmta fmtp fmtr fppf frup fseu fupr fdob fach fapg fapr fatr fmeq fmqp fmqr fmrl frra frre frrv fsec ftru fttg ftts fuec fuec"
	    ;;
	*)
	    UX_MESSAGE "#REM# Error in the UX_GET_DU_FILES function"  >> ${UXTRACELOG}
	    UX_MESSAGE "#REM# The level is equal to ${loc_file_level} which is not considered" >> ${UXTRACELOG}
	    UX_MESSAGE "The level ${loc_file_level} is not considered, no Dollar Universe files have been collected"
	    file_flag=off
	    return 1
	    ;;

esac
case ${loc_area} in
	X ) l_name_dir=UXDEX;loc_source_dir=${UXDEX};;
	S ) l_name_dir=UXDSI;loc_source_dir=${UXDSI};;
	I ) l_name_dir=UXDIN;loc_source_dir=${UXDIN};;
	A ) l_name_dir=UXDAP;loc_source_dir=${UXDAP};;
esac
if [ ${loc_file_level} -le 9 ]; then
	loc_ext_list="dta"
else
	loc_ext_list="dta idx"
fi
loc_output_directory=${UXTRACEDUFILESFOLDER}
UX_CREATE_DIR ${loc_output_directory}
[ ! $? -eq 0 ] && return 1
loc_output_directory=${UXTRACEDUFILESFOLDER}/${l_name_dir}
UX_CREATE_DIR ${loc_output_directory}
[ ! $? -eq 0 ] && return 1
UX_MESSAGE "#REM# These files come from this directory : ${loc_source_dir} " >> ${loc_output_directory}/files.txt
UX_MESSAGE "#REM# List of the collected files : ${loc_file_list} " >> ${loc_output_directory}/files.txt
UX_MESSAGE "#REM# List of the collected extensions : ${loc_ext_list} " >> ${loc_output_directory}/files.txt
UX_MESSAGE ""
UX_MESSAGE "	Warning : Dollar Universe files will be copied in the following directory"
UX_MESSAGE "		${loc_output_directory}"
UX_MESSAGE "	Available space on this file system : "
UX_MESSAGE "	df -k ${loc_output_directory}"
df -k ${loc_output_directory}
UX_MESSAGE ""
UX_MESSAGE "	To avoid a file system full we recommend that you carefully monitor the available file system space by"
UX_MESSAGE "	using the command : df -k ${loc_output_directory}"
UX_MESSAGE "	If you perceive a file system full risk, abort the procedure and relaunch it after freeing"
UX_MESSAGE "	addionnal space or changing the output directory by positioning the UXTRACELOCATE variable"
UX_MESSAGE "	(More information is available in the uxtrace_help.txt file)"
for loc_file in ${loc_file_list}
do
	if [ ${batch_flag:-off} = off ]; then
		UX_MESSAGE "Processing file ${loc_file}"
		UX_MESSAGE "	Available space on this file system : "
		df -k ${loc_output_directory}
	fi
	UX_CMD npth "df -k ${loc_output_directory}" ${UXTRACELOG}
	for loc_ext in ${loc_ext_list}
	do
		UX_MESSAGE "#REM# Test if the files *${loc_file}*${loc_ext} have already been copied" >> ${UXTRACELOG}
		UX_MESSAGE "#CMD# ls ${loc_output_directory}/*${loc_file}*${loc_ext}*" >> ${UXTRACELOG} 2>&1
		ls ${loc_output_directory}/*${loc_file}*${loc_ext}* >> ${UXTRACELOG} 2>&1
		l_return=$?
		if [ ${l_return} -ne 0 ]; then
	        	UX_CMD npth "cp ${loc_source_dir}/*${loc_file}*${loc_ext} ${loc_output_directory}" ${UXTRACELOG}
			[ $? -ne 0 ] && UX_CMD npth "cp ${UXDIR_ROOT}/*${loc_file}*${loc_ext} ${loc_output_directory}" ${UXTRACELOG}
		        which compress  > /dev/null 2>&1 && loc_compress=OK
		        which gzip      > /dev/null 2>&1 && loc_gzip=OK
		        if [ ${loc_gzip:-KO} = OK ]; then
		                UX_CMD npth "gzip ${loc_output_directory}/*${loc_file}*${loc_ext}" ${UXTRACELOG}
		        elif [ ${loc_compress:-KO} = OK ]; then
		                UX_CMD npth "compress ${loc_output_directory}/*${loc_file}*${loc_ext}" ${UXTRACELOG}
	        	fi
		fi
	done
done
}
# ----------------------------------------------- #
# Customized script submission
# ----------------------------------------------- #
UX_CUST_SCRIPT ()
{
loc_cust_script=${1}
loc_sub_mode=${2:-s}
# s for a sourcing
# k for ksh's execution
# d for detection
loc_which_script=${3}
[ ${loc_which_script:-no_value} = no_value ] || loc_cust_script=${loc_cust_script}_${loc_which_script}
case ${loc_sub_mode} in
	d )
	  if [ -r ${loc_cust_script} ]; then
	  	UX_MESSAGE "The ${loc_cust_script} script will be submitted at the end of the uxtrace."
	  else
	  	UX_MESSAGE "The ${loc_cust_script} script will not be submitted"
	  	UX_MESSAGE "#REM# The ${loc_cust_script} is not present or readable" >> ${UXTRACELOG}
		UX_CMD npth "ls -l ${loc_cust_script}" ${UXTRACELOG}
		[ ${loc_which_script:-no_value} = no_value ] && cust_std_flag=off
		[ ! ${loc_which_script:-no_value} = no_value ] && cust_flag=off
	  fi
	  ;;
	s )
	  if [ -r ${loc_cust_script} ]; then
	        UX_MESSAGE "#REM# Copy of the ${loc_cust_script} script" >> ${UXTRACELOG}
	        UX_MESSAGE "#CMD# cp ${loc_cust_script} ${UXTRACEFILESFOLDER} >> ${UXTRACELOG} 2>&1" >> ${UXTRACELOG}
        	UX_MESSAGE "Sourcing the ${loc_cust_script} script"
	        UX_MESSAGE "#REM# Sourcing the ${loc_cust_script} script" >> ${UXTRACELOG}
	        UX_MESSAGE ". ${loc_cust_script} >> \${UXTRACELOG} 2>&1"

	        UX_MESSAGE "#CMD# . ${loc_cust_script} >> ${UXTRACELOG} 2>&1" >> ${UXTRACELOG}
		. ${loc_cust_script} >> ${UXTRACELOG} 2>&1
	  else
	  	UX_MESSAGE "The ${loc_cust_script} script will not be submitted"
	  	UX_MESSAGE "#REM# The ${loc_cust_script} is not present or readable" >> ${UXTRACELOG}
		UX_CMD npth "ls -l ${loc_cust_script}" ${UXTRACELOG}
	  fi
	  ;;
	k )
	  if [ -x ${loc_cust_script} ]; then
	        UX_MESSAGE "#REM# Copy of the ${loc_cust_script} script" >> ${UXTRACELOG}
	        UX_MESSAGE "#CMD# cp ${loc_cust_script} ${UXTRACEFILESFOLDER} >> ${UXTRACELOG} 2>&1" >> ${UXTRACELOG}
        	UX_MESSAGE "Launching the ${loc_cust_script} script"
	        UX_MESSAGE "#REM# Launching the ${loc_cust_script} script" >> ${UXTRACELOG}
	        UX_MESSAGE "ksh ${loc_cust_script} >> \${UXTRACELOG} 2>&1"
	        UX_MESSAGE "#CMD# ksh ${loc_cust_script} >> ${UXTRACELOG} 2>&1" >> ${UXTRACELOG}
		ksh ${loc_cust_script} >> ${UXTRACELOG} 2>&1
	  else
	  	UX_MESSAGE "The ${loc_cust_script} script will not be submitted"
	  	UX_MESSAGE "#REM# The ${loc_cust_script} is not executable" >> ${UXTRACELOG}
		UX_CMD npth "ls -l ${loc_cust_script}" ${UXTRACELOG}
	  fi
	  ;;
	* )
	  return 1
	  ;;
esac
}
# ----------------------------------------------- #
# List all the important log files
# ----------------------------------------------- #
UX_LST_LOG_FILES ()
{
UX_CREATE_DIR ${UXTRACELOGFOLDER} >> ${UXTRACELOG} 2>&1
for l_log_dir_alias in ${UXLOGFOLDERALIAS}
do
	eval l_log_dir_path=\$${l_log_dir_alias}
	for l_log_file_name in ${UXLOGFILELIST}
	do
		ls ${l_log_dir_path}/${l_log_file_name} >> ${g_log_list} 2>> /dev/null
	done
done
[ -d ${UXDQM:-nv} ] && ls $UXDQM/*log >> ${g_log_list} 2>> /dev/null
sort -u ${g_log_list} > ${g_log_list}_tmp
mv ${g_log_list}_tmp ${g_log_list}
}

# ----------------------------------------------- #
# Timestamp all the important log files
# ----------------------------------------------- #
UX_TSP_LOG_FILES ()
{
[ ! -f ${g_log_list:-nv} ] && UX_LST_LOG_FILES
l_mess_tsp="${1}" #Typically BEG or END
while read l_log_name ; do
	UX_TIME_STAMP ${l_log_name} "#${l_mess_tsp}#" "${UXTRACENAME} run"
done < ${g_log_list}
}
##########################################################
#                    MAIN                                #
##########################################################
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
#Options management
UXCUSTSCRIPTDFT=\${UXMGR}/uxtrace_cust
ux_option_list=""
level_flag=off
while getopts scLdobvPh:p:l:f:a: option 
do
	case "${option}" in
		L )
		  light_flag=on
		  ux_option_list=${ux_option_list}L
		  level_flag=on
		  ;;
		s )
		  system_flag=on
		  ux_option_list=${ux_option_list}s
		  level_flag=on
		  ;;
		c )
		  config_flag=on
		  ux_option_list=${ux_option_list}c
		  level_flag=on
		  ;;
		l )
		  level_flag=on
		  log_flag=on
		  case ${OPTARG:-no_value} in
		       [0-9]|[0-9][0-9]|[0-9][0-9][0-9] )
		  	   UXLOGDELAY=${OPTARG}
		  	   ;;
		  	* )
			   UX_MESSAGE "#REM# -l argument is not number"
			   UX_MESSAGE "#REM# If you want to launch the uxtrace procedure in light mode"
			   UX_MESSAGE "#REM# Please use the -L option instead the -l one"
		  	   exit 1
		  	   ;;
		  esac
		  ux_option_list=${ux_option_list}l${UXLOGDELAY}
		  ;;
		a )
		  area_flag=on
		  case ${OPTARG} in
		       [xX]|[eE][xX][pP] )
		  	   UXMAINAREA=X
		  	   export UXMAINAREA
		  	   ;;
		       [sS]|[sS][iI][mM] )
		  	   UXMAINAREA=S
		  	   export UXMAINAREA
		  	   ;;
		       [iI]|[iI][nN][tT] )
		  	   UXMAINAREA=I
		  	   export UXMAINAREA
		  	   ;;
		       [aA]|[aA][pP][pP] )
		  	   UXMAINAREA=A
		  	   export UXMAINAREA
		  	   ;;
		  	* )
			   UX_MESSAGE "#REM# The argument of the -a option is not valid, ${UXMAINAREADFT} area will be considered"
		  	   ;;
		  esac
		  ux_option_list=${ux_option_list}a${UXMAINAREA}
		  ;;
		f )
		  case ${OPTARG} in
		       [0-9]|[0-9][0-9] )
		  	   UXFILELEVEL=${OPTARG}
		  	   file_flag=on
			   ux_option_list=${ux_option_list}f${UXFILELEVEL}
		  	   ;;
		  	* )
			   UX_MESSAGE "#REM# -f argument is not number, it won't be considered"
		  	   ;;
		  esac
		  ;;
		p )
		  cust_flag=on
		  ux_which_script=${OPTARG}
		  ux_option_list=${ux_option_list}p
		  level_flag=on
		  ;;
		P )
		  cust_std_flag=off
		  ux_which_script=${OPTARG}
		  ux_option_list=${ux_option_list}P
		  level_flag=on
		  ;;
		o )
		  off_flag=on
		  system_flag=on
		  level_flag=on
		  ux_option_list=${ux_option_list}o
		  ;;
		d )
		  divide_flag=on
		  ux_option_list=${ux_option_list}d
		  ;;
		b )
		  batch_flag=on
		  ux_option_list=${ux_option_list}b
		  ;;
		v )
		  ux_option_list=${ux_option_list}v
		  verbose_flag=on
		  UXTRACEMODEX=ON
		  ;;
		h )
		  if [ "${OPTARG}nv" = "nv" ]; then
			HELP 0
		  else
			HELP 1
		  fi
		  exit 0
		  ;;
		*)
		  HELP 0
		  exit 1
		  ;;
	esac
done 2> /dev/null
UX_MESSAGE "# ----------------------------------------------- #"
UX_MESSAGE "#           uxtrace version : ${UXTRACEVERSION}"
UX_MESSAGE "# ----------------------------------------------- #"
UX_MESSAGE ""
UX_CHECK_ENV
# Default values
UXTRACELOCATEDFT=${UXMGR}
UXCHECKUSERDFT=Y
UXKEEPUXTRACEFOLDERDFT=N
UXCOMPRESSUXTRACEFOLDERDFT=Y
UXLOGDELAYDFT=1
UXLOGNBDFT=25
UXDUFILESIZELIMDFT=10000
UXCUSTSCRIPTDFT=${UXMGR}/uxtrace_cust
UXLAUNCHCUSTSCRIPTDFT=s
UXMAINAREADFT=X
UXBGTIMEOUTDFT=20
UX_MESSAGE ""
# Flag Impact management 
if [ ${level_flag:-off} = off ]; then
	system_flag=on
	config_flag=on
	ux_option_list=sc${ux_option_list}
fi
if [ ${light_flag:-off} = on ]; then
	system_flag=off
	config_flag=off
fi
[ ${system_flag:-off} = on ] && UXSLEEPTIMEDFT=15
[ ${system_flag:-off} = on ] && UXLOOPNUMBERDFT=4
[ ${system_flag:-off} = on ] || UXSLEEPTIMEDFT=30
[ ${system_flag:-off} = on ] || UXLOOPNUMBERDFT=2
[ ${config_flag:-off} = on ] && ux_du_on_trace_level=7
[ ${config_flag:-off} = on ] || ux_du_on_trace_level=3
[ ${dev_flag:-off} = on ] && UXSLEEPTIMEDFT=1
[ ${dev_flag:-off} = on ] && UXLOOPNUMBERDFT=1

# Internal variables
UX_CHECK_VARIABLES UXTRACELOCATE
if [ ! ${divide_flag:-off} = on ]; then
	UXTRACENAME=TMP_${S_NOEUD}_uxtrace_${UXOS}_${S_SOCIETE}_${UXTRACEDATE}_${ux_option_list}
else
	UXTRACENAME=TMP_${S_NOEUD}_uxtrace_${UXOS}_${S_SOCIETE}_${UXTRACEDATE}_prt1_${ux_option_list}
	UXTRACENAME2=TMP_${S_NOEUD}_uxtrace_${UXOS}_${S_SOCIETE}_${UXTRACEDATE}_prt2_${ux_option_list}
	UXTRACEFOLDER2=${UXTRACELOCATE}/${UXTRACENAME2}
	UXTRACENAME3=TMP_${S_NOEUD}_uxtrace_${UXOS}_${S_SOCIETE}_${UXTRACEDATE}_prtc_${ux_option_list}
	UXTRACEFOLDER3=${UXTRACELOCATE}/${UXTRACENAME3}
	UXTRACECUSTFOLDER=${UXTRACEFOLDER3}
	UXTRACENAME4=TMP_${S_NOEUD}_uxtrace_${UXOS}_${S_SOCIETE}_${UXTRACEDATE}_prtf_${ux_option_list}
	UXTRACEFOLDER4=${UXTRACELOCATE}/${UXTRACENAME4}
	UXTRACEDUFILESFOLDER=${UXTRACEFOLDER4}
	ux_packaging_level=5
fi
UXTRACEFOLDER=${UXTRACELOCATE}/${UXTRACENAME}
UXTRACELOG=${UXTRACEFOLDER}/uxtrace.txt
UXTSPLOG=${UXTRACEFOLDER}/timestamp.txt
UXTRACESAPFOLDER=${UXTRACEFOLDER}/SAP
UXTRACEPATFOLDER=${UXTRACEFOLDER}/PAT
UXTRACEITOFOLDER=${UXTRACEFOLDER}/ITO
UXTRACETNGFOLDER=${UXTRACEFOLDER}/TNG
UXTRACECOMFOLDER=${UXTRACEFOLDER}/COM
UXTRACERFCFOLDER=${UXTRACEFOLDER}/RFC
UXTRACEDQMFOLDER=${UXTRACEFOLDER}/DQM
UXTRACELOGFOLDER=${UXTRACEFOLDER}/LOG
UXTRACELSTFOLDER=${UXTRACEFOLDER}/LST
UXTRACESYSFOLDER=${UXTRACEFOLDER}/SYS
UXTRACEDLSFOLDER=${UXTRACEFOLDER}/DLS
UXTRACEFILESFOLDER=${UXTRACEFOLDER}/FILES
ANALYZEFILE=${UXTRACEFOLDER}/analyse.txt
g_ai_file=${UXTRACEFOLDER}/all_info.txt
g_log_list=${UXTRACELOGFOLDER}/log_list.txt

loc_sap_output=${UXTRACESAPFOLDER}/sap_listing.txt
loc_rfc_output=${UXTRACERFCFOLDER}/rfc_listing.txt
[ ! ${divide_flag:-off} = on ] && UXTRACECUSTFOLDER=${UXTRACEFOLDER}/CUST
[ ! ${divide_flag:-off} = on ] && UXTRACEDUFILESFOLDER=${UXTRACEFOLDER}/DUFILES
export UXTRACECUSTFOLDER
export UXTRACEDUFILESFOLDER

# Master directory creation
UX_CREATE_DIR ${UXTRACEFOLDER} E
UX_CREATE_DIR ${UXTRACESYSFOLDER} >> ${UXTRACELOG} 2>&1
UX_CREATE_DIR ${UXTRACEDLSFOLDER} >> ${UXTRACELOG} 2>&1
UX_TIME_STAMP ${UXTSPLOG} "#BEG#GLOBAL#"

UX_CHECK_USER root
if [ ${level_flag:-off} = off ]; then
	UX_MESSAGE ""
	UX_MESSAGE "#-----------------------WARNING------------------------#"
	UX_MESSAGE "Warning the uxtrace procedure has been launched without any trace level parameter "
	UX_MESSAGE "This is equivalent to a : ${UXTRACECOMPD0} -${ux_option_list}"
	if [ ${batch_flag:-off} = off ]; then
		UX_MESSAGE ""
		UX_MESSAGE "This may take a bit longer, in case you do not have the possibility to wait,"
		UX_MESSAGE "please abort this procedure and relaunch it with one of the following option"
		UX_MESSAGE "(depending the issue you want to trace)."
		HELP 0
		UX_MESSAGE "Waiting 10 seconds before starting to take traces"
		sleep 10
	fi
	UX_MESSAGE ""
fi
UX_MESSAGE "#-----------------------VARIABLES------------------------#"
UX_MESSAGE "" >> ${UXTRACELOG}
UX_MESSAGE "The values of the configuration variables are :"
UX_MESSAGE "The values of the configuration variables are :" >> ${UXTRACELOG}
UX_MESSAGE "" >> ${UXTRACELOG}
UX_MESSAGE "#         uxtrace version : ${UXTRACEVERSION}" >> ${UXTRACELOG}
UX_MESSAGE "" >> ${UXTRACELOG}
for ux_variable_name in UXTRACELOCATE UXCUSTSCRIPT UXMAINAREA
do
	UX_CHECK_VARIABLES ${ux_variable_name}
	eval ux_value=\$${ux_variable_name}
	UX_MESSAGE "	${ux_variable_name} :		${ux_value}"
	UX_MESSAGE "	${ux_variable_name} :		${ux_value}" >> ${UXTRACELOG}
done
for ux_variable_name in UXKEEPUXTRACEFOLDER UXCOMPRESSUXTRACEFOLDER UXLOGDELAY UXLOGNB UXLOOPNUMBER UXSLEEPTIME UXLAUNCHCUSTSCRIPT UXDUFILESIZELIM UXBGTIMEOUT
do
	UX_CHECK_VARIABLES ${ux_variable_name}
	eval ux_value=\$${ux_variable_name}
	UX_MESSAGE "	${ux_variable_name} :		${ux_value}" >> ${UXTRACELOG}
done
UX_MESSAGE ""

UX_MESSAGE "#REM# The version of the launched uxtrace is ${UXTRACEVERSION}" >> ${UXTRACELOG}
UX_MESSAGE "#REM# For information, the place available in the ${UXTRACEFOLDER} is :" >> ${UXTRACELOG}
df -k ${UXTRACEFOLDER} >> ${UXTRACELOG} 2>&1
UX_MESSAGE "" >> ${UXTRACELOG}

UX_MESSAGE "#--------CUSTOMIZED SCRIPT DETECTION-------------#"
[ ${cust_std_flag:-on} = on ] && UX_CUST_SCRIPT ${UXCUSTSCRIPT} d
[ ${cust_flag:-off} = on ] && UX_CUST_SCRIPT ${UXCUSTSCRIPT} d ${ux_which_script:-no_value}
UX_MESSAGE ""
UX_MESSAGE "#----------------STARTING TRACES-----------------#"
UX_TSP_LOG_FILES BEG
UX_MESSAGE "First Global System Screenshot"
UX_SYS_ANALYZE 9 01G
UX_MESSAGE ""

UX_MESSAGE "Directory analysis"
UX_DIRECTORY_LISTING
UX_SYS_LISTING ${UXTRACEDLSFOLDER}/base_sys_lst.txt
UX_RIGHTS_ANALYSIS ${UXTRACEDLSFOLDER}/du_dir_analysis.txt
UX_MESSAGE ""

UX_MESSAGE "Analysis of the System and Dollar Universe environment"
UX_MESSAGE ""
UX_CREATE_ANALYZE

UX_MESSAGE "Dollar Universe configuration files collect procedure"
UX_MESSAGE ""
UX_GET_FILES

[ ${light_flag:-off} = on ] && UXLOGDELAY=0
UX_MESSAGE "Dollar Universe log files collect procedure"
UX_MESSAGE ""
UX_GET_LOG ${UXLOGNB} ${UXLOGDELAY}

UX_MESSAGE "Second Global System Screenshot"
UX_MESSAGE ""
UX_SYS_ANALYZE 3 02G

UX_LOOP_SYSTEM_TRACES 10 ${UXLOOPNUMBER} ${UXSLEEPTIME}

UX_MESSAGE "Third Global System Screenshot"
UX_MESSAGE ""
UX_SYS_ANALYZE 3 98G

UX_MESSAGE "Analysis of the Dollar Universe Company Status"
UX_CHECK_COMPANY_OK ${off_flag}
[ ! $? -eq 0 ] && ux_du_on_trace_level=0
UX_MESSAGE ""
UX_MESSAGE "Analysis of the DQM configuration"
UX_SCANN_DQM ${ux_du_on_trace_level}

UX_MESSAGE "Analysis of the SAP configuration"
UX_GET_SAP_RFC_FILES

UX_MESSAGE "Analysis of the Supervision tools"
UX_GET_PAT_FILES
UX_GET_ITO_FILES
UX_GET_TNG_FILES
UX_GET_COM_FILES
UX_MESSAGE ""

UX_MESSAGE "Dollar Universe Object's listing"
UX_GET_COMPANY_LISTING ${ux_du_on_trace_level}
UX_TIME_STAMP ${UXTSPLOG} "#END#GLOBAL#"
if [ ${file_flag:-off} = on ]; then
	UX_MESSAGE "Dollar Universe Data file collect"
	UX_GET_DU_FILES ${UXFILELEVEL}
	UX_MESSAGE ""
fi

UX_MESSAGE "Last Global System Screenshot"
UX_MESSAGE ""
UX_SYS_ANALYZE 3 99G
if [ ${cust_std_flag:-on} = on ] || [ ${cust_flag:-off} = on ]; then
	UX_CREATE_DIR ${UXTRACECUSTFOLDER} >> ${UXTRACELOG} 2>&1
fi
[ ${cust_std_flag:-on} = on ] && UX_CUST_SCRIPT ${UXCUSTSCRIPT} ${UXLAUNCHCUSTSCRIPT}
[ ${cust_flag:-off} = on ] && UX_MESSAGE ""
[ ${cust_flag:-off} = on ] && UX_CUST_SCRIPT ${UXCUSTSCRIPT} ${UXLAUNCHCUSTSCRIPT} ${ux_which_script:-no_value}
UX_CMD npth "rmdir ${UXTRACECUSTFOLDER}" ${UXTRACELOG}
[ ! $? -eq 0 ] && [ ${ux_packaging_level:-0} -ge 5 ] && ux_packaging_level=10
UX_CREATE_ALL_INFO
UX_PACKAGE_LIGHT
UX_MESSAGE ""
UX_TSP_LOG_FILES END
UX_MESSAGE "Packaging the UXTRACE folder"
UX_MESSAGE ""
UX_PACKAGE_FOLDER ${UXTRACELOCATE} ${UXTRACENAME} ${UXCOMPRESSUXTRACEFOLDER} ${UXKEEPUXTRACEFOLDER} ${ux_packaging_level}
