[CmdletBinding()]
param ()

$ErrorActionPreference = 'Stop';

$IsAdmin = (New-Object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $IsAdmin) {
    throw "You need to run this script elevated"
}

Write-Progress -Activity "Setting exeuction policy"
Set-ExecutionPolicy RemoteSigned

Write-Progress -Activity "Ensuring PS profile exists"
if (-not (Test-Path $PROFILE)) {
    New-Item $PROFILE -Force
}

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
    "malwarebytes",
    "linqpad",
    "spotify",
    "treesizefree",
    "lockhunter",
    "rufus",
    "crystaldiskmark",
    "crashplan",
    "typescript",
    "adobe-creative-cloud",
    "snagit",
    "github",
    "slack"
    
) | % {
    Write-Progress -Activity "Installing $_"
    Install-Package -Name $_ -ProviderName chocolatey
}

Write-Progress -Activity "Setting git identity"
$userName = (Get-WmiObject Win32_Process -Filter "Handle = $Pid").GetRelated("Win32_LogonSession").GetRelated("Win32_UserAccount").FullName
Write-Verbose "Setting git user.name to $userName"
git config --global user.name $userName
# This seems to the be MSA that was first used during Windows setup
$userEmail = "stephen@lythixdesigns.com"
Write-Verbose "Setting git user.email to $userEmail"
git config --global user.email $userEmail

Write-Progress -Activity "Setting git push behaviour to squelch the 2.0 upgrade message"
if ((& git config push.default) -eq $null) {
    git config --global push.default simple
}

Write-Progress -Activity "Setting git aliases"
git config --global alias.st "status"
git config --global alias.co "checkout"
git config --global alias.df "diff"
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

Write-Progress -Activity "Checking for Git Credential Manager"
if ((& git config credential.helper) -ne "manager") {
    Write-Warning "Git Credential Manager for Windows is missing. Install it manually from https://github.com/Microsoft/Git-Credential-Manager-for-Windows/releases"
}

Write-Progress "Enabling PowerShell on Win+X"
if ((Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\).DontUsePowerShellOnWinX -ne 0) {
    Set-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ -Name DontUsePowerShellOnWinX -Value 0
    Get-Process explorer | Stop-Process
}

Write-Progress -Activity "Reloading PS profile"
. $PROFILE

