'On error resume next
strComputer = "."
strNamespace = "\root\cimv2"
strClassName = "Win32_NTLogEvent"


Set objSWbemServices = _
 GetObject("winmgmts:{impersonationLevel=impersonate}!\\" &_
 strComputer & strNamespace)

Set colInstances = objSWbemServices.ExecQuery("SELECT * FROM " &_
 strClassName)
'Set colInstances = objSWbemServices.ExecQuery("SELECT * FROM '" & strClassName & "' where '" & objProperty.Name & "' = mnt500 ")

Wscript.Echo "Properties of Instances of Class " & strClassName
Wscript.Echo "================================================="

iCount = 0
For Each objInstance in colInstances
	iCount = iCount + 1
	Set colProperties = objInstance.Properties_

	Wscript.Echo vbCrLf
	Wscript.Echo "******************"
	Wscript.Echo "INSTANCE NUMBER: " & iCount
	Wscript.Echo "******************"
	Wscript.Echo vbCrLf
	On Error Resume Next
	For Each objProperty in colProperties
		Wscript.Echo objProperty.Name & " : " & objProperty.Value
		If Err <> 0 Then
			wscript.echo Err.Number & " -- " &  Err.Description
			wscript.echo "Error getting an event log"
			Err.Clear
		End If
	Next
	On Error GoTo 0 
	Wscript.Sleep(2000)
Next


