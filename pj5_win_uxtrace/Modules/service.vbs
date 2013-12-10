'''''''''''
''Constant
'''''''''''

'''''''''''
''Building connection to WMI
'''''''''''
strComputer = "."
Set obj_wmi = GetObject("winmgmts:\\" & strComputer)

'''''''''''
''Function
'''''''''''

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
service



