'''''''''''
''Constant
'''''''''''
'''''''''''
''Building the connection to WMI 
'''''''''''
strComputer = "."
Set obj_wmi = GetObject("winmgmts:\\" & strComputer)
'''''''''''
''Function
'''''''''''
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

'''''''''''
''Main
'''''''''''
OS
