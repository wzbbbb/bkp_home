-1- Purpose of the Module uxtrace_v3.5 :
This script collects information on Dollar Universe environments where a problem occurs.

-2- How to use it :
User must be logged on as Administrator
Dollar Universe environment must be set up using "uxsetenv.bat" command, or the uxtrace script must be located in the mgr directory of the company you want to trace.
If the company on which the problem occurs is started, we will have additionnal informations.

Included with this script are the following files:
uxpulist.exe
uxgawk.exe
uxsed.exe
uxdate.exe
uxsetenvfromfile
These files should be in the same directory as uxtrace_v3.5.bat.

-3- How to launch it :
-3.1- Graphic mode
If the uxtrace is located in the mgr directory of the company you want to trace, you have the possibility to double click on the uxtrace_v3.5.bat for a Windows Explorer, and a trace of your company without a date filtering will be taken.

-3.2- Command Mode :
-3.2.1- Without date filtering :
After you loaded the Dollar Universe environment, launch the uxtrace_v3.5.bat without any argmument.

-3.2.2- With a date filtering :
After you loaded the Dollar Universe environment, launch the uxtrace_v3.5.bat with the following synthax :
uxtrace_v2.bat  start_date start_time end_date end_time

where 
start_date and end_date must be in the following format : yyyy-mm-dd
start_time and end_time must be in the following format : hh:mm:ss

To get help, type uxtrace_v3.5 help

At the end of the script, a directory is created as %UXMGR%\WIN_ANALYSIS_"Dollar Universe Node Name"_"Time stamp"

Please, compress this directory and send it as is to : support@orsyp.com

PS : This package contains also the uxtrace_batch_v3.5.bat script which is an uxtrace which can be submitted in batch mode (from an uproc script for example : call %UXMGR%\uxtrace_batch_v3.5.bat).

GMU Orsyp 20040510
