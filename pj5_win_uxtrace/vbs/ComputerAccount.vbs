Set objSysInfo = CreateObject("ADSystemInfo")
Wscript.Echo "User name: " & objSysInfo.UserName
Wscript.Echo "Computer name: " & objSysInfo.ComputerName
Wscript.Echo "Site name: " & objSysInfo.SiteName
Wscript.Echo "Domain short name: " & objSysInfo.DomainShortName
Wscript.Echo "Domain DNS name: " & objSysInfo.DomainDNSName
Wscript.Echo "Forest DNS name: " & objSysInfo.ForestDNSName
Wscript.Echo "PDC role owner: " & objSysInfo.PDCRoleOwner
Wscript.Echo "Schema role owner: " & objSysInfo.SchemaRoleOwner
Wscript.Echo "Domain is in native mode: " & objSysInfo.IsNativeMode

