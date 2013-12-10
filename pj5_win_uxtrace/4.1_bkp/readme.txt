Introduction to Windows Uxtrace 4.0


...........Features
1. More info available
Many OS and hardware statuses can be traced now, for example the Services, the partitions, the registry, etc. 

2. Better control
It can accept parameters and provides a better way to interact with user. 

3. Similar to Unix uxtrace
It adopts the same principles and presents the results in the same structure as in the Unix uxtrace. Both the Unix and the Windows uxtraces accept the same set of parameters; and the analyzing techniques and tools could also be reused.

4. 2 ways to launch it
It can be launched interactively or in batch mode.

...........Acknowledgement
I appreciate the help from everyone, who has given me good ideas, who has answered my email and who has paid attention to this project; special thanks to GMU, who has explained to me so many implementation details of the Unix uxtrace.

...........Installation
You can unpack the package in the %UXMGR% ("mgr") directory, or put everything in a directory under %UXMGR%, it will work in both cases.

...........Package contents
* uxtrace.vbs
* uxtrace_step1.bat
* uxtrace_step2.vbs
* ISMEMBER.EXE
* tar.exe
* gzip.exe
* readme.txt

...........Launching the uxtrace

......To launch it
1. Interactively
The Windows uxtrace could be launched by double clicking on the uxtrace.vbs file. It will, then, pop up dialog boxes to ask for parameters.

2. Batch mode
The batch mode makes it possible to launch the uxtrace through an uproc. It provides the same functionality. To launch it in batch mode:

cscript uxtrace.vbs /batch:yes [ /area:{X,S,I,A} /file_level:{0-9} /target:{CS, C, S} ]

Examples:
cscript uxtrace.vbs /batch:YES 
cscript uxtrace.vbs /batch:Y  /area:a 
cscript uxtrace.vbs /batch:y  /file_level:4 /target:C
cscript uxtrace.vbs /batch:y  /file_level:9 /target:C /area:x

......The parameters
The Windows uxtrace will accept the same set of parameters as the Unix uxtrace.

Note:  The all of the parameter names are case sensitive, but the values are not.

....The concerned area: to specify the area to work on.

The valid parameters are: A, I, S, X
Default value: X

Note:  Only one concerned area can be specified a time.

....File level: to specify which data files are to be collected.

The valid parameters are: 0 - 9
Default Value: 0 (Do not collect any data files)

With value 9, the uxtrace will back all of the data files. For detailed description on which files are collected with which number and how are the files grouped, please check for additional document; or read the script.

....Target: to collect operating system information or Dollar Universe information or both.

Valid parameters are : C, S, CS, SC
Default Value: CS

C: to collect Dollar Universe related information, with intensive listing result. Similiar to the behavior of the Unix uxtrace, if the related data files are bigger than a threshold value (default 10M), instead of running the "uxlst", the data files will be copied.
S: to collect operating system information, more screenshots, plus registry, Windows event log, etc.


...........The result
......Location
The uxtrace result will be a compressed tar file saved in the %UXMGR% directory.

......Directory structure
Currently 7 subfolder are created in the uxtrace result: DLS,  DQM, DUFILES, FILES, LOG, LIST, SYS, which are a sub-set of the Unix uxtrace counterpart. More folders maybe added, e.g. ITO, PAT, etc. later.

1. DLS
In DLS, the listings of important directories are stored. From the listings, the following information can be found: access right;
owner; last access time; creation time; and last written time.
File naming convention:  
* *_ri.txt: access right
* *_ac.txt: last access time
* *_wr.txt: last writen time
* *_cr.txt: creation time

2. DQM 
It stores all of the DQM information: directory listings, copies of *.dat file, and uxshwque result.
3. DUFILES 
It stores the collected data files from the concerned area.
4. FILES 
It stores all of the important configuration files.
5. LOG 
It contains only the *.log, *.LOG and IU_PUR and IU_RTS job logs from all areas.
6. LST 
It stores the Dollar Universe listings from all started areas and focuses on the concerned area. 
7. SYS 
It saves the operating system information, e.g. processes, services, disk usage, CPU, memory, registry, etc. 

......Important files
1. all_info.txt 
It contains the same information and structure as its Unix counterpart.
2. analyse.txt 
It contains basic system information and the uxversion result.
3. timestemp.txt 
It records the start and end time of each commend run. If an uxtrace is taking very long to finish, this file shows you why; if the uxtrace was stopped in the middle, this file shows you what are already collected in the uxtrace result. 
4. uxtrace.txt 
It records all uxtrace output on the command window, and possibly, some additional error messages met while the uxtrace run. It could be used to check if the uxtrace has successfully finished, and if some errors occurred.

...........Limitations and requirements
* The VB script will need NT 4.0 with Service Pack 4 and above to run.
* The process listings do not show their launch parameters. 
* Several functions have not yet been implemented, e.g. PAT, ITO and SAP.

...........Updating log
...........4.1: 

1. The "O" switch is added to run a uxtrace without running any Dollar Universe Commands. It is required when a Dollar Universe command hangs, e.g. uxlst atm.
2. Added the gpresult.exe, could be used to replace the ISMEMBER.EXE. The ISMEMBER.EXE. is kept for now.
