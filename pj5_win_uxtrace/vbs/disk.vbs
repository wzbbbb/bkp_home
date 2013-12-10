Const HARD_DISK = 3
strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
 & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colDisks = objWMIService.ExecQuery _
 ("SELECT * FROM Win32_LogicalDisk WHERE DriveType = " _
 & HARD_DISK & "")
For Each objDisk in colDisks
 Wscript.Echo "Device ID: " & objDisk.DeviceID 
 Wscript.Echo "Free Disk Space: " & objDisk.FreeSpace
Next


