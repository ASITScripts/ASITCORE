#Time Variable
$Time = Get-Date -UFormat "%A %m/%d/%Y %R"

#ASITScripts Folder Variable
$ASITScripts = "C:\ASITScripts"

############################################################################################################
#                                         Initial Setup                                                    #
#                                                                                                          #
############################################################################################################

##Elevate if needed

If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]'Administrator')) {
    Write-Host -ForegroundColor Red ("[$Time]`t" + "You didn't run this script as an Administrator. This script will self elevate to run as an Administrator and continue.")
    Start-Sleep 1
    Write-Host -ForegroundColor Green ("[$Time]`t" + "                                               3")
    Start-Sleep 1
    Write-Host -ForegroundColor Yellow ("[$Time]`t" + "                                               2")
    Start-Sleep 1
    Write-Host -ForegroundColor Red ("[$Time]`t" + "                                               1")
    Start-Sleep 1
    Start-Process powershell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
    Exit
}

#no errors throughout
$ErrorActionPreference = 'silentlycontinue'

#Creating main folder
If (Test-Path $ASITScripts) {
    Write-Output "$ASITScripts exists. Skipping."
}
Else {
    Write-Output "The folder '$ASITScripts' doesn't exist. Creating now."
    Start-Sleep 1
    New-Item -Path "$ASITScripts" -ItemType Directory
    Write-Output "The folder $ASITScripts was successfully created."
}

#Installing ScreenConnect Agent

# Path for the download folder.
$ScreenConnectFolder = "c:\ASITScripts\ScreenConnect"
If (Test-Path $ScreenConnectFolder) {
    Write-Output "$ScreenConnectFolder exists. Skipping."
}
Else {
    Write-Output "The folder '$ScreenConnectFolder' doesn't exist. Creating now."
    Start-Sleep 1
    New-Item -Path "$ScreenConnectFolder" -ItemType Directory
    Write-Output "The folder $ScreenConnectFolder was successfully created."
}

# ALL SITE TOKENS
$AMCL = "Main (AMCL)_Windows_OS_ITSPlatform_TKNdf0898bf-ea6d-4ec1-a240-6400491b3262.msi"
$AQUACORPADELAIDE = "Adelaide Main Office (Aquacorp)_Windows_OS_ITSPlatform_TKNabc2bc6e-3eb2-45b7-9500-8bdf0654f4e3.msi"
$AQUACORPBRISBANE = "Brisbane Office (Aquacorp)_Windows_OS_ITSPlatform_TKN86ce7bfe-9001-4e75-b201-559453babcbe.msi"
$ASIT = "Australian IT (ASIT)_Windows_OS_ITSPlatform_TKNddd97d0a-2790-46d1-80fe-6095e3eb2c14.msi"
$BARCRUSHER = "Main (BarCrusher)_Windows_OS_ITSPlatform_TKNb6b6bb52-98ab-46ef-beec-903dfe5417b8.msi"
$BATMANS = "Main (Batmans)_Windows_OS_ITSPlatform_TKN3de033f9-27d2-438f-9ec8-2131ddf7f27e.msi"
$BEAUMARIS = "Beaumaris (Beaumaris Yacht Club)_Windows_OS_ITSPlatform_TKN79b18e30-846c-4c3c-ae63-d5d6fb86ef3c.msi"
$BENTANDCOUGLE = "bentandcougle (Bent and Cougle)_Windows_OS_ITSPlatform_TKN05fe8c8a-6fdb-4099-a443-f44848ce955b.msi"
$BKTAYLOR = "Main (Bktaylor)_Windows_OS_ITSPlatform_TKN832502f7-30bb-4682-923f-261f41e7edc6.msi"
$CAMVEX = "Main (Camvex)_Windows_OS_ITSPlatform_TKN9bfc44e8-fc4d-46ee-acd5-0fb042fd754f.msi"
$CASTELLOCARDINIA = "Cardinia Hotel (Castellos)_Windows_OS_ITSPlatform_TKNc13b9192-8543-459b-b6f4-171074096c8b.msi"
$CASTELLOCROYDON = "Croydon Hotel (Castellos)_Windows_OS_ITSPlatform_TKNb9a64c25-6f07-4dec-8d23-39e3349eac77.msi"
$CASTELLOFORESTER = "Foresters Arms Hotel (Castellos)_Windows_OS_ITSPlatform_TKNbafe65fb-3c63-4cef-a2f5-4cc48c69c85d.msi"
$CASTELLOGISBOURNE = "Victoria Tavern Gisbourne (Castellos)_Windows_OS_ITSPlatform_TKN59187934-fbd3-49ac-9dfa-7cb144d824f4.msi"
$CASTELLOHEADOFFICE = "HeadOffice (Castellos)_Windows_OS_ITSPlatform_TKNa1439105-5c5c-41c6-8c36-b2ae4ca4a856.msi"
$CASTELLOLONGBEACH = "Longbeach Hotel (Castellos)_Windows_OS_ITSPlatform_TKN6824eb16-83c2-4c23-ad4a-37aaa967af33.msi"
$CASTELLOPAKENHAM = "Pakenham Hotel (Castellos)_Windows_OS_ITSPlatform_TKN81e2b043-57dc-45b2-a3c9-a52673f6793a.msi"
$CASTELLOOLIVETREE = "Olive_Tree_Hotel-Castello_Group_Pty_Ltd_Windows_OS_ITSPlatform_TKNa8a34b89-d785-4d5c-affc-b13dce7080c6.msi"
$CASTELLODERRIMUT = "Derrimut_Hotel-Castello_Group_Pty_Ltd_Windows_OS_ITSPlatform_TKN38f28a1d-d34d-46f7-b50a-1c2a46df2912.msi"
$CDIT = "main (CDIT)_Windows_OS_ITSPlatform_TKN4c718ae0-eb16-47c9-a5c6-1bb2d26169de.msi"
$CHALMERS = "Main (Chalmers)_Windows_OS_ITSPlatform_TKN0cfc05cd-3682-489f-a3e7-765faf555f23.msi"
$CONSTRUCTIONZONE = "Office (ConstructionZone)_Windows_OS_ITSPlatform_TKNabd44469-8b39-4e6a-93d9-6e075fb484b1.msi"
$CREATIVEUNIVERSE = "Main (CreativeUniversre)_Windows_OS_ITSPlatform_TKN46c2732f-941f-41a8-9e39-f6e06c12ac4f.msi"
$CRIBPOINT = "Main (CribPoint)_Windows_OS_ITSPlatform_TKN7dbc2099-6555-42f4-a607-601137f3bd00.msi"
$DESTINATIONPHILLIPISLAND = "Main (Destination Phillip Island)_Windows_OS_ITSPlatform_TKNfbdefe6a-ce31-4fcb-90c9-7c47973b0414.msi"
$DIAGNOSTICARE = "Main (DiagnostiCare)_Windows_OS_ITSPlatform_TKNbc362985-2ab6-430d-8289-7d3e6bfb9e91.msi"
$DIAM = "Main (DIAM)_Windows_OS_ITSPlatform_TKNc3a12d94-815f-49ef-ba05-1b3ee1b50f4e.msi"
$DVR = "Main (DVR)_Windows_OS_ITSPlatform_TKNe6ddd88d-9aaf-453e-a46f-e6bb61af7323.msi"
$EASYLIFE = "Main (Easylife)_Windows_OS_ITSPlatform_TKN29845e7e-4d52-4d52-b525-bec5aed35bd4.msi"
$ETU = "Main (ETU)_Windows_OS_ITSPlatform_TKN90e9704d-1378-4e3f-a0fb-f8a532b080c1.msi"
$FINWELL = "Main (Finwell)_Windows_OS_ITSPlatform_TKN4ff12b06-6dc3-43e5-be0f-574cf9ff01bb.msi"
$GARAGEBEVERAGES = "Main (GarageBeverages)_Windows_OS_ITSPlatform_TKNc04355f7-1624-439b-945d-78a0131264a2.msi"
$GBLA = "Main (GBLA)_Windows_OS_ITSPlatform_TKNa8227739-47db-4cc6-bf16-f6729a9abf9b.msi"
$HAAG = "Main (HAAG)_Windows_OS_ITSPlatform_TKNa15da5c9-02ad-4309-9e60-aad37430fa83.msi"
$HGC = "Main (HGC)_Windows_OS_ITSPlatform_TKNc8f60a26-671d-4330-a4c5-0ee6617d54e8.msi"
$JAMWESTEND = "Main (JAMWestend)_Windows_OS_ITSPlatform_TKNa5d71202-1a6d-475a-a6b1-9e4a9a9fed77.msi"
$JBP = "Main (JBP)_Windows_OS_ITSPlatform_TKN8720ec15-db6c-4fa4-b018-f7b681f0bafc.msi"
$KEATING =  "Main (Keating)_Windows_OS_ITSPlatform_TKN9e1120f4-49e5-4cf4-bafa-e5ca651eb69a.msi"
$LEITZMELBOURNE = "Melbourne (Leitz)_Windows_OS_ITSPlatform_TKN6be0ba71-fd14-4ab6-9a28-6b22fd990377.msi"
$LEXLAB = "Lexlab-Lexlab_Windows_OS_ITSPlatform_TKN3ea8820f-f32e-4c2c-abe6-d54c71065afc.msi"
$LINCOLN = "Lincoln_Pearce-Lincoln_Pearce_Windows_OS_ITSPlatform_TKNf56fe394-4177-4a13-b921-e120815b54d8.msi"
$MEDIAREPUBLIC = "Main (MediaRepublic)_Windows_OS_ITSPlatform_TKNff6d6011-9654-446b-8f72-f0887723b6e9.msi"
$NEWCO = "Main (Newco)_Windows_OS_ITSPlatform_TKN0804e443-52c8-4625-bcf4-f27c137f2e11.msi"
$NEXUS = "Main (Nexus)_Windows_OS_ITSPlatform_TKNde88ac51-40be-42a5-8100-990a76db49b4.msi"
$OPGHONGKONG = "OPG Hong Kong (OPG)_Windows_OS_ITSPlatform_TKN8ba7f478-5aff-4f76-8fd4-cd71b9df2680.msi"
$OPGMELBOURNE = "OPG Melbourne (OPG)_Windows_OS_ITSPlatform_TKNf7b37ca5-019f-4e93-828c-d53a47c8a3e1.msi"
$OPGPH = "OPG Philippines (OPG)_Windows_OS_ITSPlatform_TKNa725156b-94b3-4ced-a033-d0e34f93f115.msi"
$OPGSYDNEY = "OPG Sydney (OPG)_Windows_OS_ITSPlatform_TKN5127bb22-02eb-419c-8e1e-20ad4d18e99c.msi"
$POINTONPARTNERS = "Melbourne (PointonPartners)_Windows_OS_ITSPlatform_TKN3c534a5a-ac4b-4abb-9a86-fc357a91d57d.msi"
$PTA = "Main (PTA)_Windows_OS_ITSPlatform_TKNd40af850-deec-4b95-89ce-bd66a37a71a0.msi"
$PUBCOBACCHUSMARSH = "Courthouse Hotel Bacchus Marsh (Pubco)_Windows_OS_ITSPlatform_TKN3313cf29-bd60-4290-9188-084fd8676ccd.msi"
$PUBCOBAYNBRIDGE = "Bay and Bridge Hotel (Pubco)_Windows_OS_ITSPlatform_TKN6654ed4b-09b6-4c15-9a29-36575b19d918.msi"
$PUBCOBROWNS = "Browns Corner Hotel (Pubco)_Windows_OS_ITSPlatform_TKN4f31c3c4-819d-450c-92fb-66b2f323b0b7.msi"
$PUBCOCROWN = "Crown Hotel Lilydale (Pubco)_Windows_OS_ITSPlatform_TKN22c079af-737c-4837-9b75-11c49cff799c.msi"
$PUBCODUKE = "Duke of Ed Hotel Brunswick (Pubco)_Windows_OS_ITSPlatform_TKN66c1ff3a-6649-4ff9-9ff4-4da67ea63a44.msi"
$PUBCOHEADOFFICE = "HeadOffice (Pubco)_Windows_OS_ITSPlatform_TKNf3c7f9a0-55f2-4043-b5f2-a3eeeb779dbe.msi"
$PUBCOJUNCTION = "Junction Hotel (Pubco)_Windows_OS_ITSPlatform_TKN24e7f95e-b451-4c7e-8b7e-21411b4417bc.msi"
$PUBCOKNOX = "Knox Tavern (Pubco)_Windows_OS_ITSPlatform_TKNc0246030-92be-4fba-96d1-0300e67c487b.msi"
$PUBCOLYGON = "Players on Lygon (Pubco)_Windows_OS_ITSPlatform_TKN227af785-6972-4b07-8df1-145ec4df163e.msi"
$PUBCOMACS = "Macs Hotel (Pubco)_Windows_OS_ITSPlatform_TKNbba3d607-8baf-4f4d-a95a-7279524b63af.msi"
$PUBCOMORNINGTON = "Mornington on Tanti (Pubco)_Windows_OS_ITSPlatform_TKNea0b9452-6da4-40a0-a66f-627841cb0a42.msi"
$PUBCONEPEAN = "Nepean Cellars (Pubco)_Windows_OS_ITSPlatform_TKN42951e30-ea18-45a0-b120-39d8f0d3c902.msi"
$PUBCOPOWELL = "Powell Hotel (Pubco)_Windows_OS_ITSPlatform_TKN2532da6d-bcaf-4b1c-9b78-11a6fb08f2f7.msi"
$PUBCOTEMPLESTOWE = "Templestowe Hotel (Pubco)_Windows_OS_ITSPlatform_TKN52024d90-f2fd-4b7f-bfb1-7655901e5a28.msi"
$QUAIL = "Main (Quail)_Windows_OS_ITSPlatform_TKN5d3cd3e1-59d4-4f7f-b46d-9a53260e33bf.msi"
$RACECOURSE = "Main (Racecourse)_Windows_OS_ITSPlatform_TKNa8633a0c-a515-4fcb-b76c-cc892cbfd55e.msi"
$ROSEBUDHOTEL = "rosebudhotel (Rosebud Hotel)_Windows_OS_ITSPlatform_TKNa6ce7c7d-31c4-4b33-8618-aca7b6e0b1e6.msi"
$ROSSTOWNHOTEL = "Rosstown Hotel (Rosstown Hotel)_Windows_OS_ITSPlatform_TKN0005488b-1ebb-4107-936c-bb99faef2270.msi"
$SIW = "Main (SIW)_Windows_OS_ITSPlatform_TKNba280c9b-8e60-44cc-92d3-e2421f267b3d.msi"
$SLEEPSERVICES = "SleepServices (Sleep Services)_Windows_OS_ITSPlatform_TKNa485541b-dd84-4030-8e96-1744bce5087c.msi"
$TFBBERLIN = "Berlin (TFB)_Windows_OS_ITSPlatform_TKN72bdd280-3d35-4595-ba52-a2eb3876f158.msi"
$TFBMELBOURNE = "Melbourne (TFB)_Windows_OS_ITSPlatform_TKNe8141aad-91d7-4e7c-81c5-e7cf9bca9db3.msi"
$TPC = "Main (TPC)_Windows_OS_ITSPlatform_TKNaa1d6c0c-6bd2-45f8-a2ca-8cafad9099bd.msi"
$TRADEFLEX = "Main (Tradeflex)_Windows_OS_ITSPlatform_TKNc4c01b2e-701d-4670-ad87-ec37ab44a61d.msi"
$TRINITY = "Main (Trinity)_Windows_OS_ITSPlatform_TKN22e3b7ad-2784-40be-aff1-e4e60e64287c.msi"
$VICMESH = "VicMesh (VicMesh)_Windows_OS_ITSPlatform_TKNa17373b6-23ff-4332-86c2-c3bf76dcedc3.msi"
$VINCENTCHRISP = "Melbourne (Vincent Chrisp)_Windows_OS_ITSPlatform_TKN50d6929e-d4ae-42e1-b84b-cd22c6405d9a.msi"
$VINCENTCHRISPSHEPPARTON = "Shepparton (Vincent Chrisp)_Windows_OS_ITSPlatform_TKN06a85d4b-432f-486c-b9cb-7688d25a622d.msi"
$WINENET = "Main (WineNet)_Windows_OS_ITSPlatform_TKNd35f7dd1-1e89-4463-a5b4-e77ace0bf093.msi"
$YARRAYERRING = "Main (YarraYering)_Windows_OS_ITSPlatform_TKN07149f93-a1ef-4087-924c-a5d09b907c36.msi"
$YMBF = "Main (YMBF)_Windows_OS_ITSPlatform_TKNdaa1ef84-79b1-4c6a-8f6f-3d84a7897906.msi"

