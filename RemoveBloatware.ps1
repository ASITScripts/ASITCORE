<#
Will automatically remove bloatware - Only for HP Devices at the moment

Script to automatically download the following applications
- Google Chrome
- Adobe PDF Reader

Will also adjust the following
- On Battery
- Turn off display : 30 Minutes
- Sleep: 1 Hour

- On power
- Turn off display: 1 Hour
- Sleep: Never

Adjust time and date to UTC +10 Canberra, Melbourne, Sydney
Adjust Region to Australia
#>

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

Write-Host -ForegroundColor Green ("[$Time]`t" + 'Restarted Powershell with admin priviledges')

Start-Sleep -s 5
#Installing ScreenConnect Agent

# Path for the temporary download folder.
$InstalldirSC = "c:\temp\install_screenconnect"
New-Item -Path $InstalldirSC  -ItemType directory

# Download the installer from the ScreenConnect website. Be sure to check if link is up to date - Not sure if ScreenConnect changes links or not
$source = "tinyurl.com/ConnectWiseASIT" #Not sure if TinyURL expires - check once in a while
$destination = "$InstalldirSC\ConnectWiseControl.ClientSetup.exe"
Invoke-WebRequest $source -OutFile $destination

# Start the installation when download is finished - Devices will be placed in SC group called AA - Automated Installs - Move Me
Start-Process -FilePath "$InstalldirSC\ConnectWiseControl.ClientSetup.exe" -ArgumentList "/sAll /rs /rps /msi /norestart /quiet EULA_ACCEPT=YES"

#Minor changes start here
#These are things like region, VPN reg fix, disabling bing search bar, battery etc.

Start-Sleep -s 1
Write-Host -ForegroundColor Green ("[$Time]`t" + 'Now starting minor changes...')
Start-Sleep -s 2

#Set region to AU
Set-Culture 'en-AU'
Write-Host -ForegroundColor Green ("[$Time]`t" + 'Region set to Australia')

Start-Sleep -s 1

#Sets time to UTC+10 Canberra, Melbourne, Sydney
Set-TimeZone -Id "AUS Eastern Standard Time"
Write-Host -ForegroundColor Green ("[$Time]`t" + 'Time zone set to UTC+10:00 Canberra, Melbourne, Sydney')

Start-Sleep -s 1

#Changes the power plan
powercfg.exe -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
Powercfg /Change monitor-timeout-ac 60
Powercfg /Change monitor-timeout-dc 30
Powercfg /Change standby-timeout-ac 0
Powercfg /Change standby-timeout-dc 60
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0
Write-Host -ForegroundColor Green ("[$Time]`t" + 'Powerplan adjusted')

Start-Sleep -s 1

New-ItemProperty  -path "HKLM:\SYSTEM\CurrentControlSet\Services\PolicyAgent" -name "AssumeUDPEncapsulationContextOnSendRule" -value "2"  -PropertyType "Dword"
New-ItemProperty  -path "HKLM:\SYSTEM\CurrentControlSet\Services\RasMan\Parameters" -name "ProhibitIpSec" -value "0"  -PropertyType "Dword"
New-ItemProperty  -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -name "BingSearchEnabled" -value "0" -PropertyType "Dword"
New-ItemProperty  -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -name "CortanaConsent" -value "0" -PropertyType "Dword"

Write-Host -ForegroundColor Green ("[$Time]`t" + 'VPN Regfix added')

Start-Sleep -s 10

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

# Stop HP Services
Function StopDisableService($name) {
    if (Get-Service -Name $name -ea SilentlyContinue) {
        Stop-Service -Name $name -Force -Confirm:$False
        Set-Service -Name $name -StartupType Disabled
    }
}

