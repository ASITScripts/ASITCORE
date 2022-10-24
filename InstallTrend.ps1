$InstallationFolderPath = "C:\Downloads"
$DeployTrendInstaller = "https://github.com/ASIT-LB/DeployTrend/raw/main/WFBS-SVC_Downloader.exe"

#Creates new path directory for C:\Downloads (or whatever is above for $InstallationFolderPath)
New-Item -Path $InstallationFolderPath  -ItemType directory
New-Item -Path $InstallationFolderPath\TrendAV  -ItemType directory

#Downloads and places the installer to C:\Downloads\TrendAV
Write-Host -ForegroundColor Green "Starting Trend installer download"
$outFile = "$InstallationFolderPath\TrendAV\WFBS-SVC_Downloader.exe"
Start-BitsTransfer -Source $DeployTrendInstaller -Destination $outFile
Unblock-File -Path "$InstallationFolderPath\TrendAV\WFBS-SVC_Downloader.exe"

########## Installation starts here ##############
Write-Host -ForegroundColor Green "Starting the download for Trend AV..."
Start-Process -Wait -FilePath "$InstallationFolderPath\TrendAV\WFBS-SVC_Downloader.exe" -ArgumentList "/S" -PassThru

#> To get the Unique ID of the e
$UniqueID = Read-Host "Please enter the Unique Identifier (If you do not know what this is, please refer to confluence)"

msiexec /i "$InstallationFolderPath\TrendAV\WFBS-SVC_Agent_Installer.msi" IDENTIFIER="$UniqueID" SILENTMODE=1 /L*v+ "C:\Windows\Temp\wofie_msi.log"
