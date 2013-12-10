crontab -e

05 22 * * 1,2,3,4,5 /data/daenv/APS/APS.ksh US> /etc/APS/log/APS.log 2>&1

05 22 * * 1,2,3,4,5 /etc/daenv/APS/APS.ksh US> /etc/APS/log/APS.log 2>&1


on DA_US_U_02
ln -s /data/APS/DA_US_U_02/ /etc/APS

on DA_US_U_05
ln -s /data/APS/DA_US_U_05/ /etc/APS

mkdir /data/APS/DA_US_U_02
mkdir /data/APS/DA_US_U_05

mkdir /data/APS/DA_US_U_02/log
mkdir /data/APS/DA_US_U_05/log


mkdir /data/APS/DA_US_U_02/err_log
mkdir /data/APS/DA_US_U_05/err_log


mkdir /data/APS/DA_US_U_02/MDT500
mkdir /data/APS/DA_US_U_05/MDT500


mkdir /data/APS/DA_US_U_02/PRE500
mkdir /data/APS/DA_US_U_05/PRE500

mkdir /data/APS/DA_US_U_02/TST500
mkdir /data/APS/DA_US_U_05/TST500


mkdir /data/APS/DA_US_U_02/MDT500/patch1
mkdir /data/APS/DA_US_U_05/MDT500/patch1

mkdir /data/APS/DA_US_U_02/PRE500/patch1
mkdir /data/APS/DA_US_U_05/PRE500/patch1

mkdir /data/APS/DA_US_U_02/TST500/patch1
mkdir /data/APS/DA_US_U_05/TST500/patch1

mkdir /data/APS/DA_US_U_02/MDT500/patch2
mkdir /data/APS/DA_US_U_05/MDT500/patch2

mkdir /data/APS/DA_US_U_02/PRE500/patch2
mkdir /data/APS/DA_US_U_05/PRE500/patch2

mkdir /data/APS/DA_US_U_02/TST500/patch2
mkdir /data/APS/DA_US_U_05/TST500/patch2


mkdir /data/APS/DA_US_U_02/MDT500/patch3
mkdir /data/APS/DA_US_U_05/MDT500/patch3

mkdir /data/APS/DA_US_U_02/PRE500/patch3
mkdir /data/APS/DA_US_U_05/PRE500/patch3

mkdir /data/APS/DA_US_U_02/TST500/patch3
mkdir /data/APS/DA_US_U_05/TST500/patch3


mkdir /data/APS/DA_US_U_02/MNT500
mkdir /data/APS/DA_US_U_05/MNT500


mkdir /data/APS/DA_US_U_02/QCL500
mkdir /data/APS/DA_US_U_05/QCL500

mkdir /data/APS/DA_US_U_02/SUP500
mkdir /data/APS/DA_US_U_05/SUP500


mkdir /data/APS/DA_US_U_02/MNT500/patch1
mkdir /data/APS/DA_US_U_05/MNT500/patch1

mkdir /data/APS/DA_US_U_02/QCL500/patch1
mkdir /data/APS/DA_US_U_05/QCL500/patch1

mkdir /data/APS/DA_US_U_02/SUP500/patch1
mkdir /data/APS/DA_US_U_05/SUP500/patch1

mkdir /data/APS/DA_US_U_02/MNT500/patch2
mkdir /data/APS/DA_US_U_05/MNT500/patch2

mkdir /data/APS/DA_US_U_02/QCL500/patch2
mkdir /data/APS/DA_US_U_05/QCL500/patch2

mkdir /data/APS/DA_US_U_02/SUP500/patch2
mkdir /data/APS/DA_US_U_05/SUP500/patch2


mkdir /data/APS/DA_US_U_02/MNT500/patch3
mkdir /data/APS/DA_US_U_05/MNT500/patch3

mkdir /data/APS/DA_US_U_02/QCL500/patch3
mkdir /data/APS/DA_US_U_05/QCL500/patch3

mkdir /data/APS/DA_US_U_02/SUP500/patch3
mkdir /data/APS/DA_US_U_05/SUP500/patch3

#######################################################

mkdir /data/APS/DA_US_U_02/MDT511
mkdir /data/APS/DA_US_U_05/MDT511


mkdir /data/APS/DA_US_U_02/PRE511
mkdir /data/APS/DA_US_U_05/PRE511

mkdir /data/APS/DA_US_U_02/TST511
mkdir /data/APS/DA_US_U_05/TST511


mkdir /data/APS/DA_US_U_02/MDT511/patch1
mkdir /data/APS/DA_US_U_05/MDT511/patch1

mkdir /data/APS/DA_US_U_02/PRE511/patch1
mkdir /data/APS/DA_US_U_05/PRE511/patch1

mkdir /data/APS/DA_US_U_02/TST511/patch1
mkdir /data/APS/DA_US_U_05/TST511/patch1

mkdir /data/APS/DA_US_U_02/MDT511/patch2
mkdir /data/APS/DA_US_U_05/MDT511/patch2

mkdir /data/APS/DA_US_U_02/PRE511/patch2
mkdir /data/APS/DA_US_U_05/PRE511/patch2

mkdir /data/APS/DA_US_U_02/TST511/patch2
mkdir /data/APS/DA_US_U_05/TST511/patch2


mkdir /data/APS/DA_US_U_02/MDT511/patch3
mkdir /data/APS/DA_US_U_05/MDT511/patch3

mkdir /data/APS/DA_US_U_02/PRE511/patch3
mkdir /data/APS/DA_US_U_05/PRE511/patch3

mkdir /data/APS/DA_US_U_02/TST511/patch3
mkdir /data/APS/DA_US_U_05/TST511/patch3