StopDisableService -name "HotKeyServiceUWP"
StopDisableService -name "HPAppHelperCap"
StopDisableService -name "HP Comm Recover"
StopDisableService -name "HPDiagsCap"
StopDisableService -name "HotKeyServiceUWP"
StopDisableService -name "LanWlanWwanSwitchgingServiceUWP" # Not sure if we need to stop this or not - if someone can find out that'd be cool
StopDisableService -name "HPNetworkCap"
StopDisableService -name "HPSysInfoCap"
StopDisableService -name "HP TechPulse Core"
StopDisableService -name "IntelCstService"
StopDisableService -name "IntelCstSupportService"

#Remove HP Documentation
if (Test-Path "${Env:ProgramFiles}\HP\Documentation\Doc_uninstall.cmd" -PathType Leaf) {
    try {
        Invoke-Item "${Env:ProgramFiles}\HP\Documentation\Doc_uninstall.cmd"
        Write-Host "Successfully removed provisioned package: HP Documentation"
    }
    catch {
        Write-Host "Error Remvoving HP Documentation $($_.Exception.Message)"
    }
}
else {
    Write-Host "HP Documentation is not installed"
}

#Remove HP Support Assistant silently
$HPSAuninstall = "${Env:ProgramFiles(x86)}\HP\HP Support Framework\UninstallHPSA.exe"

if (Test-Path -Path "HKLM:\Software\WOW6432Node\Hewlett-Packard\HPActiveSupport") {
    try {
        Remove-Item -Path "HKLM:\Software\WOW6432Node\Hewlett-Packard\HPActiveSupport"
        Write-Host "HP Support Assistant regkey deleted $($_.Exception.Message)"
    }
    catch {
        Write-Host "Error retreiving registry key for HP Support Assistant: $($_.Exception.Message)"
    }
}
else {
    Write-Host "HP Support Assistant regkey not found"
}

if (Test-Path $HPSAuninstall -PathType Leaf) {
    try {
        & $HPSAuninstall /s /v/qn UninstallKeepPreferences=FALSE
        Write-Host "Successfully removed provisioned package: HP Support Assistant silently"
    }
    catch {
        Write-Host "Error uninstalling HP Support Assistant: $($_.Exception.Message)"
    }
}
else {
    Write-Host "HP Support Assistant Uninstaller not found"
}

#Remove HP Connection Optimizer
$HPCOuninstall = "${Env:ProgramFiles(x86)}\InstallShield Installation Information\{6468C4A5-E47E-405F-B675-A70A70983EA6}\setup.exe"
if (Test-Path $HPCOuninstall -PathType Leaf) {
    Try {
        # Generating uninstall file
        "[InstallShield Silent]
        Version=v7.00
        File=Response File
        [File Transfer]
        OverwrittenReadOnly=NoToAll
        [{6468C4A5-E47E-405F-B675-A70A70983EA6}-DlgOrder]
        Dlg0={6468C4A5-E47E-405F-B675-A70A70983EA6}-SdWelcomeMaint-0
        Count=3
        Dlg1={6468C4A5-E47E-405F-B675-A70A70983EA6}-MessageBox-0
        Dlg2={6468C4A5-E47E-405F-B675-A70A70983EA6}-SdFinishReboot-0
        [{6468C4A5-E47E-405F-B675-A70A70983EA6}-SdWelcomeMaint-0]
        Result=303
        [{6468C4A5-E47E-405F-B675-A70A70983EA6}-MessageBox-0]
        Result=6
        [Application]
        Name=HP Connection Optimizer
        Version=2.0.18.0
        Company=HP Inc.
        Lang=0409
        [{6468C4A5-E47E-405F-B675-A70A70983EA6}-SdFinishReboot-0]
        Result=1
        BootOption=0" | Out-File -FilePath "${Env:Temp}\uninstallHPCO.iss" -Encoding UTF8 -Force:$true -Confirm:$false

        Write-Host "Successfully created uninstall file ${Env:Temp}\uninstallHPCO.iss"

        & $HPCOuninstall -runfromtemp -l0x0413 -removeonly -s -f1${Env:Temp}\uninstallHPCO.iss
        Write-Host "Successfully removed HP Connection Optimizer"
    }
    Catch {
        Write-Host "Error uninstalling HP Connection Optimizer: $($_.Exception.Message)"
    }
}
Else {
    Write-Host "HP Connection Optimizer not found"
}

