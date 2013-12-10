#!/bin/sh  
#Thu Apr  1 13:39:30 EST 2004
#Orsyp Software Inc
#Zhibing Wang
#################################
#Purpose: Back up scripts and files in home directory
#################################


#################################
#Main
#################################
time=`date "+%F"`
tarname="zwaHomeBkp-${time}.tar"
bkp_dir="/data/home/zwa/backup" 
perlnote='/data/home/zwa/PerlNote.txt'
kshnote='/data/home/zwa/KSH_note.txt'
sc='/home/zwa/sc'
pj='/home/zwa/pj1_DuMaint'
du_sc='/home/zwa/du_sc'
perlsc='/home/zwa/perl-sc'
tar cf "/tmp/${tarname}" $sc $pj $du_sc $perlsc $perlnote $kshnote 2> /dev/null
compress "/tmp/${tarname}"
mv "/tmp/${tarname}.Z" "${bkp_dir}/${tarname}.Z"
#uuencode "/data/home/zwa/backup/${tarname}.Z" "${tarname}.Z" | mail -s "cron@support2: Daily Backup" netbus1@yahoo.com  
find  "${bkp_dir}" -mtime +10 -exec rm -f {} \; #keep 10 day's backup only.

#
