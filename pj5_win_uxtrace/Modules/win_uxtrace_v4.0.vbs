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
const default_target="A"

'''''''''''
''Main
'''''''''''

area=inputbox("Please specify the area (X, S, I, A) concerned : ", "The Working Area", default_area, 2000, 2000)
file_level=inputbox("If you know the file collecting level (1 - 9), please specify it here", "The files to be collected", default_files, 2000, 2000)
target=inputbox("Please specify the tracing target:" & vbCrLf & "S : for Scheduling "& vbCrLf &  "O : for OS "& vbCrLf & "A : for All (both Scheduling and OS)", "Tracing target",  default_target , 2000, 2000)
area=UCase(area)
file_level=UCase(file_level)
target=UCase(target)
'msgbox("you have enterend: " & area & ", " & file_level & ", " & target)
Set objShell = WScript.CreateObject("WScript.Shell")
objShell.Run("%comspec% /k .\step1_v4.0.bat "& area &" "& file_level &" "& target &""), 1, True