#List of built-in apps to remove
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
    "AD2F1837.HPQuickTouch"
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

#List of programs to uninstall
$UninstallPrograms = @(
    "HP Client Security Manager"
    "HP Connection Optimizer"
    "HP Documentation"
    "HP MAC Address Manager"
    "HP Notifications"
    "HP Security Update Service"
    "HP System Default Settings"
    "HP Sure Click"
    "HP Sure Click Security Browser"
    "HP Sure Run"
    "HP Sure Recover"
    "HP Sure Sense"
    "HP Sure Sense Installer"
)

$HPidentifier = "AD2F1837"

$InstalledPackages = Get-AppxPackage -AllUsers `
| Where-Object { ($UninstallPackages -contains $_.Name) -or ($_.Name -match "^$HPidentifier") }

$ProvisionedPackages = Get-AppxProvisionedPackage -Online `
| Where-Object { ($UninstallPackages -contains $_.DisplayName) -or ($_.DisplayName -match "^$HPidentifier") }

$InstalledPrograms = Get-Package | Where-Object { $UninstallPrograms -contains $_.Name } | Sort-Object Name -Descending

#Remove appx provisioned packages - AppxProvisionedPackage
ForEach ($ProvPackage in $ProvisionedPackages) {
    Write-Host -Object "Attempting to remove provisioned package: [$($ProvPackage.DisplayName)]..."
    try {
        $Null = Remove-AppxProvisionedPackage -PackageName $ProvPackage.PackageName -Online -ErrorAction Stop
        Write-Host -Object "Successfully removed provisioned package: [$($ProvPackage.DisplayName)]"
    }
    catch { Write-Warning -Message "Failed to remove provisioned package: [$($ProvPackage.DisplayName)]" }
}

#Remove appx packages - AppxPackage
ForEach ($AppxPackage in $InstalledPackages) {                                        
    Write-Host -Object "Attempting to remove Appx package: [$($AppxPackage.Name)]..."
    try {
        $Null = Remove-AppxPackage -Package $AppxPackage.PackageFullName -AllUsers -ErrorAction Stop
        Write-Host -Object "Successfully removed Appx package: [$($AppxPackage.Name)]"
    }
    catch { Write-Warning -Message "Failed to remove Appx package: [$($AppxPackage.Name)]" }
}

#Remove installed programs
ForEach ($InstalledProgram in $InstalledPrograms) {
    Write-Host -Object "Attempting to uninstall: [$($InstalledProgram.Name)]..."
    try {
        $Null = $InstalledProgram | Uninstall-Package -AllVersions -Force -ErrorAction Stop
        Write-Host -Object "Successfully uninstalled: [$($InstalledProgram.Name)]"
    }
    catch {
        Write-Warning -Message "Failed to uninstall: [$($InstalledProgram.Name)]"
        Write-Host -Object "Attempting to uninstall as MSI package: [$($InstalledProgram.Name)]..."
        try {
            $MSIApp = Get-WmiObject Win32_Product | Where-Object { $_.name -like "$($InstalledProgram.Name)" }
            if ($null -ne $MSIApp.IdentifyingNumber) {
                Start-Process -FilePath msiexec.exe -ArgumentList @("/x $($MSIApp.IdentifyingNumber)", "/quiet", "/noreboot") -Wait
            }
            else { Write-Warning -Message "Can't find MSI package: [$($InstalledProgram.Name)]" }
        }
        catch { Write-Warning -Message "Failed to uninstall MSI package: [$($InstalledProgram.Name)]" }
    }
}

