' ## Windows Uxtrace V4.0
' ## Created by ZWA (Orsyp) 2004/12/27
' ##
' ## 
' ##
' ##
' ##
'''''''''''
''Constant
'''''''''''
const default_area="X"
const default_files="0"
const default_target="CS"

'''''''''''
''Main
'''''''''''
area=inputbox("Please specify the area (X, S, I, A) concerned : ", "The Working Area", default_area, 2000, 2000)
area=UCase(area)
if area <>"X" and area<>"S" and area<>"I" and area<>"A" then
'if area <> "X" and area <> "S" then
msgbox("Please try again and specify X, S, I or A for area.")
wscript.quit
end if
file_level=inputbox("If you know the data file collecting level (1 - 9), please specify it here", "The files to be collected", default_files, 2000, 2000)
if file_level <0 or file_level >9 then 
msgbox("Please try again and specify 0 - 9 for date file colleting.")
wscript.quit
end if
target=inputbox("Please specify the tracing target:" & vbCrLf & "C : for Dollar Universe Configuration "& vbCrLf &  "S : for OS "& vbCrLf & "CS : for All (both Configuration and OS)", "Tracing target",  default_target , 2000, 2000)
target=UCase(target)
if target ="SC" then target = "CS" end if
if target <> "S" and target <> "C" and target <> "CS" then
msgbox("Please try again and specify C, S or CS for tracing target.")
wscript.quit
end if

'msgbox("you have enterend: " & area & ", " & file_level & ", " & target)
Set objShell = WScript.CreateObject("WScript.Shell")
objShell.Run("%comspec% /k .\step1_v4.0.bat "& area &" "& file_level &" "& target &""), 1, True

