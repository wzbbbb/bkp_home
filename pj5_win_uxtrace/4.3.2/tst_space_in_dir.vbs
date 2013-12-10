Set objShell = WScript.CreateObject("WScript.Shell")
'upg_dir="c:\tmp"
upg_dir="J:\users\zwa\pj5_win_uxtrace\4.3.2"

'cmd_ "if exist " & """%ProgramFiles%\InstallShield Installation """ & _
' """Information\{357C62B2-63BD-41F6-B7A3-6D0D6C427BC3}\*.log """ & " echo yes"

cmd_ "if exist " & """%ProgramFiles%\InstallShield Installation Information""" & _
 "\{357C62B2-63BD-41F6-B7A3-6D0D6C427BC3}\*.log " & _
 " copy " & """%ProgramFiles%\InstallShield Installation Information""" & _
 "\{357C62B2-63BD-41F6-B7A3-6D0D6C427BC3}\*.log " & upg_dir

sub cmd_(cmd_name) 'run command without TS
'objShell.Run("cmd /c "& cmd_name & ""), 0, True
objShell.Run("cmd /k "& cmd_name & ""), 1, True
end sub 
