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
