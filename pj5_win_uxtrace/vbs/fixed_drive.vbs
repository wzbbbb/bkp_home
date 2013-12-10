const fixed=2  'local drives, not remotely mounted.
set objfso=createobject("scripting.filesystemobject")
set coldiskdrive=objfso.drives
for each objdiskdrive in coldiskdrive
	if objdiskdrive.drivetype=fixed then
		wscript.echo objdiskdrive.driveletter
	end if
next
