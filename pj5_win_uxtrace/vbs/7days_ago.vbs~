const days_of_evt = 7

strComputer = "."
Set obj_wmi = GetObject("winmgmts:\\" & strComputer)
Set obj_cimv2 = GetObject("winmgmts:" _
 & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
function date2utc(date_)
	Set colTimeZone = obj_cimv2.ExecQuery ("SELECT Bias FROM Win32_TimeZone")
	For Each objTimeZone in colTimeZone
		strBias = objTimeZone.Bias
		wscript.echo "strBias is: " , strBias
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
	bias = Cstr(strBias)
	if strBias > 100 then
		date2utc = date2utc & "+" & bias
	end if
	if strBias < 100 and strBias >0 then
		date2utc = date2utc & "+0" & bias
	end if
	if strBias > -100 and strBias < 0 then
		date2utc = date2utc & "-0" & Cstr(abs(strBias))
	end if

	if strBias < -100 then
		date2utc = date2utc & Cstr(strBias)
	end if
end function

wscript.echo "The date is: " &  date

begin_date = date2utc(dateadd("d", -days_of_evt, date))

wscript.echo "The begin date is: " &  begin_date
