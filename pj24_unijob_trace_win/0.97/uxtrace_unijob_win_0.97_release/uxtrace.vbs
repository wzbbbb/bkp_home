' ## Windows Uxtrace for UNIJOB Version 0.97
' ## by ZWA (Orsyp) 2009/11/30
' ## Search for services for UNIJOB instead of $U
' ## Windows Uxtrace for UNIJOB Version 0.96
' ## by ZWA (Orsyp) 2009/02/13
' ## Making the execution sync, and customizations for integration into GUI
' ## Windows Uxtrace for UNIJOB Version 0.95
' ## by ZWA (Orsyp) 2009/02/05
' ## Integrated the zip.exe
' ## Windows Uxtrace for UNIJOB Version 0.94
' ## by ZWA (Orsyp) 2008/08/11
' ## updated to work with both UniJOb and UniViewer Server 1.1
' ## Windows Uxtrace for UNIJOB Version 0.93
' ## by ZWA (Orsyp) 2008/08/11
' ## Add the UNIJOB_dir_all
' ## Windows Uxtrace for UNIJOB Version 0.92
' ## by ZWA (Orsyp) 2008/08/11
' ## modified to run in "app" instead of "data"
' ## Windows Uxtrace for UNIJOB Version 0.91
' ## by ZWA (Orsyp) 2008/07/23
' ## modified to fit the UniJob and UniViewer server 1.0.0
' ## Windows Uxtrace for UNIJOB Version 0.90
' ## Created by ZWA (Orsyp) 2008/07/23
' ## Based on Windows uxtrace
'''''''''''
''Constant
'''''''''''
'const default_area="X"
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
	file_level=inputbox("If you know the data file collecting level (0 - 9), please specify it here", "The files to be collected", default_files, 2000, 2000)
	if not isnumeric(file_level) then 'If the input is not a number, quit!
		msgbox("Please try again and specify 0 - 9 for date file colleting.")
		wscript.quit
	end if
	if file_level <0 or file_level >9 then 
		msgbox("Please try again and specify 0 - 9 for date file colleting.")
		wscript.quit
	end if

	target=inputbox("Please specify the tracing target:" & vbCrLf & "C : for UNIJOB Configuration "& vbCrLf &  "S : for OS "& vbCrLf & "CS : for All (both Configuration and OS)" & vbCrLf & "E : to collect Windows events" & vbCrLf & "O : consider the UNIJOB shutdown", "Tracing target",  default_target , 2000, 2000)
	target=UCase(target)
	if target ="SC" then target = "CS" end if
	if instr(target , "S")=0  and instr(target , "C")=0   and instr(target ,"O") =0  then
		msgbox("Please try again and specify the combintion of C, S, E and O for tracing target."& vbCrLf & "Please note: E has to be used with S ")
		wscript.quit
	end if
else
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
	Else
		target=default_target
	End If
end if
'Verifying the uxsetenv.bat location
Set objFSO = CreateObject("Scripting.FileSystemObject")
If objFSO.FileExists("..\data\unienv.bat") Then
	'wscript.echo "uxsetenv.bat is in this dir."
	env_path="..\data\"
Elseif objFSO.FileExists("..\..\data\unienv.bat") then
	env_path="..\..\data"
else
	if batch_mode="no" then
		msgbox("Please run the Windows uxtrace procedure under the 'uxtrace' directory.")
	else
		wscript.echo "Please run the Windows uxtrace procedure under the 'uxtrace' directory."
	end if

	wscript.quit
End If

'Launch the next step
Set objShell = WScript.CreateObject("WScript.Shell")
objShell.Run("%comspec% /k .\uxtrace_step1.bat X "& file_level &" "& target &" "& env_path &""), 0, True
'1 : Activates and displays a window. 
'True: wait tile the called program to complete before continue