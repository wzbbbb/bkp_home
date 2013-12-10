#!/bin/bash 
if [ ! $1 ] ; then 
 echo "Please specify the case directory. For example: 71xxx/717xx/71792" 
 exit 1
fi
chown da:support -RP /dsk2/cases/${1}
chown da:support -RP /dsk2/work/${1}
chown da:support -RP  /dsk2/upload/${1}
chmod g+w -R /dsk2/upload/${1}
chmod g+w -R /dsk2/work/${1}

