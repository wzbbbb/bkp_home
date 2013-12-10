#! /bin/ksh
# 1. Load the $U environment 
# 2. Shutdown the DQM
# 3. Rename the 2 files, uxdmpqueWBPRODX.dat and uxdmpdtaWBPRODX.dat in /var/universe/WBPROD/DQM/
# 3. Restart the DQM
# 4. Run this scritp
$UXDQM/uxaddque que=SYS_BATCH joblim=80
$UXDQM/uxaddque que=IN5 joblim=10
$UXDQM/uxaddque que=IN7 joblim=1
$UXDQM/uxaddque que=THEAT joblim=12
$UXDQM/uxaddque que=TPIX joblim=15
$UXDQM/uxaddque que=TV joblim=17
$UXDQM/uxaddque que=WHE joblim=12
$UXDQM/uxaddque que=WHV joblim=12
$UXDQM/uxaddque que=DEPRECIATION joblim=10
$UXDQM/uxaddque que=GAMES_INDUSTRY_POST_TR 
$UXDQM/uxaddque que=GAMES_INDUSTRY_PRE_TR 
$UXDQM/uxaddque que=VIDEO_INDUSTRY_POST_TR
$UXDQM/uxaddque que=VIDEO_INDUSTRY_PRE_TR 
$UXDQM/uxaddque que=ECCSBUNDLE joblim=12
$UXDQM/uxaddque que=PRIORITY joblim=5
$UXDQM/uxaddque que=BOAWIRETRANSFER 
$UXDQM/uxaddque que=WIR joblim=36
$UXDQM/uxaddque que=TEMP joblim=5
$UXDQM/uxaddque que=IU_MAINT
$UXDQM/uxaddque que=BESR joblim=5
$UXDQM/uxaddque que=SYS_RAMP   joblim=25
$UXDQM/uxaddque que=VAN_GROUP_1 GENE LSTQUE=aurp10:SYS_BATCH
$UXDQM/uxaddque que=VAN_GROUP_2 GENE LSTQUE=aurp10:SYS_BATCH
$UXDQM/uxaddque que=VAN_GROUP_3 GENE LSTQUE=aurp10:SYS_BATCH

$UXDQM/uxshwque que=*
sleep 3
$UXDQM/uxstrque que=SYS_BATCH
$UXDQM/uxstrque que=IN5
$UXDQM/uxstrque que=IN7
$UXDQM/uxstrque que=THEAT
$UXDQM/uxstrque que=TPIX
$UXDQM/uxstrque que=TV
$UXDQM/uxstrque que=WHE
$UXDQM/uxstrque que=WHV
$UXDQM/uxstrque que=DEPRECIATION
$UXDQM/uxstrque que=ECCSBUNDLE
$UXDQM/uxstrque que=PRIORITY
$UXDQM/uxstrque que=BOAWIRETRANSFER
$UXDQM/uxstrque que=WIR
$UXDQM/uxstrque que=IU_MAINT
$UXDQM/uxstrque que=BESR
$UXDQM/uxstrque que=VAN_GROUP_1
$UXDQM/uxstrque que=VAN_GROUP_2
$UXDQM/uxstrque que=VAN_GROUP_3
$UXDQM/uxshwque que=*
