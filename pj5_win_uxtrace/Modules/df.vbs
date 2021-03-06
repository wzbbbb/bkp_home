'''''''''''
''Constant
'''''''''''
const mb_factor = 1048576
'''''''''''
''Build conneciton to WMI
'''''''''''
strComputer = "."
Set obj_wmi = GetObject("winmgmts:" _
 & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")


'''''''''''
''Function
'''''''''''
function df
set col_disk=obj_wmi.execquery("select DeviceID, DriveType, FileSystem, " &_
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

'''''''''''
''Main
'''''''''''
df