#Try to remove all HP Wolf Security apps using msiexec
$InstalledWolfSecurityPrograms = Get-WmiObject Win32_Product | Where-Object { $_.name -like "HP Wolf Security*" }
ForEach ($InstalledWolfSecurityProgram in $InstalledWolfSecurityPrograms) {
    try {
        if ($null -ne $InstalledWolfSecurityProgram.IdentifyingNumber) {
            Start-Process -FilePath msiexec.exe -ArgumentList @("/x $($InstalledWolfSecurityProgram.IdentifyingNumber)", "/quiet", "/noreboot") -Wait
            Write-Host "Attempting to uninstall as MSI package: [$($InstalledWolfSecurityProgram.Name)]..."
        }
        else { Write-Warning -Message "Can't find MSI package: [$($InstalledWolfSecurityProgram.Name)]" }
    }
    catch {
        Write-Warning -Message "Failed to uninstall MSI package: [$($InstalledWolfSecurityProgram.Name)]"
    }
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

Start-Sleep -s 5

#Google Chrome download starts here

$DesktopPath = [Environment]::GetFolderPath("Desktop")
$chromeuri = "https://dl.google.com/chrome/install/googlechromestandaloneenterprise64.msi"

$chromeInstalled = (Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo

if ($null -eq $chromeInstalled.FileName) {
    Write-Host -ForegroundColor Red ("[$Time]`t" + 'Chrome is not installed.')
    Write-Host -ForegroundColor Green "Starting Chrome installation"

    $outFile = "$DesktopPath\googlechromestandaloneenterprise64.msi"
    
    Start-BitsTransfer -Source $chromeuri -Destination $outFile
    
    Start-Process -FilePath $outFile -Args "/qn" -Wait
    
    Write-Host -ForegroundColor Green "Completed Google Chrome installation"
}

else {
    Write-Host -ForegroundColor Green ("[$Time]`t" + 'Chrome is already installed.')
}

#Adobe installation starts here

$DesktopPath = [Environment]::GetFolderPath("Desktop")
$adobeuri = "https://ardownload2.adobe.com/pub/adobe/reader/win/AcrobatDC/2200120117/AcroRdrDC2200120117_en_US.exe"

$adobeInstalled = Get-ItemProperty "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object {$_.DisplayName -like "Adobe Acrobat Reader DC*"}

if ($null -eq $adobeInstalled) {
    Write-Host -ForegroundColor Red ("[$Time]`t" + 'Adobe PDF Reader is not installed.')
    Write-Host -ForegroundColor Green "Starting Adobe installation"

    $outFile = "$DesktopPath\AcroRdrDC2200120117_en_US.exe"
    
    Start-BitsTransfer -Source $adobeuri -Destination $outFile
    
    Start-Process -FilePath "$DesktopPath\AcroRdrDC2200120117_en_US.exe" -ArgumentList "/sAll /rs /rps /msi /norestart /quiet EULA_ACCEPT=YES" -Wait
    
    Write-Host -ForegroundColor Green "Completed Adobe installation"
}

else {
    Write-Host -ForegroundColor Green ("[$Time]`t" + 'Adobe PDF Reader is already installed.')
}

#This will remove the installer afterwards

try {
    Remove-Item -Force $DesktopPath\googlechromestandaloneenterprise64.msi
    Remove-Item -Force $DesktopPath\AcroRdrDC2200120117_en_US.exe
}
catch [System.SystemException]
{
    Write-Warning -Message "Installer does not exist, skipping..."
}

Write-Host "Main Pre-installation completed, now starting Windows updates..."

Start-sleep -s 5

#Restarts device after windows updates are installed
#This section will run Windows Updates and install them
try {
    If(-not(Get-InstalledModule PSWindowsUpdate -ErrorAction silentlycontinue))
    {
        Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
        Set-PSRepository PSGallery -InstallationPolicy Trusted
        Install-Module PSWindowsUpdate -Confirm:$False -Force
    }
    Get-WindowsUpdate
    Install-WindowsUpdate -AcceptAll -AutoReboot
}
catch {
    Write-Warning -Message "Some updates failed to install - please restart then manually check for updates either with PS or Windows Update"

}
Write-Host -ForegroundColor Green "All done, goodbye"
