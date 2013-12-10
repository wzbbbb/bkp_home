echo off
set PATH=%PATH%;d:\Tools

echo "Launch the global reorganization"
set uxcomp=AVALID
if not exist e:\%uxcomp% goto %uxcomp%_end
echo "Reorganize %uxcomp%"
call e:\%uxcomp%\mgr\uxsetenv.bat
call e:\%uxcomp%\mgr\ux_vrf_rgz_rst.bat
:AVALID_end

echo "Launch the global reorganization"
set uxcomp=GCO210
if not exist e:\%uxcomp% goto %uxcomp%_end
echo "Reorganize %uxcomp%"
call e:\%uxcomp%\mgr\uxsetenv.bat
call e:\%uxcomp%\mgr\ux_vrf_rgz_rst.bat
:GCO210_end

set uxcomp=MNT500
if not exist e:\%uxcomp% goto %uxcomp%_end
echo "Reorganize %uxcomp%"
call e:\%uxcomp%\mgr\uxsetenv.bat
call e:\%uxcomp%\mgr\ux_vrf_rgz_rst.bat
:MNT500_end

set uxcomp=QCL500
if not exist e:\%uxcomp% goto %uxcomp%_end
echo "Reorganize %uxcomp%"
call e:\%uxcomp%\mgr\uxsetenv.bat
call e:\%uxcomp%\mgr\ux_vrf_rgz_rst.bat
:QCL500_end

set uxcomp=SUP500
if not exist e:\%uxcomp% goto %uxcomp%_end
echo "Reorganize %uxcomp%"
call e:\%uxcomp%\mgr\uxsetenv.bat
call e:\%uxcomp%\mgr\ux_vrf_rgz_rst.bat
:SUP500_end

set uxcomp=YVALID
if not exist e:\%uxcomp% goto %uxcomp%_end
echo "Reorganize %uxcomp%"
call e:\%uxcomp%\mgr\uxsetenv.bat
call e:\%uxcomp%\mgr\ux_vrf_rgz_rst.bat
:YVALID_end

