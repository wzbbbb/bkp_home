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
		'Set obj_log_file = objFSO.OpenTextFile(logfile, ForAppending) ' 
		Set create_file = objFSO.OpenTextFile(logfile, ForAppending) ' read the output file
	else
		'Set obj_log_file = objFSO.CreateTextFile(logfile, False)  'creating the output file
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
			objFSO.CopyFile objFile.name, path_ &"\"&  f_name, OverwriteExisting 'False
			trace_log "file copyed: " & objFile.name
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
	cmd_ trace_dir &"\gzip -q *"& file_ & "*.dta"
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

	'Wscript.Echo "================================="
	obj_log_file.WriteLine "================================="
	'Wscript.Echo "Device ID: " & obj_disk.DeviceID 
	obj_log_file.WriteLine "Device ID: " & obj_disk.DeviceID 
	'Wscript.Echo "VolumeName: " & obj_disk.VolumeName 
	obj_log_file.WriteLine "VolumeName: " & obj_disk.VolumeName 
	'Wscript.Echo "Drive Type: " & obj_disk.DriveType
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
	date2utc = date2utc & Cstr(strBias)
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
	Set col_evt = obj_wmi.execquery("select * from Win32_NTLogEvent where TimeGenerated > '" & _
begin_date & "'")

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
	obj_ps.GetOwner strNameOfUser,  strUserDomain 

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
obj_log_file.WriteLine "#REM# Listing the creation time of the Dollar Universe "& var_name_ & " directory (sorted by file names)" 
obj_log_file.close
cmd_ts "dir /tc /q /o " & target_dir, output_
end function
function dir_ta(target_dir,var_name_, output_) 
set obj_log_file=create_file(output_)
obj_log_file.WriteLine "#REM# Listing the last access time of the Dollar Universe "& var_name_ & " directory (sorted by file names)" 
obj_log_file.close
cmd_ts "dir /ta /q /o " & target_dir, output_
end function
function dir_tw(target_dir,var_name_, output_) 
set obj_log_file=create_file(output_)
obj_log_file.WriteLine "#REM# Listing the last writen time of the Dollar Universe "& var_name_ & " directory (sorted by file names)" 
obj_log_file.close
cmd_ts "dir /tw /q /o " & target_dir, output_
end function
function dir_cacls(target_dir,var_name_, output_) 
set obj_log_file=create_file(output_)
obj_log_file.WriteLine "#REM# Listing the access right of the Dollar Universe "& var_name_ & " directory (sorted by file names)" 
obj_log_file.close
cmd_ts "cacls " & target_dir, output_
end function
sub sys_analysis(num)
'''''''''''getting the directory lists
trace_log "Getting service information ..."
'wscript.echo  sys_dir & "service_" & num & ".txt"
service sys_dir & "service_" & num & ".txt" , sys_dir & "service_ux_" & num & ".txt"
'service_ux sys_dir & "service_ux_" & num & ".txt"

trace_log "Getting process information ..."
'To generate the ps and ps_ux results
ps sys_dir & "ps_" & num & ".txt", sys_dir & "ps_ux_" & num & ".txt"
'ps_ux sys_dir & "ps_ux_" & num & ".txt"

'To generate the tasklist
cmd_ts "tasklist /v", sys_dir &"tasklist_" & num & ".txt"

trace_log "Getting directory listings ..."

dir_tc UXDIR_ROOT, "UXDIR_ROOT",dls_dir &"UXDIR_ROOT_cr_" & num & ".txt"
dir_tc UXDAP, "UXDAP",dls_dir &"UXDAP_cr_" & num & ".txt"
dir_tc UXDIN, "UXDIN",dls_dir &"UXDIN_cr_" & num & ".txt"
dir_tc UXDSI, "UXDSI",dls_dir &"UXDSI_cr_" & num & ".txt"
dir_tc UXDEX, "UXDEX",dls_dir &"UXDEX_cr_" & num & ".txt"

dir_ta UXDIR_ROOT,"UXDIR_ROOT", dls_dir &"UXDIR_ROOT_ac_" & num & ".txt"
dir_ta UXDIN, "UXDAP", dls_dir &"UXDAP_ac_" & num & ".txt"
dir_ta UXDIN, "UXDIN", dls_dir &"UXDIN_ac_" & num & ".txt"
dir_ta UXDEX, "UXDSI", dls_dir &"UXDSI_ac_" & num & ".txt"
dir_ta UXDEX, "UXDEX", dls_dir &"UXDEX_ac_" & num & ".txt"

dir_tw UXDIR_ROOT,"UXDIR_ROOT", dls_dir &"UXDIR_ROOT_wr_" & num & ".txt"
dir_tw UXDAP,"UXDAP", dls_dir &"UXDAP_wr_" & num & ".txt"
dir_tw UXDIN,"UXDIN", dls_dir &"UXDIN_wr_" & num & ".txt"
dir_tw UXDSI,"UXDSI", dls_dir &"UXDSI_wr_" & num & ".txt"
dir_tw UXDEX,"UXDEX", dls_dir &"UXDEX_wr_" & num & ".txt"

trace_log "Listing active connections ..."
cmd_ts "netstat -a" , sys_dir &"netstat_a_" & num & ".txt"
cmd_ts "netstat -na" , sys_dir &"netstat_na_" & num & ".txt"

trace_log "Getting file system information ..."
df sys_dir & "df_" & num & ".txt"

end sub
'''''''''''
''Variables
'''''''''''

win_trace_ver="Windows Uxtrace 4.0"
ver_short="v40"

'''''''''''
'objShell.Run("cmd /k call .\uxsetenv.bat "), 1, True
'''''''''''
'wscript.sleep(5000)
UXDIR_ROOT=var_def("UXDIR_ROOT")
UXEXE=var_def("UXEXE")
UXMGR=var_def("UXMGR")
UXDAP=var_def("UXDAP")
UXDIN=var_def("UXDIN")
UXDSI=var_def("UXDSI")
UXDEX=var_def("UXDEX")
UXLAP=var_def("UXLAP")
UXLIN=var_def("UXLIN")
UXLSI=var_def("UXLSI")
UXLEX=var_def("UXLEX")
UXPAP=var_def("UXPAP")
UXPIN=var_def("UXPIN")
UXPSI=var_def("UXPSI")
UXPEX=var_def("UXPEX")

U_LOG_FILE=var_def("U_LOG_FILE")
U_LIC_FILE=var_def("U_LIC_FILE")
U_MSG_FILE=var_def("U_MSG_FILE")
U_FMT_DATE=var_def("U_FMT_DATE")
U_MASK_UPR=var_def("U_MASK_UPR")
U_CDJ_DISABLE=var_def("U_CDJ_DISABLE")
U_CLUSTER=var_def("U_CLUSTER")
U_PMP_DISABLE=var_def("U_PMP_DISABLE")
U_AGTSAP_VERSION_REQUEST=var_def("U_AGTSAP_VERSION_REQUEST")
S_NOEUD=var_def("S_NOEUD")
S_ESPEXE=var_def("S_ESPEXE")
S_SOCIETE=var_def("S_SOCIETE")
COMPUTERNAME=var_def("COMPUTERNAME")
WINDIR=var_def("WINDIR")
etc=WINDIR & "\system32\drivers\etc"
trace_dir=objShell.CurrentDirectory
'trace_dir=var_def("cd")
'base_dir_var=array("UXDIR_ROOT", "UXEXE", "UXMGR")
'data_dir_var=array("UXDAP", "UXDIN","UXDSI","UXDEX")
dim log_dir_var(4, 2)
log_dir_var(0,1)=(UXLAP)
log_dir_var(1,1)=(UXLIN)
log_dir_var(2,1)=(UXLSI)
log_dir_var(3,1)=(UXLEX)
log_dir_var(0,0)=("UXLAP")
log_dir_var(1,0)=("UXLIN")
log_dir_var(2,0)=("UXLSI")
log_dir_var(3,0)=("UXLEX")

'wscript.echo "the number of arg is:",  WScript.Arguments.Count
'wscript.echo "arg0 is :", Wscript.Arguments.Item(0)

area=Wscript.Arguments.Item(0)
file_level=Wscript.Arguments.Item(1)
target=Wscript.Arguments.Item(2)


'''''''''''
''Main
'''''''''''
'''''''''''Creating the result directory
current_time=format_time(now)
trace_name=  "TMP_" & S_NOEUD & "_uxtrace_Win_" & S_SOCIETE &"_"& current_time & "_" & area & file_level & target 
U_DIR_ANALYSIS=UXMGR & "\" & trace_name
objFSO.CreateFolder(U_DIR_ANALYSIS)
Set obj_ts_file = objFSO.CreateTextFile(U_DIR_ANALYSIS & "\timestamp.txt", False)
Set obj_tr_file = objFSO.CreateTextFile(U_DIR_ANALYSIS & "\uxtrace.txt", False)
trace_log "The trace result is temporarily saved in : " & U_DIR_ANALYSIS

