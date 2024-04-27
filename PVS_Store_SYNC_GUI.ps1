# new powershell gui
# start date: 12.03.2024
# last edit: 07.04.2024
# syntax note: comments and explanations above commands

# clearing variables each time script runs
Get-Location
if ($null -ne $first_path -xor $null -ne $second_path -xor $null -ne $both_path -xor $null -ne $process_id -xor $null -ne $param) {

    Clear-Variable first_path 
    Clear-Variable second_path
    Clear-Variable both_path
    Clear-Variable process_id
    Clear-Variable param

}

#minimize console function
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'

function ShowConsole {
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 5) #5 show
}
#ShowConsole

function HideConsole {
    $consolePtr = [Console.Window]::GetConsoleWindow()
    [Console.Window]::ShowWindow($consolePtr, 0) #0 hide
}
#Setting console to be hidden
HideConsole


# Global VARs

$Global:XmLPath = 'D:\TEST\\PVS_SYNC.xml'
$Global:Log_Path = 'D:\TEST\'
$Global:LogName = ''
#$Global:PicPath = 'D:\TEST\Pinguin.jpg'
$Global:PicByte = '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'



# create main function
function global:MainProgram {

    # modules for windows forms are loaded
    [reflection.assembly]::loadwithpartialname("System.Windows.Forms") | Out-Null
    [reflection.assembly]::loadwithpartialname("System.Drawing") | Out-Null

    # clear Host is clearing the text output when running program
    clear-Host

    # clear the error variable to do better debugging later on
    $error.clear()

    # if error appears, program will continue
    $errorActionPreference = "SilentlyContinue"

    # popup defintion
    function global:popup_one {
        $wsh = New-Object -ComObject Wscript.Shell
        $wsh.Popup("Please select start and destination directory!", "0", "Error!", 0x1)
    }
    # popup CheckBox defintion
    function global:popup_checkbox {
        $wsh = New-Object -ComObject Wscript.Shell
        $wsh.Popup("Please select PVS Store Sync CheckBox!", "0", "Error!", 0x1)
    }

    # Create new config file
    

    # definition of handler click actions
    
    # launch folder dialog 1
    $global:handler_1_click = {

        $TextBox1.Clear()
        #Textbox will be cleared

        $FolderBrowser1 = New-Object System.Windows.Forms.FolderBrowserDialog
        #declaring FolderBrowserDialog
        
        $FolderBrowser1.ShowDialog() | Out-Null
        #Showing FolderDialog

        #Declaring folder choice to variable
        $global:First_Selected_Path = $FolderBrowser1.SelectedPath
        
        #Adding chosen path to Textbox next to search... button
        $TextBox1.ReadOnly = $false
        $global:TextBox1.AppendText($First_Selected_Path)
        $TextBox1.ReadOnly = $true
        


           
        }

  

    # launch folder dialog 2
    $global:handler_2_Click = {
        # Create an empty XML document
        [xml]$xmlDoc = New-Object System.Xml.XmlDocument

        # Create the root element
        $root = $xmlDoc.CreateElement("PVS_Servers")
        $xmlDoc.AppendChild($root)

        for($i=1;$i -le 5;$i++){
        # Add first book
        $Object = $xmlDoc.CreateElement("PVS_Server")
        $root.AppendChild($Object)

        $ChildElement1 = $xmlDoc.CreateElement("Server_Name")
        $ChildElement1.InnerText = 'PVS0'+$i
        $Object.AppendChild($ChildElement1)

        $ChildElement2 = $xmlDoc.CreateElement("Store_Path")
        $ChildElement2.InnerText = '\\PVS_Server\Store_Path'+$i
        $Object.AppendChild($ChildElement2)
    }
        # Save the XML content to a file
        $xmlDoc.Save($XmLPath)
        handler_5_Click
        }

    

    # start-job defintion
    $global:handler_3_Click = {
        
        if ( ($TextBox1.Text.Length -lt 1) -OR ($ListBoxBox2.Items.Count -lt 1) ) {
            popup_one
            return
        }
        <#
        if ($checkBox1.Checked) {
            $param = "/L "
        }

        if ($checkBox2.Checked) {
            $param = $param + "/E "
        }

        if ($checkBox3.Checked) {
            $param = $param + "/R:0 " , "/W:0 "
        }
        
        
        if ($checkBox4.Checked) {
            $param = $param + "/MIR"
        }

        if ($checkBox5.Checked) {
            $param = $param + "/Mov"
        }

        if ($checkBox6.Checked) {
            $param = $param + "/NFL /NDL"
        }
        #> 
        $RichTextBox1.Clear()
        $RichTextBox1.ReadOnly = $false
        $RichTextBox1.AppendText("Job started... `n `n")
        $RichTextBox1.ReadOnly = $true

        #Start-Sleep -Seconds 2

        $get_transfer_size = "{0:N2}" -f ((Get-ChildItem -path $first_selected_path -recurse | Measure-Object -property length -sum ).sum /1GB) + " GB"

        $RichTextBox1.ReadOnly = $false
        $RichTextBox1.AppendText("Transfer-Size: $get_transfer_size`n`n")
        $RichTextBox1.ReadOnly = $true


        if  ($checkBox7.Checked) {
            #start-process -FilePath C:\Windows\System32\cmd.exe -ArgumentList ("/K" , "color a & robocopy" , "$both_path" , "$param") -PassThru -WindowStyle Minimized
            $param = "*.vhd *.vhdx *.avhd *.avhdx *.pvp /mir /xf *.lok /xd WriteCache /xo /R:1 /W:1 /MT:32"
            #####
            $xml = New-Object XML
            $xml.load($XmLPath)
          
            foreach ($Serv in $xml.SelectNodes("/PVS_Servers/PVS_Server")) {
             
             $Dst = $Serv.SelectSingleNode("Store_Path").InnerText
             $Srv1 = $Serv.SelectSingleNode("Server_Name").InnerText
             $LogName = $Log_Path+$Srv1+"_PVS_SYNC.log"
             $LogFullPath = "/LOG:$LogName"
             $Surce = $TextBox1.Text
             [string]$Command =$Surce+' '+$Dst+' '+$param+' '+$LogFullPath
             Start-Process "RoboCopy.exe" -ArgumentList $Command
             $RichTextBox1.ReadOnly = $false
             $RichTextBox1.AppendText("The following directories are affected:`n`n$First_Selected_Path wird kopiert in  ------>  $Dst `n`nThe following parameters were used:`n $param `n`n")
             $RichTextBox1.ReadOnly = $true
             }
            #####
            
            
             
            
        }

        if  (!$checkBox7.Checked){
            popup_checkbox
            return
        }
        
        else {
            $Surce = $TextBox1.Text
            $Dst = $TextBox2.Text
            [string]$Command =$Surce+' '+$Dst+' '+$param 
            Start-Process "RoboCopy.exe" -ArgumentList $Command
            start-process -FilePath C:\Windows\System32\cmd.exe -ArgumentList ("/K" , "color a & robocopy" , "$Command") -PassThru -WindowStyle Hidden
            $RichTextBox1.ReadOnly = $false
            $RichTextBox1.AppendText("The following directories are affected:`n`n$First_Selected_path wird kopiert in  ------>  $Second_selected_path`n`nThe following parameters were used:`n $param")          
            $RichTextBox1.ReadOnly = $true
        }
    }

    # stop-job definition
    $global:handler_4_Click = {

        Add-Type -AssemblyName PresentationCore, PresentationFramework
        $ButtonType = [System.Windows.MessageBoxButton]::YesNoCancel
        $MessageIcon = [System.Windows.MessageBoxImage]::Error
        $MessageBody = "Are you sure you want to finish every Robocopy job? Attention: Every Robocopy job is interrupted."
        $MessageTitle = "Confirm Cancel"
        $Result = [System.Windows.MessageBox]::Show($MessageBody, $MessageTitle, $ButtonType, $MessageIcon)

        switch ($Result) {
            'Yes' {
                Stop-Process -ProcessName Robocopy -Force
            }
            'No' {
            }
            'Cancel' {
            }
        }
        
    }

    Function handler_5_Click {
        # Function to update the listbox with Server names
        $xml = New-Object XML
        $xml.load($XmLPath)
        $ListBoxBox2.Items.Clear()
          
           foreach ($Serv in $xml.SelectNodes("/PVS_Servers/PVS_Server")) {
           
           #$ServerName = $Serv.SelectSingleNode("Server_Name").InnerText
           $StorePath = $Serv.SelectSingleNode("Store_Path").InnerText
           $ListBoxBox2.Items.Add($StorePath)
           }
       
       }



    

    #refresh click definition
    $global:refresh_click = { 
        Function MakeNewForm {
            $mainform.Close()
            #Closes the form
            $mainform.Dispose()
            MainProgram
            #reopen the main program
        }
        MakeNewForm  
    }

        

    # start of form definition function
    function global:FormDefinition {

        # main window
        # main form definition
        $mainform = New-Object System.Windows.Forms.Form
        # name of the form which will be displayed
        $mainform.Text = "PVS Sync"
        # just a name for the form - wont be displayed
        $mainform.Name = "mainform"
        # comment
        $mainform.DataBindings.DefaultDataSourceUpdateMode = 0
        # "import" to be able to define form size
        $system_Drawing_Size = New-Object System.Drawing.Size
        # form width definition
        $system_Drawing_Size.Width = 800
        # form height definition
        $system_Drawing_Size.Height = 600
        # tell that var is drawing size var
        $mainform.ClientSize = $System_Drawing_Size

        # define form will be in foreground opened
        $mainform.Top = $false
        
        # define windows is fixed and cant be resized.
        # (https://docs.microsoft.com/de-de/dotnet/api/system.windows.forms.formborderstyle?view=windowsdesktop-6.0)
        $mainform.FormBorderStyle = 'Fixed3D'
        # define if form can be maximized or not
        $mainform.MaximizeBox = $false
        # define form will pop up in center of screen
        $mainform.StartPosition = "CenterScreen"
        #Save the initial state of the form
        #$initialFormWindowState = $mainform.WindowState
        #Init the OnLoad event to correct the initial state of the form
        $mainform.add_Load($OnLoadForm_StateCorrection)
        
        
        # TextBox 1 definition
        $global:TextBox1 = New-Object System.Windows.Forms.TextBox
        #$TextBox1.FormattingEnabled = $True
        $System_Drawing_Size = New-Object System.Drawing.Size
        $System_Drawing_Size.Width = 400
        $System_Drawing_Size.Height = 20
        $TextBox1.Size = $System_Drawing_Size
        $TextBox1.DataBindings.DefaultDataSourceUpdateMode = 0
        $TextBox1.Name = "RichTextBox1"
        $System_Drawing_Point = New-Object System.Drawing.Point
        $System_Drawing_Point.X = 195
        $System_Drawing_Point.Y = 70
        $TextBox1.Location = $System_Drawing_Point
        $TextBox1.ReadOnly = $true
        $Textbox1.TabIndex = 4
        $TextBox1.Font = [System.Drawing.Font]::New('Tahoma', 12)

        # TextBox Server definition
        $global:TextBoxServer = New-Object System.Windows.Forms.TextBox
        #$TextBox2.FormattingEnabled = $True
        $System_Drawing_Size = New-Object System.Drawing.Size
        $System_Drawing_Size.Width = 400
        $System_Drawing_Size.Height = 20
        $TextBoxServer.Size = $System_Drawing_Size
        $TextBoxServer.DataBindings.DefaultDataSourceUpdateMode = 0
        $TextBoxServer.Name = "RichTextBoxServer"
        $System_Drawing_Point = New-Object System.Drawing.Point
        $System_Drawing_Point.X = 195
        $System_Drawing_Point.Y = 290
        $TextBoxServer.Location = $System_Drawing_Point
        $TextBoxServer.ReadOnly = $false
        $TextboxServer.TabIndex = 4
        $TextBoxServer.Font = [System.Drawing.Font]::New('Tahoma', 12)

        # TextBox Path definition
        $global:TextBoxPath = New-Object System.Windows.Forms.TextBox
        #$TextBox2.FormattingEnabled = $True
        $System_Drawing_Size = New-Object System.Drawing.Size
        $System_Drawing_Size.Width = 400
        $System_Drawing_Size.Height = 20
        $TextBoxPath.Size = $System_Drawing_Size
        $TextBoxPath.DataBindings.DefaultDataSourceUpdateMode = 0
        $TextBoxPath.Name = "RichTextBoxPath"
        $System_Drawing_Point = New-Object System.Drawing.Point
        $System_Drawing_Point.X = 195
        $System_Drawing_Point.Y = 350
        $TextBoxPath.Location = $System_Drawing_Point
        $TextBoxPath.ReadOnly = $false
        $TextboxPath.TabIndex = 4
        $TextBoxPath.Font = [System.Drawing.Font]::New('Tahoma', 12)

        # RichTextBox 1 definition
        $RichTextBox1 = New-Object System.Windows.Forms.RichTextBox
        #$RichTextBox1.FormattingEnabled = $True
        $System_Drawing_Size = New-Object System.Drawing.Size
        $System_Drawing_Size.Width = 760
        $System_Drawing_Size.Height = 170
        $RichTextBox1.Size = $System_Drawing_Size
        $RichTextBox1.DataBindings.DefaultDataSourceUpdateMode = 0
        $RichTextBox1.Name = "RichTextBox1"
        $System_Drawing_Point = New-Object System.Drawing.Point
        $System_Drawing_Point.X = 20 
        $System_Drawing_Point.Y = 390
        $RichTextBox1.Location = $System_Drawing_Point
        $RichTextBox1.ReadOnly = $true
        $RichTextBox1.Font = [System.Drawing.Font]::New('Tahoma', 10)

        # ListBox 2 definition
        $global:ListBoxBox2 = New-Object System.Windows.Forms.ListBox
        $System_Drawing_Size = New-Object System.Drawing.Size
        $System_Drawing_Size.Width = 400
        $System_Drawing_Size.Height = 80
        $ListBoxBox2.Size = $System_Drawing_Size
        $ListBoxBox2.DataBindings.DefaultDataSourceUpdateMode = 0
        $ListBoxBox2.Name = "ListBox2"
        $System_Drawing_Point = New-Object System.Drawing.Point
        $System_Drawing_Point.X = 195 
        $System_Drawing_Point.Y = 190
        $ListBoxBox2.Location = $System_Drawing_Point
        $ListBoxBox2.ReadOnly = $false
        $ListBoxBox2.Font = [System.Drawing.Font]::New('Tahoma', 10)
        #$ListBoxBox
        #$ListBoxBox2.Items.Add("ssssssss")

        # Populate textboxes with selected Server data
        $ListBoxBox2.Add_SelectedIndexChanged({
            $xml = New-Object XML
            $xml.load($XmLPath)
            $selectedServer = $xml.SelectNodes("/PVS_Servers/PVS_Server")[$ListBoxBox2.SelectedIndex]
            #$tbID.Text = $selectedServer.SelectSingleNode("ID").InnerText
            $TextBoxServer.Text = $selectedServer.SelectSingleNode("Server_Name").InnerText
            $TextBoxPath.Text = $selectedServer.SelectSingleNode("Store_Path").InnerText
            })


        
        
        # label 1
        $label1 = New-Object System.Windows.Forms.Label
        $label1.Location = New-Object System.Drawing.Point(200, 30)
        $label1.Size = New-Object System.Drawing.Size(400, 20)
        $label1.Font = new-object System.Drawing.Font('Ariel', 10, [System.Drawing.FontStyle]::Regular)
        $label1.Text = 'Select the Source PVS Store Location:'
        $label1.Font = [System.Drawing.Font]::New('Tahoma', 12)
        
        # label 2
        $label2 = New-Object System.Windows.Forms.Label
        $label2.Location = New-Object System.Drawing.Point(200, 150)
        $label2.Size = New-Object System.Drawing.Size(400, 20)
        $label2.Font = new-object System.Drawing.Font('Ariel', 10, [System.Drawing.FontStyle]::Regular)
        $label2.Text = 'Select the Destination PVS Store Location:'
        $label2.Font = [System.Drawing.Font]::New('Tahoma', 12)

        # label 3 (LOG)
        $label3 = New-Object System.Windows.Forms.Label
        $label3.Location = New-Object System.Drawing.Point(20, 370)
        $label3.Size = New-Object System.Drawing.Size(400, 20)
        $label3.Font = new-object System.Drawing.Font('Ariel', 10, [System.Drawing.FontStyle]::Regular)
        $label3.Text = 'Log:'
        $label3.Font = [System.Drawing.Font]::New('Tahoma', 10)

        # label Server
        $labelServer = New-Object System.Windows.Forms.Label
        $labelServer.Location = New-Object System.Drawing.Point(200, 270)
        $labelServer.Size = New-Object System.Drawing.Size(400, 20)
        $labelServer.Font = new-object System.Drawing.Font('Ariel', 10, [System.Drawing.FontStyle]::Regular)
        $labelServer.Text = 'Selected destination Server:'
        $labelServer.Font = [System.Drawing.Font]::New('Tahoma', 12)

        # label Path
        $labelPath = New-Object System.Windows.Forms.Label
        $labelPath.Location = New-Object System.Drawing.Point(200, 330)
        $labelPath.Size = New-Object System.Drawing.Size(400, 20)
        $labelPath.Font = new-object System.Drawing.Font('Ariel', 10, [System.Drawing.FontStyle]::Regular)
        $labelPath.Text = 'Selected destination Path:'
        $labelPath.Font = [System.Drawing.Font]::New('Tahoma', 12)

        


        ### buttons

        ## Copy-Directory
        $Choose_Copy_Directory_Button = New-Object System.Windows.Forms.Button
        $Choose_Copy_Directory_Button.Location = New-Object System.Drawing.Point(620, 70) #y und x Achse
        $Choose_Copy_Directory_Button.Size = New-Object System.Drawing.Size(75, 23)
        # text of button 
        $Choose_Copy_Directory_Button.Text = 'Search..'
        $Choose_Copy_Directory_Button.TabIndex = 6
        # define what happens if click
        $Choose_Copy_Directory_Button.add_Click($handler_1_Click)

        ## Create button
        $CreateButton = New-Object System.Windows.Forms.Button
        $CreateButton.Location = New-Object System.Drawing.Point(620, 190) #y und x Achse
        $CreateButton.Size = New-Object System.Drawing.Size(75, 23)
        # text of button 
        $CreateButton.Text = 'Reset'
        $CreateButton.TabIndex = 7
        $CreateButton.Enabled = $false
        # define what happens if click
        $CreateButton.add_Click($handler_2_Click)

        ## Update button
        $UpdateButton = New-Object System.Windows.Forms.Button
        $UpdateButton.Location = New-Object System.Drawing.Point(620, 220) #y und x Achse
        $UpdateButton.Size = New-Object System.Drawing.Size(75, 23)
        # text of button 
        $UpdateButton.Text = 'Update..'
        $UpdateButton.TabIndex = 7
        # define what happens if click
        $UpdateButton.Add_Click({
            if ($ListBoxBox2.SelectedIndex -ge 0) {
                $xml = New-Object XML
                $xml.load($XmLPath)
                $selectedServer = $xml.SelectNodes("/PVS_Servers/PVS_Server")[$ListBoxBox2.SelectedIndex]
                $selectedServer.SelectSingleNode("Server_Name").InnerText = $TextBoxServer.Text
                $selectedServer.SelectSingleNode("Store_Path").InnerText = $TextBoxPath.Text
        
                $xml.Save($XmLPath)
                handler_5_Click
            }
        })

        ## Delete button
        $DeleteButton = New-Object System.Windows.Forms.Button
        $DeleteButton.Location = New-Object System.Drawing.Point(620, 250) #y und x Achse
        $DeleteButton.Size = New-Object System.Drawing.Size(75, 23)
        # text of button 
        $DeleteButton.Text = 'Delete..'
        $DeleteButton.TabIndex = 7
        # define what happens if click
        $DeleteButton.add_Click({
            if ($ListBoxBox2.SelectedIndex -ge 0) {
                $xml = New-Object XML
                $xml.load($XmLPath)
                $selectedServer = $xml.SelectNodes("/PVS_Servers/PVS_Server")[$ListBoxBox2.SelectedIndex]
                $xml.DocumentElement.RemoveChild($selectedServer)

                $xml.Save($XmLPath)
                handler_5_Click
                #$tbID.Clear()
                $TextboxServer.Clear()
                $TextboxPath.Clear()
        
            }
        })

        ## Create New Server button
        $CreateNewButton = New-Object System.Windows.Forms.Button
        $CreateNewButton.Location = New-Object System.Drawing.Point(620, 280) #y und x Achse
        $CreateNewButton.Size = New-Object System.Drawing.Size(75, 23)
        # text of button 
        $CreateNewButton.Text = 'New'
        $CreateNewButton.TabIndex = 7
        $CreateNewButton.Enabled = $true
        # define what happens if click
        $CreateNewButton.Add_Click({
            $xml = New-Object XML
            $xml.load($XmLPath)
            $newServer = $xml.CreateElement("PVS_Server")
            #$newID = $xml.CreateElement("ID")
            $newServer_Name = $xml.CreateElement("Server_Name")
            $newStore_Path = $xml.CreateElement("Store_Path")
        
            #$newID.InnerText = $tbID.Text
            $newServer_Name.InnerText = $TextBoxServer.Text
            $newStore_Path.InnerText =  $TextBoxPath.Text
        
            #$newServer.AppendChild($newID)
            $newServer.AppendChild($newServer_Name)
            $newServer.AppendChild($newStore_Path)
        
            $xml.DocumentElement.AppendChild($newServer)
            $xml.Save($XmLPath)
            handler_5_Click
            $TextboxServer.Clear()
            $TextboxPath.Clear()
        })


        ## Quit button
        $CancelButton = New-Object System.Windows.Forms.Button
        $CancelButton.Location = New-Object System.Drawing.Point(705, 570) #y und x Achse
        $CancelButton.Size = New-Object System.Drawing.Size(75, 23)
        # text of button 
        $CancelButton.Text = 'Cancel'
        # define what happens if click
        $CancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
        # define color of the button text - default is black
        $CancelButton.ForeColor = "red"
        # define color of the background of button - default is white/gray
        #$CancelButton.BackColor = "red"

        ## start-job button
        $start_job_button = New-Object System.Windows.Forms.Button
        $start_job_button.Location = New-Object System.Drawing.Point(324, 570 ) #y und x Achse
        $start_job_button.Size = New-Object System.Drawing.Size(75, 23)
        $start_job_button.Text = 'Start'
        $start_job_button.ForeColor = "white"
        $start_job_button.BackColor = "green"
        $start_job_button.TabIndex = 8
        $start_job_button.add_Click($handler_3_Click)

        ## stop job button definition
        $stop_job_button = New-Object System.Windows.Forms.Button
        $stop_job_button.Location = New-Object System.Drawing.Point(424, 570 ) #Y und x Achse
        $stop_job_button.Size = New-Object System.Drawing.Size(75, 23)
        $stop_job_button.Text = 'Stop'
        $stop_job_button.ForeColor = "white"
        $stop_job_button.BackColor = "red"
        $stop_job_button.TabIndex = 9
        $stop_job_button.add_Click($handler_4_Click)

        #Refresh Button
        $RefreshButton = New-Object System.Windows.Forms.Button
        $RefreshButton.Location = New-Object System.Drawing.Point(20, 570 ) #X und Y Achse
        $RefreshButton.Size = New-Object System.Drawing.Size(75, 23)
        $RefreshButton.Text = 'Refresh'
        $RefreshButton.add_Click($refresh_click)

        # checkbox 1 definition
        $global:checkBoxRes = New-Object System.Windows.Forms.CheckBox
        $checkBoxRes.UseVisualStyleBackColor = $True
        $System_Drawing_Size = New-Object System.Drawing.Size
        $System_Drawing_Size.Width = 155
        $System_Drawing_Size.Height = 30
        $checkBoxRes.Size = $System_Drawing_Size
        $checkBoxRes.TabIndex = 0
        $checkBoxRes.Text = "(RES)"
        $System_Drawing_Point = New-Object System.Drawing.Point
        $System_Drawing_Point.X = 715
        $System_Drawing_Point.Y = 185
        $checkBoxRes.Location = $System_Drawing_Point
        $checkBoxRes.DataBindings.DefaultDataSourceUpdateMode = 0
        $checkBoxRes.Name = "checkBoxRes"
        $checkBoxRes.add_CheckedChanged({
             $CreateButton.Enabled = $checkBoxRes.Checked
            
            })

        #Checkbox 2 wird definiert
        $global:checkBox2 = New-Object System.Windows.Forms.CheckBox
        $checkBox2.UseVisualStyleBackColor = $True
        $System_Drawing_Size = New-Object System.Drawing.Size
        $System_Drawing_Size.Width = 155
        $System_Drawing_Size.Height = 30
        $checkBox2.Size = $System_Drawing_Size
        $checkBox2.TabIndex = 1
        $checkBox2.Text = "Also (empty) subdirectories (/E)"
        $System_Drawing_Point = New-Object System.Drawing.Point
        $System_Drawing_Point.X = 20
        $System_Drawing_Point.Y = 70
        $checkBox2.Location = $System_Drawing_Point
        $checkBox2.DataBindings.DefaultDataSourceUpdateMode = 0
        $checkBox2.Name = "checkBox2"

        #$checkbox2.Checked = $true
        #$checkbox2.Enabled = $false
        
        #Checkbox 3 wird definiert
        $global:checkBox3 = New-Object System.Windows.Forms.CheckBox
        $checkBox3.UseVisualStyleBackColor = $True
        $System_Drawing_Size = New-Object System.Drawing.Size
        $System_Drawing_Size.Width = 155
        $System_Drawing_Size.Height = 30
        $checkBox3.Size = $System_Drawing_Size
        $checkBox3.TabIndex = 2
        $checkBox3.Text = "Ignore Errors (/R:0, /W:0)"
        $System_Drawing_Point = New-Object System.Drawing.Point
        $System_Drawing_Point.X = 20
        $System_Drawing_Point.Y = 120
        $checkBox3.Location = $System_Drawing_Point
        $checkBox3.DataBindings.DefaultDataSourceUpdateMode = 0
        $checkBox3.Name = "checkBox3"

        #$checkbox3.Checked = $true
        #$checkbox3.Enabled = $false

        #Checkbox 4 wird definiert
        $global:checkBox4 = New-Object System.Windows.Forms.CheckBox
        $checkBox4.UseVisualStyleBackColor = $True
        $System_Drawing_Size = New-Object System.Drawing.Size
        $System_Drawing_Size.Width = 155
        $System_Drawing_Size.Height = 30
        $checkBox4.Size = $System_Drawing_Size
        $checkBox4.TabIndex = 3
        $checkBox4.Text = "Delete destination folder content"
        $System_Drawing_Point = New-Object System.Drawing.Point
        $System_Drawing_Point.X = 20
        $System_Drawing_Point.Y = 170
        $checkBox4.Location = $System_Drawing_Point
        $checkBox4.DataBindings.DefaultDataSourceUpdateMode = 0
        $checkBox4.Name = "checkBox4"

        #Checkbox 5 wird definiert
        $global:checkBox5 = New-Object System.Windows.Forms.CheckBox
        $checkBox5.UseVisualStyleBackColor = $True
        $System_Drawing_Size = New-Object System.Drawing.Size
        $System_Drawing_Size.Width = 155
        $System_Drawing_Size.Height = 30
        $checkBox5.Size = $System_Drawing_Size
        $checkBox5.TabIndex = 4
        $checkBox5.Text = "Delete origin folder contents"
        $System_Drawing_Point = New-Object System.Drawing.Point
        $System_Drawing_Point.X = 20
        $System_Drawing_Point.Y = 220
        $checkBox5.Location = $System_Drawing_Point
        $checkBox5.DataBindings.DefaultDataSourceUpdateMode = 0
        $checkBox5.Name = "checkBox5"

        #Checkbox 6 wird definiert
        $global:checkBox6 = New-Object System.Windows.Forms.CheckBox
        $checkBox6.UseVisualStyleBackColor = $True
        $System_Drawing_Size = New-Object System.Drawing.Size
        $System_Drawing_Size.Width = 155
        $System_Drawing_Size.Height = 30
        $checkBox6.Size = $System_Drawing_Size
        $checkBox6.TabIndex = 5
        $checkBox6.Text = "Do not show progress"
        $System_Drawing_Point = New-Object System.Drawing.Point
        $System_Drawing_Point.X = 20
        $System_Drawing_Point.Y = 270
        $checkBox6.Location = $System_Drawing_Point
        $checkBox6.DataBindings.DefaultDataSourceUpdateMode = 0
        $checkBox6.Name = "checkBox6"

        #Checkbox 7 wird definiert
        $global:checkBox7 = New-Object System.Windows.Forms.CheckBox
        $checkBox6.UseVisualStyleBackColor = $True
        $System_Drawing_Size = New-Object System.Drawing.Size
        $System_Drawing_Size.Width = 155
        $System_Drawing_Size.Height = 30
        $checkBox7.Size = $System_Drawing_Size
        $checkBox7.TabIndex = 5
        $checkBox7.Text = "PVS Store Sync"
        $System_Drawing_Point = New-Object System.Drawing.Point
        $System_Drawing_Point.X = 210
        $System_Drawing_Point.Y = 567
        $checkBox7.Location = $System_Drawing_Point
        $checkBox7.DataBindings.DefaultDataSourceUpdateMode = 0
        $checkBox7.Name = "checkBox7"
        $checkBox7.BackColor = "Yellow"
        #$checkBox7.Checked = $true
        $checkbox7.add_CheckedChanged({

        $checkBox1.Enabled = -not $checkbox7.Checked
        $checkbox1.Checked = -not $checkbox7.Checked

        $checkBox2.Enabled = -not $checkbox7.Checked
        $checkbox2.Checked = -not $checkbox7.Checked

        $checkBox3.Enabled = -not $checkbox7.Checked
        $checkbox3.Checked = -not $checkbox7.Checked

        $checkBox4.Enabled = -not $checkbox7.Checked
        $checkbox4.Checked = -not $checkbox7.Checked

        $checkBox5.Enabled = -not $checkbox7.Checked
        $checkbox5.Checked = -not $checkbox7.Checked

        $checkBox6.Enabled = -not $checkbox7.Checked
        $checkbox6.Checked = -not $checkbox7.Checked
        })

        #$file3 = (get-item $PicPath)
        $Image = [Drawing.Bitmap]::FromStream([IO.MemoryStream][Convert]::FromBase64String($PicByte))
        #$global:img3 = [System.Drawing.Image]::FromStream($Image)
        #$img3.UseVisualStyleBackColor = $True
        
        $pictureBox2 = new-object Windows.Forms.PictureBox
        $System_Drawing_Size = New-Object System.Drawing.Size
        $System_Drawing_Size.Width = 155
        $System_Drawing_Size.Height = 155
        $pictureBox2.Size = $System_Drawing_Size
        $pictureBox2.Image = $Image
        #$pictureBox2.SizeMode = "Autosize"
        $pictureBox2.Anchor = "Bottom, right"
        $System_Drawing_Point = New-Object System.Drawing.Point
        $System_Drawing_Point.X = 20
        $System_Drawing_Point.Y = 170
        $pictureBox2.Location = $System_Drawing_Point
        $pictureBox2.DataBindings.DefaultDataSourceUpdateMode = 0
        $pictureBox2.TabIndex = 5
        $pictureBox2.Name = "pictureBox2"
        

        
               
        # implement all things to mainform

        # implement textboxes
        $mainform.Controls.Add($TextBox1)
        $mainform.Controls.Add($TextBoxServer)
        $mainform.Controls.Add($TextBoxPath)
        

        # implement RichTextBox
        $mainform.Controls.Add($RichTextBox1)
        $mainform.Controls.Add($ListBoxBox2)
        $mainform.Controls.Add($pictureBox2)
        # implement labels
        $mainform.Controls.Add($label1)
        $mainform.Controls.Add($label2)
        $mainform.Controls.Add($label3)
        $mainform.Controls.Add($label4)
        $mainform.Controls.Add($labelServer)
        $mainform.Controls.Add($labelPath)

        # implement all action buttons
        $mainform.Controls.Add($Choose_Copy_Directory_Button)
        $mainform.Controls.Add($CreateButton)
        $mainform.Controls.Add($UpdateButton)
        $mainform.Controls.Add($DeleteButton)
        $mainform.Controls.Add($CancelButton)
        $mainform.Controls.Add($start_job_button)
        $mainform.Controls.Add($stop_job_button)
        $mainform.Controls.Add($RefreshButton)
        $mainform.Controls.Add($CreateNewButton)

        
        
        # implement checkboxes
        $mainform.Controls.Add($checkBoxRes)
        <#
        $mainform.Controls.Add($checkBox2)
        $mainform.Controls.Add($checkBox3)
        $mainform.Controls.Add($checkBox4)
        $mainform.Controls.Add($checkBox5)
        $mainform.Controls.Add($checkBox6)
        #>
        $mainform.Controls.Add($checkBox7)
        
        # show the form
        handler_5_Click
        $mainform.ShowDialog() | Out-Null
    }
    FormDefinition
}

# call the main program
MainProgram
