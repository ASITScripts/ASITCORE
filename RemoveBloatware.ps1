param([switch]$Elevated)

function Test-Admin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
	if ($elevated) 
	{
		# tried to elevate, did not work, aborting
	} 
	else {
		Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}

exit
}

#Core Variables
$Time = Get-Date -UFormat "%A %m/%d/%Y %R"

#Script starts here
Write-Host -ForegroundColor Green ("[$Time]`t" + 'Restarted Powershell with admin priviledges')

#Bloatware removal starts here

function Write-LogEntry {
    param (
        [parameter(Mandatory = $true, HelpMessage = "Value added to the log file.")]
        [ValidateNotNullOrEmpty()]
        [string]$Value,

        [parameter(Mandatory = $true, HelpMessage = "Severity for the log entry. 1 for Informational, 2 for Warning and 3 for Error.")]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("1", "2", "3")]
        [string]$Severity,

        [parameter(Mandatory = $false, HelpMessage = "Name of the log file that the entry will written to.")]
        [ValidateNotNullOrEmpty()]
        [string]$FileName = "ByeByeBloatware.log"
    )
    # Determine log file location
    $LogFilePath = Join-Path -Path (Join-Path -Path $env:windir -ChildPath "Temp") -ChildPath $FileName
    
    # Construct time stamp for log entry
    $Time = -join @((Get-Date -Format "HH:mm:ss.fff"), "+", (Get-WmiObject -Class Win32_TimeZone | Select-Object -ExpandProperty Bias))
    
    # Construct date for log entry
    $Date = (Get-Date -Format "MM-dd-yyyy")
    
    # Construct context for log entry
    $Context = $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)
    
    # Construct final log entry
    $LogText = "<![LOG[$($Value)]LOG]!><time=""$($Time)"" date=""$($Date)"" component=""ByeByeBloatware"" context=""$($Context)"" type=""$($Severity)"" thread=""$($PID)"" file="""">"
    
    # Add value to log file
    try {
        Out-File -InputObject $LogText -Append -NoClobber -Encoding Default -FilePath $LogFilePath -ErrorAction Stop
    }
    catch [System.Exception] {
        Write-Warning -Message "Unable to append log entry to ByeByeBloatware.log file. Error message at line $($_.InvocationInfo.ScriptLineNumber): $($_.Exception.Message)"
    }
}

#Remove HP Documentation
if (Test-Path "C:\Program Files\HP\Documentation\Doc_uninstall.cmd" -PathType Leaf){
Try {
    Invoke-Item "C:\Program Files\HP\Documentation\Doc_uninstall.cmd"
    Write-LogEntry -Value "Successfully removed provisioned package: HP Documentation" -Severity 1
    }
Catch {
        Write-LogEntry -Value  "Error Remvoving HP Documentation $($_.Exception.Message)" -Severity 3
        }
}
Else {
        Write-LogEntry -Value  "HP Documentation is not installed" -Severity 1
}

#Remove HP Support Assistant silently

$HPSAuninstall = "C:\Program Files (x86)\HP\HP Support Framework\UninstallHPSA.exe"

if (Test-Path -Path "HKLM:\Software\WOW6432Node\Hewlett-Packard\HPActiveSupport") {
Try {
        Remove-Item -Path "HKLM:\Software\WOW6432Node\Hewlett-Packard\HPActiveSupport"
        Write-LogEntry -Value  "HP Support Assistant regkey deleted $($_.Exception.Message)" -Severity 1
    }
Catch {
        Write-LogEntry -Value  "Error retreiving registry key for HP Support Assistant: $($_.Exception.Message)" -Severity 3
        }
}
Else {
        Write-LogEntry -Value  "HP Support Assistant regkey not found" -Severity 1
}

if (Test-Path $HPSAuninstall -PathType Leaf) {
    Try {
        & $HPSAuninstall /s /v/qn UninstallKeepPreferences=FALSE
        Write-LogEntry -Value "Successfully removed provisioned package: HP Support Assistant silently" -Severity 1
    }
        Catch {
        Write-LogEntry -Value  "Error uninstalling HP Support Assistant: $($_.Exception.Message)" -Severity 3
        }
}
Else {
        Write-LogEntry -Value  "HP Support Assistant Uninstaller not found" -Severity 1
}

#List of packages to install. Add to this list when you find more
$UninstallPackages = @(
    "AD2F1837.HPJumpStarts"
    "AD2F1837.HPPCHardwareDiagnosticsWindows"
    "AD2F1837.HPPowerManager"
    "AD2F1837.HPPrivacySettings"
    "AD2F1837.HPSupportAssistant"
    "AD2F1837.HPSureShieldAI"
    "AD2F1837.HPSystemInformation"
    "AD2F1837.HPQuickDrop"
    "AD2F1837.HPWorkWell"
    "AD2F1837.myHP"
    "AD2F1837.HPDesktopSupportUtilities"
    "AD2F1837.HPEasyClean"
    "AD2F1837.HPSystemInformation"
    "AD2F1837.HPAutoLockAndAwake"
    "Microsoft.GetHelp"
    "Microsoft.Getstarted"
    "Microsoft.MicrosoftOfficeHub"
    "Microsoft.MicrosoftSolitaireCollection"
    "Microsoft.People"
    "Microsoft.StorePurchaseApp"
    "microsoft.windowscommunicationsapps"
    "Microsoft.WindowsFeedbackHub"
    "Microsoft.Xbox.TCUI"
    "Microsoft.XboxGameOverlay"
    "Microsoft.XboxGamingOverlay"
    "Microsoft.XboxIdentityProvider"
    "Microsoft.XboxSpeechToTextOverlay"
    "Microsoft.XboxApp"
    "Microsoft.Wallet"
    "Microsoft.SkypeApp"
    "Microsoft.BingWeather"
    "Tile.TileWindowsApplication"
    "MicrosoftOfficeHub"
    "Microsoft\.Office\.Desktop"
)

# List of programs to uninstall - These are programs, not packages. If unsure when adding whether it's a package or program, best to Google it.
$UninstallPrograms = @(
    "HP Connection Optimizer"
    "HP Documentation"
    "HP MAC Address Manager"
    "HP Notifications"
    "HP Security Update Service"
    "HP System Default Settings"
    "HP Sure Click"
    "HP Sure Run"
    "HP Sure Recover"
    "HP Sure Sense"
    "HP Sure Sense Installer"
    "HP Wolf Security Application Support for Sure Sense"
    "HP Wolf Security Application Support for Windows"
    "HP Client Security Manager"
    "HP Wolf Security"
    "HP Sure Run Module"
)

#Get a list of installed packages matching our list
$InstalledPackages = Get-AppxPackage -AllUsers | Where-Object {($UninstallPackages -contains $_.Name)}

#Get a list of Provisioned packages matching our list
$ProvisionedPackages = Get-AppxProvisionedPackage -Online | Where-Object  {($UninstallPackages -contains $_.DisplayName)}

#Get a list of installed programs matching our list
$InstalledPrograms = Get-Package | Where-Object  {$UninstallPrograms -contains $_.Name}


# Remove provisioned packages first
ForEach ($ProvPackage in $ProvisionedPackages) {

    Write-LogEntry -Value "Attempting to remove provisioned package: [$($ProvPackage.DisplayName)]" -Severity 1

    Try {
        $Null = Remove-AppxProvisionedPackage -PackageName $ProvPackage.PackageName -Online -ErrorAction Stop
        Write-LogEntry -Value "Successfully removed provisioned package: [$($ProvPackage.DisplayName)]" -Severity 1
    }
    Catch {
        Write-LogEntry -Value  "Failed to remove provisioned package: [$($ProvPackage.DisplayName)] Error message: $($_.Exception.Message)" -Severity 3
    }
}

# Remove appx packages
ForEach ($AppxPackage in $InstalledPackages) {
                                            
    Write-LogEntry -Value "Attempting to remove Appx package: [$($AppxPackage.Name)] " -Severity 1

    Try {
        $Null = Remove-AppxPackage -Package $AppxPackage.PackageFullName -AllUsers -ErrorAction Stop
        Write-LogEntry -Value "Successfully removed Appx package: [$($AppxPackage.Name)]" -Severity 1
    }
    Catch {
        Write-LogEntry -Value  "Failed to remove Appx package: [$($AppxPackage.Name)] Error message: $($_.Exception.Message)" -Severity 3
    }
}

# Remove installed programs
$InstalledPrograms | ForEach-Object {

    Write-LogEntry -Value "Attempting to uninstall: [$($_.Name)]"  -Severity 1

    Try {
        $Null = $_ | Uninstall-Package -AllVersions -Force -ErrorAction Stop
        Write-LogEntry -Value "Successfully uninstalled: [$($_.Name)]" -Severity 1
    }
    Catch {
        Write-LogEntry -Value  "Failed to uninstall: [$($_.Name)] Error message: $($_.Exception.Message)" -Severity 3
    }
}

#Fallback attempt 1 to remove HP Wolf Security using msiexec
Try {
    MsiExec /x "{0E2E04B0-9EDD-11EB-B38C-10604B96B11E}" /qn /norestart
    Write-LogEntry -Value "Fallback to MSI uninistall for HP Wolf Security initiated" -Severity 1
}
Catch {
    Write-LogEntry -Value  "Failed to uninstall HP Wolf Security using MSI - Error message: $($_.Exception.Message)" -Severity 3
}

#Fallback attempt 2 to remove HP Wolf Security using msiexec
Try {
    MsiExec /x "{4DA839F0-72CF-11EC-B247-3863BB3CB5A8}" /qn /norestart
    Write-LogEntry -Value "Fallback to MSI uninistall for HP Wolf 2 Security initiated" -Severity 1
}
Catch {
    Write-LogEntry -Value  "Failed to uninstall HP Wolf Security 2 using MSI - Error message: $($_.Exception.Message)" -Severity 3
}


#Remove shortcuts
$pathTCO = "C:\ProgramData\HP\TCO"
$pathTCOc = "C:\Users\Public\Desktop\TCO Certified.lnk"
$pathOS = "C:\Program Files (x86)\Online Services"
$pathFT = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Free Trials.lnk"

if (Test-Path $pathTCO) {
    Try {
        Remove-Item -LiteralPath $pathTCO -Force -Recurse
        Write-LogEntry -Value "Shortcut for $pathTCO removed" -Severity 1
    }
        Catch {
        Write-LogEntry -Value  "Error deleting $pathTCO $($_.Exception.Message)" -Severity 3
        }
    }
Else {
        Write-LogEntry -Value  "Folder $pathTCO not found" -Severity 1
}

if (Test-Path $pathTCOc -PathType Leaf) {
    Try {
        Remove-Item -Path $pathTCOc  -Force -Recurse
        Write-LogEntry -Value "Shortcut for $pathTCOc removed" -Severity 1
    }
        Catch {
        Write-LogEntry -Value  "Error deleting $pathTCOc $($_.Exception.Message)" -Severity 3
        }
    }
Else {
        Write-LogEntry -Value  "File $pathTCOc not found" -Severity 1
}

if (Test-Path $pathOS) {
    Try {
        Remove-Item -LiteralPath $pathOS  -Force -Recurse
        Write-LogEntry -Value "Shortcut for $pathOS removed" -Severity 1
    }
        Catch {
        Write-LogEntry -Value  "Error deleting $pathOS $($_.Exception.Message)" -Severity 3
        }
    }
Else {
        Write-LogEntry -Value  "Folder $pathOS not found" -Severity 1
}

    if (Test-Path $pathFT -PathType Leaf) {
    Try {
        Remove-Item -Path $pathFT -Force -Recurse
        Write-LogEntry -Value "Shortcut for $pathFT removed" -Severity 1
    }
        Catch {
        Write-LogEntry -Value  "Error deleting $pathFT $($_.Exception.Message)" -Severity 3
        }
    }
Else {
        Write-LogEntry -Value  "File $pathFT not found" -Severity 1
}

Write-Host -ForegroundColor Green ("[$Time]`t" + 'Bloatware removal script completed.')