'''''''''''
''Constant
'''''''''''


'''''''''''
''Building connection to WMI
'''''''''''
strComputer = "."
Set obj_cimv2 = GetObject("winmgmts:" _
 & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

'''''''''''
''Function
'''''''''''
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
'''''''''''
''Main
'''''''''''
ps