# Add new sites above
# no errors throughout
$ErrorActionPreference = 'silentlycontinue'
 
# Creating main folder
If (Test-Path $ASITScripts) {
    Write-Output "$ASITScripts exists. Skipping."
}
Else {
    Write-Output "The folder '$ASITScripts' doesn't exist. Creating now."
    Start-Sleep 1
    New-Item -Path "$ASITScripts" -ItemType Directory
    Write-Output "The folder $ASITScripts was successfully created."
}
 
# Installing RMM Agent
 
# Path for the download folder.
$RMM = "c:\ASITScripts\RMM"
If (Test-Path $RMM) {
    Write-Output "$RMM exists. Skipping."
}
Else {
    Write-Output "The folder '$RMM' doesn't exist. Creating now."
    Start-Sleep 1
    New-Item -Path "$RMM" -ItemType Directory
    Write-Output "The folder $RMM was successfully created."
}
 
# Do not edit anything above unless needed to for some reason - just keeps it neat by placing all the script stuff in one folder
function Get-MenuChoice
    {
    #region Comment Based Help [CBH]
 
    <#
    .SYNOPSIS
        Display a text menu & returns a valid response.
    #>
 
    #endregion
 
    #region Parameters
    # For some unknown reason, parameter help comments will not work without a CBH.
    [CmdletBinding()]
    Param
        (
        # Required string or string array of menu item[s] to display.
        [Parameter(
            Mandatory,
            Position = 0
            )]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $MenuItems,
 
        # Optional menu title.
        [Parameter(
            Position = 1
            )]
        [string]
        $MenuTitle = '',
 
        # Optional user prompt.
        [Parameter(
            Position = 2
            )]
        [string]
        $MenuPrompt = 'Please enter a choice from the above items '
        )
    #endregion
 
    #region Init variables
    $ValidMenuChoices = $MenuItems | ForEach-Object { $_ -replace '(\d+).*', '$1' }
    $Frequency = 1000
    $Duration = 100
    $MenuChoice = ''
    #endregion
 
    while ($MenuChoice -notin $ValidMenuChoices)
        {
        Clear-Host
        if (-not [string]::IsNullOrEmpty($MenuTitle))
            {
            $MenuTitle | Out-Host
            }
        $MenuItems | Out-Host
        Write-host ''
        $MenuChoice = (Read-Host $MenuPrompt)
        if ($MenuChoice -notin $ValidMenuChoices)
            {
            # The bell char doesn't work in the ISE and [console]:: items
            #    don't work in non-interactive sessions.
            if ($Host.Name -match 'ISE')
                {
                [console]::Beep($Frequency, $Duration)
                }
                else
                {
                Write-Host [char]7
                }
            }
        }
 
    return $MenuChoice
 
    } # end function Get-MenuChoice
 
$TopMenu = (
	'1 - AMCL',
	'2 - AQUACORP ADELAIDE' ,
	'3 - AQUACORP BRISBANE' ,
	'4 - ASIT',
	'5 - BARCRUSHER',
	'6 - BATMANS',
	'7 - BEAUMARIS',
	'8 - BENT AND COUGLE',
	'9 - BK TAYLOR',
	'10 - CAMVEX',
	'11 - CASTELLO CARDINIA',
	'12 - CASTELLO CROYDON',
	'13 - CASTELLO FORESTER',
	'14 - CASTELLO GISBOURNE',
	'15 - CASTELLO HEADOFFICE',
	'16 - CASTELLO LONGBEACH',
	'17 - CASTELLO PAKENHAM',
	'18 - CDIT',
	'19 - CHALMERS',
	'20 - CONSTRUCTION ZONE',
	'21 - CREATIVE UNIVERSE',
	'22 - CRIBPOINT',
	'23 - DESTINATION PHILLIP ISLAND',
	'24 - DIAGNOSTICARE',
	'25 - DIAM',
	'26 - DVR',
	'27 - EASYLIFE',
	'28 - ETU',
	'29 - FINWELL',
	'30 - GARAGE BEVERAGES',
	'31 - GBLA',
	'32 - HAAG',
	'33 - HGC',
	'34 - JAM WESTEND',
	'35 - JBP',
	'36 - KEATING',
	'37 - LEITZ MELBOURNE',
	'38 - MEDIA REPUBLIC',
	'39 - NEWCO',
	'40 - NEXUS',
	'41 - OPG HONG KONG',
	'42 - OPG MELBOURNE',
	'43 - OPG PHILLIPINES',
	'44 - OPG SYDNEY',
	'45 - POINTON PARTNERS',
	'46 - PTA',
	'47 - PUBCO BACCHUSMARSH',
	'48 - PUBCO BAYNBRIDGE',
	'49 - PUBCO BROWNS',
	'50 - PUBCO CROWN',
	'51 - PUBCO DUKE',
	'52 - PUBCO HEADOFFICE',
	'53 - PUBCO JUNCTION',
	'54 - PUBCO KNOX',
	'55 - PUBCO LYGON',
	'56 - PUBCO MORNINGTON',
	'57 - PUBCO NEPEAN',
	'58 - PUBCO POWELL',
	'59 - PUBCO TEMPLESTOWE',
	'60 - QUAIL',
	'61 - RACE COURSE',
	'62 - ROSEBUD HOTEL',
	'63 - ROSSTOWN HOTEL',
	'64 - SIW',
	'65 - SLEEP SERVICES',
	'66 - TFB BERLIN',
	'67 - TFB MELBOURNE',
	'68 - TPC',
	'69 - TRADEFLEX',
	'70 - TRINITY',
	'71 - VICMESH',
	'72 - VINCENT CHRISP',
	'73 - VINCENTCHRISP SHEPPARTON',
	'74 - WINENET',
	'75 - YARRA YERRING',
	'76 - YMBF',
	'77 - PUBCO MACS WARRNAMBOOL',
	'78 - LEXLAB',
 	'79 - LINCOLN PEARCE',
  	'80 - CASTELLO OLIVE TREE',
   	'81 - CASTELLO DERRIMUT',
	'0 - No RMM Client required')

# $Choice = Get-MenuChoice $TopMenu
$Choice = Get-MenuChoice -MenuItems $TopMenu -MenuTitle 'Which client / site is this device for?' -MenuPrompt 'Please select a site for RMM installation / SC client installation'

