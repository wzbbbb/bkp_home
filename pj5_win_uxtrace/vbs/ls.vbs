Set FSO = CreateObject("Scripting.FileSystemObject")
Set Folder = FSO.GetFolder("e:\mnt500\exp\log")
Set FileList = Folder.Files
For Each File in FileList
    Wscript.Echo File.Name & VbTab & File.Size , File.DateLastModified
Next


