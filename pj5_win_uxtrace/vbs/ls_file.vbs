ForAppending=8
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.GetFile("e:\mnt500\exp\log\universe.log")
'Set obj_file_ = objFSO.OpenTextFile("e:\mnt500\exp\log\universe.log", ForAppending)
Wscript.Echo "Absolute path: " & objFSO.GetAbsolutePathName(objFile)
Wscript.Echo "Parent folder: " & objFSO.GetParentFolderName(objFile)
Wscript.Echo "File name: " & objFSO.GetFileName(objFile)
Wscript.Echo "Base name: " & objFSO.GetBaseName(objFile)
Wscript.Echo "Extension name: " & objFSO.GetExtensionName(objFile)