dls_dir=U_DIR_ANALYSIS & "\DLS\"
dqm_dir=U_DIR_ANALYSIS & "\DQM\"
dufiles_dir=U_DIR_ANALYSIS & "\DUFILES\"
files_dir=U_DIR_ANALYSIS & "\FILES\"
lst_dir=U_DIR_ANALYSIS & "\LST\"
log_dir=U_DIR_ANALYSIS & "\LOG\"
sys_dir=U_DIR_ANALYSIS & "\SYS\"

objFSO.CreateFolder(dls_dir)
objFSO.CreateFolder(dqm_dir)
objFSO.CreateFolder(dufiles_dir)
objFSO.CreateFolder(files_dir)
objFSO.CreateFolder(lst_dir)
objFSO.CreateFolder(log_dir)
objFSO.CreateFolder(sys_dir)


BEG="BEG"
'wscript.echo "First Global System Screenshot"
trace_log "First Global System Screenshot"
sys_analysis "01G"
cmd_ts "dir /tc /q /o " & etc, dls_dir &"etc_cr.txt"
cmd_ts "dir /ta /q /o " & etc, dls_dir &"etc_ac.txt"
cmd_ts "dir /tw /q /o " & etc, dls_dir &"etc_wr.txt"
cmd_ts "cacls " & etc &"\*", dls_dir &"etc_ri.txt"

