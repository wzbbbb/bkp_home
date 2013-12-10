#!/bin/bash

UXDEX=/apps/du/530/FLS530/exp/data
UXEXE=/apps/du/530/FLS530/exec
s=`date +%H:%M`

t=`$UXEXE/uxtim "HH:MM" "$s" "HH:MM" "+00h05"`

grep -v PUR_HHMM $UXDEX/u_purge_param.ref| sed -e '4i\' -e "PUR_HHMM=$t" >/dev/shm/tmp1.txt
rm -f $UXDEX/u_purge_param.ref 

#grep -v PUR_HHMM $UXDEX/u_purge_param.ref >/dev/shm/tmp1.txt

#sed 's/PUR_HHMM=00:01/PUR_HHMM=14:20/'  $UXDEX/u_purge_param.ref >/dev/shm/tmp1.txt

mv /dev/shm/tmp1.txt $UXDEX/u_purge_param.ref
chown univa:univ $UXDEX/u_purge_param.ref

$UXEXE/loadPurParFic FLS530 X casdlsup06
