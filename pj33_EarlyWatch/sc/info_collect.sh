#!/bin/ksh
run_cmd () {
echo "###CMD:$1"
eval $1 2>&1
echo "###END:$1"
}
run_cmd "uname -a"
run_cmd "who -b"
run_cmd "java -version"
run_cmd "head -3 /etc/*release"
run_cmd "universion -version"
run_cmd "universion -product"
run_cmd "ulimit -Ha"
run_cmd "ulimit -Sa"
run_cmd "who -b"
run_cmd "ls -l $UXLEX"
run_cmd "ls -l $UXDEX"
run_cmd "ls -l $UXPEX"
run_cmd "ls -l $UXMGR"
#run_cmd "ls -l $UXLIB" #$U V5 ONLY
run_cmd "ls -l $UXEXE"
#run_cmd "ls -l $UXDQM" #$U V5 only
