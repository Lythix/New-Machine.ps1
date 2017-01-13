[CmdletBinding()]
param ()

$ErrorActionPreference = 'Stop';

$IsAdmin = (New-Object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $IsAdmin) {
    throw "You need to run this script elevated"
}

Write-Progress -Activity "Setting exeuction policy"
Set-ExecutionPolicy RemoteSigned

Write-Progress -Activity "Ensuring Chocolatey is available"
$null = Get-PackageProvider -Name chocolatey

Write-Progress -Activity "Ensuring Chocolatey is trusted"
if (-not ((Get-PackageSource -Name chocolatey).IsTrusted)) {
    Set-PackageSource -Name chocolatey -Trusted
}

@(
    "git.install",
    "fiddler4",
    "conemu",
    "visualstudiocode",
    "beyondcompare",
#    "filezilla",
    "teamviewer",
    "skype",
    "7zip.install",
    "sourcetree",
    "tortoisegit",
    "Git-Credential-Manager-for-Windows",
    "vlc",
    "sysinternals",
    "nodejs",
    "dropbox",
    "googledrive",
#    "malwarebytes",
    "linqpad",
#    "spotify",
    "treesizefree",
    "lockhunter",
    "rufus",
    "crystaldiskmark",
#    "crashplan",
    "typescript",
    "adobe-creative-cloud",
    "snagit",
    "github",
    "slack"
    
) | % {
    Write-Progress -Activity "Installing $_"
    Choco install $_ -y
}