Write-Output ''
switch ($Choice)
    {
	'1' {$Selection = $AMCL}
	'2' {$Selection = $AQUACORPADELAIDE}
	'3' {$Selection = $AQUACORPBRISBANE}
	'4' {$Selection = $ASIT}
	'5' {$Selection = $BARCRUSHER}
	'6' {$Selection = $BATMANS}
	'7' {$Selection = $BEAUMARIS}
	'8' {$Selection = $BENTANDCOUGLE}
	'9' {$Selection = $BKTAYLOR}
	'10' {$Selection = $CAMVEX}
	'11' {$Selection = $CASTELLOCARDINIA}
	'12' {$Selection = $CASTELLOCROYDON}
	'13' {$Selection = $CASTELLOFORESTER}
	'14' {$Selection = $CASTELLOGISBOURNE}
	'15' {$Selection = $CASTELLOHEADOFFICE}
	'16' {$Selection = $CASTELLOLONGBEACH}
	'17' {$Selection = $CASTELLOPAKENHAM}
	'18' {$Selection = $CDIT}
	'19' {$Selection = $CHALMERS}
	'20' {$Selection = $CONSTRUCTIONZONE}
	'21' {$Selection = $CREATIVEUNIVERSE}
	'22' {$Selection = $CRIBPOINT}
	'23' {$Selection = $DESTINATIONPHILLIPISLAND}
	'24' {$Selection = $DIAGNOSTICARE}
	'25' {$Selection = $DIAM}
	'26' {$Selection = $DVR}
	'27' {$Selection = $EASYLIFE}
	'28' {$Selection = $ETU}
	'29' {$Selection = $FINWELL}
	'30' {$Selection = $GARAGEBEVERAGES}
	'31' {$Selection = $GBLA}
	'32' {$Selection = $HAAG}
	'33' {$Selection = $HGC}
	'34' {$Selection = $JAMWESTEND}
	'35' {$Selection = $JBP}
	'36' {$Selection = $KEATING}
	'37' {$Selection = $LEITZMELBOURNE}
	'38' {$Selection = $MEDIAREPUBLIC}
	'39' {$Selection = $NEWCO}
	'40' {$Selection = $NEXUS}
	'41' {$Selection = $OPGHONGKONG}
	'42' {$Selection = $OPGMELBOURNE}
	'43' {$Selection = $OPGPH}
	'44' {$Selection = $OPGSYDNEY}
	'45' {$Selection = $POINTONPARTNERS}
	'46' {$Selection = $PTA}
	'47' {$Selection = $PUBCOBACCHUSMARSH}
	'48' {$Selection = $PUBCOBAYNBRIDGE}
	'49' {$Selection = $PUBCOBROWNS}
	'50' {$Selection = $PUBCOCROWN}
	'51' {$Selection = $PUBCODUKE}
	'52' {$Selection = $PUBCOHEADOFFICE}
	'53' {$Selection = $PUBCOJUNCTION}
	'54' {$Selection = $PUBCOKNOX}
	'55' {$Selection = $PUBCOLYGON}
	'56' {$Selection = $PUBCOMORNINGTON}
	'57' {$Selection = $PUBCONEPEAN}
	'58' {$Selection = $PUBCOPOWELL}
	'59' {$Selection = $PUBCOTEMPLESTOWE}
	'60' {$Selection = $QUAIL}
	'61' {$Selection = $RACECOURSE}
	'62' {$Selection = $ROSEBUDHOTEL}
	'63' {$Selection = $ROSSTOWNHOTEL}
	'64' {$Selection = $SIW}
	'65' {$Selection = $SLEEPSERVICES}
	'66' {$Selection = $TFBBERLIN}
	'67' {$Selection = $TFBMELBOURNE}
	'68' {$Selection = $TPC}
	'69' {$Selection = $TRADEFLEX}
	'70' {$Selection = $TRINITY}
	'71' {$Selection = $VICMESH}
	'72' {$Selection = $VINCENTCHRISP}
	'73' {$Selection = $VINCENTCHRISPSHEPPARTON}
	'74' {$Selection = $WINENET}
	'75' {$Selection = $YARRAYERRING}
	'76' {$Selection = $YMBF}
	'77' {$Selection = $PUBCOMACS}
	'78' {$Selection = $LEXLAB}
 	'79' {$Selection = $LINCOLN}
  	'80' {$Selection = $CASTELLOOLIVETREE}
   	'81' {$Selection = $CASTELLODERRIMUT}
	'0' {$Selection = "NORMM"}
    }

# End selection

if ($Selection -match "NORMM")
{
    # Download the installer from the ScreenConnect website. Be sure to check if link is up to date - Not sure if ScreenConnect changes links or not
        Write-Output -ForegroundColor Green "Installing SC client"
        $source = "https://github.com/ASITScripts/ASITCORE/raw/main/ScreenConnect.ClientSetup%20(2).msi"
        $destination = "$ScreenConnectFolder\ScreenConnect.ClientSetup.msi"
        Invoke-WebRequest $source -OutFile $destination

    # Start the installation when download is finished - Devices will be placed in SC group called AA - Automated Installs - Move Me
        Start-Process -FilePath "$ScreenConnectFolder\ScreenConnect.ClientSetup.msi" -ArgumentList "/msi /norestart /quiet EULA_ACCEPT=YES"
}
else {
    # Downloads the RMM installer
        $source = "https://aussup-my.sharepoint.com/:u:/g/personal/louis_goode_asit_com_au/ERQ6-q5S83RAmH5t1gw8RloB1MqrLONLDbs654IaAY38sw?e=z8IGAB&download=1" #Replace this link with whatever
        $destination = "$RMM\$Selection"
        Invoke-WebRequest $source -OutFile $destination
        Start-Process -FilePath "$destination" -ArgumentList "/quiet" -Wait
        Write-Output -ForegroundColor Green "[$Time]`t" + "RMM Installation completed, please allow a few minutes for it to appear on RMM"
}

#Create Folder
$ByeByeBloatwareFolder = "C:\ASITScripts\Debloat"
If (Test-Path $ByeByeBloatwareFolder) {
    Write-Output -ForegroundColor Red ("[$Time]`t" + "$ByeByeBloatwareFolder exists. Skipping.")
}
Else {
    Write-Output -ForegroundColor Green ("[$Time]`t" + "The folder '$ByeByeBloatwareFolder' doesn't exist. Creating now.")
    Start-Sleep 1
    New-Item -Path "$ByeByeBloatwareFolder" -ItemType Directory
    Write-Output -ForegroundColor Green ("[$Time]`t" + "The folder $ByeByeBloatwareFolder was successfully created.")
}

Start-Transcript -Path "C:\ASITScripts\Debloat\Debloat.log"

$locale = Get-WinSystemLocale | Select-Object -expandproperty Name

##Switch on locale to set variables
## Switch on locale to set variables
switch ($locale) {
    "en-US" {
        $everyone = "Everyone"
        $builtin = "Builtin"
    }    
    "en-GB" {
        $everyone = "Everyone"
        $builtin = "Builtin"
    }
    default {
        $everyone = "Everyone"
        $builtin = "Builtin"
    }
}

#Changes the power plan
powercfg.exe -SETACTIVE 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
Powercfg /Change monitor-timeout-ac 60
Powercfg /Change monitor-timeout-dc 30
Powercfg /Change standby-timeout-ac 0
Powercfg /Change standby-timeout-dc 60
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238C9FA8-0AAD-41ED-83F4-97BE242C8F20 7bc4a2f9-d8fc-4469-b07b-33eb785aaca0 0
Write-Host -ForegroundColor Green ("[$Time]`t" + 'Powerplan adjusted')

#Add VPN Registry fixes
New-ItemProperty  -path "HKLM:\SYSTEM\CurrentControlSet\Services\PolicyAgent" -name "AssumeUDPEncapsulationContextOnSendRule" -value "2"  -PropertyType "Dword"
New-ItemProperty  -path "HKLM:\SYSTEM\CurrentControlSet\Services\RasMan\Parameters" -name "ProhibitIpSec" -value "0"  -PropertyType "Dword"
Write-Host -ForegroundColor Green ("[$Time]`t" + 'VPN Regfix added')

