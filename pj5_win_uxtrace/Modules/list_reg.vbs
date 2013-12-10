'''''''''''
''Constant
'''''''''''
strComputer = "."
Const HKEY_LOCAL_MACHINE = &H80000002
const HKEY_CURRENT_USER  = &H80000001
strKeyPath = "SOFTWARE\ORSYP S.A."

'''''''''''
''Building the connection to WMI
'''''''''''
Set objReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" & _
 strComputer & "\root\default:StdRegProv")

'''''''''''
''Function
'''''''''''
sub list_reg
	wscript.echo "===========HKEY_LOCAL_MACHINE\"& strKeyPath & "==========="
	shw_sub_key HKEY_LOCAL_MACHINE, strKeyPath
	wscript.echo "===========HKEY_CURRENT_USER\"& strKeyPath & "==========="
	shw_sub_key HKEY_CURRENT_USER, strKeyPath
end sub

sub shw_sub_key(hkey, KeyPath)
	ret_cod = objReg.EnumKey(hkey, KeyPath, arrSubKeys)
	if ret_cod = 0  and IsArray(arrSubKeys) then 
	For Each Subkey in arrSubKeys
		 Wscript.Echo KeyPath & "\" & Subkey
		 shw_sub_key hkey, KeyPath & "\" & Subkey
	Next
	end if 
end sub
'''''''''''
''Main
'''''''''''
list_reg
