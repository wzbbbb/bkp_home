# dudmp6 for Windows by ZWA
# V1.0 03/01/2013
# Comparing with the current UNIX version of the script, this dudmp6 procedure does not require any 
# predefined directory structure and no update in the template file.
#
#

# The input box

#$node_=$args[0];
#$company_=$args[1];
#write-host $node_ $company_
#if ($args.length -lt 2 ) { 
#	write-host "Please specify the node name and company name";
#	write-host "For example, dudmp6 node1 FLS600";
#	exit 1;
#}
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

[System.Windows.Forms.MessageBox]::Show("The default UVMS is caplda02. Update the template response file to use another UVMS.", "6013 64 bit Windows kit required");
$dir_dufiles=""
$dir_template=""
$dir_v6kit=""
$dir_install=""
$node_=""
$company_=""
function input_box ($dir_dufiles, $dir_template, $dir_v6kit, $dir_install, $node_, $company_) {
$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "All fields are mandatory"
$objForm.Size = New-Object System.Drawing.Size(700,500) 
$objForm.StartPosition = "CenterScreen"

$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$script:dir_dufiles=$objTextBox_dufiles.Text;
     $script:dir_template=$objTextBox_template.Text;
     $script:dir_v6kit=$objTextBox_v6kit.Text;
     $script:dir_install=$objTextBox_install.Text;
     $script:node_=$objTextBox_node.Text;
     $script:company_=$objTextBox_company.Text;
     $objForm.Close()
    }
    })
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm.Close(); [environment]::exit(0) }})

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(275,420)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click(
	{$script:dir_dufiles=$objTextBox_dufiles.Text;
	$script:dir_template=$objTextBox_template.Text;
	$script:dir_v6kit=$objTextBox_v6kit.Text;
	$script:dir_install=$objTextBox_install.Text;
	$script:node_=$objTextBox_node.Text;
	$script:company_=$objTextBox_company.Text;
	$objForm.Close()
	})
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(350,420)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$objForm.Close(); [environment]::exit(0) })
$objForm.Controls.Add($CancelButton)

$objLabel_dufiles = New-Object System.Windows.Forms.Label
$objLabel_dufiles.Location = New-Object System.Drawing.Size(10,20) 
$objLabel_dufiles.Size = New-Object System.Drawing.Size(300,20) 
$objLabel_dufiles.Text = "The DUFILES path of the unpacked uxtrace result:"
$objForm.Controls.Add($objLabel_dufiles) 

$objTextBox_dufiles = New-Object System.Windows.Forms.TextBox 
$objTextBox_dufiles.Location = New-Object System.Drawing.Size(10,40) 
$objTextBox_dufiles.Size = New-Object System.Drawing.Size(600,20) 
$objTextBox_dufiles.Text = $dir_dufiles
$objForm.Controls.Add($objTextBox_dufiles) 

$objLabel_template = New-Object System.Windows.Forms.Label
$objLabel_template.Location = New-Object System.Drawing.Size(10,80) 
$objLabel_template.Size = New-Object System.Drawing.Size(600,20) 
$objLabel_template.Text = "The path of the template file and this script:"
$objForm.Controls.Add($objLabel_template) 

$objTextBox_template = New-Object System.Windows.Forms.TextBox 
$objTextBox_template.Location = New-Object System.Drawing.Size(10,100) 
$objTextBox_template.Size = New-Object System.Drawing.Size(600,20) 
$objTextBox_template.Text = $dir_template
$objForm.Controls.Add($objTextBox_template) 

$objLabel_v6kit = New-Object System.Windows.Forms.Label
$objLabel_v6kit.Location = New-Object System.Drawing.Size(10,140) 
$objLabel_v6kit.Size = New-Object System.Drawing.Size(600,20) 
$objLabel_v6kit.Text = "The path of the V6 kit:"
$objForm.Controls.Add($objLabel_v6kit) 

$objTextBox_v6kit = New-Object System.Windows.Forms.TextBox 
$objTextBox_v6kit.Location = New-Object System.Drawing.Size(10,160) 
$objTextBox_v6kit.Size = New-Object System.Drawing.Size(600,20) 
$objTextBox_v6kit.Text = $dir_v6kit
$objForm.Controls.Add($objTextBox_v6kit) 