' read U_TMP_PATH info from UNIVERSE.def and then get the listing.
Set objExecObject = objShell.Exec("cmd /c findstr U_TMP_PATH %UXEXE%\UNIVERSE.def") 
U_TMP_PATH = objExecObject.StdOut.ReadLine()
U_TMP_PATH = trim(U_TMP_PATH)
if len(U_TMP_PATH) < 13 then
	trace_log "U_TMP_PATH is not properly defined."
else
	U_TMP_PATH_string = Split(U_TMP_PATH , " ", -1, 1)
	On Error Resume Next
	tmp_path_ind_ = Filter(U_TMP_PATH_string, ":")
	'U_TMP_PATH = U_TMP_PATH_string(1)
	If Err <> 0 Then
		obj_tr_file.writeline Err.Number & " -- " &  Err.Description
		obj_tr_file.writeline "U_TMP_PATH is not defined in the *.def files."
	    Err.Clear
	else
		U_TMP_PATH = tmp_path_ind_(0)
		'cmd_ts "dir /tc /q /o " & U_TMP_PATH, dls_dir &"U_TMP_PATH_cr_.txt"
		dir_tc U_TMP_PATH, "U_TMP_PATH", dls_dir &"U_TMP_PATH_cr_.txt"
		dir_cacls U_TMP_PATH &"\*", "U_TMP_PATH", dls_dir &"U_TMP_PATH_ri.txt"
		'wscript.echo "U_TMP_PATH is :" , U_TMP_PATH 
	End If
	On Error GoTo 0 
end if
' read DQM info from UNIVERSE.def and then get the listing.
trace_log "Getting DQM information ..."
Set objExecObject = objShell.Exec("cmd /c findstr UXOS_DMP_QUE %UXEXE%\UNIVERSE.def") 
read_line = objExecObject.StdOut.ReadLine()
'wscript.echo "read_line is :"& read_line &"XXX"
DQM_line=trim(read_line)
'wscript.echo "DQM_line is :"& DQM_line &"XXX"
if len(DQM_line) < 15  then
	trace_log "DQM is not used or properly defined."
else
	DQM_var = Split(DQM_line , " ", -1, 1)
	On Error Resume Next
	DQM_ind_= Filter(DQM_var, "dta")
	If Err <> 0 Then
		obj_tr_file.writeline Err.Number & " -- " &  Err.Description
		obj_tr_file.writeline "DQM directory is not defined in the *.def files."
		Err.Clear
	else
		'wscript.echo "DQM_ind_(0) is : "& DQM_ind_(0)
		Set objFile = objFSO.GetFile(DQM_ind_(0))
		UXDQM=objFSO.GetParentFolderName(objFile)
		'wscript.echo "UXDQM is : "& UXDQM
		dir_tc UXDQM, "UXDQM", dqm_dir &"UXDQM_cr.txt"
		dir_cacls  UXDQM &"\*", "UXDQM", dqm_dir &"UXDQM_ri.txt"
		cmd_ "if exist "& UXDQM &"\* copy " & UXDQM &"\* " & dqm_dir
		cmd_ts  "%UXEXE%\uxshwque que=* ", dqm_dir &"\uxshwque_all.txt"
	
	End If
	On Error GoTo 0 
end if

'xxx
dir_tc UXEXE, "UXEXE",dls_dir &"UXEXE_cr.txt"
dir_tc UXMGR, "UXMGR",dls_dir &"UXMGR_cr.txt"
dir_tc UXPAP, "UXPAP",dls_dir &"UXPAP_cr.txt"
dir_tc UXPIN, "UXPIN",dls_dir &"UXPIN_cr.txt"
dir_tc UXPSI, "UXPSI",dls_dir &"UXPSI_cr.txt"
dir_tc UXPEX, "UXPEX",dls_dir &"UXPEX_cr.txt"
dir_tc UXLAP, "UXLAP",dls_dir &"UXLAP_cr.txt"
dir_tc UXLIN, "UXLIN",dls_dir &"UXLIN_cr.txt"
dir_tc UXLSI, "UXLSI",dls_dir &"UXLSI_cr.txt"
dir_tc UXLEX, "UXLEX",dls_dir &"UXLEX_cr.txt"

dir_ta UXEXE, "UXEXE", dls_dir &"UXEXE_ac.txt"
dir_ta UXMGR, "UXMGR", dls_dir &"UXMGR_ac.txt"
dir_ta UXPAP, "UXPAP", dls_dir &"UXPAP_ac.txt"
dir_ta UXPIN, "UXPIN", dls_dir &"UXPIN_ac.txt"
dir_ta UXPSI, "UXPSI", dls_dir &"UXPSI_ac.txt"
dir_ta UXPEX, "UXPEX", dls_dir &"UXPEX_ac.txt"
dir_ta UXLAP, "UXLAP", dls_dir &"UXLAP_ac.txt"
dir_ta UXLIN, "UXLIN", dls_dir &"UXLIN_ac.txt"
dir_ta UXLSI, "UXLSI", dls_dir &"UXLSI_ac.txt"
dir_ta UXLEX, "UXLEX", dls_dir &"UXLEX_ac.txt"

