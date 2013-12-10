
$dir_template="d:\apps\powershell"
$company_="TST600"
$node_="calpmzwa"
$com_nod=$company_
$com_nod+="_"
$com_nod+=$node_
$port_="35740"
$dir_install="d:\apps\du"
Get-Content $dir_template\duas6013_custom.iss |foreach {$_ -replace "VM2K8R2001", "$node_"} |set-content $dir_template\current_template.iss;
(Get-Content $dir_template\current_template.iss) |foreach {$_ -replace "TMP600", "$company_"} |set-content $dir_template\current_template.iss;
(Get-Content $dir_template\current_template.iss) |foreach {$_ -replace "20600", "$port_"} |set-content $dir_template\current_template.iss;
#(Get-Content $dir_template\current_template.iss )|foreach {$_ -replace [regex]::Escape("c:\ORSYP\DUAS\TMP600_VM2K8R2001"), ($dir_install\$com_nod)} |set-content $dir_template\current_template.iss
(Get-Content $dir_template\current_template.iss )|foreach {$_ -replace [regex]::Escape("c:\ORSYP\DUAS"), ($dir_install)} |set-content $dir_template\current_template.iss