$objLabel_install = New-Object System.Windows.Forms.Label
$objLabel_install.Location = New-Object System.Drawing.Size(10,200) 
$objLabel_install.Size = New-Object System.Drawing.Size(300,20) 
$objLabel_install.Text = "The target installation path:"
$objForm.Controls.Add($objLabel_install) 

$objTextBox_install = New-Object System.Windows.Forms.TextBox 
$objTextBox_install.Location = New-Object System.Drawing.Size(10,220) 
$objTextBox_install.Size = New-Object System.Drawing.Size(600,20) 
$objTextBox_install.Text = $dir_install
$objForm.Controls.Add($objTextBox_install) 

$objLabel_node = New-Object System.Windows.Forms.Label
$objLabel_node.Location = New-Object System.Drawing.Size(10,260) 
$objLabel_node.Size = New-Object System.Drawing.Size(300,20) 
$objLabel_node.Text = "The node name of the target intallation:"
$objForm.Controls.Add($objLabel_node) 

$objTextBox_node = New-Object System.Windows.Forms.TextBox 
$objTextBox_node.Location = New-Object System.Drawing.Size(10,280) 
$objTextBox_node.Size = New-Object System.Drawing.Size(600,20) 
$objTextBox_node.Text = $node_
$objForm.Controls.Add($objTextBox_node) 

$objLabel_company = New-Object System.Windows.Forms.Label
$objLabel_company.Location = New-Object System.Drawing.Size(10,320) 
$objLabel_company.Size = New-Object System.Drawing.Size(300,20) 
$objLabel_company.Text = "The company name of the target intallation:"
$objForm.Controls.Add($objLabel_company) 

$objTextBox_company = New-Object System.Windows.Forms.TextBox 
$objTextBox_company.Location = New-Object System.Drawing.Size(10,340) 
$objTextBox_company.Size = New-Object System.Drawing.Size(600,20) 
$objTextBox_company.Text = $company_
$objForm.Controls.Add($objTextBox_company) 

$objForm.Topmost = $True

$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()
}
input_box
$ready_="False"
while ($ready_ -eq "False") {
 if (($dir_dufiles -eq "") -or ($dir_template -eq "") -or ($dir_v6kit -eq "") -or ($dir_install -eq "") -or ($node_  -eq "") -or ($company_ -eq "")) 
 {
	[System.Windows.Forms.MessageBox]::Show("Please fill in all fields.", "Error");
	input_box $dir_dufiles $dir_template $dir_v6kit $dir_install $node_ $company_ ;
 }
 elseif((test-path $dir_dufiles) -ne "True" ) 
 {
	[System.Windows.Forms.MessageBox]::Show("The DUFILES path specified does not exist.", "Error");
	input_box $dir_dufiles $dir_template $dir_v6kit $dir_install $node_ $company_ ;
 }
 elseif (! $dir_dufiles.contains("DUFILES")) {
	[System.Windows.Forms.MessageBox]::Show("Input the path including DUFILES.", "Error");
	input_box $dir_dufiles $dir_template $dir_v6kit $dir_install $node_ $company_ ;
 }
 elseif ((test-path $dir_template) -ne "True" ) 
 {
	[System.Windows.Forms.MessageBox]::Show("The template and script path specified does not exist.", "Error");
	input_box $dir_dufiles $dir_template $dir_v6kit $dir_install $node_ $company_ ;
 }
 elseif ((test-path $dir_v6kit) -ne "True" ) 
 {
	[System.Windows.Forms.MessageBox]::Show("The $U V6 installation kit path specified does not exist.", "Error");
	input_box $dir_dufiles $dir_template $dir_v6kit $dir_install $node_ $company_ ;
 }
 elseif((test-path $dir_install) -ne "True" ) 
 {
	[System.Windows.Forms.MessageBox]::Show("The target installation path does not exists.", "Error");
	input_box $dir_dufiles $dir_template $dir_v6kit $dir_install $node_ $company_ ;
 }
 elseif ( $node_ -eq "" ) 
 {
	[System.Windows.Forms.MessageBox]::Show("Please specify a node name", "Error");
	input_box $dir_dufiles $dir_template $dir_v6kit $dir_install $node_ $company_ ;
 }
 elseif ( $company_ -eq "" ) 
 {
	[System.Windows.Forms.MessageBox]::Show("Please specify a company name", "Error");
	input_box $dir_dufiles $dir_template $dir_v6kit $dir_install $node_ $company_ ;
 }
 else {$ready_="True"}
}

