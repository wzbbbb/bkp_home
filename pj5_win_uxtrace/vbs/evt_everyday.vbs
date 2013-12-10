days_of_evt = 7

strComputer = "."
Set obj_wmi = GetObject("winmgmts:\\" & strComputer)
Set obj_cimv2 = GetObject("winmgmts:" _
 & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
function date2utc(date_)
	Set colTimeZone = obj_cimv2.ExecQuery ("SELECT Bias FROM Win32_TimeZone")
	For Each objTimeZone in colTimeZone
		strBias = objTimeZone.Bias
	Next
	date2utc = Year(date_)
	dtmMonth = Month(date_)
	If Len(dtmMonth) = 1 Then
		dtmMonth = "0" & dtmMonth
	End If
	date2utc = date2utc & dtmMonth
	dtmDay = Day(date_)
	If Len(dtmDay) = 1 Then
		dtmDay = "0" & dtmDay
	End If
	date2utc = date2utc & dtmDay & "000000.000000"
	date2utc = date2utc & Cstr(strBias)
end function

begin_date = date2utc(dateadd("d", -days_of_evt, date))

wscript.echo "The begin date is: " &  begin_date

'Set col_evt = obj_wmi.execquery("select * from Win32_NTLogEvent where TimeGenerated > '" & begin_date & "'")
Set col_evt = obj_wmi.execquery("select * from Win32_NTLogEvent")

For Each objSWbemObject In col_evt
 Wscript.Echo "Log File: " & objSWbemObject.LogFile & vbCrLf & _
 "Record Number: " & objSWbemObject.RecordNumber & vbCrLf & _
 "Type: " & objSWbemObject.Type & vbCrLf & _
 "Time Generated: " & objSWbemObject.TimeGenerated & vbCrLf & _
 "Source: " & objSWbemObject.SourceName & vbCrLf & _
 "Category: " & objSWbemObject.Category & vbCrLf & _
 "Category String: " & objSWbemObject.CategoryString & vbCrLf & _
 "Event: " & objSWbemObject.EventCode & vbCrLf & _
 "User: " & objSWbemObject.User & vbCrLf & _
 "Computer: " & objSWbemObject.ComputerName & vbCrLf & _
 "Message: " & objSWbemObject.Message & vbCrLf
Next

