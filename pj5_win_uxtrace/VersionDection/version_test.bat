@echo off
echo "This window will close after the script finishes, please wait ..."
hostname >output.txt
ipconfig /all >>output.txt
cscript Version_Test.vbs >>output.txt
