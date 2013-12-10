Set objFSO = CreateObject("Scripting.FileSystemObject")
ForAppending=8

strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
 & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set FileList = objWMIService.ExecQuery _
 ("ASSOCIATORS OF {Win32_Directory.Name='e:\mnt500\exp\log'} Where " _
 & "ResultClass = CIM_DataFile")
For Each objFile In FileList
 If objFile.Extension = "log" or objFile.Extension = "LOG" Then
	wscript.echo objFile.name
	file_name=objFile.name
	Set obj_log_file = objFSO.OpenTextFile(file_name, ForAppending) ' read the output file
	obj_log_file.writeline "the test from vbs"

 End If
Next