############################################################################################################
#                                        Remove AppX Packages                                              #
#                                                                                                          #
############################################################################################################

    #Removes AppxPackages
    $WhitelistedApps = 'Microsoft.WindowsNotepad|Microsoft.CompanyPortal|Microsoft.ScreenSketch|Microsoft.Paint3D|Microsoft.WindowsCalculator|Microsoft.WindowsStore|Microsoft.Windows.Photos|CanonicalGroupLimited.UbuntuonWindows|`
    |Microsoft.MicrosoftStickyNotes|Microsoft.MSPaint|Microsoft.WindowsCamera|.NET|Framework|AD2F1837.HPAutoLockAndAwake`
    Microsoft.HEIFImageExtension|Microsoft.ScreenSketch|Microsoft.StorePurchaseApp|Microsoft.VP9VideoExtensions|Microsoft.WebMediaExtensions|Microsoft.WebpImageExtension|Microsoft.DesktopAppInstaller|WindSynthBerry|MIDIBerry|Slack'
    #NonRemovable Apps that where getting attempted and the system would reject the uninstall, speeds up debloat and prevents 'initalizing' overlay when removing apps
    $NonRemovable = '1527c705-839a-4832-9118-54d4Bd6a0c89|c5e2524a-ea46-4f67-841f-6a9465d9d515|E2A4F912-2574-4A75-9BB0-0D023378592B|F46D4000-FD22-4DB4-AC8E-4E1DDDE828FE|InputApp|Microsoft.AAD.BrokerPlugin|Microsoft.AccountsControl|`
    Microsoft.BioEnrollment|Microsoft.CredDialogHost|Microsoft.ECApp|Microsoft.LockApp|Microsoft.MicrosoftEdgeDevToolsClient|Microsoft.MicrosoftEdge|Microsoft.PPIProjection|Microsoft.Win32WebViewHost|Microsoft.Windows.Apprep.ChxApp|`
    Microsoft.Windows.AssignedAccessLockApp|Microsoft.Windows.CapturePicker|Microsoft.Windows.CloudExperienceHost|Microsoft.Windows.ContentDeliveryManager|Microsoft.Windows.Cortana|Microsoft.Windows.NarratorQuickStart|`
    Microsoft.Windows.ParentalControls|Microsoft.Windows.PeopleExperienceHost|Microsoft.Windows.PinningConfirmationDialog|Microsoft.Windows.SecHealthUI|Microsoft.Windows.SecureAssessmentBrowser|Microsoft.Windows.ShellExperienceHost|`
    Microsoft.Windows.XGpuEjectDialog|Microsoft.XboxGameCallableUI|Windows.CBSPreview|windows.immersivecontrolpanel|Windows.PrintDialog|Microsoft.XboxGameCallableUI|Microsoft.VCLibs.140.00|Microsoft.Services.Store.Engagement|Microsoft.UI.Xaml.2.0|*Nvidia*'
    Get-AppxPackage -AllUsers | Where-Object {$_.Name -NotMatch $WhitelistedApps -and $_.Name -NotMatch $NonRemovable} | Remove-AppxPackage
    Get-AppxPackage -allusers | Where-Object {$_.Name -NotMatch $WhitelistedApps -and $_.Name -NotMatch $NonRemovable} | Remove-AppxPackage
    Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -NotMatch $WhitelistedApps -and $_.PackageName -NotMatch $NonRemovable} | Remove-AppxProvisionedPackage -Online


##Remove bloat
    $Bloatware = @(

        #Unnecessary Windows 10/11 AppX Apps
        "Microsoft.549981C3F5F10"
        "Microsoft.BingNews"
        "Microsoft.GetHelp"
        "Microsoft.Getstarted"
        "Microsoft.Messaging"
        "Microsoft.Microsoft3DViewer"
        "Microsoft.MicrosoftOfficeHub"
        "Microsoft.MicrosoftSolitaireCollection"
        "Microsoft.NetworkSpeedTest"
        "Microsoft.MixedReality.Portal"
        "Microsoft.News"
        "Microsoft.Office.Lens"
        "Microsoft.Office.OneNote"
        "Microsoft.Office.Sway"
        "Microsoft.OneConnect"
        "Microsoft.People"
        "Microsoft.Print3D"
        "Microsoft.RemoteDesktop"
        "Microsoft.SkypeApp"
        "Microsoft.StorePurchaseApp"
        "Microsoft.Office.Todo.List"
        "Microsoft.Whiteboard"
        "Microsoft.WindowsAlarms"
        #"Microsoft.WindowsCamera"
        "microsoft.windowscommunicationsapps"
        "Microsoft.WindowsFeedbackHub"
        "Microsoft.WindowsMaps"
        "Microsoft.WindowsSoundRecorder"
        "Microsoft.Xbox.TCUI"
        "Microsoft.XboxApp"
        "Microsoft.XboxGameOverlay"
        "Microsoft.XboxIdentityProvider"
        "Microsoft.XboxSpeechToTextOverlay"
        "Microsoft.ZuneMusic"
        "Microsoft.ZuneVideo"
        "MicrosoftTeams"
        "Microsoft.YourPhone"
        "Microsoft.XboxGamingOverlay_5.721.10202.0_neutral_~_8wekyb3d8bbwe"
        "Microsoft.GamingApp"
        "Microsoft.Todos"
        "Microsoft.PowerAutomateDesktop"
        "SpotifyAB.SpotifyMusic"
        "Disney.37853FC22B2CE"
        "*EclipseManager*"
        "*ActiproSoftwareLLC*"
        "*AdobeSystemsIncorporated.AdobePhotoshopExpress*"
        "*Duolingo-LearnLanguagesforFree*"
        "*PandoraMediaInc*"
        "*CandyCrush*"
        "*BubbleWitch3Saga*"
        "*Wunderlist*"
        "*Flipboard*"
        "*Twitter*"
        "*Facebook*"
        "*Spotify*"
        "*Minecraft*"
        "*Royal Revolt*"
        "*Sway*"
        "*Speed Test*"
        "*Dolby*"
        "*Office*"
        "*Disney*"
        "clipchamp.clipchamp"
        "*gaming*"
        "MicrosoftCorporationII.MicrosoftFamily"
        "C27EB4BA.DropboxOEM"
        "*DevHome*"
        #Optional: Typically not removed but you can if you need to for some reason
        #"*Microsoft.Advertising.Xaml_10.1712.5.0_x64__8wekyb3d8bbwe*"
        #"*Microsoft.Advertising.Xaml_10.1712.5.0_x86__8wekyb3d8bbwe*"
        #"*Microsoft.BingWeather*"
        #"*Microsoft.MSPaint*"
        #"*Microsoft.MicrosoftStickyNotes*"
        #"*Microsoft.Windows.Photos*"
        #"*Microsoft.WindowsCalculator*"
        #"*Microsoft.WindowsStore*"

    )
    foreach ($Bloat in $Bloatware) {
        
        Get-AppxPackage -allusers -Name $Bloat| Remove-AppxPackage -AllUsers
        Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like $Bloat | Remove-AppxProvisionedPackage -Online
        Write-Host "Trying to remove $Bloat."
    }

############################################################################################################
#                                        Remove Registry Keys                                              #
#                                                                                                          #
############################################################################################################

##We need to grab all SIDs to remove at user level
$UserSIDs = Get-ChildItem "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList" | Select-Object -ExpandProperty PSChildName

    
    #These are the registry keys that it will delete.
            
    $Keys = @(
            
        #Remove Background Tasks
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.BackgroundTasks\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
        #Windows File
        "HKCR:\Extensions\ContractId\Windows.File\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
            
        #Registry keys to delete if they aren't uninstalled by RemoveAppXPackage/RemoveAppXProvisionedPackage
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\46928bounde.EclipseManager_2.2.4.51_neutral__a5h4egax66k6y"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Launch\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
            
        #Scheduled Tasks to delete
        "HKCR:\Extensions\ContractId\Windows.PreInstalledConfigTask\PackageId\Microsoft.MicrosoftOfficeHub_17.7909.7600.0_x64__8wekyb3d8bbwe"
            
        #Windows Protocol Keys
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.PPIProjection_10.0.15063.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.15063.0.0_neutral_neutral_cw5n1h2txyewy"
        "HKCR:\Extensions\ContractId\Windows.Protocol\PackageId\Microsoft.XboxGameCallableUI_1000.16299.15.0_neutral_neutral_cw5n1h2txyewy"
               
        #Windows Share Target
        "HKCR:\Extensions\ContractId\Windows.ShareTarget\PackageId\ActiproSoftwareLLC.562882FEEB491_2.6.18.18_neutral__24pqs290vpjk0"
    )
        
    #This writes the output of each key it is removing and also removes the keys listed above.
    ForEach ($Key in $Keys) {
        Write-Host "Removing $Key from registry"
        Remove-Item $Key -Recurse
    }


    #Disables Windows Feedback Experience
    Write-Host "Disabling Windows Feedback Experience program"
    $Advertising = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo"
    If (!(Test-Path $Advertising)) {
        New-Item $Advertising
    }
    If (Test-Path $Advertising) {
        Set-ItemProperty $Advertising Enabled -Value 0 
    }
            
    #Stops Cortana from being used as part of your Windows Search Function
    Write-Host "Stopping Cortana from being used as part of your Windows Search Function"
    $Search = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
    If (!(Test-Path $Search)) {
        New-Item $Search
    }
    If (Test-Path $Search) {
        Set-ItemProperty $Search AllowCortana -Value 0 
    }

    #Disables Web Search in Start Menu
    Write-Host "Disabling Bing Search in Start Menu"
    $WebSearch = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
    If (!(Test-Path $WebSearch)) {
        New-Item $WebSearch
    }
    Set-ItemProperty $WebSearch DisableWebSearch -Value 1 
    ##Loop through all user SIDs in the registry and disable Bing Search
    foreach ($sid in $UserSIDs) {
        $WebSearch = "Registry::HKU\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Search"
        If (!(Test-Path $WebSearch)) {
            New-Item $WebSearch
        }
        Set-ItemProperty $WebSearch BingSearchEnabled -Value 0
    }
    
    Set-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" BingSearchEnabled -Value 0 

            
    #Stops the Windows Feedback Experience from sending anonymous data
    Write-Host "Stopping the Windows Feedback Experience program"
    $Period = "HKCU:\Software\Microsoft\Siuf\Rules"
    If (!(Test-Path $Period)) { 
        New-Item $Period
    }
    Set-ItemProperty $Period PeriodInNanoSeconds -Value 0 

    ##Loop and do the same
    foreach ($sid in $UserSIDs) {
        $Period = "Registry::HKU\$sid\Software\Microsoft\Siuf\Rules"
        If (!(Test-Path $Period)) { 
            New-Item $Period
        }
        Set-ItemProperty $Period PeriodInNanoSeconds -Value 0 
    }

    #Prevents bloatware applications from returning and removes Start Menu suggestions               
    Write-Host "Adding Registry key to prevent bloatware apps from returning"
    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
    $registryOEM = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    If (!(Test-Path $registryPath)) { 
        New-Item $registryPath
    }
    Set-ItemProperty $registryPath DisableWindowsConsumerFeatures -Value 1 

    If (!(Test-Path $registryOEM)) {
        New-Item $registryOEM
    }
    Set-ItemProperty $registryOEM  ContentDeliveryAllowed -Value 0 
    Set-ItemProperty $registryOEM  OemPreInstalledAppsEnabled -Value 0 
    Set-ItemProperty $registryOEM  PreInstalledAppsEnabled -Value 0 
    Set-ItemProperty $registryOEM  PreInstalledAppsEverEnabled -Value 0 
    Set-ItemProperty $registryOEM  SilentInstalledAppsEnabled -Value 0 
    Set-ItemProperty $registryOEM  SystemPaneSuggestionsEnabled -Value 0  
    
    ##Loop through users and do the same
    foreach ($sid in $UserSIDs) {
        $registryOEM = "Registry::HKU\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
        If (!(Test-Path $registryOEM)) {
            New-Item $registryOEM
        }
        Set-ItemProperty $registryOEM  ContentDeliveryAllowed -Value 0 
        Set-ItemProperty $registryOEM  OemPreInstalledAppsEnabled -Value 0 
        Set-ItemProperty $registryOEM  PreInstalledAppsEnabled -Value 0 
        Set-ItemProperty $registryOEM  PreInstalledAppsEverEnabled -Value 0 
        Set-ItemProperty $registryOEM  SilentInstalledAppsEnabled -Value 0 
        Set-ItemProperty $registryOEM  SystemPaneSuggestionsEnabled -Value 0 
    }
    
    #Preping mixed Reality Portal for removal    
    Write-Host "Setting Mixed Reality Portal value to 0 so that you can uninstall it in Settings"
    $Holo = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Holographic"    
    If (Test-Path $Holo) {
        Set-ItemProperty $Holo  FirstRunSucceeded -Value 0 
    }

    ##Loop through users and do the same
    foreach ($sid in $UserSIDs) {
        $Holo = "Registry::HKU\$sid\Software\Microsoft\Windows\CurrentVersion\Holographic"    
        If (Test-Path $Holo) {
            Set-ItemProperty $Holo  FirstRunSucceeded -Value 0 
        }
    }

    #Disables Wi-fi Sense
    Write-Host "Disabling Wi-Fi Sense"
    $WifiSense1 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting"
    $WifiSense2 = "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots"
    $WifiSense3 = "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config"
    If (!(Test-Path $WifiSense1)) {
        New-Item $WifiSense1
    }
    Set-ItemProperty $WifiSense1  Value -Value 0 
    If (!(Test-Path $WifiSense2)) {
        New-Item $WifiSense2
    }
    Set-ItemProperty $WifiSense2  Value -Value 0 
    Set-ItemProperty $WifiSense3  AutoConnectAllowedOEM -Value 0 
        
    #Disables live tiles
    Write-Host "Disabling live tiles"
    $Live = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"    
    If (!(Test-Path $Live)) {      
        New-Item $Live
    }
    Set-ItemProperty $Live  NoTileApplicationNotification -Value 1 

    ##Loop through users and do the same
    foreach ($sid in $UserSIDs) {
        $Live = "Registry::HKU\$sid\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"    
        If (!(Test-Path $Live)) {      
            New-Item $Live
        }
        Set-ItemProperty $Live  NoTileApplicationNotification -Value 1 
    }
        
    #Turns off Data Collection via the AllowTelemtry key by changing it to 0
    # This is needed for Intune reporting to work, uncomment if using via other method
    #Write-Host "Turning off Data Collection"
    #$DataCollection1 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
    #$DataCollection2 = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    #$DataCollection3 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection"    
    #If (Test-Path $DataCollection1) {
    #    Set-ItemProperty $DataCollection1  AllowTelemetry -Value 0 
    #}
    #If (Test-Path $DataCollection2) {
    #    Set-ItemProperty $DataCollection2  AllowTelemetry -Value 0 
    #}
    #If (Test-Path $DataCollection3) {
    #    Set-ItemProperty $DataCollection3  AllowTelemetry -Value 0 
    #}
    

###Enable location tracking for "find my device", uncomment if you don't need it

    #Disabling Location Tracking
    #Write-Host "Disabling Location Tracking"
    #$SensorState = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}"
    #$LocationConfig = "HKLM:\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration"
    #If (!(Test-Path $SensorState)) {
    #    New-Item $SensorState
    #}
    #Set-ItemProperty $SensorState SensorPermissionState -Value 0 
    #If (!(Test-Path $LocationConfig)) {
    #    New-Item $LocationConfig
    #}
    #Set-ItemProperty $LocationConfig Status -Value 0 
        
    #Disables People icon on Taskbar
    Write-Host "Disabling People icon on Taskbar"
    $People = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People'
    If (Test-Path $People) {
        Set-ItemProperty $People -Name PeopleBand -Value 0
    }

    ##Loop through users and do the same
    foreach ($sid in $UserSIDs) {
        $People = "Registry::HKU\$sid\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People"
        If (Test-Path $People) {
            Set-ItemProperty $People -Name PeopleBand -Value 0
        }
    }

    Write-Host "Disabling Cortana"
    $Cortana1 = "HKCU:\SOFTWARE\Microsoft\Personalization\Settings"
    $Cortana2 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization"
    $Cortana3 = "HKCU:\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
    If (!(Test-Path $Cortana1)) {
        New-Item $Cortana1
    }
    Set-ItemProperty $Cortana1 AcceptedPrivacyPolicy -Value 0 
    If (!(Test-Path $Cortana2)) {
        New-Item $Cortana2
    }
    Set-ItemProperty $Cortana2 RestrictImplicitTextCollection -Value 1 
    Set-ItemProperty $Cortana2 RestrictImplicitInkCollection -Value 1 
    If (!(Test-Path $Cortana3)) {
        New-Item $Cortana3
    }
    Set-ItemProperty $Cortana3 HarvestContacts -Value 0

    ##Loop through users and do the same
    foreach ($sid in $UserSIDs) {
        $Cortana1 = "Registry::HKU\$sid\SOFTWARE\Microsoft\Personalization\Settings"
        $Cortana2 = "Registry::HKU\$sid\SOFTWARE\Microsoft\InputPersonalization"
        $Cortana3 = "Registry::HKU\$sid\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore"
        If (!(Test-Path $Cortana1)) {
            New-Item $Cortana1
        }
        Set-ItemProperty $Cortana1 AcceptedPrivacyPolicy -Value 0 
        If (!(Test-Path $Cortana2)) {
            New-Item $Cortana2
        }
        Set-ItemProperty $Cortana2 RestrictImplicitTextCollection -Value 1 
        Set-ItemProperty $Cortana2 RestrictImplicitInkCollection -Value 1 
        If (!(Test-Path $Cortana3)) {
            New-Item $Cortana3
        }
        Set-ItemProperty $Cortana3 HarvestContacts -Value 0
    }


    #Removes 3D Objects from the 'My Computer' submenu in explorer
    Write-Host "Removing 3D Objects from explorer 'My Computer' submenu"
    $Objects32 = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
    $Objects64 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}"
    If (Test-Path $Objects32) {
        Remove-Item $Objects32 -Recurse 
    }
    If (Test-Path $Objects64) {
        Remove-Item $Objects64 -Recurse 
    }

   
    ##Removes the Microsoft Feeds from displaying
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds"
$Name = "EnableFeeds"
$value = "0"

if (!(Test-Path $registryPath)) {
    New-Item -Path $registryPath -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
}

else {
    New-ItemProperty -Path $registryPath -Name $name -Value $value -PropertyType DWORD -Force | Out-Null
}

##Kill Cortana again
Get-AppxPackage - allusers Microsoft.549981C3F5F10 | Remove AppxPackage
    
############################################################################################################
#                                        Remove Scheduled Tasks                                            #
#                                                                                                          #
############################################################################################################

    #Disables scheduled tasks that are considered unnecessary 
    Write-Host "Disabling scheduled tasks"
    $task1 = Get-ScheduledTask -TaskName XblGameSaveTaskLogon -ErrorAction SilentlyContinue
    if ($null -ne $task1) {
    Get-ScheduledTask  XblGameSaveTaskLogon | Disable-ScheduledTask -ErrorAction SilentlyContinue
    }
    $task2 = Get-ScheduledTask -TaskName XblGameSaveTask -ErrorAction SilentlyContinue
    if ($null -ne $task2) {
    Get-ScheduledTask  XblGameSaveTask | Disable-ScheduledTask -ErrorAction SilentlyContinue
    }
    $task3 = Get-ScheduledTask -TaskName Consolidator -ErrorAction SilentlyContinue
    if ($null -ne $task3) {
    Get-ScheduledTask  Consolidator | Disable-ScheduledTask -ErrorAction SilentlyContinue
    }
    $task4 = Get-ScheduledTask -TaskName UsbCeip -ErrorAction SilentlyContinue
    if ($null -ne $task4) {
    Get-ScheduledTask  UsbCeip | Disable-ScheduledTask -ErrorAction SilentlyContinue
    }
    $task5 = Get-ScheduledTask -TaskName DmClient -ErrorAction SilentlyContinue
    if ($null -ne $task5) {
    Get-ScheduledTask  DmClient | Disable-ScheduledTask -ErrorAction SilentlyContinue
    }
    $task6 = Get-ScheduledTask -TaskName DmClientOnScenarioDownload -ErrorAction SilentlyContinue
    if ($null -ne $task6) {
    Get-ScheduledTask  DmClientOnScenarioDownload | Disable-ScheduledTask -ErrorAction SilentlyContinue
    }


############################################################################################################
#                                             Disable Services                                             #
#                                                                                                          #
############################################################################################################
    ##Write-Host "Stopping and disabling Diagnostics Tracking Service"
    #Disabling the Diagnostics Tracking Service
    ##Stop-Service "DiagTrack"
    ##Set-Service "DiagTrack" -StartupType Disabled

    Function StopDisableService($name) {
        if (Get-Service -Name $name -ea SilentlyContinue) {
            Stop-Service -Name $name -Force -Confirm:$False
            Set-Service -Name $name -StartupType Disabled
        }
    }
    StopDisableService -name "HPAppHelperCap"
    StopDisableService -name "HP Comm Recover" #This causes disconnection issues
    #StopDisableService -name "HPDiagsCap" - Just for diagnosing
    #StopDisableService -name "HotKeyServiceUWP" - This disables FN keys for HP devices - SOMETIMES you can disable this if needed if it's causing issues for some reason
    StopDisableService -name "LanWlanWwanSwitchgingServiceUWP" # Not sure if we need to stop this or not - if someone can find out that'd be cool
    StopDisableService -name "HPNetworkCap"
    StopDisableService -name "HPSysInfoCap"
    StopDisableService -name "HP TechPulse Core"
    StopDisableService -name "IntelCstService"
    StopDisableService -name "IntelCstSupportService"

############################################################################################################
#                                        Windows 11 Specific                                               #
#                                                                                                          #
############################################################################################################
    #Windows 11 Customisations
    write-host "Removing Windows 11 Customisations"
    #Remove XBox Game Bar
    
    Get-AppxPackage -allusers Microsoft.XboxGamingOverlay | Remove-AppxPackage
    write-host "Removed Xbox Gaming Overlay"
    Get-AppxPackage -allusers Microsoft.XboxGameCallableUI | Remove-AppxPackage
    write-host "Removed Xbox Game Callable UI"

    #Remove Cortana
    Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppxPackage
    write-host "Removed Cortana"

    #Remove GetStarted
    Get-AppxPackage -allusers *getstarted* | Remove-AppxPackage
    write-host "Removed Get Started"

    #Remove Parental Controls
   Get-AppxPackage -allusers Microsoft.Windows.ParentalControls | Remove-AppxPackage 
   write-host "Removed Parental Controls"

   #Remove Teams Chat
$MSTeams = "MicrosoftTeams"

$WinPackage = Get-AppxPackage -allusers | Where-Object {$_.Name -eq $MSTeams}
$ProvisionedPackage = Get-AppxProvisionedPackage -Online | Where-Object { $_.DisplayName -eq $WinPackage }
If ($null -ne $WinPackage) 
{
    Remove-AppxPackage  -Package $WinPackage.PackageFullName -AllUsers
} 

If ($null -ne $ProvisionedPackage) 
{
    Remove-AppxProvisionedPackage -online -Packagename $ProvisionedPackage.Packagename -AllUsers
}

##Tweak reg permissions
Invoke-WebRequest -uri "https://github.com/ASITScripts/ASITCORE/raw/Pre-InstallREQs/SetACL.exe" -outfile "C:\Windows\Temp\SetACL.exe"
C:\Windows\Temp\SetACL.exe -on "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" -ot reg -actn setowner -ownr "n:$everyone"
 C:\Windows\Temp\SetACL.exe -on "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" -ot reg -actn ace -ace "n:$everyone;p:full"


##Stop it coming back
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications"
If (!(Test-Path $registryPath)) { 
    New-Item $registryPath
}
Set-ItemProperty $registryPath ConfigureChatAutoInstall -Value 0


##Unpin it
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Chat"
If (!(Test-Path $registryPath)) { 
    New-Item $registryPath
}
Set-ItemProperty $registryPath "ChatIcon" -Value 2
write-host "Removed Teams Chat"
############################################################################################################
#                                           Windows Backup App                                             #
#                                                                                                          #
############################################################################################################
$version = Get-WMIObject win32_operatingsystem | Select-Object Caption
if ($version.Caption -like "*Windows 10*") {
    write-host "Removing Windows Backup"
    $filepath = "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\WindowsBackup\Assets"
if (Test-Path $filepath) {
Remove-WindowsPackage -Online -PackageName "Microsoft-Windows-UserExperience-Desktop-Package~31bf3856ad364e35~amd64~~10.0.19041.3393"

##Add back snipping tool functionality
write-host "Adding Windows Shell Components"
DISM /Online /Add-Capability /CapabilityName:Windows.Client.ShellComponents~~~~0.0.1.0
write-host "Components Added"
}
write-host "Removed"
}

############################################################################################################
#                                           Windows CoPilot                                                #
#                                                                                                          #
############################################################################################################
$version = Get-WMIObject win32_operatingsystem | Select-Object Caption
if ($version.Caption -like "*Windows 11*") {
    write-host "Removing Windows Copilot"
# Define the registry key and value
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"
$propertyName = "TurnOffWindowsCopilot"
$propertyValue = 1

# Check if the registry key exists
if (!(Test-Path $registryPath)) {
    # If the registry key doesn't exist, create it
    New-Item -Path $registryPath -Force | Out-Null
}

# Get the property value
$currentValue = Get-ItemProperty -Path $registryPath -Name $propertyName -ErrorAction SilentlyContinue

# Check if the property exists and if its value is different from the desired value
if ($null -eq $currentValue -or $currentValue.$propertyName -ne $propertyValue) {
    # If the property doesn't exist or its value is different, set the property value
    Set-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue
}


##Grab the default user as well
$registryPath = "HKEY_USERS\.DEFAULT\Software\Policies\Microsoft\Windows\WindowsCopilot"
$propertyName = "TurnOffWindowsCopilot"
$propertyValue = 1

# Check if the registry key exists
if (!(Test-Path $registryPath)) {
    # If the registry key doesn't exist, create it
    New-Item -Path $registryPath -Force | Out-Null
}

# Get the property value
$currentValue = Get-ItemProperty -Path $registryPath -Name $propertyName -ErrorAction SilentlyContinue

# Check if the property exists and if its value is different from the desired value
if ($null -eq $currentValue -or $currentValue.$propertyName -ne $propertyValue) {
    # If the property doesn't exist or its value is different, set the property value
    Set-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue
}


##Load the default hive from c:\users\Default\NTUSER.dat
reg load HKU\temphive "c:\users\default\ntuser.dat"
$registryPath = "registry::hku\temphive\Software\Policies\Microsoft\Windows\WindowsCopilot"
$propertyName = "TurnOffWindowsCopilot"
$propertyValue = 1

# Check if the registry key exists
if (!(Test-Path $registryPath)) {
    # If the registry key doesn't exist, create it
    [Microsoft.Win32.RegistryKey]$HKUCoPilot = [Microsoft.Win32.Registry]::Users.CreateSubKey("temphive\Software\Policies\Microsoft\Windows\WindowsCopilot", [Microsoft.Win32.RegistryKeyPermissionCheck]::ReadWriteSubTree)
    $HKUCoPilot.SetValue("TurnOffWindowsCopilot", 0x1, [Microsoft.Win32.RegistryValueKind]::DWord)
}

        



    $HKUCoPilot.Flush()
    $HKUCoPilot.Close()
[gc]::Collect()
[gc]::WaitForPendingFinalizers()
reg unload HKU\temphive


write-host "Removed"


foreach ($sid in $UserSIDs) {
    $registryPath = "Registry::HKU\$sid\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot"
    $propertyName = "TurnOffWindowsCopilot"
    $propertyValue = 1
    
    # Check if the registry key exists
    if (!(Test-Path $registryPath)) {
        # If the registry key doesn't exist, create it
        New-Item -Path $registryPath -Force | Out-Null
    }
    
    # Get the property value
    $currentValue = Get-ItemProperty -Path $registryPath -Name $propertyName -ErrorAction SilentlyContinue
    
    # Check if the property exists and if its value is different from the desired value
    if ($null -eq $currentValue -or $currentValue.$propertyName -ne $propertyValue) {
        # If the property doesn't exist or its value is different, set the property value
        Set-ItemProperty -Path $registryPath -Name $propertyName -Value $propertyValue
    }
}
}

############################################################################################################
#                                             Clear Start Menu                                             #
#                                                                                                          #
############################################################################################################
write-host "Clearing Start Menu"
#Delete layout file if it already exists

##Check windows version
$version = Get-WMIObject win32_operatingsystem | Select-Object Caption
if ($version.Caption -like "*Windows 10*") {
    write-host "Windows 10 Detected"
    write-host "Removing Current Layout"
    If(Test-Path C:\Windows\StartLayout.xml)

    {
    
    Remove-Item C:\Windows\StartLayout.xml
    
    }
    write-host "Creating Default Layout"
    #Creates the blank layout file
    
    Write-Output "<LayoutModificationTemplate xmlns:defaultlayout=""http://schemas.microsoft.com/Start/2014/FullDefaultLayout"" xmlns:start=""http://schemas.microsoft.com/Start/2014/StartLayout"" Version=""1"" xmlns=""http://schemas.microsoft.com/Start/2014/LayoutModification"">" >> C:\Windows\StartLayout.xml
    
    Write-Output " <LayoutOptions StartTileGroupCellWidth=""6"" />" >> C:\Windows\StartLayout.xml
    
    Write-Output " <DefaultLayoutOverride>" >> C:\Windows\StartLayout.xml
    
    Write-Output " <StartLayoutCollection>" >> C:\Windows\StartLayout.xml
    
    Write-Output " <defaultlayout:StartLayout GroupCellWidth=""6"" />" >> C:\Windows\StartLayout.xml
    
    Write-Output " </StartLayoutCollection>" >> C:\Windows\StartLayout.xml
    
    Write-Output " </DefaultLayoutOverride>" >> C:\Windows\StartLayout.xml
    
    Write-Output "</LayoutModificationTemplate>" >> C:\Windows\StartLayout.xml
}
if ($version.Caption -like "*Windows 11*") {
    write-host "Windows 11 Detected"
    write-host "Removing Current Layout"
    If(Test-Path "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml")

    {
    
    Remove-Item "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml"
    
    }
    
$blankjson = @'
{ 
    "pinnedList": [ 
      { "desktopAppId": "MSEdge" }, 
      { "packagedAppId": "Microsoft.WindowsStore_8wekyb3d8bbwe!App" }, 
      { "packagedAppId": "desktopAppId":"Microsoft.Windows.Explorer" } 
    ] 
  }
'@

$blankjson | Out-File "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml" -Encoding utf8 -Force
}


############################################################################################################
#                                              Remove Xbox Gaming                                          #
#                                                                                                          #
############################################################################################################

New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Services\xbgm" -Name "Start" -PropertyType DWORD -Value 4 -Force
Set-Service -Name XblAuthManager -StartupType Disabled
Set-Service -Name XblGameSave -StartupType Disabled
Set-Service -Name XboxGipSvc -StartupType Disabled
Set-Service -Name XboxNetApiSvc -StartupType Disabled
$task = Get-ScheduledTask -TaskName "Microsoft\XblGameSave\XblGameSaveTask" -ErrorAction SilentlyContinue
if ($null -ne $task) {
Set-ScheduledTask -TaskPath $task.TaskPath -Enabled $false
}

##Check if GamePresenceWriter.exe exists
if (Test-Path "$env:WinDir\System32\GameBarPresenceWriter.exe") {
    write-host "GamePresenceWriter.exe exists"
    C:\Windows\Temp\SetACL.exe -on  "$env:WinDir\System32\GameBarPresenceWriter.exe" -ot file -actn setowner -ownr "n:$everyone"
C:\Windows\Temp\SetACL.exe -on  "$env:WinDir\System32\GameBarPresenceWriter.exe" -ot file -actn ace -ace "n:$everyone;p:full"

#Take-Ownership -Path "$env:WinDir\System32\GameBarPresenceWriter.exe"
$NewAcl = Get-Acl -Path "$env:WinDir\System32\GameBarPresenceWriter.exe"
# Set properties
$identity = "$builtin\Administrators"
$fileSystemRights = "FullControl"
$type = "Allow"
# Create new rule
$fileSystemAccessRuleArgumentList = $identity, $fileSystemRights, $type
$fileSystemAccessRule = New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule -ArgumentList $fileSystemAccessRuleArgumentList
# Apply new rule
$NewAcl.SetAccessRule($fileSystemAccessRule)
Set-Acl -Path "$env:WinDir\System32\GameBarPresenceWriter.exe" -AclObject $NewAcl
Stop-Process -Name "GameBarPresenceWriter.exe" -Force
Remove-Item "$env:WinDir\System32\GameBarPresenceWriter.exe" -Force -Confirm:$false

}
else {
    write-host "GamePresenceWriter.exe does not exist"
}

New-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\GameDVR" -Name "AllowgameDVR" -PropertyType DWORD -Value 0 -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "SettingsPageVisibility" -PropertyType String -Value "hide:gaming-gamebar;gaming-gamedvr;gaming-broadcasting;gaming-gamemode;gaming-xboxnetworking" -Force
Remove-Item C:\Windows\Temp\SetACL.exe -recurse

############################################################################################################
#                                       Grab all Uninstall Strings                                         #
#                                                                                                          #
############################################################################################################


write-host "Checking 32-bit System Registry"
##Search for 32-bit versions and list them
$allstring = @()
$path1 =  "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
#Loop Through the apps if name has Adobe and NOT reader
$32apps = Get-ChildItem -Path $path1 | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString

foreach ($32app in $32apps) {
#Get uninstall string
$string1 =  $32app.uninstallstring
#Check if it's an MSI install
if ($string1 -match "^msiexec*") {
#MSI install, replace the I with an X and make it quiet
$string2 = $string1 + " /quiet /norestart"
$string2 = $string2 -replace "/I", "/X "
#Create custom object with name and string
$allstring += New-Object -TypeName PSObject -Property @{
    Name = $32app.DisplayName
    String = $string2
}
}
else {
#Exe installer, run straight path
$string2 = $string1
$allstring += New-Object -TypeName PSObject -Property @{
    Name = $32app.DisplayName
    String = $string2
}
}

}
write-host "32-bit check complete"
write-host "Checking 64-bit System registry"
##Search for 64-bit versions and list them

$path2 =  "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
#Loop Through the apps if name has Adobe and NOT reader
$64apps = Get-ChildItem -Path $path2 | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString

foreach ($64app in $64apps) {
#Get uninstall string
$string1 =  $64app.uninstallstring
#Check if it's an MSI install
if ($string1 -match "^msiexec*") {
#MSI install, replace the I with an X and make it quiet
$string2 = $string1 + " /quiet /norestart"
$string2 = $string2 -replace "/I", "/X "
#Uninstall with string2 params
$allstring += New-Object -TypeName PSObject -Property @{
    Name = $64app.DisplayName
    String = $string2
}
}
else {
#Exe installer, run straight path
$string2 = $string1
$allstring += New-Object -TypeName PSObject -Property @{
    Name = $64app.DisplayName
    String = $string2
}
}

}

write-host "64-bit checks complete"

##USER
write-host "Checking 32-bit User Registry"
##Search for 32-bit versions and list them
$path1 =  "HKCU:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
##Check if path exists
if (Test-Path $path1) {
#Loop Through the apps if name has Adobe and NOT reader
$32apps = Get-ChildItem -Path $path1 | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString

foreach ($32app in $32apps) {
#Get uninstall string
$string1 =  $32app.uninstallstring
#Check if it's an MSI install
if ($string1 -match "^msiexec*") {
#MSI install, replace the I with an X and make it quiet
$string2 = $string1 + " /quiet /norestart"
$string2 = $string2 -replace "/I", "/X "
#Create custom object with name and string
$allstring += New-Object -TypeName PSObject -Property @{
    Name = $32app.DisplayName
    String = $string2
}
}
else {
#Exe installer, run straight path
$string2 = $string1
$allstring += New-Object -TypeName PSObject -Property @{
    Name = $32app.DisplayName
    String = $string2
}
}
}
}
write-host "32-bit check complete"
write-host "Checking 64-bit Use registry"
##Search for 64-bit versions and list them

$path2 =  "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
#Loop Through the apps if name has Adobe and NOT reader
$64apps = Get-ChildItem -Path $path2 | Get-ItemProperty | Select-Object -Property DisplayName, UninstallString

foreach ($64app in $64apps) {
#Get uninstall string
$string1 =  $64app.uninstallstring
#Check if it's an MSI install
if ($string1 -match "^msiexec*") {
#MSI install, replace the I with an X and make it quiet
$string2 = $string1 + " /quiet /norestart"
$string2 = $string2 -replace "/I", "/X "
#Uninstall with string2 params
$allstring += New-Object -TypeName PSObject -Property @{
    Name = $64app.DisplayName
    String = $string2
}
}
else {
#Exe installer, run straight path
$string2 = $string1
$allstring += New-Object -TypeName PSObject -Property @{
    Name = $64app.DisplayName
    String = $string2
}
}

}

############################################################################################################
#                                        Remove Manufacturer Bloat                                         #
#                                                                                                          #
############################################################################################################
##Check Manufacturer
write-host "Detecting Manufacturer"
$details = Get-CimInstance -ClassName Win32_ComputerSystem
$manufacturer = $details.Manufacturer

if ($manufacturer -like "*HP*") {
    Write-Host "HP detected"
    #Remove HP bloat


##HP Specific
$UninstallPrograms = @(
    "HP Client Security Manager"
    "HP Notifications"
    "HP Security Update Service"
    "HP System Default Settings"
    "HP Wolf Security"
    "HP Wolf Security Application Support for Sure Sense"
    "HP Wolf Security Application Support for Windows"
    "AD2F1837.HPPCHardwareDiagnosticsWindows"
    "AD2F1837.HPPowerManager"
    "AD2F1837.HPPrivacySettings"
    "AD2F1837.HPQuickDrop"
    "AD2F1837.HPSupportAssistant"
    "AD2F1837.HPSystemInformation"
    "AD2F1837.myHP"
    "RealtekSemiconductorCorp.HPAudioControl",
    "HP Sure Recover",
    "HP Sure Run Module"
    "RealtekSemiconductorCorp.HPAudioControl_2.39.280.0_x64__dt26b99r8h8gj"
)

$HPidentifier = "AD2F1837"

$InstalledPackages = Get-AppxPackage -AllUsers | Where-Object {(($UninstallPackages -contains $_.Name) -or ($_.Name -match "^$HPidentifier"))-and ($_.Name -NotMatch $WhitelistedApps)}

$ProvisionedPackages = Get-AppxProvisionedPackage -Online | Where-Object {(($UninstallPackages -contains $_.Name) -or ($_.Name -match "^$HPidentifier"))-and ($_.Name -NotMatch $WhitelistedApps)}

$InstalledPrograms = $allstring | Where-Object {$UninstallPrograms -contains $_.Name}

# Remove provisioned packages first
ForEach ($ProvPackage in $ProvisionedPackages) {

    Write-Host -Object "Attempting to remove provisioned package: [$($ProvPackage.DisplayName)]..."

    Try {
        $Null = Remove-AppxProvisionedPackage -PackageName $ProvPackage.PackageName -Online -ErrorAction Stop
        Write-Host -Object "Successfully removed provisioned package: [$($ProvPackage.DisplayName)]"
    }
    Catch {Write-Warning -Message "Failed to remove provisioned package: [$($ProvPackage.DisplayName)]"}
}

# Remove appx packages
ForEach ($AppxPackage in $InstalledPackages) {
                                            
    Write-Host -Object "Attempting to remove Appx package: [$($AppxPackage.Name)]..."

    Try {
        $Null = Remove-AppxPackage -Package $AppxPackage.PackageFullName -AllUsers -ErrorAction Stop
        Write-Host -Object "Successfully removed Appx package: [$($AppxPackage.Name)]"
    }
    Catch {Write-Warning -Message "Failed to remove Appx package: [$($AppxPackage.Name)]"}
}

# Remove installed programs
$InstalledPrograms | ForEach-Object {

    Write-Host -Object "Attempting to uninstall: [$($_.Name)]..."
    $uninstallcommand = $_.String

    Try {
        if ($uninstallcommand -match "^msiexec*") {
            #Remove msiexec as we need to split for the uninstall
            $uninstallcommand = $uninstallcommand -replace "msiexec.exe", ""
            #Uninstall with string2 params
            Start-Process 'msiexec.exe' -ArgumentList $uninstallcommand -NoNewWindow -Wait
            }
            else {
            #Exe installer, run straight path
            $string2 = $uninstallcommand
            start-process $string2
            }
        #$A = Start-Process -FilePath $uninstallcommand -Wait -passthru -NoNewWindow;$a.ExitCode
        #$Null = $_ | Uninstall-Package -AllVersions -Force -ErrorAction Stop
        Write-Host -Object "Successfully uninstalled: [$($_.Name)]"
    }
    Catch {Write-Warning -Message "Failed to uninstall: [$($_.Name)]"}


}

##Belt and braces, remove via CIM too
foreach ($program in $UninstallPrograms) {
Get-CimInstance -Classname Win32_Product | Where-Object Name -Match $program | Invoke-CimMethod -MethodName UnInstall
}


#Remove HP Documentation if it exists
if (test-path -Path "C:\Program Files\HP\Documentation\Doc_uninstall.cmd") {
$A = Start-Process -FilePath "C:\Program Files\HP\Documentation\Doc_uninstall.cmd" -Wait -passthru -NoNewWindow
}

##Remove HP Connect Optimizer if setup.exe exists
if (test-path -Path 'C:\Program Files (x86)\InstallShield Installation Information\{6468C4A5-E47E-405F-B675-A70A70983EA6}\setup.exe') {
Invoke-WebRequest -uri "https://raw.githubusercontent.com/ASITScripts/ASITCORE/Pre-InstallREQs/HPConnOpt.iss" -outfile "C:\Windows\Temp\HPConnOpt.iss"

&'C:\Program Files (x86)\InstallShield Installation Information\{6468C4A5-E47E-405F-B675-A70A70983EA6}\setup.exe' @('-s', '-f1C:\Windows\Temp\HPConnOpt.iss')
}
Write-Host "Removed HP bloat"
}



if ($manufacturer -like "*Dell*") {
    Write-Host "Dell detected"
    # Remove Dell bloat

# Dell

$UninstallPrograms = @(
    "Dell Optimizer"
    "Dell Power Manager"
    "DellOptimizerUI"
    "Dell SupportAssist OS Recovery"
    "Dell SupportAssist"
    "Dell Optimizer Service"
    "DellInc.PartnerPromo"
    "DellInc.DellOptimizer"
    "DellInc.DellCommandUpdate"
    "Dell Command | Update for Windows"
    "Dell Digital Delivery"
    "Dell SupportAssist Remediation"
    "SupportAssist Recovery Assistant"
)

$WhitelistedApps = @(
    "WavesAudio.MaxxAudioProforDell2019"
    "Dell - Extension*"
    "Dell, Inc. - Firmware*"
)

$InstalledPackages = Get-AppxPackage -AllUsers | Where-Object {(($_.Name -in $UninstallPrograms) -or ($_.Name -like "*Dell*")) -and ($_.Name -NotMatch $WhitelistedApps)}

$ProvisionedPackages = Get-AppxProvisionedPackage -Online | Where-Object {(($_.Name -in $UninstallPrograms) -or ($_.Name -like "*Dell*")) -and ($_.Name -NotMatch $WhitelistedApps)}

$InstalledPrograms = $allstring | Where-Object {(($_.Name -in $UninstallPrograms) -or ($_.Name -like "*Dell*")) -and ($_.Name -NotMatch $WhitelistedApps)}
# Remove provisioned packages first
ForEach ($ProvPackage in $ProvisionedPackages) {

    Write-Host -Object "Attempting to remove provisioned package: [$($ProvPackage.DisplayName)]..."

    Try {
        $Null = Remove-AppxProvisionedPackage -PackageName $ProvPackage.PackageName -Online -ErrorAction Stop
        Write-Host -Object "Successfully removed provisioned package: [$($ProvPackage.DisplayName)]"
    }
    Catch {Write-Warning -Message "Failed to remove provisioned package: [$($ProvPackage.DisplayName)]"}
}

# Remove appx packages
ForEach ($AppxPackage in $InstalledPackages) {
                                            
    Write-Host -Object "Attempting to remove Appx package: [$($AppxPackage.Name)]..."

    Try {
        $Null = Remove-AppxPackage -Package $AppxPackage.PackageFullName -AllUsers -ErrorAction Stop
        Write-Host -Object "Successfully removed Appx package: [$($AppxPackage.Name)]"
    }
    Catch {Write-Warning -Message "Failed to remove Appx package: [$($AppxPackage.Name)]"}
}

# Remove any bundled packages
ForEach ($AppxPackage in $InstalledPackages) {
                                            
    Write-Host -Object "Attempting to remove Appx package: [$($AppxPackage.Name)]..."

    Try {
        $null = Get-AppxPackage -AllUsers -PackageTypeFilter Main, Bundle, Resource -Name $AppxPackage.Name | Remove-AppxPackage -AllUsers
        Write-Host -Object "Successfully removed Appx package: [$($AppxPackage.Name)]"
    }
    Catch {Write-Warning -Message "Failed to remove Appx package: [$($AppxPackage.Name)]"}
}


# Remove installed programs
$InstalledPrograms | ForEach-Object {

    Write-Host -Object "Attempting to uninstall: [$($_.Name)]..."
    $uninstallcommand = $_.String

    Try {
        if ($uninstallcommand -match "^msiexec*") {
            #Remove msiexec as we need to split for the uninstall
            $uninstallcommand = $uninstallcommand -replace "msiexec.exe", ""
            #Uninstall with string2 params
            Start-Process 'msiexec.exe' -ArgumentList $uninstallcommand -NoNewWindow -Wait
            }
            else {
            #Exe installer, run straight path
            $string2 = $uninstallcommand
            start-process $string2
            }
        #$A = Start-Process -FilePath $uninstallcommand -Wait -passthru -NoNewWindow;$a.ExitCode        
        #$Null = $_ | Uninstall-Package -AllVersions -Force -ErrorAction Stop
        Write-Host -Object "Successfully uninstalled: [$($_.Name)]"
    }
    Catch {Write-Warning -Message "Failed to uninstall: [$($_.Name)]"}
}

# Belt and braces, remove via CIM too
foreach ($program in $UninstallPrograms) {
    Get-CimInstance -Classname Win32_Product | Where-Object Name -Match $program | Invoke-CimMethod -MethodName UnInstall
    }

}


if ($manufacturer -like "Lenovo") {
    Write-Host "Lenovo detected"

    #Remove HP bloat

##Lenovo Specific
    # Function to uninstall applications with .exe uninstall strings

    function UninstallApp {

        param (
            [string]$appName
        )

        # Get a list of installed applications from Programs and Features
        $installedApps = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*,
        HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |
        Where-Object { $_.DisplayName -like "*$appName*" }

        # Loop through the list of installed applications and uninstall them

        foreach ($app in $installedApps) {
            $uninstallString = $app.UninstallString
            $displayName = $app.DisplayName
            Write-Host "Uninstalling: $displayName"
            Start-Process $uninstallString -ArgumentList "/VERYSILENT" -Wait
            Write-Host "Uninstalled: $displayName" -ForegroundColor Green
        }
    }

    ##Stop Running Processes

    $processnames = @(
    "SmartAppearanceSVC.exe"
    "UDClientService.exe"
    "ModuleCoreService.exe"
    "ProtectedModuleHost.exe"
    "*lenovo*"
    "FaceBeautify.exe"
    "McCSPServiceHost.exe"
    "mcapexe.exe"
    "MfeAVSvc.exe"
    "mcshield.exe"
    "Ammbkproc.exe"
    "AIMeetingManager.exe"
    "DADUpdater.exe"
    )

    foreach ($process in $processnames) {
        write-host "Stopping Process $process"
        Get-Process -Name $process | Stop-Process -Force
        write-host "Process $process Stopped"
    }

    $UninstallPrograms = @(
        "E046963F.AIMeetingManager"
        "E0469640.SmartAppearance"
        "MirametrixInc.GlancebyMirametrix"
        "E046963F.LenovoCompanion"
        "E0469640.LenovoUtility"
    )
    
    
    $InstalledPackages = Get-AppxPackage -AllUsers | Where-Object {(($_.Name -in $UninstallPrograms))}
    
    $ProvisionedPackages = Get-AppxProvisionedPackage -Online | Where-Object {(($_.Name -in $UninstallPrograms))}
    
    $InstalledPrograms = $allstring | Where-Object {(($_.Name -in $UninstallPrograms))}
    # Remove provisioned packages first
    ForEach ($ProvPackage in $ProvisionedPackages) {
    
        Write-Host -Object "Attempting to remove provisioned package: [$($ProvPackage.DisplayName)]..."
    
        Try {
            $Null = Remove-AppxProvisionedPackage -PackageName $ProvPackage.PackageName -Online -ErrorAction Stop
            Write-Host -Object "Successfully removed provisioned package: [$($ProvPackage.DisplayName)]"
        }
        Catch {Write-Warning -Message "Failed to remove provisioned package: [$($ProvPackage.DisplayName)]"}
    }
    
    # Remove appx packages
    ForEach ($AppxPackage in $InstalledPackages) {
                                                
        Write-Host -Object "Attempting to remove Appx package: [$($AppxPackage.Name)]..."
    
        Try {
            $Null = Remove-AppxPackage -Package $AppxPackage.PackageFullName -AllUsers -ErrorAction Stop
            Write-Host -Object "Successfully removed Appx package: [$($AppxPackage.Name)]"
        }
        Catch {Write-Warning -Message "Failed to remove Appx package: [$($AppxPackage.Name)]"}
    }
    
    # Remove any bundled packages
    ForEach ($AppxPackage in $InstalledPackages) {
                                                
        Write-Host -Object "Attempting to remove Appx package: [$($AppxPackage.Name)]..."
    
        Try {
            $null = Get-AppxPackage -AllUsers -PackageTypeFilter Main, Bundle, Resource -Name $AppxPackage.Name | Remove-AppxPackage -AllUsers
            Write-Host -Object "Successfully removed Appx package: [$($AppxPackage.Name)]"
        }
        Catch {Write-Warning -Message "Failed to remove Appx package: [$($AppxPackage.Name)]"}
    }
    
    
# Remove installed programs
$InstalledPrograms | ForEach-Object {

    Write-Host -Object "Attempting to uninstall: [$($_.Name)]..."
    $uninstallcommand = $_.String

    Try {
        if ($uninstallcommand -match "^msiexec*") {
            #Remove msiexec as we need to split for the uninstall
            $uninstallcommand = $uninstallcommand -replace "msiexec.exe", ""
            #Uninstall with string2 params
            Start-Process 'msiexec.exe' -ArgumentList $uninstallcommand -NoNewWindow -Wait
            }
            else {
            #Exe installer, run straight path
            $string2 = $uninstallcommand
            start-process $string2
            }
        #$A = Start-Process -FilePath $uninstallcommand -Wait -passthru -NoNewWindow;$a.ExitCode
        #$Null = $_ | Uninstall-Package -AllVersions -Force -ErrorAction Stop
        Write-Host -Object "Successfully uninstalled: [$($_.Name)]"
    }
    Catch {Write-Warning -Message "Failed to uninstall: [$($_.Name)]"}
}

##Belt and braces, remove via CIM too
foreach ($program in $UninstallPrograms) {
    Get-CimInstance -Classname Win32_Product | Where-Object Name -Match $program | Invoke-CimMethod -MethodName UnInstall
    }

    # Get Lenovo Vantage service uninstall string to uninstall service
    $lvs = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*", "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*" | Where-Object DisplayName -eq "Lenovo Vantage Service"
    if (!([string]::IsNullOrEmpty($lvs.QuietUninstallString))) {
        $uninstall = "cmd /c " + $lvs.QuietUninstallString
        Write-Host $uninstall
        Invoke-Expression $uninstall
    }

    # Uninstall Lenovo Smart
    UninstallApp -appName "Lenovo Smart"

    # Uninstall Ai Meeting Manager Service
    UninstallApp -appName "Ai Meeting Manager"

    # Uninstall ImController service
    ##Check if exists
    $path = "c:\windows\system32\ImController.InfInstaller.exe"
    if (Test-Path $path) {
        Write-Host "ImController.InfInstaller.exe exists"
        $uninstall = "cmd /c " + $path + " -uninstall"
        Write-Host $uninstall
        Invoke-Expression $uninstall
    }
    else {
        Write-Host "ImController.InfInstaller.exe does not exist"
    }
    ##Invoke-Expression -Command 'cmd.exe /c "c:\windows\system32\ImController.InfInstaller.exe" -uninstall'

    # Remove vantage associated registry keys
    Remove-Item 'HKLM:\SOFTWARE\Policies\Lenovo\E046963F.LenovoCompanion_k1h2ywk1493x8' -Recurse -ErrorAction SilentlyContinue
    Remove-Item 'HKLM:\SOFTWARE\Policies\Lenovo\ImController' -Recurse -ErrorAction SilentlyContinue
    Remove-Item 'HKLM:\SOFTWARE\Policies\Lenovo\Lenovo Vantage' -Recurse -ErrorAction SilentlyContinue
    #Remove-Item 'HKLM:\SOFTWARE\Policies\Lenovo\Commercial Vantage' -Recurse -ErrorAction SilentlyContinue

     # Uninstall AI Meeting Manager Service
     $path = 'C:\Program Files\Lenovo\Ai Meeting Manager Service\unins000.exe'
     $params = "/SILENT"
     if (test-path -Path $path) {
     Start-Process -FilePath $path -ArgumentList $params -Wait
     }
    # Uninstall Lenovo Vantage
    $path = 'C:\Program Files (x86)\Lenovo\VantageService\3.13.43.0\Uninstall.exe'
    $params = '/SILENT'
    if (test-path -Path $path) {
        Start-Process -FilePath $path -ArgumentList $params -Wait
    }
    ##Uninstall Smart Appearance
    $path = 'C:\Program Files\Lenovo\Lenovo Smart Appearance Components\unins000.exe'
    $params = '/SILENT'
    if (test-path -Path $path) {
        Start-Process -FilePath $path -ArgumentList $params -Wait
    }

    # Remove Lenovo Now
    Set-Location "c:\program files (x86)\lenovo\lenovowelcome\x86"

    # Update $PSScriptRoot with the new working directory
    $PSScriptRoot = (Get-Item -Path ".\").FullName
    invoke-expression -command .\uninstall.ps1

    Write-Host "All applications and associated Lenovo components have been uninstalled." -ForegroundColor Green
}


############################################################################################################
#                                        Remove Any other installed crap                                   #
#                                                                                                          #
############################################################################################################

#McAfee

write-host "Detecting McAfee"
$mcafeeinstalled = "false"
$InstalledSoftware = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
foreach($obj in $InstalledSoftware){
     $name = $obj.GetValue('DisplayName')
     if ($name -like "*McAfee*") {
         $mcafeeinstalled = "true"
     }
}

$InstalledSoftware32 = Get-ChildItem "HKLM:\Software\WOW6432NODE\Microsoft\Windows\CurrentVersion\Uninstall"
foreach($obj32 in $InstalledSoftware32){
     $name32 = $obj32.GetValue('DisplayName')
     if ($name32 -like "*McAfee*") {
         $mcafeeinstalled = "true"
     }
}

if ($mcafeeinstalled -eq "true") {
    Write-Host "McAfee detected"
    #Remove McAfee bloat
# McAfee
##### Download McAfee Consumer Product Removal Tool #####
write-host "Downloading McAfee Removal Tool"
# Download Source
$URL = 'https://github.com/ASITScripts/ASITCORE/raw/Pre-InstallREQs/mcafeeclean.zip'

# Set Save Directory
$destination = 'C:\ProgramData\Debloat\mcafee.zip'

#Download the file
Invoke-WebRequest -Uri $URL -OutFile $destination -Method Get
  
Expand-Archive $destination -DestinationPath "C:\ProgramData\Debloat" -Force

write-host "Removing McAfee"
# Automate Removal and kill services
start-process "C:\ProgramData\Debloat\Mccleanup.exe" -ArgumentList "-p StopServices,MFSY,PEF,MXD,CSP,Sustainability,MOCP,MFP,APPSTATS,Auth,EMproxy,FWdiver,HW,MAS,MAT,MBK,MCPR,McProxy,McSvcHost,VUL,MHN,MNA,MOBK,MPFP,MPFPCU,MPS,SHRED,MPSCU,MQC,MQCCU,MSAD,MSHR,MSK,MSKCU,MWL,NMC,RedirSvc,VS,REMEDIATION,MSC,YAP,TRUEKEY,LAM,PCB,Symlink,SafeConnect,MGS,WMIRemover,RESIDUE -v -s"
write-host "McAfee Removal Tool has been run"

}


# Look for anything else - COMMENT THIS ENTIRE SECTION IF YOU ARE RUNNING THIS ON A PRE EXISTING DEVICE #
# IF YOU DON'T IT WILL REMOVE EVERYTHING THE USER INSTALLED #

# Look for anything else - COMMENT THIS ENTIRE SECTION IF YOU ARE RUNNING THIS ON A PRE EXISTING DEVICE #
# IF YOU DON'T IT WILL REMOVE EVERYTHING THE USER INSTALLED #

# Look for anything else - COMMENT THIS ENTIRE SECTION IF YOU ARE RUNNING THIS ON A PRE EXISTING DEVICE #
# IF YOU DON'T IT WILL REMOVE EVERYTHING THE USER INSTALLED #

if ($intunecomplete -eq 0 -and $nonAdminLoggedOn) {


##Apps to ignore - NOTE: Chrome has an unusual uninstall so sort on it's own
$whitelistapps = @(
    "Microsoft Update Health Tools"
    "Microsoft Intune Management Extension"
    "Microsoft Edge"
    "Microsoft Edge Update"
    "Microsoft Edge WebView2 Runtime"
    "Google Chrome"
    "Microsoft Teams"
    "Teams Machine-Wide Installer"
    "Microsoft OneDrive"
    "@C:\WINDOWS\System32\mstsc.exe,-4000"
)

$InstalledSoftware = Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
foreach($obj in $InstalledSoftware){
    $name = $obj.GetValue('DisplayName')
    if ($null -eq $name) {
        $name = $obj.GetValue('DisplayName_Localized')
    }
     if (($whitelistapps -notcontains $name) -and ($null -ne $obj.GetValue('UninstallString'))) {
        $uninstallcommand = $obj.GetValue('UninstallString')
        write-host "Uninstalling $name"
        if ($uninstallcommand -like "*msiexec*") {
        $splitcommand = $uninstallcommand.Split("{")
        $msicode = $splitcommand[1]
        $uninstallapp = "msiexec.exe /X {$msicode /qn"
        start-process "cmd.exe" -ArgumentList "/c $uninstallapp"
        }
        else {
        $splitcommand = $uninstallcommand.Split("{")
        
        $uninstallapp = "$uninstallcommand /S"
        start-process "cmd.exe" -ArgumentList "/c $uninstallapp"
        }
     }

     }


$InstalledSoftware32 = Get-ChildItem "HKLM:\Software\WOW6432NODE\Microsoft\Windows\CurrentVersion\Uninstall"
foreach($obj32 in $InstalledSoftware32){
     $name32 = $obj32.GetValue('DisplayName')
     if (($whitelistapps -notcontains $name32) -and ($null -ne $obj32.GetValue('UninstallString'))) {
        $uninstallcommand32 = $obj.GetValue('UninstallString')
        write-host "Uninstalling $name"
                if ($uninstallcommand32 -like "*msiexec*") {
        $splitcommand = $uninstallcommand32.Split("{")
        $msicode = $splitcommand[1]
        $uninstallapp = "msiexec.exe /X {$msicode /qn"
        start-process "cmd.exe" -ArgumentList "/c $uninstallapp"
        }
        else {
        $splitcommand = $uninstallcommand32.Split("{")
        
        $uninstallapp = "$uninstallcommand /S"
        start-process "cmd.exe" -ArgumentList "/c $uninstallapp"
        }
    }
}

# COMMENT THIS ENTIRE SECTION ABOVE IF YOU ARE RUNNING THIS ON A PRE EXISTING DEVICE #
# IF YOU DON'T IT WILL REMOVE EVERYTHING THE USER INSTALLED #

# COMMENT THIS ENTIRE SECTION ABOVE IF YOU ARE RUNNING THIS ON A PRE EXISTING DEVICE #
# IF YOU DON'T IT WILL REMOVE EVERYTHING THE USER INSTALLED #

# COMMENT THIS ENTIRE SECTION ABOVE IF YOU ARE RUNNING THIS ON A PRE EXISTING DEVICE #
# IF YOU DON'T IT WILL REMOVE EVERYTHING THE USER INSTALLED #

}

Write-Host -ForegroundColor Green ("[$Time]`t" + "Bloatware removal completed... Now starting application installations")

Start-Sleep -s 5

#Google Chrome download starts here

$DesktopPath = [Environment]::GetFolderPath("Desktop")
$chromeuri = "https://dl.google.com/dl/chrome/install/googlechromestandaloneenterprise64.msi"

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

if ($null -eq $adobeInstalled.FileName) {
    Write-Host -ForegroundColor Red ("[$Time]`t" + 'Adobe PDF Reader is not installed.')
    Write-Host -ForegroundColor Green ("[$Time]`t" + "Starting Adobe installation")

    $outFile = "$DesktopPath\AcroRdrDC2200120117_en_US.exe"
    
    Start-BitsTransfer -Source $adobeuri -Destination $outFile
    
    Start-Process -FilePath "$DesktopPath\AcroRdrDC2200120117_en_US.exe" -ArgumentList "/sAll /rs /rps /msi /norestart /quiet EULA_ACCEPT=YES" -Wait
    
    Write-Host -ForegroundColor Green ("[$Time]`t" + "Completed Adobe installation")
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

Remove-Item $script:MyInvocation.MyCommand.Path -Force

Stop-Transcript
