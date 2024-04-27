param ([switch]$DoReboot, [switch]$UpdateList,[string]$DBPath)

if ($DoReboot) {

    # Load the XML file containing computer names
    $xmlPath = $DBPath#"C:\WinApps\XML\File.xml"
    $xml = [xml]::new()
    $xml.Load($xmlPath)

    # Get the list of computer names from the XML
    $ServerNames = $xml.SelectNodes("/Servers/Server/DNSName") | ForEach-Object { $_.InnerText }

    # Reboot each computer
    foreach ($ServerName in $ServerNames) {
        Write-Host "Rebooting computer: $ServerName"
        Restart-Computer -ComputerName $ServerName -Force
    }

}
if ($UpdateList) {

    Add-Type -AssemblyName System.Windows.Forms

    # Function to update the listbox with Server names
    function UpdateServerList {
        $listBox.Items.Clear()
        foreach ($Server in $xml.SelectNodes("/Servers/Server")) {
            #$id = $Server.SelectSingleNode("ID").InnerText
            $DNSName = $Server.SelectSingleNode("DNSName").InnerText
            $IPAddress = $Server.SelectSingleNode("IPAddress").InnerText
            $Farm = $Server.SelectSingleNode("Farm").InnerText
            $listBox.Items.Add("$DNSName --> $IPAddress --> $Farm")
        }
    }

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Integrity XML CRUD"
    $form.Size = New-Object System.Drawing.Size(400, 450)
    $form.StartPosition = "CenterScreen"

    # Create the XML document
    $xmlPath = $DBPath#"C:\WinApps\XML\File.xml"
    $xml = [xml]::new()
    $xml.Load($xmlPath)

    # Create the listbox to display Server names
    $listBox = New-Object System.Windows.Forms.ListBox
    $listBox.Location = New-Object System.Drawing.Point(20, 20)
    $listBox.Size = New-Object System.Drawing.Size(260, 200)
    $form.Controls.Add($listBox)

    # Create textboxes for data entry
    #$tbID = New-Object System.Windows.Forms.TextBox
    #$tbID.Location = New-Object System.Drawing.Point(100, 230)
    #$tbID.Size = New-Object System.Drawing.Size(180, 20)
    #$form.Controls.Add($tbID)

    $tbDNSName = New-Object System.Windows.Forms.TextBox
    $tbDNSName.Location = New-Object System.Drawing.Point(100, 260)
    $tbDNSName.Size = New-Object System.Drawing.Size(180, 20)
    $form.Controls.Add($tbDNSName)

    $tbIPAddress = New-Object System.Windows.Forms.TextBox
    $tbIPAddress.Location = New-Object System.Drawing.Point(100, 290)
    $tbIPAddress.Size = New-Object System.Drawing.Size(180, 20)
    $form.Controls.Add($tbIPAddress)

    $tbFarm = New-Object System.Windows.Forms.TextBox
    $tbFarm.Location = New-Object System.Drawing.Point(100, 320)
    $tbFarm.Size = New-Object System.Drawing.Size(180, 20)
    $form.Controls.Add($tbFarm)

    # Populate textboxes with selected Server data
    $listBox.Add_SelectedIndexChanged({
            $selectedServer = $xml.SelectNodes("/Servers/Server")[$listBox.SelectedIndex]
            #$tbID.Text = $selectedServer.SelectSingleNode("ID").InnerText
            $tbDNSName.Text = $selectedServer.SelectSingleNode("DNSName").InnerText
            $tbIPAddress.Text = $selectedServer.SelectSingleNode("IPAddress").InnerText
            $tbFarm.Text = $selectedServer.SelectSingleNode("Farm").InnerText
        })

    # Create buttons for CRUD operations
    $btnCreate = New-Object System.Windows.Forms.Button
    $btnCreate.Location = New-Object System.Drawing.Point(20, 350)
    $btnCreate.Size = New-Object System.Drawing.Size(80, 30)
    $btnCreate.Text = "Create"
    $btnCreate.Add_Click({
            $newServer = $xml.CreateElement("Server")
            #$newID = $xml.CreateElement("ID")
            $newDNSName = $xml.CreateElement("DNSName")
            $newIPAddress = $xml.CreateElement("IPAddress")
            $newFarm = $xml.CreateElement("Farm")

            #$newID.InnerText = $tbID.Text
            $newDNSName.InnerText = $tbDNSName.Text
            $newIPAddress.InnerText = $tbIPAddress.Text
            $newFarm.InnerText = $tbFarm.Text

            #$newServer.AppendChild($newID)
            $newServer.AppendChild($newDNSName)
            $newServer.AppendChild($newIPAddress)
            $newServer.AppendChild($newFarm)

            $xml.DocumentElement.AppendChild($newServer)
            $xml.Save($xmlPath)
            UpdateServerList
        })
    $form.Controls.Add($btnCreate)

    $btnUpdate = New-Object System.Windows.Forms.Button
    $btnUpdate.Location = New-Object System.Drawing.Point(110, 350)
    $btnUpdate.Size = New-Object System.Drawing.Size(80, 30)
    $btnUpdate.Text = "Update"
    $btnUpdate.Add_Click({
            if ($listBox.SelectedIndex -ge 0) {
                $selectedServer = $xml.SelectNodes("/Servers/Server")[$listBox.SelectedIndex]
                #$selectedServer.SelectSingleNode("ID").InnerText = $tbID.Text
                $selectedServer.SelectSingleNode("DNSName").InnerText = $tbDNSName.Text
                $selectedServer.SelectSingleNode("IPAddress").InnerText = $tbIPAddress.Text
                $selectedServer.SelectSingleNode("Farm").InnerText = $tbFarm.Text

                $xml.Save($xmlPath)
                UpdateServerList
            }
        })
    $form.Controls.Add($btnUpdate)

    $btnDelete = New-Object System.Windows.Forms.Button
    $btnDelete.Location = New-Object System.Drawing.Point(200, 350)
    $btnDelete.Size = New-Object System.Drawing.Size(80, 30)
    $btnDelete.Text = "Delete"
    $btnDelete.Add_Click({
            if ($listBox.SelectedIndex -ge 0) {
                $selectedServer = $xml.SelectNodes("/Servers/Server")[$listBox.SelectedIndex]
                $xml.DocumentElement.RemoveChild($selectedServer)

                $xml.Save($xmlPath)
                UpdateServerList
                #$tbID.Clear()
                $tbDNSName.Clear()
                $tbIPAddress.Clear()
                $tbFarm.Clear()
            }
        })
    $form.Controls.Add($btnDelete)

    # Initial update of the listbox
    UpdateServerList

    # Display the form
    $form.ShowDialog()

}
else{
    Write-Host "Choose one of 2 options and set path to XML file, no options were selected!" -ForegroundColor Red -BackgroundColor Yellow
    Start-Sleep -Seconds 1
    Write-Host "           " -BackgroundColor White
    Start-Sleep -Seconds 1
    Write-Host "           " -BackgroundColor Blue
    Start-Sleep -Seconds 1
    Write-Host "           " -BackgroundColor Red
}
