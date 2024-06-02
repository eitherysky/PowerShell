<#
.SYNOPSIS
    This script monitors a specific file and executes a program based on the file's contents.

.DESCRIPTION
    The script continuously checks the contents of a designated "flag" file. When the file contains specific trigger words, the script starts a corresponding program. It's intended for automation tasks where external triggers are needed to start various processes.

.PARAMETER Interval
    The interval in seconds at which the file is checked.

.PARAMETER RefFilePath
    The path to the reference file that the script monitors.

.PARAMETER LogFile
    The path to the log file where all operational logs are stored.

.EXAMPLE
    PS> .\MonitorScript.ps1
    This command runs the script using the default settings defined within the script variables.

.NOTES
    Author: Alex Dan
    Created: 01/05/2024
    Last Updated: 07/05/2024
    Version: 1.0
#>

# Define global variables
$Global:Interval = 2
$Global:RefFilePath = "D:\TEST\Listener\Flag.txt"
$Global:LogFile = "D:\TEST\Listener\Log.txt"
$Global:ProgToStart = "cmd.exe"
$Global:maxSize = 1048576 # 1 MB in bytes

# Function to remove the first N lines from the file
function Remove-FirstLines {
    param (
        [string]$file,
        [int]$linesToRemove
    )
    
    # Read the file into an array, skipping the first N lines
    $content = Get-Content $file | Select-Object -Skip $linesToRemove
    
    # Write the remaining lines back to the file
    Set-Content -Path $file -Value $content
}

# Check if the file size exceeds the maximum size
function Check-FileSize {

    $fileSize = (Get-Item $LogFile).Length

    if ($fileSize -gt $maxSize) {
        # Calculate the number of lines to remove (this is a simple example)
        $linesToRemove = 500
    
        # Remove the first N lines from the file
        Remove-FirstLines -file $LogFile -linesToRemove $linesToRemove
    
        Write-Host "The first $linesToRemove lines have been removed from the file."
    }
    else {
        Write-Host "The file size is within the limit."
    }

}

# Function to log messages with a timestamp for better traceability.
function Write-Log {
    param (
        [string]$Message,
        [string]$Path = $Global:LogFile
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp - $Message"
    Write-Host $logEntry -ForegroundColor Cyan
    Add-Content -Path $Path -Value $logEntry
}

# Starts a specified program and logs the process ID.
function Start-Program {
    param (
        [string]$ProgramPath
    )
    try {
        $process = Start-Process -FilePath $ProgramPath -PassThru
        Write-Log "Program started: $ProgramPath"
        Write-Log "Process ID: $($process.Id)"
        Clear-Content -Path $Global:RefFilePath
    }
    catch {
        Write-Log "Failed to start program: $ProgramPath. Error: $_"
    }
}

# Monitors the reference file and starts programs based on its content.
function Monitor-ReferenceFile {
    param (
        [string]$FilePath
    )

    try {
        $content = Get-Content -Path $FilePath -ErrorAction Stop

        if ($content.Length -ge 1) {
            switch ($content) {
                "Scanner" {
                    Start-Program -ProgramPath $ProgToStart
                }
                default {
                    Write-Log "No valid program specified in $FilePath"
                }
            }
        }
        else {
            Write-Log "Reference file is empty: $FilePath"
        }
    }
    catch {
        Write-Log "Error reading from file: $FilePath. Error: $_"
    }
}

# Main operational loop to continuously monitor and act.
function Main-Loop {
    while ($true) {
        Check-FileSize
        Monitor-ReferenceFile -FilePath $Global:RefFilePath
        Start-Sleep -Seconds $Global:Interval
    }
}

# Entry point of the script.
function Main {
    Write-Log "Starting monitoring service."
    Main-Loop
}

# Execute the main function to start the program.
Main
