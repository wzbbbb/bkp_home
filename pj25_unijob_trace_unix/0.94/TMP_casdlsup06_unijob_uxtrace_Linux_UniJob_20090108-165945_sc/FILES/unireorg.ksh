#! /bin/ksh 

UX_GET_PROCESSES ()
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
# ----------------------------------------------- #
UX_CHECK_UNIJOB ()
{
[ ${UXTRACEMODEX:-OFF} = ON ] && set -x ; [ ${UXTRACEMODEV:-OFF} = ON ] && set -v
ux_company_nb=`UX_GET_PROCESSES | grep "uniio UNIJOB X ${S_NODENAME}" | wc -l`
if [ ! ${ux_company_nb} -eq 0 ]; then
	echo "ON"
else
	echo "OFF"
fi
}

rst_fic()
{
# OS check
OS=`uname`

# Add the location of the unlink function in the PATH
if [ -d /usr/sbin ]
then
	export PATH=${PATH}:/usr/sbin
fi
#
ln -s $2/$1.dta ${U_TMP_PATH}/$1.dta_rst
if [ $? -ne 0 ]
then
   echo "unable to link $2/$1.dta to ${U_TMP_PATH}/$1.dta_rst"
   exit 1
fi
if [ "${3}" = "G" ]
then
   echo "general reorganization"
   export U_RST_PATH=$UXDIR_ROOT
   $UXEXE/uxrstfic $1
else
   echo "area reorganization"
   export U_RST_PATH=$2
   $UXEXE/uxrstfic $1 $3
fi

if [ $? -ne 0 ]
then
   if [ "${OS}" = "Linux" ]
   then
      rm -f  ${U_TMP_PATH}/$1.dta_rst
   else
      unlink ${U_TMP_PATH}/$1.dta_rst
   fi
   rm -f ${U_TMP_PATH:-no_value}/$1.dta
   rm -f ${U_TMP_PATH:-no_value}/$1.idx
   echo "unable to reorganize $2/$1"
   exit 1
fi

if [ "${OS}" = "Linux" ]
then
   rm -f  ${U_TMP_PATH}/$1.dta_rst
else
   unlink ${U_TMP_PATH}/$1.dta_rst
fi

cp ${U_TMP_PATH:-no_value}/$1.dta  ${U_RST_PATH}/$1.dta
rm -f ${U_TMP_PATH:-no_value}/$1.dta
cp ${U_TMP_PATH:-no_value}/$1.idx  ${U_RST_PATH}/$1.idx
rm -f ${U_TMP_PATH:-no_value}/$1.idx 

return 0
}

# ========================================================
# ORSYP.SA 
#
# Reorganization procedure for UniJob  
# ========================================================
if [ "${U_ROOT_DIR}"x = x ]
then
  echo "UniJob environment not found"
  echo "The unienv environment file must be loaded first."
  exit 1
fi

# getting variables
UXDEX=`${U_ROOT_DIR}/app/bin/getvar UXDEX`
U_TMP_PATH=`${U_ROOT_DIR}/app/bin/getvar U_TMP_PATH`
UXEXE=`${U_ROOT_DIR}/app/bin/getvar UXEXE`
UXDIR_ROOT=`${U_ROOT_DIR}/app/bin/getvar UXDIR_ROOT`
UNI_DIR_APP=`${U_ROOT_DIR}/app/bin/getvar UNI_DIR_APP`
S_NODENAME=`${U_ROOT_DIR}/app/bin/getvar S_NODENAME`

# checking that the instance is down
ux_unijob_status=`UX_CHECK_UNIJOB`
if  [ ${ux_unijob_status:-OFF} = ON  ]; then
   echo "UniJob is running."
   echo "Please stop the UniJob instance before reorganization."
   echo ""
   exit 1
fi

if [ "${U_TMP_PATH:-nondefinie}" = "nondefinie" ]
then
   export U_TMP_PATH="/tmp"
fi

     VERIF=Y
     export VERIF
  if [ $# -eq 1 ] && [ $1 = NOVERIF ]
  then
     echo "WARNING: UniJob database files check desactivated"
     VERIF=N
     export VERIF
  fi

#
echo "###############################################"
echo "Start date :   \c"
date
rst_fic dffdob50 $UXDIR_ROOT G 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic mdfapr50 $UXDIR_ROOT G 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic mdfaprgb $UXDIR_ROOT G 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmrl50 $UXDIR_ROOT G 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_frra50 $UXDIR_ROOT G 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_frre50 $UXDIR_ROOT G 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_frrv50 $UXDIR_ROOT G 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_ftru50 $UXDIR_ROOT G 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fttg50 $UXDIR_ROOT G 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_ftts50 $UXDIR_ROOT G 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmeq50 $UXDIR_ROOT G 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmqr50 $UXDIR_ROOT G 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmqp50 $UXDIR_ROOT G 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fecd50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fecl50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmca50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmcm50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmcx50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmer50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmev50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmfu50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmhs50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmlc50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmlp50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmph50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmpi50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmpl50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmsb50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmse50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmsp50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmta50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmtp50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmtr50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fppf50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fseu50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################\n"
echo "Start date :   \c"
date
rst_fic u_frup50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fupr50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fmpf50 $UXDEX X 
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fbvm50 $UXDEX X
echo "End date   :   \c"
date
echo "###############################################\n"
echo "###############################################"
echo "Start date :   \c"
date
rst_fic u_fbvi50 $UXDEX X
echo "End date   :   \c"
date
echo "###############################################\n"

