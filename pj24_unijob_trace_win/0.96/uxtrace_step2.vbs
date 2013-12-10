'''''''''''
''Constant
'''''''''''
Const ForAppending = 8
Const ForWriting = 2
Const OverwriteExisting = False
const mb_factor = 1048576
const data_file_limit = 10485760 '10Mb
'const data_file_limit = 60000 '60Kb
days_of_evt = 7
Const HKEY_LOCAL_MACHINE = &H80000002
const HKEY_CURRENT_USER  = &H80000001
strKeyPath = "SOFTWARE\ORSYP S.A."
'''''''''''
''Creating the OBJ
'''''''''''
Set objShell = WScript.CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")
'''''''''''
''Build conneciton to WMI
'''''''''''
strComputer = "."
Set obj_wmi = GetObject("winmgmts:\\" & strComputer)
Set obj_cimv2 = GetObject("winmgmts:" _
 & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set objReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & _
 strComputer & "\root\default:StdRegProv")


'''''''''''
''Function
'''''''''''
function var_def(var_name)
Set objExecObject = objShell.Exec("cmd /c echo %" & var_name & "%")
var_def = objExecObject.StdOut.ReadLine()
end function

function getvar_def(var_name)
Set objExecObject = objShell.Exec("cmd /c " & U_ROOT_DIR & "\app\bin\getvar.exe " & var_name)
getvar_def = objExecObject.StdOut.ReadLine()
end function

function getvar_java_def(var_name)
Set objExecObject = objShell.Exec("cmd /c java -jar " & UXJAR & "\getvar.jar "   & var_name)
getvar_java_def = objExecObject.StdOut.ReadLine()
end function

function format_time(time_)
y=Year(time_)
m=Month(time_)
if len(m) = 1 then
	m="0" & m 
end if
d=Day(time_)
if len(d) = 1 then
	d="0" & d 
end if
h=Hour(time_)
if len(h) = 1 then
	h="0" & h 
end if
i=Minute(time_)
if len(i) = 1 then
	i="0" & i 
end if
s=Second(time_)
if len(s) = 1 then
	s="0" & s 
end if
format_time=y & m & d & "-" & h & i & s
'wscript.echo format_time
end function

function format_time_no_break(time_)
y=Year(time_)
m=Month(time_)
if len(m) = 1 then
	m="0" & m 
end if
d=Day(time_)
if len(d) = 1 then
	d="0" & d 
end if
h=Hour(time_)
if len(h) = 1 then
	h="0" & h 
end if
i=Minute(time_)
if len(i) = 1 then
	i="0" & i 
end if
s=Second(time_)
if len(s) = 1 then
	s="0" & s 
end if
format_time_no_break=y & m & d &  h & i & s
'wscript.echo format_time_no_break
end function
sub cmd_ts(cmd, logfile)
ts_b=format_time(now)
obj_ts_file.WriteLine "#TSP# #BEG# " & ts_b 'put ts in the timestamp.txt
obj_ts_file.WriteLine "#CMD# " & cmd
If objFSO.FileExists(logfile) Then
	Set obj_log_file = objFSO.OpenTextFile(logfile, ForAppending) ' read the output file
else
	Set obj_log_file = objFSO.CreateTextFile(logfile, False)  'creating the output file
End If
obj_log_file.WriteLine "#CMD# " & cmd
obj_log_file.WriteLine "#TSP# #BEG# " & ts_b 'put ts in the output file
obj_log_file.Close
objShell.Run("cmd /c "& cmd & ">>" & logfile & " 2>&1"), 0, True
ts_e=format_time(now)
obj_ts_file.WriteLine "#TSP# #END# " & ts_e
end sub 
sub cp(file_, path_)
	If objFSO.FileExists(file_) Then
		objFSO.CopyFile file_ , path_ , OverwriteExisting
	end if		
end sub
sub sub_ts(BEG, f_handle, cmd) 'write TS and CMD in both TS and output file
	if  BEG="BEG" then
		ts_b=format_time(now)
		obj_ts_file.WriteLine "#TSP# #BEG# " & ts_b 'put ts in the timestamp.txt
		obj_ts_file.WriteLine "#CMD# " & cmd ' writing in the TS file
		f_handle.WriteLine "#TSP# #BEG# " & ts_b 'put ts in the output file
		f_handle.WriteLine "#CMD# " & cmd ' in the output file
	else
		ts_e=format_time(now)
		obj_ts_file.WriteLine "#TSP# #END# " & ts_e
	end if 
end sub 
sub cmd_(cmd_name) 'run command without TS
objShell.Run("cmd /c "& cmd_name & ""), 0, True
end sub 
function create_file(logfile)
	If objFSO.FileExists(logfile) Then ' creating the output log for the cmd
		Set create_file = objFSO.OpenTextFile(logfile, ForAppending) ' read the output file
	else
		Set create_file= objFSO.CreateTextFile(logfile, False)  'creating the output file
	End If
end function

