set dir_v6kit=%1%
set dir_template=%2%
echo %dir_v6kit%
echo %dir_template%
%dir_v6kit%\du_as_6.0.13_windows64.exe /s /f1"%dir_template%\current_template.iss"


