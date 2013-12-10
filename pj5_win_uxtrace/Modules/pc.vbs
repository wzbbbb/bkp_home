'''''''''''
''Constant
'''''''''''
'''''''''''
''Building the connection to WMI 
'''''''''''
strComputer = "."
Set obj_wmi = GetObject("winmgmts:\\" & strComputer)
'''''''''''
''Function
'''''''''''
sub PC 
	Set col_pc = obj_wmi.execquery("select Description, "&_
	"Manufacturer, Model, NumberOfProcessors, PrimaryOwnerName, SystemType,"&_
	"TotalPhysicalMemory from Win32_ComputerSystem")
For Each obj_pc In col_pc
 Wscript.Echo "============================================" & vbCrLf & _
 "Description: " & obj_pc.Description & vbCrLf & _
 "Manufacturer: " & obj_pc.Manufacturer & vbCrLf & _
 "Model: " & obj_pc.Model & vbCrLf & _
 "NumberOfProcessors: " & obj_pc.NumberOfProcessors & vbCrLf & _
 "PrimaryOwnerName: " & obj_pc.PrimaryOwnerName & vbCrLf & _
 "SystemType: " & obj_pc.SystemType & vbCrLf & _
 "TotalPhysicalMemory: " & obj_pc.TotalPhysicalMemory 
Next
end sub

'''''''''''
''Main
'''''''''''
PC
