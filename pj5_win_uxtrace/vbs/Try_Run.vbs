Set objShell = WScript.CreateObject("WScript.Shell")
objShell.Run("%comspec% /c dir"), 0, True

' Below does not work, can not get the return code.
'return_code = objShell.Run("cmd /K dir"), 1, True


'Wscript.Echo "Script completed."
'Wscript.Echo "Return code is: ", return_code