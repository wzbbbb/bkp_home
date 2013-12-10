impacted_jobs.sh 

Description 
The jobs can be seen directly from future launch and execution window, except in the following 2 situations.
•	A session header was in launch wait. After the crash, the launch window is expired; the rest of the session will not run.
•	A uproc in a session was in EXECUTING. After the crash, the job could be in ABORTED status; the rest of the session will not run.
This script will gather the information based on the 2 status, LAUNCH WAIT and EXECUTING.
Important: the DUAS has to be started with out Launcher engine, otherwise the job status will be modified, and the script will not be able to provide useful information.
To use the script: 
1.	Please load DUAS environment
2.	Run the script with date:time as input. The "date" has to be in the format of U_FMT_DATE, which is normal formate used in DUAS listing.  Time is a 4 digits number.
For example: 
./impacted_jobs.sh 09/20/2019:2000
The script will generate an output file, impacted_jobs.txt, in the local directory.


The other 2 scripts in this directory are trying to get out the session
informaiton from uxtrace result, uxlst ctl. It is not perfect yet. The
impacted_jobs.sh is prefered one.