'label1:
function cp_dta(src_, file_, path_)
	cp_dta="no"
	Set FileList = obj_cimv2.ExecQuery _
	 ("ASSOCIATORS OF {Win32_Directory.Name='"& src_ &"'} Where " _
	 & "ResultClass = CIM_DataFile")
	For Each objFile In FileList
		Set obj_get_ = objFSO.GetFile(objFile.name)
		f_name=objFSO.GetFileName(obj_get_) 
	if instr(f_name, file_)<>0 and objFile.Extension = "dta" then
		'file_found="yes"
		cp_dta="yes"
		If not objFSO.FileExists(path_ &"\"& f_name &".gz") Then 'cp only if it not already cp&gz-ed
			If not objFSO.FileExists(path_ &"\"& f_name) Then 'cp only if it not already cp-ed, when no gzip.exe
				objFSO.CopyFile objFile.name, path_ &"\"&  f_name, OverwriteExisting 'False
				trace_log "file copied: " & objFile.name
			end if
		end if		
	End If
	Next
end function
sub cp_gz_dta(src1_,src2_, file_, path_)
	cp_dta_res=cp_dta(src1_, file_, path_)
	if cp_dta_res="no" then 'If the file is not found in src1_, check src2_ 
		cp_dta_res=cp_dta(src2_, file_, path_)
	end if
	objShell.CurrentDirectory =path_ 
	cmd_ UXEXE &"\zip.exe -q "& file_ & ".zip *"& file_ & "*.dta"
end sub 
function get_file_size(file_, dir_) 
	Set FileList = obj_cimv2.ExecQuery _
	("ASSOCIATORS OF {Win32_Directory.Name='"& dir_ &"'} Where " _
	 & "ResultClass = CIM_DataFile")
	For Each objFile In FileList
		Set obj_get_ = objFSO.GetFile(objFile.name)
		f_name=objFSO.GetFileName(obj_get_) 
		'wscript.echo "f_name is: " & f_name
		if instr(f_name, file_)<>0 and objFile.Extension = "dta" then
			get_file_size=obj_get_.Size
		End If
	Next
end function

sub df(logfile)
	set obj_log_file=create_file(logfile)
	sub_ts "BEG", obj_log_file, "df"  ' write TS and CMD in both TS and output file
	set col_disk=obj_cimv2.execquery("select DeviceID, DriveType, FileSystem, " &_
	"FreeSpace, Name, ProviderName, size, VolumeName from Win32_LogicalDisk")
for each obj_disk in col_disk
	obj_log_file.WriteLine "================================="
	obj_log_file.WriteLine "Device ID: " & obj_disk.DeviceID 
	Select Case obj_disk.DriveType
		 Case 1
		 'Wscript.Echo "No root directory."
		 obj_log_file.WriteLine "No root directory."
		 Case 2
		 obj_log_file.WriteLine  "DriveType: Removable drive."
		 Case 3
		 obj_log_file.WriteLine "DriveType: Local hard disk."
		 Case 4
		 obj_log_file.WriteLine "DriveType: Network disk." 
		 Case 5
		 obj_log_file.WriteLine "DriveType: Compact disk." 
		 Case 6
		 obj_log_file.WriteLine "DriveType: RAM disk." 
	Case Else
	obj_log_file.WriteLine "Drive type could not be determined."
	End Select
	'Wscript.Echo "VolumeName: " & obj_disk.VolumeName 
	if obj_disk.DriveType=4 then
		obj_log_file.WriteLine "VolumeName: " 
	else
		obj_log_file.WriteLine "VolumeName: " & obj_disk.VolumeName 
	end if
	obj_log_file.WriteLine "FileSystem: " & obj_disk.FileSystem 
	obj_log_file.WriteLine "FreeSpace: " & int(obj_disk.FreeSpace / mb_factor) & " MB"
	'Wscript.Echo "Name: " & obj_disk.Name 
	obj_log_file.WriteLine "ProviderName: " & obj_disk.ProviderName 
	obj_log_file.WriteLine "Size: " & int(obj_disk.Size / mb_factor) & " MB"
next
	sub_ts "END", obj_log_file, "df"  ' write TS in both TS and out put file
	obj_log_file.Close
end sub

function date2utc(date_)
	Set colTimeZone = obj_cimv2.ExecQuery ("SELECT Bias FROM Win32_TimeZone")
	For Each objTimeZone in colTimeZone
		strBias = objTimeZone.Bias
	Next
	date2utc = Year(date_)
	dtmMonth = Month(date_)
	If Len(dtmMonth) = 1 Then
		dtmMonth = "0" & dtmMonth
	End If
	date2utc = date2utc & dtmMonth
	dtmDay = Day(date_)
	If Len(dtmDay) = 1 Then
		dtmDay = "0" & dtmDay
	End If
	date2utc = date2utc & dtmDay & "000000.000000"
	bias = Cstr(strBias)
	if strBias > 100 then
		date2utc = date2utc & "+" & bias
	end if
	if strBias < 100 and strBias >0 then
		date2utc = date2utc & "+0" & bias
	end if
	if strBias > -100 and strBias < 0 then
		date2utc = date2utc & "-0" & Cstr(abs(strBias))
	end if
	if strBias < -100 then
		date2utc = date2utc & Cstr(strBias)
	end if
end function

Function utc2date(dtmInstallDate)
	 utc2date = CDate(Mid(dtmInstallDate, 5, 2) & "/" & _
	 Mid(dtmInstallDate, 7, 2) & "/" & Left(dtmInstallDate, 4) _
	 & " " & Mid (dtmInstallDate, 9, 2) & ":" & _
	 Mid(dtmInstallDate, 11, 2) & ":" & Mid(dtmInstallDate, _
	 13, 2))
End Function

Sub get_evtlog(logfile)
	set obj_log_file=create_file(logfile)
	sub_ts "BEG", obj_log_file, "EventLog"  ' write TS and CMD in both TS and output file
	begin_date = date2utc(dateadd("d", -days_of_evt, date))
	Set col_evt = obj_wmi.execquery("select * from Win32_NTLogEvent where TimeGenerated > '"  & begin_date & "'")

For Each obj_evt In col_evt
	On Error Resume Next
	 obj_log_file.WriteLine "Log File: " & obj_evt.LogFile & vbCrLf & _
	 "Record Number: " & obj_evt.RecordNumber & vbCrLf & _
	 "Type: " & obj_evt.Type & vbCrLf & _
	 "Time Generated: " & utc2date(obj_evt.TimeGenerated) & vbCrLf & _
	 "Source: " & obj_evt.SourceName & vbCrLf & _
	 "Category: " & obj_evt.Category & vbCrLf & _
	 "Category String: " & obj_evt.CategoryString & vbCrLf & _
	 "Event: " & obj_evt.EventCode & vbCrLf & _
	 "User: " & obj_evt.User & vbCrLf & _
	 "Computer: " & obj_evt.ComputerName & vbCrLf & _
	 "Message: " & obj_evt.Message & vbCrLf
	If Err <> 0 Then
	    obj_tr_file.writeline Err.Number & " -- " &  Err.Description
	    obj_tr_file.writeline "Error getting an event log"
	    Err.Clear
	End If
Next
	On Error GoTo 0 
	sub_ts "END", obj_log_file, "EventLog"  ' write TS in both TS and out put file
	obj_log_file.Close
End Sub

sub HOTFIX(logfile)
	set obj_log_file=create_file(logfile)
	sub_ts "BEG", obj_log_file, "HOTFIX"  ' write TS and CMD in both TS and output file
Set col_fix = obj_cimv2.ExecQuery _
 ("SELECT Description,  FixComments, HotFixID, ServicePackInEffect " &_ 
 "FROM Win32_QuickFixEngineering")
For Each obj_fix in col_fix
	obj_log_file.WriteLine "=================================" 
	obj_log_file.WriteLine  "Description: " & obj_fix.Description
	obj_log_file.WriteLine  "FixComments: " & obj_fix.FixComments
	obj_log_file.WriteLine  "Hot Fix ID: " & obj_fix.HotFixID
	obj_log_file.WriteLine "ServicePackInEffect: " & obj_fix.ServicePackInEffect
Next
	sub_ts "END", obj_log_file, "HOTFIX"  ' write TS in both TS and out put file
	obj_log_file.Close
end sub

sub list_reg(logfile)
	set obj_log_file=create_file(logfile)
	sub_ts "BEG", obj_log_file, "registry"  ' write TS and CMD in both TS and output file
	obj_log_file.WriteLine "===========HKEY_LOCAL_MACHINE\"& strKeyPath & "==========="
	shw_sub_key HKEY_LOCAL_MACHINE, strKeyPath, obj_log_file
	obj_log_file.WriteLine "===========HKEY_CURRENT_USER\"& strKeyPath & "==========="
	shw_sub_key HKEY_CURRENT_USER, strKeyPath, obj_log_file
	sub_ts "END", obj_log_file, "registry"  ' write TS in both TS and out put file
	obj_log_file.Close
end sub

sub shw_sub_key(hkey, KeyPath, f_handle)
	ret_cod = objReg.EnumKey(hkey, KeyPath, arrSubKeys)
	if ret_cod = 0  and IsArray(arrSubKeys) then 
	For Each Subkey in arrSubKeys
		f_handle.WriteLine KeyPath & "\" & Subkey
		shw_sub_key hkey, KeyPath & "\" & Subkey, f_handle
	Next
	end if 
end sub

sub nic(logfile) 
	set obj_log_file=create_file(logfile)
	sub_ts "BEG", obj_log_file, "NIC"  ' write TS and CMD in both TS and output file
	Set col_pc = obj_wmi.execquery("select AdapterType, "&_
	"Caption, MACAddress, Manufacturer, ProductName  " &_
	"from Win32_NetworkAdapter where  AdapterType = ""Ethernet 802.3"" ")
For Each obj_pc In col_pc
 obj_log_file.WriteLine "============================================" & vbCrLf & _
 "AdapterType: " & obj_pc.AdapterType & vbCrLf & _
 "Caption: " & obj_pc.Caption & vbCrLf & _
 "MACAddress: " & obj_pc.MACAddress & vbCrLf & _
 "Manufacturer: " & obj_pc.Manufacturer & vbCrLf & _
 "ProductName: " & obj_pc.ProductName 
Next
	sub_ts "END", obj_log_file, "NIC"  ' write TS in both TS and out put file
	obj_log_file.Close
end sub

Function utc2date(dtmInstallDate)
	 utc2date = CDate(Mid(dtmInstallDate, 5, 2) & "/" & _
	 Mid(dtmInstallDate, 7, 2) & "/" & Left(dtmInstallDate, 4) _
	 & " " & Mid (dtmInstallDate, 9, 2) & ":" & _
	 Mid(dtmInstallDate, 11, 2) & ":" & Mid(dtmInstallDate, _
	 13, 2))
End Function

sub OS(logfile)
	set obj_log_file=create_file(logfile)
	sub_ts "BEG", obj_log_file, "OS"  ' write TS and CMD in both TS and output file
	Set col_os = obj_wmi.execquery("select Caption, "&_
	"CurrentTimeZone, FreePhysicalMemory, FreeSpaceInPagingFiles, "&_
	"FreeVirtualMemory, InstallDate, LastBootUpTime, Locale, "&_
	"NumberOfUsers, OSLanguage, RegisteredUser, ServicePackMajorVersion, "&_
	"ServicePackMinorVersion, SystemDirectory, TotalVirtualMemorySize," &_
	"Version from Win32_OperatingSystem")
For Each obj_os In col_os
 On Error Resume Next
 obj_log_file.WriteLine "============================================" & vbCrLf & _
 "Caption: " & obj_os.Caption & vbCrLf & _
 "Service Pack: " & obj_os.ServicePackMajorVersion & _
 "." & obj_os.ServicePackMinorVersion & vbCrLf & _
 "CurrentTimeZone: " & obj_os.CurrentTimeZone & vbCrLf & _
 "FreePhysicalMemory: " & obj_os.FreePhysicalMemory & vbCrLf & _
 "FreeSpaceInPagingFiles: " & obj_os.FreeSpaceInPagingFiles & vbCrLf & _
 "FreeVirtualMemory: " & obj_os.FreeVirtualMemory & vbCrLf & _
 "TotalVirtualMemorySize: " & obj_os.TotalVirtualMemorySize & vbCrLf & _
 "InstallDate: " & utc2date(obj_os.InstallDate) & vbCrLf & _
 "LastBootUpTime: " & utc2date(obj_os.LastBootUpTime) & vbCrLf & _
 "Locale: " & obj_os.Locale & vbCrLf & _
 "NumberOfUsers: " & obj_os.NumberOfUsers & vbCrLf & _
 "OSLanguage: " & obj_os.OSLanguage & vbCrLf & _
 "RegisteredUser: " & obj_os.RegisteredUser & vbCrLf & _
 "Version: " & obj_os.Version & vbCrLf & _
 "System Directory: " & obj_os.SystemDirectory
Next
	sub_ts "END", obj_log_file, "OS"  ' write TS in both TS and out put file
	obj_log_file.Close
end sub
sub PC(logfile)
	set obj_log_file=create_file(logfile)
	sub_ts "BEG", obj_log_file, "PC"  ' write TS and CMD in both TS and output file
	Set col_pc = obj_wmi.execquery("select Description, "&_
	"Manufacturer, Model, NumberOfProcessors, PrimaryOwnerName, SystemType,"&_
	"TotalPhysicalMemory from Win32_ComputerSystem")
For Each obj_pc In col_pc
 obj_log_file.WriteLine "============================================" & vbCrLf & _
 "Description: " & obj_pc.Description & vbCrLf & _
 "Manufacturer: " & obj_pc.Manufacturer & vbCrLf & _
 "Model: " & obj_pc.Model & vbCrLf & _
 "NumberOfProcessors: " & obj_pc.NumberOfProcessors & vbCrLf & _
 "PrimaryOwnerName: " & obj_pc.PrimaryOwnerName & vbCrLf & _
 "SystemType: " & obj_pc.SystemType & vbCrLf & _
 "TotalPhysicalMemory: " & obj_pc.TotalPhysicalMemory 
Next
	sub_ts "END", obj_log_file, "PC"  ' write TS in both TS and out put file
	obj_log_file.Close
end sub

Function utc2date(date_)
	 utc2date = CDate(Mid(date_, 5, 2) & "/" & _
	 Mid(date_, 7, 2) & "/" & Left(date_, 4) _
	 & " " & Mid (date_, 9, 2) & ":" & _
	 Mid(date_, 11, 2) & ":" & Mid(date_, _
	 13, 2))
End Function

sub ps(logfile, logfile_ux)
	set obj_log_file=create_file(logfile)
	set obj_log_file_ux=create_file(logfile_ux)
	sub_ts "BEG", obj_log_file, "ps"  ' write TS and CMD in both TS and output file
	sub_ts "BEG", obj_log_file_ux, "ps"  ' write TS and CMD in both TS and output file
Set col_ps_lst = obj_cimv2.ExecQuery _
 ("SELECT Name, ProcessID, ParentProcessID, Priority, CreationDate, " & _ 
 "ExecutablePath, ThreadCount, PageFileUsage, PageFaults, WorkingSetSize FROM Win32_Process")

obj_log_file.WriteLine "Process"& vbTab &"Process owner"& vbTab &"Process ID"& vbTab &"Parent PID"& vbTab &"Priority"& vbTab &"Creation Date"& vbTab &"Path"& vbTab &"Thread Count"& vbTab &"Page File Size"& vbTab &"Page Faults"& vbTab &"Working Set Size"
obj_log_file_ux.WriteLine "Process"& vbTab &"Process owner"& vbTab &"Process ID"& vbTab &"Parent PID"& vbTab &"Priority"& vbTab &"Creation Date"& vbTab &"Path"& vbTab &"Thread Count"& vbTab &"Page File Size"& vbTab &"Page Faults"& vbTab &"Working Set Size"
obj_log_file.WriteLine "=============================================================================================="
obj_log_file_ux.WriteLine "=============================================================================================="
For Each obj_ps in col_ps_lst
	'colProperties = obj_ps.GetOwner(strNameOfUser,strUserDomain)
	On Error Resume Next
	obj_ps.GetOwner strNameOfUser,  strUserDomain 
	If Err <> 0 Then
		obj_tr_file.writeline Err.Number & " -- " &  Err.Description
		obj_tr_file.writeline "U_TMP_PATH is not defined in the *.def files."
	    Err.Clear
	else
		obj_log_file.Write obj_ps.Name & vbTab &  strUserDomain & "\" & strNameOfUser & vbTab & obj_ps.ProcessID & vbTab & obj_ps.ParentProcessID & vbTab & obj_ps.Priority & vbTab 
		if isnull(obj_ps.CreationDate)  then
			obj_log_file.Write "Creation Date: not defined" & vbTab 
		else
			obj_log_file.Write utc2date(obj_ps.CreationDate) & vbTab 
		end if
		obj_log_file.WriteLine obj_ps.ExecutablePath & vbTab & obj_ps.ThreadCount & vbTab & obj_ps.PageFileUsage & vbTab & obj_ps.PageFaults & vbTab & obj_ps.WorkingSetSize

		if instr(obj_ps.Name, "Uni")<>0 or instr(obj_ps.Name, "uni")<>0 or instr(obj_ps.Name, "Ux")<>0 or instr(obj_ps.Name, "ux")<>0 then
			obj_log_file_ux.Write obj_ps.Name & vbTab &  strUserDomain & "\" & strNameOfUser & vbTab & obj_ps.ProcessID & vbTab & obj_ps.ParentProcessID & vbTab & obj_ps.Priority & vbTab 
			if isnull(obj_ps.CreationDate)  then
				obj_log_file_ux.Write "Creation Date: not defined" & vbTab 
			else
				obj_log_file_ux.Write utc2date(obj_ps.CreationDate) & vbTab 
			end if
			obj_log_file_ux.WriteLine obj_ps.ExecutablePath & vbTab & obj_ps.ThreadCount & vbTab & obj_ps.PageFileUsage & vbTab & obj_ps.PageFaults & vbTab & obj_ps.WorkingSetSize
		end if
	End If
	On Error GoTo 0 
Next
	sub_ts "END", obj_log_file, "ps"  ' write TS in both TS and out put file
	sub_ts "END", obj_log_file_ux, "ps"  ' write TS in both TS and out put file
	obj_log_file.Close
	obj_log_file_ux.Close
end sub

sub service(logfile, logfile_ux)
	set obj_log_file=create_file(logfile)
	set obj_log_file_ux=create_file(logfile_ux)
	sub_ts "BEG", obj_log_file, "serivce"  ' write TS and CMD in both TS and output file
	sub_ts "BEG", obj_log_file_ux, "serivce"  ' write TS and CMD in both TS and output file
	Set col_services = obj_wmi.execquery("select Name, DisplayName, " & _
	 "Description, DesktopInteract, InstallDate, PathName, ProcessID, " & _
	 " StartMode, State, StartName, Status from Win32_Service")
	obj_log_file_ux.WriteLine "Name"& VbTab &"Display Name"& VbTab &"Description"& VbTab & "DesktopInteract"& VbTab &"Path"& VbTab &"ProcessID"& VbTab &"Start Mode"& VbTab & "User Account"& VbTab &"State"& VbTab &"Status" 
	obj_log_file_ux.WriteLine "===========================================================================================" 
For Each obj_service In col_services
	 obj_log_file.WriteLine "=================================" & vbCrLf & _
	 "Name: " & obj_service.Name & vbCrLf & _
	 "Display Name: " & obj_service.DisplayName & vbCrLf & _
	 "Description: " & obj_service.Description & vbCrLf & _
	 "DesktopInteract: " & obj_service.DesktopInteract & vbCrLf & _
	 "Path: " & obj_service.PathName & vbCrLf & _
	 "ProcessID: " & obj_service.ProcessID & vbCrLf & _
	 "Start Mode: " & obj_service.StartMode & vbCrLf & _
	 "User Account: " & obj_service.StartName & vbCrLf & _
	 "State: " & obj_service.State & vbCrLf & _
	 "Status: " & obj_service.Status 
	if instr(obj_service.DisplayName, "Univer$e")<>0 then
		obj_log_file_ux.WriteLine  obj_service.Name & VbTab & obj_service.DisplayName & VbTab & _
		obj_service.Description & VbTab & obj_service.DesktopInteract & VbTab &  obj_service.PathName & VbTab & _
		obj_service.ProcessID & VbTab & obj_service.StartMode & VbTab & obj_service.StartName & VbTab & _
		obj_service.State & VbTab & obj_service.Status 
	 end if
Next
	sub_ts "END", obj_log_file, "service"  ' write TS in both TS and out put file
	sub_ts "END", obj_log_file_ux, "service"  ' write TS in both TS and out put file
	obj_log_file.Close
	obj_log_file_ux.Close
end sub
function dir_tc(target_dir,var_name_, output_) 
set obj_log_file=create_file(output_)
obj_log_file.WriteLine "#REM# Listing the creation time of the UNIJOB "& var_name_ & " directory (sorted by file names)" 
obj_log_file.close
cmd_ts "dir /tc /q /o " & target_dir, output_
end function
function dir_ta(target_dir,var_name_, output_) 
set obj_log_file=create_file(output_)
obj_log_file.WriteLine "#REM# Listing the last access time of the UNIJOB "& var_name_ & " directory (sorted by file names)" 
obj_log_file.close
cmd_ts "dir /ta /q /o " & target_dir, output_
end function
function dir_tw(target_dir,var_name_, output_) 
set obj_log_file=create_file(output_)
obj_log_file.WriteLine "#REM# Listing the last writen time of the UNIJOB "& var_name_ & " directory (sorted by file names)" 
obj_log_file.close
cmd_ts "dir /tw /q /o " & target_dir, output_
end function
function dir_cacls(target_dir,var_name_, output_) 
set obj_log_file=create_file(output_)
obj_log_file.WriteLine "#REM# Listing the access right of the UNIJOB "& var_name_ & " directory (sorted by file names)" 
obj_log_file.close
cmd_ts "cacls " & target_dir, output_
end function

function dir_tc_all(target_dir,var_name_, output_) 
set obj_log_file=create_file(output_)
obj_log_file.WriteLine "#REM# Listing the creation time of the UNIJOB "& var_name_ & " directory (sorted by file names)" 
obj_log_file.close
cmd_ts "dir /tc /q /o /s " & target_dir, output_
end function
function dir_ta_all(target_dir,var_name_, output_) 
set obj_log_file=create_file(output_)
obj_log_file.WriteLine "#REM# Listing the last access time of the UNIJOB "& var_name_ & " directory (sorted by file names)" 
obj_log_file.close
cmd_ts "dir /ta /q /o /s " & target_dir, output_
end function
function dir_tw_all(target_dir,var_name_, output_) 
set obj_log_file=create_file(output_)
obj_log_file.WriteLine "#REM# Listing the last writen time of the UNIJOB "& var_name_ & " directory (sorted by file names)" 
obj_log_file.close
cmd_ts "dir /tw /q /o /s " & target_dir, output_
end function
function dir_cacls_all(target_dir,var_name_, output_) 
set obj_log_file=create_file(output_)
obj_log_file.WriteLine "#REM# Listing the access right of the UNIJOB "& var_name_ & " directory (sorted by file names)" 
obj_log_file.close
cmd_ts "cacls " & target_dir & " /t", output_
end function
sub ping_host(var_name_, output_)
	set obj_log_file=create_file(output_)
	obj_log_file.WriteLine "#REM# ping host name "& var_name_ & " " 
	obj_log_file.close
	cmd_ts "ping " & var_name_ , output_
end sub 
function get_hostname_from_sck(var_name_)
	Set objExecObject = objShell.Exec("cmd /c findstr %S_NOEUD% %UXMGR%\uxsrsrv.sck") 
	Do While Not objExecObject.StdOut.AtEndOfStream
	    strText = objExecObject.StdOut.ReadLine()
	    strText = trim(strText)
	    'wscript.echo "strText is now " & strText
	    If Instr(strText, "#") <> 1 Then ' found the line
		l_hostname_=Split(strText, " ", -1, 1)
		get_hostname_from_sck= l_hostname_(Ubound(l_hostname_))
		'wscript.echo get_hostname_from_sck
		Exit Do
	    End If
	Loop
end function
sub ping_local(var_name_, output_)
	local_hostname=get_hostname_from_sck(var_name_)
	ping_host local_hostname, output_ 
end sub 
sub sys_analysis(num)
'''''''''''getting the directory lists
trace_log "Getting service information ..."
'wscript.echo  sys_dir & "service_" & num & ".txt"
service sys_dir & "service_" & num & ".txt" , sys_dir & "service_ux_" & num & ".txt"

trace_log "Getting process information ..."
'To generate the ps and ps_ux results
ps sys_dir & "ps_" & num & ".txt", sys_dir & "ps_ux_" & num & ".txt"

'To generate the tasklist
cmd_ts "tasklist /v", sys_dir &"tasklist_" & num & ".txt"

trace_log "Getting UNIJOB directory listings for data files ..."

dir_tc UXDIR_ROOT, "UXDIR_ROOT",dls_dir &"UXDIR_ROOT_cr_" & num & ".txt"
dir_tc_all UXDIR_ROOT, "UXDIR_ROOT",dls_dir &"UNIJOB_dir_all_cr_" & num & ".txt"
dir_tc UXDEX, "UXDEX",dls_dir &"UXDEX_cr_" & num & ".txt"

dir_ta UXDIR_ROOT,"UXDIR_ROOT", dls_dir &"UXDIR_ROOT_ac_" & num & ".txt"
dir_ta_all UXDIR_ROOT,"UXDIR_ROOT", dls_dir &"UNIJOB_dir_all_ac_" & num & ".txt"
dir_ta UXDEX, "UXDEX", dls_dir &"UXDEX_ac_" & num & ".txt"

dir_tw UXDIR_ROOT,"UXDIR_ROOT", dls_dir &"UXDIR_ROOT_wr_" & num & ".txt"
dir_tw_all UXDIR_ROOT,"UXDIR_ROOT", dls_dir &"UNIJOB_dir_all_wr_" & num & ".txt"
dir_tw UXDEX,"UXDEX", dls_dir &"UXDEX_wr_" & num & ".txt"

trace_log "Listing active connections ..."
cmd_ts "netstat -a" , sys_dir &"netstat_a_" & num & ".txt"
cmd_ts "netstat -ao" , sys_dir &"netstat_ao_" & num & ".txt"
cmd_ts "netstat -na" , sys_dir &"netstat_na_" & num & ".txt"
cmd_ts "netstat -nao" , sys_dir &"netstat_nao_" & num & ".txt"

trace_log "Getting file system information ..."
df sys_dir & "df_" & num & ".txt"

ping_local  S_NOEUD, sys_dir & "ping_localnode_" & num & ".txt"
ping_host  "localhost", sys_dir & "ping_localhost_" & num & ".txt"

end sub
'''''''''''
''Variables
'''''''''''

win_trace_ver="UNIJOB Uxtrace 0.9.5"
ver_short="v09"

'''''''''''
'objShell.Run("cmd /k call .\uxsetenv.bat "), 1, True
'''''''''''
'wscript.sleep(5000)
U_ROOT_DIR=var_def("U_ROOT_DIR")
'getvar is not available in UniViwer Server, so all paths hard code
UXDIR_ROOT=U_ROOT_DIR 
UXEXE=U_ROOT_DIR & "\app\bin"
UXMGR=U_ROOT_DIR & "\data"
UNI_DIR_APP=U_ROOT_DIR & "\app"
UXDEX=U_ROOT_DIR & "\data\data"
UXLEX=U_ROOT_DIR & "\data\log"
UXPEX=U_ROOT_DIR & "\data\upr"
UXFIL=U_ROOT_DIR & "\app\files"
UXJAR=U_ROOT_DIR & "\app\jars"
U_TMP_PATH=U_ROOT_DIR & "\data\temp"

Set objExecObject = objShell.Exec("cmd /c findstr /i unijob " & UXMGR &"\install\history_install.txt") 
read_line = objExecObject.StdOut.ReadLine()
if len(read_line) < 3 then
	TARGET_INSTANCE="UniViewer_Server"
	U_LOG_FILE=U_ROOT_DIR & "\data\log\uvserver.log"
	UNI_VERSION=getvar_java_def("UNI_VERSION")
else
	TARGET_INSTANCE="UniJob"
	U_LOG_FILE=U_ROOT_DIR & "\data\log\unijob.log"
	UNI_VERSION=getvar_def("UNI_VERSION")
end if
Set objExecObject = objShell.Exec("cmd /c findstr /i S_NODENAME  " & UXMGR &"\values.xml") 
NODE_STRING = objExecObject.StdOut.ReadLine()
NODE_STRING_1 = Split(trim(NODE_STRING), ">") ' the result od split is an array
NODE_STRING_2 = Split(NODE_STRING_1(1), "<") ' get everyting after the 1st > 
S_NOEUD = NODE_STRING_2(0)
'S_NOEUD=getvar_def("S_NODENAME")

'S_ESPEXE=var_def("S_ESPEXE")
S_SOCIETE="UNIJOB"
COMPUTERNAME=var_def("COMPUTERNAME")
WINDIR=var_def("WINDIR")
etc=WINDIR & "\system32\drivers\etc"
trace_dir=objShell.CurrentDirectory
dim log_dir_var(4, 2)
log_dir_var(0,1)=(UXLAP)
log_dir_var(1,1)=(UXLIN)
log_dir_var(2,1)=(UXLSI)
log_dir_var(3,1)=(UXLEX)
log_dir_var(0,0)=("UXLAP")
log_dir_var(1,0)=("UXLIN")
log_dir_var(2,0)=("UXLSI")
log_dir_var(3,0)=("UXLEX")

area=Wscript.Arguments.Item(0)
file_level=Wscript.Arguments.Item(1)
target=Wscript.Arguments.Item(2)

'''''''''''
''Main
'''''''''''
'''''''''''Creating the result directory
current_time=format_time_no_break(now)
'trace_name=  "TMP_" & S_NOEUD & "_uxtrace_Win_" & S_SOCIETE &"_"& current_time & "_" & area & file_level & target 
trace_name=  "uxtrace_result_" & current_time  
U_DIR_ANALYSIS=UNI_DIR_APP & "\uxtrace\" & trace_name
objFSO.CreateFolder(U_DIR_ANALYSIS)
Set obj_ts_file = objFSO.CreateTextFile(U_DIR_ANALYSIS & "\timestamp.txt", False)
Set obj_tr_file = objFSO.CreateTextFile(U_DIR_ANALYSIS & "\uxtrace.txt", False)
trace_log "################################################################## "
trace_log "***********                                            *********** "
trace_log "***********     Welcome to UNIJOB Uxtrace 0.9.5        *********** "
trace_log "***********        ORSYP Dollar Access team            *********** "
trace_log "***********                                            *********** "
trace_log "################################################################## "
trace_log " "
trace_log "The trace result is temporarily saved in : " & U_DIR_ANALYSIS

dls_dir=U_DIR_ANALYSIS & "\DLS\"
dufiles_dir=U_DIR_ANALYSIS & "\DUFILES\"
files_dir=U_DIR_ANALYSIS & "\FILES\"
log_dir=U_DIR_ANALYSIS & "\LOG\"
sys_dir=U_DIR_ANALYSIS & "\SYS\"
upg_dir=U_DIR_ANALYSIS & "\UPG\"

objFSO.CreateFolder(dls_dir)
objFSO.CreateFolder(dufiles_dir)
objFSO.CreateFolder(files_dir)
objFSO.CreateFolder(log_dir)
objFSO.CreateFolder(sys_dir)
objFSO.CreateFolder(upg_dir)


BEG="BEG"
'wscript.echo "First Global System Screenshot"
trace_log "First Global System Screenshot"
sys_analysis "01G"
cmd_ts "dir /tc /q /o " & etc, dls_dir &"etc_cr.txt"
cmd_ts "dir /ta /q /o " & etc, dls_dir &"etc_ac.txt"
cmd_ts "dir /tw /q /o " & etc, dls_dir &"etc_wr.txt"
cmd_ts "cacls " & etc &"\*", dls_dir &"etc_ri.txt"

dir_tc U_TMP_PATH, "U_TMP_PATH", dls_dir &"U_TMP_PATH_cr_.txt"
dir_cacls U_TMP_PATH &"\*", "U_TMP_PATH", dls_dir &"U_TMP_PATH_ri.txt"

trace_log "Getting UNIJOB directory/file, creation time ..."
dir_tc UXEXE, "UXEXE",dls_dir &"UXEXE_cr.txt"
dir_tc UXMGR, "UXMGR",dls_dir &"UXMGR_cr.txt"
dir_tc UXFIL, "UXFIL",dls_dir &"UXFIL_cr.txt"
dir_tc UXJAR, "UXJAR",dls_dir &"UXJAR_cr.txt"
dir_tc UXPEX, "UXPEX",dls_dir &"UXPEX_cr.txt"
dir_tc UXLEX, "UXLEX",dls_dir &"UXLEX_cr.txt"

trace_log "Getting UNIJOB directory/file, last access time ..."
dir_ta UXEXE, "UXEXE", dls_dir &"UXEXE_ac.txt"
dir_ta UXMGR, "UXMGR", dls_dir &"UXMGR_ac.txt"
dir_ta UXFIL, "UXFIL", dls_dir &"UXFIL_ac.txt"
dir_ta UXJAR, "UXJAR", dls_dir &"UXJAR_ac.txt"
dir_ta UXPEX, "UXPEX", dls_dir &"UXPEX_ac.txt"
dir_ta UXLEX, "UXLEX", dls_dir &"UXLEX_ac.txt"

trace_log "Getting UNIJOB directory/file, last written time ..."
dir_tw UXEXE, "UXEXE", dls_dir &"UXEXE_wr.txt"
dir_tw UXMGR, "UXMGR", dls_dir &"UXMGR_wr.txt"
dir_tw UXFIL, "UXFIL", dls_dir &"UXFIL_wr.txt"
dir_tw UXJAR, "UXJAR", dls_dir &"UXJAR_wr.txt"
dir_tw UXPEX, "UXPEX", dls_dir &"UXPEX_wr.txt"
dir_tw UXLEX, "UXLEX", dls_dir &"UXLEX_wr.txt"

'wscript.echo "Getting directory/file access right ..."
trace_log "Getting UNIJOB directory/file, access right ..."

dir_cacls UXDIR_ROOT &"\*","UXDIR_ROOT", dls_dir &"UXDIR_ROOT_ri.txt"
dir_cacls_all UXDIR_ROOT &"\*","UXDIR_ROOT", dls_dir &"UNIJOB_dir_all_ri.txt"
dir_cacls UXEXE &"\*","UXEXE", dls_dir &"UXEXE_ri.txt"
dir_cacls UXMGR &"\*","UXMGR", dls_dir &"UXMGR_ri.txt"
dir_cacls UXFIL &"\*","UXFIL", dls_dir &"UXFIL_ri.txt"
dir_cacls UXJAR &"\*","UXJAR", dls_dir &"UXJAR_ri.txt"
dir_cacls UXDEX &"\*","UXDEX", dls_dir &"UXDEX_ri.txt"
dir_cacls UXPEX &"\*","UXPEX", dls_dir &"UXPEX_ri.txt"
dir_cacls UXLEX &"\*","UXLEX", dls_dir &"UXLEX_ri.txt"


'''''''''''analyse.txt
'wscript.echo "Populating the analyse.txt ... "
trace_log "Populating the analyse.txt ... "
OS U_DIR_ANALYSIS & "\analyse.txt"
cmd_ts  "hostname ", U_DIR_ANALYSIS &"\analyse.txt"
cmd_ts "java -version", U_DIR_ANALYSIS &"\analyse.txt"
objShell.CurrentDirectory = UXMGR
if instr(UNI_VERSION, "UniJob") <> 0 then
	cmd_ts "unicheckuj.bat", U_DIR_ANALYSIS &"\analyse.txt"
else
	cmd_ts "unicheckms.bat", U_DIR_ANALYSIS &"\analyse.txt"
end if
cmd_ts "echo " & UNI_VERSION, U_DIR_ANALYSIS &"\analyse.txt"
df U_DIR_ANALYSIS & "\analyse.txt"

'''''''''''env & id
cmd_ts "set" , sys_dir &"env.txt"
cmd_ts  "gpresult", sys_dir &"gpresult.txt"
cmd_ts  "ipconfig /all", sys_dir &"ipconfig_all.txt"
'cmd_ts  "%UXEXE%\uxgetcpu.exe ", sys_dir &"uxgetcpu.txt"

'''''''''''Populating ...\FILES  
'wscript.echo "Getting configuration and log files ... "
trace_log "Getting configuration and log files ... "
cp UXMGR & "\u_batch_cmd", files_dir
cmd_ "copy "& UXMGR &"\*.xml " & files_dir
cmd_ "copy "& UXMGR &"\*.bat " & files_dir
cmd_ "copy "& UXMGR &"\*.dat " & files_dir
cmd_ "copy "& UXMGR &"\*.dta " & files_dir
cmd_ "copy "& UXMGR &"\*.key " & files_dir
cmd_ "if exist " & """%ProgramFiles%\InstallShield Installation Information""" & _
 "\{357C62B2-63BD-41F6-B7A3-6D0D6C427BC3}\*.log " & _
 " copy " & """%ProgramFiles%\InstallShield Installation Information""" & _
 "\{357C62B2-63BD-41F6-B7A3-6D0D6C427BC3}\*.log " & upg_dir
cmd_ "if exist %windir%\system32\drivers\etc\* copy %windir%\system32\drivers\etc\* " & files_dir

'''''''''''Working on the LOGs
Select Case area 
    case "A" log_d=UXLAP 
    case "I" log_d=UXLIN
    case "S" log_d=UXLSI 
    case "X" log_d=UXLEX 
End Select	
'''''''''''Tag TS in log and LOG in all areas, then copy them, copy IU_PUR and IU_RTS
for ind_ =3 to 3 

	objShell.CurrentDirectory = log_dir_var(ind_,1)
	Set objExecObject = objShell.Exec("cmd /c dir /B *.log")
	Do While Not objExecObject.StdOut.AtEndOfStream
	    log_name_ = objExecObject.StdOut.ReadLine()
	    cmd_ "echo #TSP# #BEG# " & U_DIR_ANALYSIS & ">> " &  log_name_
	    cmd_ "copy " & log_name_ & " " & log_dir &   log_dir_var(ind_,0) &"_"& log_name_
	Loop
next

trace_log "Second Global System Screenshot"
sys_analysis "02G"

wscript.sleep(30000)

trace_log "Third Global System Screenshot"
sys_analysis "98G"

'''''''''''Checking the IO status

'''''''''''Getting data files
If file_level <> 0 then
	trace_log "Getting specified data files"
	trace_log "file_level is: " & file_level
	Select Case area 
	    case "A" 
		    data_d=UXDAP 
		    data_d_="UXDAP" 
	    case "I" 
		    data_d=UXDIN
		    data_d_="UXDIN"
	    case "S" 
		    data_d=UXDSI 
		    data_d_="UXDSI" 
	    case "X" 
		    data_d=UXDEX 
		    data_d_="UXDEX"
	End Select	
	If not objFSO.FolderExists(dufiles_dir & data_d_) Then
		objFSO.CreateFolder(dufiles_dir & data_d_)
	End If
	
	Select Case file_level 
	    case 1 
		    file_list= array("ftts","fttg","ftru","fuec","fsec")
	    case 2 
		    file_list= array("fupr", "frup", "fmse", "fmta", "fmca", "fmpl", "fmrl")
	    case 3 
		    file_list= array("fmsp", "fmtp", "fmer")
	    case 4 
		    file_list= array("fmsb", "fmev")
	    case 5 
		    file_list= array("fmpi", "fecl", "fecd", "fmev")
	    case 6 
		    file_list= array("fmpi", "fmsb", "fmhs", "fmph", "fmcx", "fmfu")
	    case 7 
		    file_list= array("fmpi", "fecl", "fecd", "fmev", "fmsb", "fmlp", "fmhs", "fmph")
	    case 8 
		    file_list= array("fecd", "fmev", "fmlc", "fmph", "fmsb", "fecl", "fmcx", "fmlp", "fmpi", "fmtp", "fmpf", "fmpl", "fmsp", "fmtr", "fseu", "fmfu", "fmhs")
	    case 9 
		    file_list= array("fecd", "fecl", "fmca", "fmcm", "fmcx", "fmer", "fmev", "fmfu", "fmhs", "fmlc", "fmlp", "fmpf", "fmph", "fmpi", "fmpl", "fmsb", "fmse", "fmsp", "fmta", "fmtp", "fmtr", "fppf", "frup", "fseu", "fupr", "fach", "fapg", "fapr", "fatr", "fmeq", "fmqp", "fmqr", "fmrl", "frra", "frre", "frrv", "fsec", "ftru", "fttg", "ftts", "fuec", "fbvi")
	End Select	
	'for each file_l_ in file_list
	'    wscript.echo file_l_
        'next
	for each file_l_ in file_list
	'wscript.echo data_d, UXDIR_ROOT, file_l_, dufiles_dir & data_d_ 
	    cp_gz_dta data_d, UXDIR_ROOT, file_l_, dufiles_dir & data_d_ 'cp and zip file 
        next
	cmd_ "if exist " & data_d & "\*.bvi copy " & data_d &"\*.bvi " & dufiles_dir & data_d_ 'cp the customer created views 
	cp_gz_dta UXDIR_ROOT, UXDEX, "fdob", dufiles_dir & data_d_'Copy as the distribution history
else ' when file_level=0, the dir "dufiles_dir & data_d_" is not created, cp it to dufiles_dir
	cp_gz_dta UXDIR_ROOT, UXDEX, "fdob", dufiles_dir'Copy as the distribution history
end if

'''''''''''Getting system info 
if instr(target ,"S")<>0 then
	'wscript.echo "Additional System Screenshot 1"
	trace_log "Getting Hardware and Operating System information ..."
	PC sys_dir & "hardware.txt"
	nic sys_dir & "hardware.txt"
	HOTFIX sys_dir & "hotfix.txt"

	if instr(target, "E")<>0 then
		trace_log "Getting Windows event log ..."
		get_evtlog sys_dir & "eventlog.txt"
	end if
end if
trace_log "Last Global System Screenshot"
sys_analysis "99G"

'''''''''''Creating the all_info.txt file
trace_log "Creating the all_info.txt file ..."
objShell.CurrentDirectory = U_DIR_ANALYSIS 

cmd_ts "type .\analyse.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\SYS\hardware.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "echo #REM# More information can be found in the DLS subdirectory " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\etc_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\etc_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXMGR_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXMGR_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DSL\UXEXE_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DSL\UXEXE_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "echo #REM# More information can be found in the DLS subdirectory " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXDIR_ROOT_cr_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXDIR_ROOT_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"

cmd_ts "type .\DLS\UXDEX_cr_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXDEX_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"

cmd_ts "type .\DLS\UXPEX_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXPEX_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"

cmd_ts "type .\DLS\UXLEX_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXLEX_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\U_TMP_PATH_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\U_TMP_PATH_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"

cmd_ts "echo #REM# More information can be found in the SYS subdirectory" ,  U_DIR_ANALYSIS &"\all_info.txt"

cmd_ts "type .\SYS\env.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\SYS\service_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\SYS\ps_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\SYS\netstat_a_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\SYS\netstat_na_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\SYS\netstat_ao_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"

'''''''''''Closing the ts file
obj_ts_file.Close
''''''''''' zip the trace result 
trace_log "Packing the result ... "

objShell.CurrentDirectory = U_DIR_ANALYSIS
	cmd_ UXEXE &"\zip.exe -qr DLS.zip DLS\*" 
	objFSO.DeleteFolder(".\DLS")
	cmd_ UXEXE &"\zip.exe -qr SYS.zip SYS\*" 
	objFSO.DeleteFolder(".\SYS")
	cmd_ UXEXE &"\zip.exe -qr DUFILES.zip DUFILES\*" 
	objFSO.DeleteFolder(".\DUFILES")
	'Copy the uxtrace.txt file
	cmd_ "copy " & trace_dir &"\uxtrace.txt " &  U_DIR_ANALYSIS 
	objShell.CurrentDirectory = U_ROOT_DIR & "\app\uxtrace" 
	obj_tr_file.Close
	cmd_ UXEXE &"\zip.exe -qr " & trace_name &".zip " & trace_name & "\*"
	objFSO.DeleteFolder(".\" & trace_name)
	cmd_  "move /Y " & trace_name &".zip " & U_TMP_PATH
'''''''''''Tag #END# TS into log and LOG in all areas
for ind_ =3 to 3 
	objShell.CurrentDirectory = log_dir_var(ind_,1)
	Set objExecObject = objShell.Exec("cmd /c dir /B *.log")
	Do While Not objExecObject.StdOut.AtEndOfStream
	    log_name_ = objExecObject.StdOut.ReadLine()
	    cmd_ "echo #TSP# #END# " & U_DIR_ANALYSIS & ">> " &  log_name_
	Loop
next
wscript.echo "##################################################################"
wscript.echo " "
wscript.echo "*   The Windows uxtrace procedure has successfully completed. "
wscript.echo "*   Please send the following to technical support :          "
wscript.echo "*   " & U_DIR_ANALYSIS & ".zip."
wscript.echo "*   "
wscript.echo "*   If the result is larger than 2MB, please upload it to your" 
wscript.echo "*   ftp directory on ftp.orsyp.com"
wscript.echo " "
wscript.echo "##################################################################"

if finding_tar = "yes" then
	objShell.CurrentDirectory = UXMGR
	objFSO.DeleteFolder(U_DIR_ANALYSIS)
end if

sub trace_log(msg) 'To output to both monitor and the uxtrace.txt file.
	wscript.echo msg
	obj_tr_file.writeline msg  
end sub
