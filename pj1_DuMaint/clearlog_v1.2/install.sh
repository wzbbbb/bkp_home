#!/bin/sh  
#Fri Mar 26 10:04:45 EST 2004
#Orsyp Software Inc
#Zhibing Wang
#Version 1.1.1 Aug. 31st, 2004
#################################
#Purpose:
# 1. To initialize the configuration file: DuMaint.conf
# 2. To parameterize the DuDetect.sh
# 3. To deploy the scripts into right locations
################################

#################################
# Variables
#################################
Conf=DuMaint.conf # The Main configuration file
tmp=/tmp/tmp$$
tmp1=/tmp/tmp1$$
#################################
#Creating the DuMaint.conf
#################################
FillConf () {
cp $Conf $tmp
sed -e '/ScDir/a\' -e "ScDir=$ScDir" $tmp > $tmp1
cp $tmp1 $tmp
sed -e '/ConfDir/a\' -e "ConfDir=$ConfDir" $tmp > $tmp1
cp $tmp1 $tmp
sed -e '/LogDir/a\' -e "LogDir=$LogDir" $tmp > $tmp1
cp $tmp1 $tmp
sed -e '/Admin/a\' -e "Admin=$Admin" $tmp > $tmp1
cp $tmp1 $tmp
#echo "ScDir:$ScDir" >> $Conf
#echo "ConfDir:$ConfDir" >> $Conf
#echo "LogDir:$LogDir" >> $Conf
#echo "Admin:$Admin" >> $Conf
}
#################################
#Read the parameters
#################################
ReadPars () {
echo "Note: You can not modify the directory structure after the installation."
echo "If left blank, a \"DuMaint\" directory under the current directory will be created. "
echo "Please input the directory for the script files :" 
read ScDir
echo "If left blank, a \"DuMaint\" directory under the current directory will be created. "
echo "Please input the directory for the configuration files :" 
read ConfDir
echo "If left blank, a \"DuMaint\" directory under the current directory will be created. "
echo "Please input the directory for the log files :" 
read LogDir
echo "Please input the email address of the admin user. Please separate different email addresses with spaces."
echo "Default root :" 
read Admin
}
#################################
#settle the parameters
#################################
SettlePars () {
for dir in "$ScDir" "$ConfDir" "$LogDir" ; do
	case "$dir" in
		"$ScDir")
			[ -z "$dir" ] && dir="`pwd`/DuMaint" && ScDir=$dir;; 
		"$ConfDir")
			[ -z "$dir" ] && dir="`pwd`/DuMaint" && ConfDir=$dir;;
		"$LogDir")
			[ -z "$dir" ] && dir="`pwd`/DuMaint" && LogDir=$dir;; 
	esac
        if [ ! -d "$dir" ] ; then       #if not properly defined.
                echo "$dir does not exist! Want to create one (y/n)? :"
                read i
		[ -z "$i" ] && echo "Input y or n!" && exit 1
                if [ $i = "y" -o $i = "Y" ] ; then
                        mkdir "$dir"
                else
                        echo Redefine the directory for "$dir", then run the script again!
                        exit 1
                fi
        fi
done
}
#################################
#Moving files around
#################################
InstallFiles () {
cp $tmp ${ConfDir}/$Conf 	#$tmp is DuMaint.conf
cp DuDetect.sh ${ScDir}/
UpdateDir "${ScDir}/DuDetect.sh"
cp ClrLogController.sh ${ScDir}/
UpdateDir "${ScDir}/ClrLogController.sh"
cp IU_CLRLOG.000 ${ScDir}/IU_CLRLOG.000 
cp readme.txt ${ScDir}/readme.txt
}
#################################
#Write in the dir info
#################################
UpdateDir (){
file=$1
#sed "/CCCCC/\${ConfDir}/" $file >$tmp1 #Write in the ConfDir
sed -e '/CCCCC/a\' -e "ConfDir=\"${ConfDir}\"" $file >$tmp1 #append the dir info into 
cp $tmp1 $file						# the right place
sed '/CCCCC/d' $file > $tmp1				#remove the place holder
cp $tmp1 $file
sed -e '/SSSSS/a\' -e "ScDir=\"${ScDir}\"" $file >$tmp1
cp $tmp1 $file
sed '/SSSSS/d' $file > $tmp1
cp $tmp1 $file
sed -e '/LLLLL/a\' -e "LogDir=\"${LogDir}\"" $file >$tmp1
cp $tmp1 $file
sed '/LLLLL/d' $file > $tmp1
cp $tmp1 $file
#sed -e '/AAAAA/a\' -e "Admin=\"${Admin}\"" $file >$tmp1
#cp $tmp1 $file
#sed '/AAAAA/d' $file > $tmp1
#cp $tmp1 $file
#cp $tmp1 $file
#sed "/LLLLL/\${LogDir}/" $file >$tmp1 #Write in the ConfDir
#cp $tmp1 $file
}
#################################
#Post install procedure
#################################
PostIns () {
echo '******Please read the readme.txt first.                             ******'
echo '******Please run the DuDetect.sh,                                   ******'
echo '******then update the $UXMGR/ClearLog.conf file for each $U Company.******'
rm -f $tmp $tmp1
}
#################################
#Main
#################################
ReadPars
SettlePars
FillConf
InstallFiles
PostIns
