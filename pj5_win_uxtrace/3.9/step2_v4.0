'''''''''''
''Constant
'''''''''''
const mb_factor = 1048576
days_of_evt = 7
Const HKEY_LOCAL_MACHINE = &H80000002
const HKEY_CURRENT_USER  = &H80000001
strKeyPath = "SOFTWARE\ORSYP S.A."
'''''''''''
''Build conneciton to WMI
'''''''''''
strComputer = "."
Set obj_wmi = GetObject("winmgmts:\\" & strComputer)

'Set obj_wmi = GetObject("winmgmts:" _
' & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set obj_cimv2 = GetObject("winmgmts:" _
 & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set objReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & _
 strComputer & "\root\default:StdRegProv")

'''''''''''
''Function
'''''''''''
function df
'set col_disk=obj_wmi.execquery("select DeviceID, DriveType, FileSystem, " &_
set col_disk=obj_cimv2.execquery("select DeviceID, DriveType, FileSystem, " &_
"FreeSpace, Name, ProviderName, size, VolumeName from Win32_LogicalDisk")
for each obj_disk in col_disk
	Wscript.Echo "================================="
	Wscript.Echo "Device ID: " & obj_disk.DeviceID 
	Wscript.Echo "VolumeName: " & obj_disk.VolumeName 
	'Wscript.Echo "Drive Type: " & obj_disk.DriveType
	Select Case obj_disk.DriveType
		 Case 1
		 Wscript.Echo "No root directory."
		 Case 2
		 Wscript.Echo "DriveType: Removable drive."
		 Case 3
		 Wscript.Echo "DriveType: Local hard disk."
		 Case 4
		 Wscript.Echo "DriveType: Network disk." 
		 Case 5
		 Wscript.Echo "DriveType: Compact disk." 
		 Case 6
		 Wscript.Echo "DriveType: RAM disk." 
	Case Else
	Wscript.Echo "Drive type could not be determined."
	End Select
	Wscript.Echo "FileSystem: " & obj_disk.FileSystem 
	Wscript.Echo "FreeSpace: " & int(obj_disk.FreeSpace / mb_factor) & " MB"
	'Wscript.Echo "Name: " & obj_disk.Name 
	Wscript.Echo "ProviderName: " & obj_disk.ProviderName 
	Wscript.Echo "Size: " & int(obj_disk.Size / mb_factor) & " MB"
next

end function

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

Sub get_evtlog
begin_date = date2utc(dateadd("d", -days_of_evt, date))
Set col_evt = obj_wmi.execquery("select * from Win32_NTLogEvent where TimeGenerated > '" & _
 begin_date & "'")
For Each obj_evt In col_evt
	 Wscript.Echo "Log File: " & obj_evt.LogFile & vbCrLf & _
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
Next
End Sub

sub HOTFIX
Set col_fix = obj_cimv2.ExecQuery _
 ("SELECT Description,  FixComments, HotFixID, ServicePackInEffect " &_ 
 "FROM Win32_QuickFixEngineering")
For Each obj_fix in col_fix
	 Wscript.Echo "=================================" 
	 Wscript.Echo "Description: " & obj_fix.Description
	 Wscript.Echo "FixComments: " & obj_fix.FixComments
	 Wscript.Echo "Hot Fix ID: " & obj_fix.HotFixID
	 Wscript.Echo "ServicePackInEffect: " & obj_fix.ServicePackInEffect
Next

end sub

sub list_reg
	wscript.echo "===========HKEY_LOCAL_MACHINE\"& strKeyPath & "==========="
	shw_sub_key HKEY_LOCAL_MACHINE, strKeyPath
	wscript.echo "===========HKEY_CURRENT_USER\"& strKeyPath & "==========="
	shw_sub_key HKEY_CURRENT_USER, strKeyPath
end sub

sub shw_sub_key(hkey, KeyPath)
	ret_cod = objReg.EnumKey(hkey, KeyPath, arrSubKeys)
	if ret_cod = 0  and IsArray(arrSubKeys) then 
	For Each Subkey in arrSubKeys
		 Wscript.Echo KeyPath & "\" & Subkey
		 shw_sub_key hkey, KeyPath & "\" & Subkey
	Next
	end if 
end sub

sub nic 
	Set col_pc = obj_wmi.execquery("select AdapterType, "&_
	"Caption, MACAddress, Manufacturer, ProductName  " &_
	"from Win32_NetworkAdapter where  AdapterType = ""Ethernet 802.3"" ")
For Each obj_pc In col_pc
 Wscript.Echo "============================================" & vbCrLf & _
 "AdapterType: " & obj_pc.AdapterType & vbCrLf & _
 "Caption: " & obj_pc.Caption & vbCrLf & _
 "MACAddress: " & obj_pc.MACAddress & vbCrLf & _
 "Manufacturer: " & obj_pc.Manufacturer & vbCrLf & _
 "ProductName: " & obj_pc.ProductName 