dir_tw UXEXE, "UXEXE", dls_dir &"UXEXE_wr.txt"
dir_tw UXMGR, "UXMGR", dls_dir &"UXMGR_wr.txt"
dir_tw UXPAP, "UXPAP", dls_dir &"UXPAP_wr.txt"
dir_tw UXPIN, "UXPIN", dls_dir &"UXPIN_wr.txt"
dir_tw UXPSI, "UXPSI", dls_dir &"UXPSI_wr.txt"
dir_tw UXPEX, "UXPEX", dls_dir &"UXPEX_wr.txt"
dir_tw UXLAP, "UXLAP", dls_dir &"UXLAP_wr.txt"
dir_tw UXLIN, "UXLIN", dls_dir &"UXLIN_wr.txt"
dir_tw UXLSI, "UXLSI", dls_dir &"UXLSI_wr.txt"
dir_tw UXLEX, "UXLEX", dls_dir &"UXLEX_wr.txt"

'wscript.echo "Getting directory/file access right ..."
trace_log "Getting directory/file access right ..."

dir_cacls UXDIR_ROOT &"\*","UXDIR_ROOT", dls_dir &"UXDIR_ROOT_ri.txt"
dir_cacls UXLEX &"\*","UXEXE", dls_dir &"UXEXE_ri.txt"
dir_cacls UXMGR &"\*","UXMGR", dls_dir &"UXMGR_ri.txt"
dir_cacls UXDAP &"\*","UXDAP", dls_dir &"UXDAP_ri.txt"
dir_cacls UXDIN &"\*","UXDIN", dls_dir &"UXDIN_ri.txt"
dir_cacls UXDSI &"\*","UXDSI", dls_dir &"UXDSI_ri.txt"
dir_cacls UXDEX &"\*","UXDEX", dls_dir &"UXDEX_ri.txt"
dir_cacls UXPAP &"\*","UXPAP", dls_dir &"UXPAP_ri.txt"
dir_cacls UXPIN &"\*","UXPIN", dls_dir &"UXPIN_ri.txt"
dir_cacls UXPSI &"\*","UXPSI", dls_dir &"UXPSI_ri.txt"
dir_cacls UXPEX &"\*","UXPEX", dls_dir &"UXPEX_ri.txt"
dir_cacls UXLAP &"\*","UXLAP", dls_dir &"UXLAP_ri.txt"
dir_cacls UXLIN &"\*","UXLIN", dls_dir &"UXLIN_ri.txt"
dir_cacls UXLSI &"\*","UXLSI", dls_dir &"UXLSI_ri.txt"
dir_cacls UXLEX &"\*","UXLEX", dls_dir &"UXLEX_ri.txt"


'''''''''''analyse.txt
'wscript.echo "Populating the analyse.txt ... "
trace_log "Populating the analyse.txt ... "
OS U_DIR_ANALYSIS & "\analyse.txt"
cmd_ts  "hostname ", U_DIR_ANALYSIS &"\analyse.txt"
cmd_ts UXEXE & "\uxversion ", U_DIR_ANALYSIS &"\analyse.txt"
df U_DIR_ANALYSIS & "\analyse.txt"

'''''''''''env & id
'Set obj_ana_file = objFSO.CreateTextFile(U_DIR_ANALYSIS &"\analyse.txt", False)  
'obj_ana_file.close
cmd_ts "set" , sys_dir &"env.txt"
'objShell.CurrentDirectory = UXMGR
cmd_ts trace_dir & "\ismember.exe -l", sys_dir &"groups.txt"

'''''''''''Populating ...\FILES  
'wscript.echo "Getting configuration and log files ... "
trace_log "Getting configuration and log files ... "
cp UXMGR & "\uxsetenv.bat", files_dir
cmd_ "if exist %uxmgr%\uxstartup* copy %uxmgr%\uxstartup* " & files_dir
cp UXMGR & "\u_batch", files_dir
cmd_ "if exist %uxmgr%\uxsrsrv* copy %uxmgr%\uxsrsrv* " & files_dir
cmd_ "if exist %UXMGR%\uxlnm*.dat copy %uxmgr%\uxlnm*.dat " & files_dir
cmd_ "if exist %uxmgr%\U_POST_UPROC.* copy %uxmgr%\U_POST_UPROC.* " & files_dir
cmd_ "if exist %uxmgr%\U_ANTE_UPROC.* copy %uxmgr%\U_ANTE_UPROC.* " & files_dir
cmd_ "if exist %UXMGR%\u_fail01*.* copy %uxmgr%\u_fail01*.* " & files_dir
cp UXMGR & "\useralias.txt", files_dir
cp UXMGR & "\security.txt", files_dir
cp UXEXE & "\UNIVERSE.def", files_dir
cp UXEXE & "\" & S_SOCIETE  & ".def", files_dir
cp UXEXE & "\u_batch*", files_dir
cmd_ "if exist %uxexe%\u_batch.* copy %uxexe%\u_batch.* " & files_dir
cmd_ "if exist %windir%\system32\drivers\etc\* copy %windir%\system32\drivers\etc\* " & files_dir

'''''''''''Working on the LOGs
Select Case area 
    case "A" log_d=UXLAP 
    case "I" log_d=UXLIN
    case "S" log_d=UXLSI 
    case "X" log_d=UXLEX 
