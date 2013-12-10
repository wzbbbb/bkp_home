'''''''''''
''Constant
'''''''''''
days_of_evt = 7

'''''''''''
''Building the conneciton to WMI
'''''''''''
strComputer = "."
Set obj_winmgmts = GetObject("winmgmts:\\" & strComputer)
Set obj_cimv2 = GetObject("winmgmts:" _
 & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

'''''''''''
''Functions
'''''''''''

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

Function utc2date(dtmInstallDate)
	 utc2date = CDate(Mid(dtmInstallDate, 5, 2) & "/" & _
	 Mid(dtmInstallDate, 7, 2) & "/" & Left(dtmInstallDate, 4) _
	 & " " & Mid (dtmInstallDate, 9, 2) & ":" & _
	 Mid(dtmInstallDate, 11, 2) & ":" & Mid(dtmInstallDate, _
	 13, 2))
End Function

Sub get_evtlog
begin_date = date2utc(dateadd("d", -days_of_evt, date))
'wscript.echo begin_date
'Set colSWbemObjectSet = obj_winmgmts.InstancesOf("Win32_NTLogEvent")
Set col_evt = obj_winmgmts.execquery("select * from Win32_NTLogEvent where TimeGenerated > '" & _
 begin_date & "'")
'Set col_evt = obj_winmgmts.execquery("select * from Win32_NTLogEvent where '" & _
'eventidentifier & "'= 1073741828")
For Each obj_evt In col_evt
	 Wscript.Echo "Log File: " & obj_evt.LogFile & vbCrLf & _
	 "Record Number: " & obj_evt.RecordNumber & vbCrLf & _
	 "Type: " & obj_evt.Type & vbCrLf & _
	 "Time Generated: " & utc2date(obj_evt.TimeGenerated) & vbCrLf & _
	 "Source: " & obj_evt.SourceName & vbCrLf & _
	 "Category: " & obj_evt.Category & vbCrLf & _
	 "Category String: " & obj_evt.CategoryString & vbCrLf & _
	 "Event: " & obj_evt.EventCode & vbCrLf & _
	 "User: " & obj_evt.User & vbCrLf & _
	 "Computer: " & obj_evt.ComputerName & vbCrLf & _
	 "Message: " & obj_evt.Message & vbCrLf
Next
End Sub
'''''''''''
''Main
'''''''''''
get_evtlog