Next
end sub

Function utc2date(dtmInstallDate)
	 utc2date = CDate(Mid(dtmInstallDate, 5, 2) & "/" & _
	 Mid(dtmInstallDate, 7, 2) & "/" & Left(dtmInstallDate, 4) _
	 & " " & Mid (dtmInstallDate, 9, 2) & ":" & _
	 Mid(dtmInstallDate, 11, 2) & ":" & Mid(dtmInstallDate, _
	 13, 2))
End Function

sub OS
	Set col_os = obj_wmi.execquery("select Caption, "&_
	"CurrentTimeZone, FreePhysicalMemory, FreeSpaceInPagingFiles, "&_
	"FreeVirtualMemory, InstallDate, LastBootUpTime, Locale, "&_
	"NumberOfUsers, OSLanguage, RegisteredUser, ServicePackMajorVersion, "&_
	"ServicePackMinorVersion, SystemDirectory, TotalVirtualMemorySize," &_
	"Version from Win32_OperatingSystem")
For Each obj_os In col_os
 Wscript.Echo "============================================" & vbCrLf & _
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
end sub
sub PC 
	Set col_pc = obj_wmi.execquery("select Description, "&_
	"Manufacturer, Model, NumberOfProcessors, PrimaryOwnerName, SystemType,"&_
	"TotalPhysicalMemory from Win32_ComputerSystem")
For Each obj_pc In col_pc
 Wscript.Echo "============================================" & vbCrLf & _
 "Description: " & obj_pc.Description & vbCrLf & _
 "Manufacturer: " & obj_pc.Manufacturer & vbCrLf & _
 "Model: " & obj_pc.Model & vbCrLf & _
 "NumberOfProcessors: " & obj_pc.NumberOfProcessors & vbCrLf & _
 "PrimaryOwnerName: " & obj_pc.PrimaryOwnerName & vbCrLf & _
 "SystemType: " & obj_pc.SystemType & vbCrLf & _
 "TotalPhysicalMemory: " & obj_pc.TotalPhysicalMemory 
Next
end sub

Function utc2date(date_)
	 utc2date = CDate(Mid(date_, 5, 2) & "/" & _
	 Mid(date_, 7, 2) & "/" & Left(date_, 4) _
	 & " " & Mid (date_, 9, 2) & ":" & _
	 Mid(date_, 11, 2) & ":" & Mid(date_, _
	 13, 2))
End Function

sub ps
Set col_ps_lst = obj_cimv2.ExecQuery _
 ("SELECT Name, ProcessID, ParentProcessID, Priority, CreationDate, " & _ 
 "ExecutablePath, ThreadCount, PageFileUsage, PageFaults, WorkingSetSize FROM Win32_Process")
For Each obj_ps in col_ps_lst
	colProperties = obj_ps.GetOwner(strNameOfUser,strUserDomain)
	wscript.echo "================================="
	Wscript.Echo "Process: " & obj_ps.Name
	Wscript.Echo "Process owner: " & strUserDomain & "\" & strNameOfUser 
	Wscript.Echo "Process ID: " & obj_ps.ProcessID
	Wscript.Echo "Parent PID: " & obj_ps.ParentProcessID
	Wscript.Echo "Priority: " & obj_ps.Priority
	if isnull(obj_ps.CreationDate)  then
		Wscript.Echo "Creation Date: not defined" 
	else
		Wscript.Echo "Creation Date: " & utc2date(obj_ps.CreationDate)
	end if
	Wscript.Echo "Path: " & obj_ps.ExecutablePath
	Wscript.Echo "Thread Count: " & obj_ps.ThreadCount
	Wscript.Echo "Page File Size: " & obj_ps.PageFileUsage
	Wscript.Echo "Page Faults: " & obj_ps.PageFaults
	Wscript.Echo "Working Set Size: " & obj_ps.WorkingSetSize
Next
end sub

sub service
Set col_services = obj_wmi.execquery("select Name, DisplayName, " & _
 "Description, DesktopInteract, InstallDate, PathName, ProcessID, " & _
 " StartMode, State, StartName, Status from Win32_Service")
For Each obj_service In col_services
	 Wscript.Echo "=================================" & vbCrLf & _
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
	 'if isnull(obj_service.InstallDate) then
 	'	 Wscript.Echo "InstallDate: not defined "
	' else
	'	 Wscript.Echo "InstallDate: " & obj_service.InstallDate 
	' end if
Next
end sub
'''''''''''
''Main
'''''''''''
Select Case wscript.arguments.item(0)
    case "df" df
    case "get_evtlog" get_evtlog
    case "HOTFIX" HOTFIX
    case "list_reg" list_reg
    case "nic" nic
    case "OS" OS
    case "PC" PC
    case "ps" ps
    case "service" service
End Select