$dir_dufiles
$dir_template
$dir_v6kit
$dir_install
$node_
$company_

# Finding the free ports
$in_use="yes"; 
while ( $in_use -eq "yes" ) {  
	$seed_=get-random -Maximum 6500 -Minimum 900;
	$port_=$seed_*10;
#	write-host testing port $port_
#netstat -an|grep $port_
#	$tcpobject = new-Object system.Net.Sockets.TcpClient
	netstat -an|findstr $port_  2>&1 > $null
	$rc=$?
#	echo "this is rc $rc"
	if ( $rc -eq "True" )  { $in_use = "yes"; }
	else { $in_use = "no"; }
}

# Creating the current_template file
Get-Content $dir_template\duas6013_custom.iss |foreach {$_ -replace "VM2K8R2001", "$node_"} |set-content $dir_template\current_template.iss;
(Get-Content $dir_template\current_template.iss) |foreach {$_ -replace "TMP600", "$company_"} |set-content $dir_template\current_template.iss;
(Get-Content $dir_template\current_template.iss) |foreach {$_ -replace "20600", "$port_"} |set-content $dir_template\current_template.iss;
(Get-Content $dir_template\current_template.iss )|foreach {$_ -replace [regex]::Escape("c:\ORSYP\DUAS"), ($dir_install)} |set-content $dir_template\current_template.iss

#$time_stamp=(date -f yyyy-MM-dd_HH-mm)
cmd /c "$dir_v6kit\du_as_6.0.13_windows64.exe /s /f1$dir_template\current_template.iss"
#cmd /c "dudmp_1.bat $dir_v6kit $dir_template"
#cmd /c "c:\du\du_as_6.0.13_windows64.exe /s /f1X:\home\zwa\pj32_dudmp6_win\current_template.iss"
#$dir_v6kit\du_as_6.0.13_windows64.exe /s /f1"$dir_template\current_template.iss" /f2"$dir_template\duas6013_$time_stamp.log"
$install_result=$?
if ( $install_result -ne "True" ) {
	[System.Windows.Forms.MessageBox]::Show("Install failed. Please check the install log.", "Error");
	[environment]::exit(1) 
}
	else { write-host "Install finished :)";
}		

# Getting the %UNI_DIR_EXEC%
$com_nod=$company_
$com_nod+="_"
$com_nod+=$node_
$UNI_DIR_EXEC="$dir_install\$com_nod\bin"
$UXMGR="$dir_install\$com_nod\mgr"
# Turn off engines 
cmd /c "$UXMGR\uxsetenv & $UNI_DIR_EXEC\unisetvar UNI_STARTUP_X IO,CDJ,BVS,DQM,EEP,SYN,ALM"
cmd /c "$UXMGR\uxsetenv & $UNI_DIR_EXEC\unisetvar UNI_STARTUP_S IO,CDJ,BVS,SYN,ALM"
cmd /c "$UXMGR\uxsetenv & $UNI_DIR_EXEC\unisetvar UNI_STARTUP_I IO,CDJ,BVS,SYN,ALM"
cmd /c "$UXMGR\uxsetenv & $UNI_DIR_EXEC\unisetvar UNI_STARTUP_A IO,CDJ,BVS,SYN,ALM"
cmd /c "$UXMGR\uxsetenv & $UNI_DIR_EXEC\unistop"
$shutdown_result=$?
if ($shutdown_result -ne "True" ) {
	[System.Windows.Forms.MessageBox]::Show("Failed to shutdown $U. Please check the install log.", "Error");
	[environment]::exit(1) 
}
# Select area with a dropdown box
[array]$DropDownArray = "Application area", "Integration area", "Simulation area", "Production area"
function Return-DropDown {
	$script:Choice = $DropDown.SelectedItem.ToString()
	$Form.Close()
	Write-Host $Choice
}
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
$Form = New-Object System.Windows.Forms.Form
$Form.width = 300
$Form.height = 150
$Form.Text = "DropDown"
$Form.StartPosition = "CenterScreen"
$DropDown = new-object System.Windows.Forms.ComboBox
$DropDown.Location = new-object System.Drawing.Size(100,10)
$DropDown.Size = new-object System.Drawing.Size(130,30)
ForEach ($Item in $DropDownArray) {
	$DropDown.Items.Add($Item)
}
$DropDown.SelectedItem = "Production area"
$Form.Controls.Add($DropDown)

