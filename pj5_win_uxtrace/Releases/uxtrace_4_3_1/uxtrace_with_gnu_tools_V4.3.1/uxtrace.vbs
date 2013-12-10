' ## Windows Uxtrace Version 4.0
' ## Created by ZWA (Orsyp) 2004/12/27
' ##
' ## Windows Uxtrace Version 4.1
' ## Modified by ZWA (Orsyp) 2005/05/16
' ## Added the "O" switch
' ## 
' ## Windows Uxtrace Version 4.2
' ## Modified by ZWA (Orsyp) 2005/06/03
' ## Make the Windows event collection optional, and not "ON" by default.
' ##
' ## Windows Uxtrace Version 4.2.1
' ## Modified by ZWA (Orsyp) 2005/06/24
' ## Minor enhancements
' ## Added ipconfig /all
' ## Remove the dependency on tar and gzip, instead using as add on only 
' ## 
' ## Windows Uxtrace Version 4.2.2
' ## Modified by ZWA (Orsyp) 2005/10/11
' ## Backing up the uxversion.bat file
' ## Ping localhost found in the uxsrsrv.sck file
' ##
' ## Windows Uxtrace Version 4.3.0
' ## Modified by ZWA (Orsyp) 2006/02/22
' ## Bug fixs
' ## Enhancements
' ##
' ## Windows Uxtrace Version 4.3.1
' ## Modified by ZWA (Orsyp) 2006/05/05
' ## Minor enhancements
  
'''''''''''
''Constant
'''''''''''
const default_area="X"
const default_files="0"
const default_target="CS"

'''''''''''
''Function
'''''''''''
'''''''''''
''Main
'''''''''''
'Getting the input, batch_mode="no" -> interactive mode; batch_mode="yes" -> batch mode
Set colNamedArguments = WScript.Arguments.Named

If colNamedArguments.Exists("batch") Then
	batch_mode = colNamedArguments.Item("batch")
Else
	batch_mode="no"
End If


If batch_mode="no" then
	area=inputbox("Please specify the area (X, S, I, A) concerned : ", "The Working Area", default_area, 2000, 2000)
	area=UCase(area) 'to turn all input into upper case
	if area <>"X" and area<>"S" and area<>"I" and area<>"A" then
		msgbox("Please try again and specify X, S, I or A for area.")
		wscript.quit
	end if

	file_level=inputbox("If you know the data file collecting level (0 - 9), please specify it here", "The files to be collected", default_files, 2000, 2000)
	if not isnumeric(file_level) then 'If the input is not a number, quit!
		msgbox("Please try again and specify 0 - 9 for date file colleting.")
		wscript.quit
	end if
	if file_level <0 or file_level >9 then 
		msgbox("Please try again and specify 0 - 9 for date file colleting.")
		wscript.quit
	end if

	target=inputbox("Please specify the tracing target:" & vbCrLf & "C : for Dollar Universe Configuration "& vbCrLf &  "S : for OS "& vbCrLf & "CS : for All (both Configuration and OS)" & vbCrLf & "E : to collect Windows events" & vbCrLf & "O : consider the Dollar Universe Compay shutdown", "Tracing target",  default_target , 2000, 2000)
	target=UCase(target)
	if target ="SC" then target = "CS" end if
	if instr(target , "S")=0  and instr(target , "C")=0   and instr(target ,"O") =0  then
		msgbox("Please try again and specify the combintion of C, S, E and O for tracing target."& vbCrLf & "Please note: E has to be used with S ")
		wscript.quit
	end if
else
	'wscript.echo "ha, the batch mode!"
	If colNamedArguments.Exists("area") Then
		area = colNamedArguments.Item("area")
		area=UCase(area)
		if area <>"X" and area<>"S" and area<>"I" and area<>"A" then
			wscript.echo "Please try again and specify X, S, I or A for area." 
			wscript.quit
		end if
	Else
		area=default_area
	End If

	If colNamedArguments.Exists("file_level") Then
		file_level = colNamedArguments.Item("file_level")
		if not isnumeric(file_level) then 
			wscript.echo "Please try again and specify 0 - 9 for date file colleting."
			wscript.quit
		end if
		if file_level <0 or file_level >9 then 
			wscript.echo "Please try again and specify 0 - 9 for date file colleting."
			wscript.quit
		end if
	Else
		file_level=default_files
	End If
	If colNamedArguments.Exists("target") Then
		target = colNamedArguments.Item("target")
		target=UCase(target)
		if target ="SC" then target = "CS" end if

		if instr(target , "S")=0  and instr(target , "C")=0   and instr(target ,"O") =0  then
			'msgbox("Please try again and specify the combintion of C, S, E and O for tracing target.")
			wscript.echo ("Please try again and specify the combintion of C, S, E and O for tracing target."& vbCrLf & "Please note: E has to be used with S ")
			wscript.quit
		end if
		'if target <> "S" and target <> "C" and target <> "CS" and target <> "O" then
		'	wscript.echo "Please try again and specify C, S, CS or O for tracing target."
		'	wscript.quit
		'end if
	Else
		target=default_target
	End If
end if
'Verifying the uxsetenv.bat location
Set objFSO = CreateObject("Scripting.FileSystemObject")
If objFSO.FileExists(".\uxsetenv.bat") Then
	'wscript.echo "uxsetenv.bat is in this dir."
	env_path="."
Elseif objFSO.FileExists("..\uxsetenv.bat") then
	env_path=".."
else
	if batch_mode="no" then
		msgbox("Please unpack the Windows uxtrace procedure under the 'mgr' directory.")
	else
		wscript.echo "Please unpack the Windows uxtrace procedure under the 'mgr' directory."
	end if

	wscript.quit
End If

'Launch the next step
Set objShell = WScript.CreateObject("WScript.Shell")
objShell.Run("%comspec% /k .\uxtrace_step1.bat "& area &" "& file_level &" "& target &" "& env_path &""), 1, True
'1 : Activates and displays a window. 
'True: wait tile the called program to complete before continue
