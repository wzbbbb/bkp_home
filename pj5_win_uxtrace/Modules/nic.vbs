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
sub nic 
	Set col_pc = obj_wmi.execquery("select AdapterType, "&_
	"Caption, MACAddress, Manufacturer, ProductName  " &_
	"from Win32_NetworkAdapter where  AdapterType = ""Ethernet 802.3"" ")
For Each obj_pc In col_pc
 Wscript.Echo "============================================" & vbCrLf & _
 "AdapterType: " & obj_pc.AdapterType & vbCrLf & _
 "Caption: " & obj_pc.Caption & vbCrLf & _
 "MACAddress: " & obj_pc.MACAddress & vbCrLf & _
 "Manufacturer: " & obj_pc.Manufacturer & vbCrLf & _
 "ProductName: " & obj_pc.ProductName 
Next
end sub

'''''''''''
''Main
'''''''''''
nic
