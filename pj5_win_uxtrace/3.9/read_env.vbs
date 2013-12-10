'''''''''''
''Creating the OBJ
'''''''''''
Set objShell = WScript.CreateObject("WScript.Shell")
Set objFSO = CreateObject("Scripting.FileSystemObject")

'''''''''''
''Function
'''''''''''
function var_def(var_name)
Set objExecObject = objShell.Exec("cmd /c echo %" & var_name & "%")
var_def = objExecObject.StdOut.ReadLine()
end function


sub read_env
UXDIR_ROOT=var_def(UXDIR_ROOT)
UXEXE=var_def(UXEXE)
UXMGR=var_def(UXMGR)
UXDAP=var_def(UXDAP)
UXDIN=var_def(UXDIN)
UXDSI=var_def(UXDSI)
UXDEX=var_def(UXDEX)
UXLAP=var_def(UXLAP)
UXLIN=var_def(UXLIN)
UXLSI=var_def(UXLSI)
UXLEX=var_def(UXLEX)
UXPAP=var_def(UXPAP)
UXPIN=var_def(UXPIN)
UXPSI=var_def(UXPSI)
UXPEX=var_def(UXPEX)
U_LOG_FILE=var_def(U_LOG_FILE)
U_LIC_FILE=var_def(U_LIC_FILE)
U_MSG_FILE=var_def(U_MSG_FILE)
U_FMT_DATE=var_def(U_FMT_DATE)
U_MASK_UPR=var_def(U_MASK_UPR)
U_CDJ_DISABLE=var_def(U_CDJ_DISABLE)
U_CLUSTER=var_def(U_CLUSTER)
U_PMP_DISABLE=var_def(U_PMP_DISABLE)
U_AGTSAP_VERSION_REQUEST=var_def(U_AGTSAP_VERSION_REQUEST)
S_NOEUD=var_def(S_NOEUD)
S_ESPEXE=var_def(S_ESPEXE)

wscript.echo "UXEXE is :", var_def("UXEXE")
wscript.echo "UXDIR_ROOT is :", var_def("UXDIR_ROOT")
wscript.echo "UXMGR is :", var_def("UXMGR")
end sub
'''''''''''
''Main
'''''''''''
base_dir_var=array("UXDIR_ROOT", "UXEXE", "UXMGR")
data_dir_var=array("UXDAP", "UXDIN","UXDSI","UXDEX")
log_dir_var=array("UXLAP", "UXLIN","UXLSI","UXLEX")
upr_dir_var=array("UXPAP", "UXPIN","UXPSI","UXPEX")


win_trace_ver="Windows Uxtrace 4.0"
ver_short="v40"

If objFSO.FileExists(".\uxsetenv.bat") Then
	wscript.echo "uxsetenv.bat is in this dir."
	Set objExecObject = objShell.Exec("cmd /k .\uxsetenv.bat")
	ooo = objExecObject.StdOut.ReadLine()
	wscript.echo "here is ooo : " , ooo	
	'objShell.Run("%comspec% /k .\uxsetenv.bat"), 1, True
	
	' Set objFile = objFSO.GetFile("C:\FSO\ScriptLog.txt")
Elseif objFSO.FileExists("..\uxsetenv.bat") then
	Set objExecObject = objShell.Exec("cmd /c ..\uxsetenv.bat")
else
	 Wscript.Echo "Please unpack the Windows uxtrace procedure under the 'mgr' directory."
	 wscript.quit
End If
read_env
