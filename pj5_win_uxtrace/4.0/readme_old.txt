Windows Uxtrace Version 4.0 readme
Created by ZWA (Orsyp) 2005/01/31


===========Features
1. Many Windows system and hardware information, which is not available to the batch interface, for example the Services, the partitions, the registry, etc., now can be collected. 

2. It now can accept parameters and provides a better way to interact with user. 

3. It adopts the same principles and presents the results in the same structure as in the Unix uxtrace. Both the Unix and the Windows uxtraces accept the same set of parameters; and the analyzing technics and tools could also be reused.

4. It can be launched interactively or in batch mode.

===========Acknowledgement
I appreciate the help from everyone, who has given me good ideas, who has answered my email and who has payed attention to this project. Special thanks to GMU, who has explained so many implementation details of the Unix uxtrace to me.

===========Installation
Unpack the package in the %UXMGR% ("mgr") directory. By default, it will create a new directory. The Windows uxtrace will also work if you put everything directly in the %UXMGR% directory.

===========Package contents
1. win_uxtrace_v4.0.vbs
2. step1_v4.0.bat
3. step_2.v4.0.vbs
4. ISMEMBER.EXE
5. tar.exe
6. gzip.exe
7. readme.txt

===========Launching the uxtrace

======To launch it
1. The Windows uxtrace could be launched by double clicking on the win_uxtrace_v4.0.vbs file. It will, then, pop up dialog boxs to ask for parameters.

2. The batch mode also provides the same functionality. To launch it in batch mode:

cscript win_uxtrace_v4.0.vbs /batch:yes [ /area:{X,S,I,A} /file_level:{0-9} /target:{CS, C, S} ]

Examples:
cscript win_uxtrace_v4.0.vbs /batch:YES 
cscript win_uxtrace_v4.0.vbs /batch:Y  /area:a 
cscript win_uxtrace_v4.0.vbs /batch:y  /file_level:4 /target:C
cscript win_uxtrace_v4.0.vbs /batch:y  /file_level:9 /target:C /area:x


======The parameters
The Windows uxtrace will accept the same set of parameters as the Unix uxtrace.

1. The concerned area: to specify the area to work on.

Note: The parameter names are case sensitive, but the values are not.

The valid parameters are : A, I, S, X
Default value: X

Note:  
1. Only one concerned area can be specified a time.


2. File level: to specify which data files are to be collected.

The valid parameters are : 0 - 9
Default Value: 0 (Do not collect any data files)

For detailed description on which files are collected with which number and how are the files grouped, please check for additional document; or read the script.


3. Target: to collect operating system information or Dollar Universe information or both.

Valid parameters are : C, S, CS, SC
Default Value: CS

Note:  
The parameter is not case sensistive.

C: to collect Dollar Universe related information, with intensive listing result. Similiar to the behavior of the Unix uxtrace, if the related data files are bigger than a threshold value (default 10M), instead of running the "uxlst", the data files will be copied.
S: to collect operating system information, more screenshots, plus registry, Windows event log, etc.


===========The result

The uxtrace result will be a compressed tar file saved in the %UXMGR% directory.
Currently 7 subfolder are created in the uxtrace result: DLS, DQM, DUFILES, FILES, LOG, LIST, SYS, which are a sub-set of the Unix uxtrace counterpart. More folder maybe added, e.g. ITO, PAT, etc. later.  
In DLS, the listings of important directories are stored. From the listings, several useful information can be found: 
1. the access right of the files and directores;
2. the owners of the files and directores; 
3. the last access time of the files and directores;
4. the creation time of the files and directores;
5. the last write time of the files and directores;

File naming convention:  
*_ri.txt: access right
*_ac.txt: last access time
*_wr.txt: last writen time
*_cr.txt: creation time

DQM stores all information about DQM: directory listings, copies of *.dat files and the uxshwque result.

DUFILES stores the collected data files.

FILES stores all of the important configuration files.

LOG contains only the *.log, *.LOG and IU_PUR and IU_RTS job logs from all areas.

LST stores the Dollar Universe listings. 

SYS saves the operating system information.

analyse.txt contains all of the information in all of the directories. Everything in a plain text file.

timestemp.txt records the start and end time of all of the commends run.


===========Limitations and requirements
1. The VB script will need NT 4.0 with Service Pack 4 and above to run.
2. The process listings do not show their launch parameters. 
3. Several functions have not yet been implemented, e.g. PAT, ITO and SAP.
