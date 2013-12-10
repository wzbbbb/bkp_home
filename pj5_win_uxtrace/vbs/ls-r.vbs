Set FSO = CreateObject("Scripting.FileSystemObject")
ShowSubfolders FSO.GetFolder("f:\downloads")
Sub ShowSubFolders(Folder)
    For Each Subfolder in Folder.SubFolders
        Wscript.Echo Subfolder.Path
        ShowSubFolders Subfolder
    Next
End Sub