End Select	
'''''''''''Tag TS in log and LOG in all areas, then copy them, copy IU_PUR and IU_RTS
for ind_ =0 to 3 
	Set FileList = obj_cimv2.ExecQuery _
	 ("ASSOCIATORS OF {Win32_Directory.Name='"& log_dir_var(ind_,1) &"'} Where " _
	 & "ResultClass = CIM_DataFile")
	'wscript.echo log_dir_var(ind_,0) & " is: " & log_dir_var(ind_,1)
	trace_log log_dir_var(ind_,0) & " is: " & log_dir_var(ind_,1)
	For Each objFile In FileList
		Set obj_get_ = objFSO.GetFile(objFile.name)
		f_name=objFSO.GetFileName(obj_get_) 
	 If objFile.Extension = "log" or objFile.Extension = "LOG" Then
		'wscript.echo objFile.name
		'trace_log objFile.name

		On Error Resume Next
		Set obj_wri_ = objFSO.OpenTextFile(objFile.name, ForAppending)  
		If Err <> 0 Then
			obj_tr_file.writeline Err.Number & " -- " &  Err.Description
			obj_tr_file.writeline "Could not attach time stamp in" & objFile.name 
		    Err.Clear
		else
			obj_wri_.writeline "#TSP# #BEG# " & U_DIR_ANALYSIS
			obj_wri_.close
		End If
		On Error GoTo 0 
		objFSO.CopyFile objFile.name, log_dir &  log_dir_var(ind_,0) &"_"& f_name
	elseif instr(f_name, "IU_RTS")<>0 or instr(f_name, "IU_PUR")<>0 then
		objFSO.CopyFile objFile.name, log_dir &  log_dir_var(ind_,0) &"_"& f_name
	 End If
	Next
next

trace_log "Second Global System Screenshot"
sys_analysis "02G"

wscript.sleep(30000)

trace_log "Third Global System Screenshot"
sys_analysis "98G"

'''''''''''Checking the IO status
dim io_status(4)
io_ind_=0
areas_list=array("APP", "INT", "SIM", "EXP")
for each io_area_ in areas_list 
	Set objExecObject = objShell.Exec("cmd /c " & UXEXE & "\uxlst atm lan " & io_area_ & "")
	Do While Not objExecObject.StdOut.AtEndOfStream
	    strText = objExecObject.StdOut.ReadLine()
	    If Instr(strText, "Pid") > 0 Then
		io_status(io_ind_) = "Running"
		Exit Do
	    End If
	Loop
	io_ind_ = io_ind_ + 1
next


'APP, INT, SIM, EXP
'ser_io_a=S_SOCIETE & "_IO_A"
'ser_io_i=S_SOCIETE & "_IO_I"
'ser_io_s=S_SOCIETE & "_IO_S"
'ser_io_x=S_SOCIETE & "_IO_X"
''wscript.echo "ser_io_s is:" , ser_io_s
'Set col_services = obj_wmi.execquery("select Name, State from Win32_Service where Name='" & ser_io_a & "' or Name='" & ser_io_i & "' or Name='" & ser_io_s & "' or Name='" & ser_io_x & "'" )
'For Each obj_service In col_services
'	Wscript.Echo "=================================" & vbCrLf & _
'	"Name: " & obj_service.Name & vbCrLf & _
'	"State: " & obj_service.State  
'	if obj_service.Name = ser_io_a then
'		io_status(0)=obj_service.State
'	elseif  obj_service.Name = ser_io_i then
'		io_status(1)=obj_service.State
'	elseif obj_service.Name = ser_io_s then
'		io_status(2)=obj_service.State
'	elseif obj_service.Name = ser_io_x then
'		io_status(3)=obj_service.State
'	end if
'Next


'Set objExecObject = objShell.Exec("cmd /c mkdir " & U_DIR_ANALYSIS & "")
'var_def = objExecObject.StdOut.ReadLine()
'objShell.Run("cmd /c mkdir " & U_DIR_ANALYSIS & "\DLS"), 1, True

'Set objFile = objFSO.CreateTextFile("C:\FSO\ScriptLog.txt", False)
'Set objFile = objFSO.CreateTextFile(U_DIR_ANALYSIS & "\timestamp.txt", False)
'Set obj_ts_file = objFSO.CreateTextFile(U_DIR_ANALYSIS & "\timestamp.txt", False)
'objFile.Close
'Set obj_ts_file = objFSO.OpenTextFile(U_DIR_ANALYSIS & "\timestamp.txt", ForAppending)

