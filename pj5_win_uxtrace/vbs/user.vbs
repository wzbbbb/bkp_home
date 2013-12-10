Set objOU = GetObject("LDAP://ou=MIS,dc=na,dc=orsyp,dc=com")
Wscript.Echo objOU.Get("description")


