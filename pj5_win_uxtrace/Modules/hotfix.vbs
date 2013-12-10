'''''''''''
''Constant
'''''''''''
strComputer = "."
Set obj_cimv2 = GetObject("winmgmts:" _
 & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
'''''''''''
''Building connection to WMI
'''''''''''

'''''''''''
''Function
'''''''''''
sub HOTFIX
Set col_fix = obj_cimv2.ExecQuery _
 ("SELECT Description,  FixComments, HotFixID, ServicePackInEffect " &_ 
 "FROM Win32_QuickFixEngineering")
For Each obj_fix in col_fix
	 Wscript.Echo "=================================" 
	 Wscript.Echo "Description: " & obj_fix.Description
	 Wscript.Echo "FixComments: " & obj_fix.FixComments
	 Wscript.Echo "Hot Fix ID: " & obj_fix.HotFixID
	 Wscript.Echo "ServicePackInEffect: " & obj_fix.ServicePackInEffect
Next

end sub

'''''''''''
''Main
'''''''''''
HOTFIX
