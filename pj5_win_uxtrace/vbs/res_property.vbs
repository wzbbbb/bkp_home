strComputer = "."
strNamespace = "\root\cimv2"
strClassName = "Win32_Service"

Set objSWbemServices = GetObject("winmgmts:" _
 & "{impersonationLevel=impersonate}!\\" & strComputer & strNamespace)

Set colInstances = objSWbemServices.ExecQuery _
 ("SELECT * FROM " & strClassName)
For Each objInstance in colInstances
 Wscript.Echo "Caption " & objInstance.Caption
 Wscript.Echo "Description " & objInstance.Description
Next


