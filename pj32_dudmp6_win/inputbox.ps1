
$dir_dufiles=""
$dir_template=""
$dir_v6kit=""
$dir_install=""
$node_=""
$company_=""
function input_box ($dir_dufiles, $dir_template, $dir_v6kit, $dir_install, $node_, $company_) {

[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 

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
$objLabel_v6kit.Text = "The path of the unpacked V6 kit:"
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
