@echo off
set UXMGR=%1%
set trace_dir=%2%
set trace_name=%3%
cd %UXMGR%
%trace_dir%\tar cvf %trace_name%.tar %trace_name%
%trace_dir%\gzip %trace_name%.tar 