'''''''''''$U admin listing
'wscript.echo "Getting Dollar Universe Admin information ... "
trace_log "Getting Dollar Universe Admin information ... "
if io_status(3) = "Running" then
cmd_ts UXEXE & "\uxshw mu mu=*", lst_dir & "admin_mu_shw.txt" 
cmd_ts UXEXE & "\uxlst mu", lst_dir & "admin_mu_lst.txt" 
cmd_ts UXEXE & "\uxlst mut", lst_dir & "admin_mut_lst.txt" 
cmd_ts UXEXE & "\uxlst hdp", lst_dir & "admin_hdp_lst.txt" 
cmd_ts UXEXE & "\uxlst appl", lst_dir & "admin_appl_lst.txt" 
cmd_ts UXEXE & "\uxshw node tnode=*", lst_dir & "admin_node_shw.txt" 
cmd_ts UXEXE & "\uxlst node", lst_dir & "admin_node_lst.txt" 
cmd_ts UXEXE & "\uxshw user user=*", lst_dir & "admin_user_shw.txt" 
cmd_ts UXEXE & "\uxlst user", lst_dir & "admin_user_shw.txt" 
cmd_ts UXEXE & "\uxlst prof prof=*", lst_dir & "admin_profile_lst.txt" 
cmd_ts UXEXE & "\lstproxy", lst_dir & "admin_lstproxy.txt" 
end if
'''''''''''$U all started areas listing

'for i=lbound(io_status) to ubound(io_status)
trace_log "Getting listing from all started areas ..."
for array_ind=0 to 3
	if io_status(array_ind) = "Running" then
		Select Case array_ind
		    case "0" 
			    area_="APP"
			    area_s="A"
			    data_d=UXDAP 
			    data_d_="UXDAP"
		    case "1" 
			    area_="INT"
			    area_s="I"
			    data_d=UXDIN
			    data_d_="UXDIN"
		    case "2" 
			    area_="SIM"
			    area_s="S"
			    data_d=UXDSI 
			    data_d_="UXDSI" 
		    case "3" 
			    area_="EXP"
			    area_s="X"
			    data_d=UXDEX 
			    data_d_="UXDEX" 
		End Select	

		cmd_ts UXEXE & "\uxgetnla "& S_SOCIETE &" "& area_s &" "& S_NOEUD, lst_dir & area_ &"_uxgetnla.txt"
		cmd_ts UXEXE & "\uxlst atm "& area_ , lst_dir & area_ & "_atm_lst.txt"
		cmd_ts UXEXE & "\uxlst upr "& area_ , lst_dir & area_ & "_upr_lst.txt"
		cmd_ts UXEXE & "\uxlst ses "& area_ , lst_dir & area_ & "_ses_lst.txt"
		cmd_ts UXEXE & "\uxlst tsk full "& area_ , lst_dir & area_ & "_tsk_lst.txt"
		'testing the 6 date files,if > 10M, create a dir in DUFILES 
		big_datafile="no"
		common_list=array("fmcx","fmfu","fmlp","fmsb","fmsp","fmtp")
		'label1
		hs_list=array("fmcx","fmfu","fmlp","fmsb","fmsp","fmtp","fmhs","fmph")

		'wscript.echo "area is: " & area
		trace_log "Concerned area is: " & area
		'wscript.echo "area_s is: " & area_s
		trace_log "Working in area: " & area_s
		if target <> "S" then
		if area =  area_s then 'For the area concerned
		trace_log "Getting specific infomation in the concerned area ..."
		cmd_ts UXEXE & "\uxshw upr upr=* vupr=* "& area_ , lst_dir & area_ & "_upr_shw.txt"
		cmd_ts UXEXE & "\uxshw ses ses=* vses=* lnk "& area_ , lst_dir & area_ & "_ses_shw.txt"
		cmd_ts UXEXE & "\uxshw tsk upr=* vupr=* ses=* vses=* mu=* "& area_ , lst_dir & area_ &"_tsk_shw.txt"
		cmd_ts UXEXE & "\uxlst res "& area_ , lst_dir & area_ &"_res_lst.txt"
		cmd_ts UXEXE & "\uxshw res res=* "& area_ , lst_dir & area_ &"_res_shw.txt"
		for each file_ in hs_list 'test 8 files size
			file_size_=get_file_size(file_, data_d )
			'wscript.echo "file name is:", file_
			trace_log "Testing file:"& file_
			if file_size_ >=data_file_limit then
				big_datafile="yes"
				If not objFSO.FolderExists(dufiles_dir & data_d_) Then
					objFSO.CreateFolder(dufiles_dir & data_d_)
				End If
				exit for
			end if 
		next' for each file_in hs_list 
		if big_datafile="no" then
			cmd_ts UXEXE & "\uxlst fla full "& area_ , lst_dir & area_ & "_fla_lst.txt"
			cmd_ts UXEXE & "\uxlst ctl full "& area_ , lst_dir & area_ & "_ctl_lst.txt"
			cmd_ts UXEXE & "\uxlst ctl full upr=IU_PUR "& area_ , lst_dir & area_ & "_ctl_lst_IU_PUR.txt"
			cmd_ts UXEXE & "\uxlst evt full "& area_ , lst_dir & area_ & "_evt_lst.txt"
			'cmd_ts UXEXE & "\uxlst ctl log "& area_ , lst_dir & area_ & "_ctl_log.txt"
			cmd_ts UXEXE & "\uxlst ctl hst "& area_ , lst_dir & area_ & "_ctl_hst.txt"
		else 
			for each file_ in hs_list 'copy the data files
			cp_gz_dta data_d, UXDIR_ROOT, file_, dufiles_dir & data_d_ 
			next
			cmd_ts "echo One of the data files is larger then "& data_file_limit &". The data files are copied instead." , lst_dir & area_ & "_fla_lst.txt"
			cmd_ts "echo One of the data files is larger then "& data_file_limit &". The data files are copied instead." , lst_dir & area_ & "_ctl_lst.txt"
			cmd_ts "echo One of the data files is larger then "& data_file_limit &". The data files are copied instead." , lst_dir & area_ & "_evt_lst.txt"
			cmd_ts "echo One of the data files is larger then "& data_file_limit &". The data files are copied instead." , lst_dir & area_ & "_ctl_log.txt"
			cmd_ts "echo One of the data files is larger then "& data_file_limit &". The data files are copied instead." , lst_dir & area_ & "_ctl_hst.txt"

		end if 'big_datafile

		else ' not concerned area
		for each file_ in common_list
			'wscript.echo "file name is:", file_
			trace_log "Testing file: "& file_
			file_size_=get_file_size(file_, data_d )
			if file_size_ >=data_file_limit then
				big_datafile="yes"
				If not objFSO.FolderExists(dufiles_dir & data_d_) Then
					objFSO.CreateFolder(dufiles_dir & data_d_)
				End If
				exit for
			end if 
		next' for each file_in common_list 
		if big_datafile="no" then
		cmd_ts UXEXE & "\uxlst fla full "& area_ , lst_dir & area_ & "_fla_lst.txt"
		cmd_ts UXEXE & "\uxlst ctl full "& area_ , lst_dir & area_ & "_ctl_lst.txt"
		cmd_ts UXEXE & "\uxlst evt full "& area_ , lst_dir & area_ & "_evt_lst.txt"
		else
			for each file_ in common_list 'copy the data files
				cp_gz_dta data_d, UXDIR_ROOT, file_, dufiles_dir & data_d_ 
			next
			cmd_ts "echo One of the data files is larger then "& data_file_limit &". The data files are copied instead." , lst_dir & area_ & "_fla_lst.txt"
			cmd_ts "echo One of the data files is larger then "& data_file_limit &". The data files are copied instead.", lst_dir & area_ & "_ctl_lst.txt"
			cmd_ts "echo One of the data files is larger then "& data_file_limit &". The data files are copied instead.", lst_dir & area_ & "_evt_lst.txt"

		end if 
	end if 'concerned area or not
	end if  ' if target <> "S"
	end if 'The area is up or not
