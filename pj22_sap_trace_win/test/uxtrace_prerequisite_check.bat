@echo off
echo "This window will close after the script finishes, please wait ..."
hostname >uxtrace_prerequisite_check_output.txt
ipconfig /all >>uxtrace_prerequisite_check_output.txt
cscript uxtrace_version_test.vbs >>uxtrace_prerequisite_check_output.txt
