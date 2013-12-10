strComputer = "."
Set obj_wmi = GetObject("winmgmts:\\" & strComputer)
Set obj_cimv2 = GetObject("winmgmts:" _
 & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

On Error Resume Next
WScript.Echo "WSH Version: " & WScript.Version
Wscript.Echo "VBScript Version: " & ScriptEngineMajorVersion _
    & "." & ScriptEngineMinorVersion
strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer _
        & "\root\cimv2")
Set colWMISettings = objWMIService.ExecQuery _
    ("Select * from Win32_WMISetting")
For Each objWMISetting in colWMISettings
    Wscript.Echo "WMI Version: " & objWMISetting.BuildVersion
Next
Set objShell = CreateObject("WScript.Shell")
strAdsiVersion = objShell.RegRead _
("HKLM\SOFTWARE\Microsoft\" &_
"Active Setup\Installed Components\" &_
"{E92B03AB-B707-11d2-9CBD-0000F87A369E}\Version")
If strAdsiVersion = vbEmpty Then
    strAdsiVersion = objShell.RegRead _
    ("HKLM\SOFTWARE\Microsoft\ADs\Providers\LDAP\")
    If strAdsiVersion = vbEmpty Then
        strAdsiVersion = "ADSI is not installed."
    Else
        strAdsiVersion = "2.0"
    End If
End If
WScript.Echo "ADSI Version: " & strAdsiVersion

Function utc2date(dtmInstallDate)
	 utc2date = CDate(Mid(dtmInstallDate, 5, 2) & "/" & _
	 Mid(dtmInstallDate, 7, 2) & "/" & Left(dtmInstallDate, 4) _
	 & " " & Mid (dtmInstallDate, 9, 2) & ":" & _
	 Mid(dtmInstallDate, 11, 2) & ":" & Mid(dtmInstallDate, _
	 13, 2))
End Function
sub OS()
	Set col_os = obj_wmi.execquery("select Caption, "&_
	"CurrentTimeZone, FreePhysicalMemory, FreeSpaceInPagingFiles, "&_
	"FreeVirtualMemory, InstallDate, LastBootUpTime, Locale, "&_
	"NumberOfUsers, OSLanguage, RegisteredUser, ServicePackMajorVersion, "&_
	"ServicePackMinorVersion, SystemDirectory, TotalVirtualMemorySize," &_
	"Version from Win32_OperatingSystem")
For Each obj_os In col_os
WScript.Echo "============================================" & vbCrLf & _
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
sub PC()
	Set col_pc = obj_wmi.execquery("select Description, "&_
	"Manufacturer, Model, NumberOfProcessors, PrimaryOwnerName, SystemType,"&_
	"TotalPhysicalMemory from Win32_ComputerSystem")
For Each obj_pc In col_pc
 WScript.Echo "============================================" & vbCrLf & _
 "Description: " & obj_pc.Description & vbCrLf & _
 "Manufacturer: " & obj_pc.Manufacturer & vbCrLf & _
 "Model: " & obj_pc.Model & vbCrLf & _
 "NumberOfProcessors: " & obj_pc.NumberOfProcessors & vbCrLf & _
 "PrimaryOwnerName: " & obj_pc.PrimaryOwnerName & vbCrLf & _
 "SystemType: " & obj_pc.SystemType & vbCrLf & _
 "TotalPhysicalMemory: " & obj_pc.TotalPhysicalMemory 
Next
end sub

sub HOTFIX()
Set col_fix = obj_cimv2.ExecQuery _
 ("SELECT Description,  FixComments, HotFixID, ServicePackInEffect " &_ 
 "FROM Win32_QuickFixEngineering")
For Each obj_fix in col_fix
	WScript.Echo "=================================" 
	WScript.Echo  "Description: " & obj_fix.Description
	WScript.Echo "FixComments: " & obj_fix.FixComments
	WScript.Echo "Hot Fix ID: " & obj_fix.HotFixID
	WScript.Echo "ServicePackInEffect: " & obj_fix.ServicePackInEffect
Next
end sub
sub nic() 
	Set col_pc = obj_wmi.execquery("select AdapterType, "&_
	"Caption, MACAddress, Manufacturer, ProductName  " &_
	"from Win32_NetworkAdapter where  AdapterType = ""Ethernet 802.3"" ")
For Each obj_pc In col_pc
 WScript.Echo "============================================" & vbCrLf & _
 "AdapterType: " & obj_pc.AdapterType & vbCrLf & _
 "Caption: " & obj_pc.Caption & vbCrLf & _
 "MACAddress: " & obj_pc.MACAddress & vbCrLf & _
 "Manufacturer: " & obj_pc.Manufacturer & vbCrLf & _
 "ProductName: " & obj_pc.ProductName 
Next
end sub

OS
PC
nic
HOTFIX