next


'''''''''''Getting system info 

if target<>"C" then

'wscript.echo "Additional System Screenshot 1"
'sys_analysis "11"

trace_log "Getting Hardware and Operating System information ..."
PC sys_dir & "hardware.txt"
'OS sys_dir & "system.txt"
nic sys_dir & "hardware.txt"
HOTFIX sys_dir & "hotfix.txt"

trace_log "Getting Dollar Universe registry ..."
list_reg sys_dir & "registry.txt"

trace_log "Getting Windows event log ..."
get_evtlog sys_dir & "eventlog.txt"

'wscript.echo "Additional System Screenshot 2"
'sys_analysis "12"

'wscript.sleep(30000)

'wscript.echo "Additional System Screenshot 3"
'sys_analysis "13"

end if

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
		    file_list= array("fecd", "fecl", "fmca", "fmcm", "fmcx", "fmer", "fmev", "fmfu", "fmhs", "fmlc", "fmlp", "fmpf", "fmph", "fmpi", "fmpl", "fmsb", "fmse", "fmsp", "fmta", "fmtp", "fmtr", "fppf", "frup", "fseu", "fupr", "fdob", "fach", "fapg", "fapr", "fatr", "fmeq", "fmqp", "fmqr", "fmrl", "frra", "frre", "frrv", "fsec", "ftru", "fttg", "ftts", "fuec")
	End Select	
	'for each file_l_ in file_list
	'    wscript.echo file_l_
        'next
	for each file_l_ in file_list
	'wscript.echo data_d, UXDIR_ROOT, file_l_, dufiles_dir & data_d_ 
	    cp_gz_dta data_d, UXDIR_ROOT, file_l_, dufiles_dir & data_d_ 'cp and zip file 
        next
	cp_gz_dta UXDIR_ROOT, UXDEX, "fdob", dufiles_dir & data_d_'Copy as the distribution history
else ' when file_level=0, the dir "dufiles_dir & data_d_" is not created, cp it to dufiles_dir
	cp_gz_dta UXDIR_ROOT, UXDEX, "fdob", dufiles_dir'Copy as the distribution history
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
cmd_ts "echo #REM# More information can be found in the DQM subdirectory " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DQM\UXDQM_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DQM\UXDQM_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "echo #REM# More information can be found in the DLS subdirectory " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXDIR_ROOT_cr_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXDIR_ROOT_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"

cmd_ts "type .\DLS\UXDEX_cr_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXDEX_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXDSI_cr_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXDSI_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXDIN_cr_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXDIN_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXDAP_cr_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXDAP_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"

cmd_ts "type .\DLS\UXPEX_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXPEX_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXPSI_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXPSI_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXPIN_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXPIN_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXPAP_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXPAP_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"


cmd_ts "type .\DLS\UXLEX_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXLEX_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXLSI_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXLSI_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXLIN_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXLIN_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXLAP_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\UXLAP_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\U_TMP_PATH_cr.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\DLS\U_TMP_PATH_ri.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"

cmd_ts "echo #REM# More information can be found in the SYS subdirectory" ,  U_DIR_ANALYSIS &"\all_info.txt"

cmd_ts "type .\SYS\env.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\SYS\service_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\SYS\ps_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\SYS\netstat_a_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"
cmd_ts "type .\SYS\netstat_na_01G.txt " ,  U_DIR_ANALYSIS &"\all_info.txt"

'The all_info.txt is not zipped
'objShell.CurrentDirectory = trace_dir 
'cmd_ trace_dir &"\gzip " & U_DIR_ANALYSIS &"\all_info.txt"
'''''''''''Closing the ts file
obj_ts_file.Close
'''''''''''tar and zip the trace result 
trace_log "Packing the result ... "
obj_tr_file.Close
'Set objShell = WScript.CreateObject("WScript.Shell")
'wscript.echo "trace_dir is:" & trace_dir
'Wscript.Echo " Working Directory:" & objShell.CurrentDirectory
'Wscript.Echo "trace_name is: " & trace_name

objShell.CurrentDirectory = U_DIR_ANALYSIS
'DLS, DQM, SYS, LST, DUFILES
cmd_ trace_dir &"\tar cvf DLS.tar DLS" 
objFSO.DeleteFolder(".\DLS")
cmd_ trace_dir &"\tar cvf DQM.tar DQM"
objFSO.DeleteFolder(".\DQM")
cmd_ trace_dir &"\tar cvf SYS.tar SYS" 
objFSO.DeleteFolder(".\SYS")
cmd_ trace_dir &"\tar cvf LST.tar LST"
objFSO.DeleteFolder(".\LST")
cmd_ trace_dir &"\tar cvf DUFILES.tar DUFILES" 
objFSO.DeleteFolder(".\DUFILES")

'Copy the uxtrace.txt file
cmd_ "copy " & trace_dir &"\uxtrace.txt " &  U_DIR_ANALYSIS 

objShell.CurrentDirectory = UXMGR
cmd_ trace_dir &"\tar cvf " & trace_name &".tar " & trace_name
cmd_ trace_dir &"\gzip " & trace_name &".tar"
'''''''''''Tag #END# TS into log and LOG in all areas
for ind_ =0 to 3 
	Set FileList = obj_cimv2.ExecQuery _
	 ("ASSOCIATORS OF {Win32_Directory.Name='"& log_dir_var(ind_,1) &"'} Where " _
	 & "ResultClass = CIM_DataFile")
	'wscript.echo log_dir_var(ind_,0) & " is: " & log_dir_var(ind_,1)
	For Each objFile In FileList
	 If objFile.Extension = "log" or objFile.Extension = "LOG" Then
		'wscript.echo "writing #END# in " & objFile.name
		On Error Resume Next
		Set obj_wri_ = objFSO.OpenTextFile(objFile.name, ForAppending)  
		If Err <> 0 Then
		    'trace_log Err.Number & " -- " &  Err.Description 
		    'trace_log "Could not attach END time stamp in " & objFile.name 
		    Err.Clear
		else
			obj_wri_.writeline "#TSP# #END# " & U_DIR_ANALYSIS
			obj_wri_.close
		End If
		On Error GoTo 0 
	 End If
	Next
next

wscript.echo "##################################################################"
wscript.echo "*** The Windows uxtrace procedure has successfully completed. "
wscript.echo "*** Please send the following to technical support :          "
wscript.echo "*** " & U_DIR_ANALYSIS & ".tar.gz"
wscript.echo "*** If the result is larger than 2MB, please upload it to your" 
wscript.echo "*** ftp directory on ftp.orsyp.com"
wscript.echo "##################################################################"

objShell.CurrentDirectory = UXMGR
objFSO.DeleteFolder(U_DIR_ANALYSIS)

sub trace_log(msg) 'To output to both monitor and the uxtrace.txt file.
	wscript.echo msg
	obj_tr_file.writeline msg  
end sub

'On Error Resume Next
'objFSO.DeleteFile(trace_dir & "\uxtrace.txt")
'objShell.Run("cmd /c del "& trace_dir & "\uxtrace.txt"), 0, False
'If Err <> 0 Then
'    Wscript.Echo Err.Number & " -- " &  Err.Description
'    Wscript.Echo "Du to security control, the temporary uxtrace log: " & trace_dir & "\uxtrace.txt could not be deleted. Please delete it manually."
'    Err.Clear
'End If