$DropDownLabel = new-object System.Windows.Forms.Label
$DropDownLabel.Location = new-object System.Drawing.Size(10,10) 
$DropDownLabel.size = new-object System.Drawing.Size(100,20) 
$DropDownLabel.Text = "Items"
$Form.Controls.Add($DropDownLabel)

$Button = new-object System.Windows.Forms.Button
$Button.Location = new-object System.Drawing.Size(100,50)
$Button.Size = new-object System.Drawing.Size(100,20)
$Button.Text = "Select an Item"
$Button.Add_Click({Return-DropDown})
$form.Controls.Add($Button)

$Form.Add_Shown({$Form.Activate()})
[void]$Form.ShowDialog()

# Load the data files
switch ($Choice) {
	"Application area" {
		$area_data_d="$dir_install\$com_nod\data\app";
		$area_3="app";
		$area_d="UXDAP"
	}
	"Integration area" {
		$area_data_d="$dir_install\$com_nod\data\int";
		$area_3="int";
		$area_d="UXDIN"
	}
	"Simulation area" {
		$area_data_d="$dir_install\$com_nod\data\sim";
		$area_3="sim";
		$area_d="UXDSI"
	}
	"Production area" {
		$area_data_d="$dir_install\$com_nod\data\exp";
		$area_3="exp";
		$area_d="UXDEX"
	}
	default {
		$area_data_d="$dir_install\$com_nod\data\exp";
		$area_3="exp";
		$area_d="UXDEX"
	}
}
$base_data_d="$dir_install\$com_nod\data";
cp $dir_dufiles\data\*.idx $base_data_d
cp $dir_dufiles\data\*.dta $base_data_d
cp $dir_dufiles\data\*\*.idx $base_data_d
cp $dir_dufiles\data\*\*.dta $base_data_d

cp $dir_dufiles\$area_d\*.idx $area_data_d
cp $dir_dufiles\$area_d\*.dta $area_data_d
cp $dir_dufiles\$area_d\*\*.idx $area_data_d
cp $dir_dufiles\$area_d\*\*.dta $area_data_d

# Reorg or not?

$answer = Read-host "########## Do you want to run reorg? (y)/n"

If (! $answer.tolower().Contains("n")) {
	cmd /c "$UXMGR\uxsetenv & $UNI_DIR_EXEC\unireorg"
}
# Restarting $U
cmd /c "$UXMGR\uxsetenv & $UNI_DIR_EXEC\unistart";
$start_result=$?;
if ($start_result -ne "True") {
	[System.Windows.Forms.MessageBox]::Show("Failed to start $U.", "Error");
	[environment]::exit(1) 
}

$answer = Read-host "##########  Want to generate the listings? (y)/n"
If (! $answer.tolower().Contains("n")) {

#start-job -scriptblock {cmd /c "$UXMGR\uxsetenv & %UXEXE%\uxlst atm > d:\temp\uxlst_atm.txt"}
cmd /c "$UXMGR\uxsetenv & $UNI_DIR_EXEC\uxlst ctl full $area_3 >$dir_dufiles/../LST/dump_uxlst_ctl_full.txt";
cmd /c "$UXMGR\uxsetenv & $UNI_DIR_EXEC\uxlst fla full $area_3 >$dir_dufiles/../LST/dump_uxlst_fla_full.txt";
cmd /c "$UXMGR\uxsetenv & $UNI_DIR_EXEC\uxlst ctl hst $area_3 >$dir_dufiles/../LST/dump_uxlst_hst.txt";
cmd /c "$UXMGR\uxsetenv & $UNI_DIR_EXEC\uxlst evt full $area_3 >$dir_dufiles/../LST/dump_uxlst_evt_full.txt"
}
