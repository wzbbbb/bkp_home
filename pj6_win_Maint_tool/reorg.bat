@echo off

if not "%1%" == "" goto no_message
echo Which Company do you want to reorg?
echo Launch this program again and specify one of the following parameters: 
:: echo 0 for COMM50
echo M for MNT500
echo Q for QCL500
echo S for SUP500
echo F for FLS500
echo CM for CLUSTER MNT500
echo CQ for CLUSTER QCL500
echo CS for CLUSTER SUP500
goto end
:no_message
rem if %1%== goto end
if %1==M call d:\lddu M
if %1==Q call d:\lddu Q
if %1==S call d:\lddu S
if %1==F call d:\lddu F
if %1==CM call d:\lddu CM
if %1==CQ call d:\lddu CQ
if %1==CS call d:\lddu CS

%UXMGR%\ux_vrf_rgz_rst.bat

:end
