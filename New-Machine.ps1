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

if ($env:Path.Contains("chocolatey"))
{
    "Choco already installed"
}
else
{
    "Installing Choco"
    iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

$ExistingChocoPackages = (& choco list -localonly) | % { $_.Split(' ')[0] }
function Install-ChocoIfNotAlready($name) {
    if ($ExistingChocoPackages -contains $name)
    {
        "$name already installed"
        #$result = & choco install $name -y -force
      #   $result = choco install $name -y -force
    }
    else
    {
        "Installing $name"
        #$result = & choco install $name -y
        $result = choco install $name -y 
    }
}



#Write-Progress -Activity "Ensuring Chocolatey is available"
#$null = Get-PackageProvider -Name chocolatey

#Write-Progress -Activity "Ensuring Chocolatey is trusted"
#if (-not ((Get-PackageSource -Name chocolatey).IsTrusted)) {
#    Set-PackageSource -Name chocolatey -Trusted
#}

@(
#    "google-chrome-x64",
    "git.install",
    "SublimeText3",
    "skype",
    "git.install",
    "conemu",
    "visualstudiocode",
    "git",
    "beyondcompare",
    "resharper",
    "resharper-platform",
    "filezilla",
    "teamviewer",
    "7zip.install",
    "sourcetree",
    "tortoisegit",
    "Git-Credential-Manager-for-Windows",
    "vlc",
    "skype",
    "sysinternals",
    "nodejs",
    "dropbox",
    "googledrive",
    "malwarebytes",
    "baretail",
    "linqpad",
    "spotify",
    "treesizefree",
    "speccy",
    "f.lux",
    "lockhunter",
    "rufus",
    "vmwareworkstation",
    "crystaldiskmark",
    "chutzpah",
    "crashplan",
    "geforce-experience",
    "typescript",
    "adobe-creative-cloud",
    "snagit",
    "github",
    "nodejs.install",
    "Jump-Location",
    "slack",
    "snagit"   
    
) | % {
    $checkPackage = Find-Package $_
    if ($checkPackage.Name -eq $_)
    {
        Write-Progress -Activity "Installing $_"
#        $result = Install-Package -Name $_ -ProviderName chocolatey
        # $result = choco install $_ -y -force
        Install-ChocoIfNotAlready $_

        $result | Format-List
    }
}
    
#$OneDriveRoot = (gi HKCU:\Software\Microsoft\Windows\CurrentVersion\SkyDrive).GetValue('UserFolder')
#if (-not (Test-Path $OneDriveRoot))
#    throw "Couldn't find the OneDrive root"
#}

#$SshKeyPath = Join-Path $OneDriveRoot Tools\ssh\id.ppk
#if (-not (Test-Path $SshKeyPath))


#$userName = (Get-WmiObject Win32_Process -Filter "Handle = $Pid").GetRelated("Win32_LogonSession").GetRelated("Win32_UserAccount").FullName
#$WshShell = New-Object -ComObject WScript.Shell
#$PageantShortcut = $WshShell.CreateShortcut((Join-Path ([Environment]::GetFolderPath("CommonStartMenu")) Programs\PuTTY\Pageant.lnk))
#$PageantShortcut.Arguments = "-i $SshKeyPath"
#$PageantShortcut.Save()
# This seems to the be MSA that was first used during Windows setup
#"Setting plink.exe as GIT_SSH"
#$PuttyDirectory = $PageantShortcut.WorkingDirectory
#$PlinkPath = Join-Path $PuttyDirectory plink.exe
#[Environment]::SetEnvironmentVariable('GIT_SSH', $PlinkPath, [EnvironmentVariableTarget]::User)
#$env:GIT_SSH = $PlinkPath
#Write-Verbose "Setting git user.email to $userEmail"
#if ($env:Path.Contains("git"))
#{

Write-Host "Setting git identity"
git config --global user.name "Stephen Price"
git config --global user.email "Stephen@lythixdesigns.com"

Write-Progress -Activity "Setting git push behaviour to squelch the 2.0 upgrade message"
if ((& git config push.default) -eq $null)
{
    "Setting git push behaviour to squelch the 2.0 upgrade message"
    git config --global push.default simple
}

#Write-Host "Setting git aliases"
#git config --global alias.st "status"
#git config --global alias.co "checkout"
#git config --global alias.df "diff"
#git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"

Write-Progress -Activity "Checking for Git Credential Manager"
if ((& git config credential.helper) -ne "manager") {
    Write-Warning "Git Credential Manager for Windows is missing. Install it manually from https://github.com/Microsoft/Git-Credential-Manager-for-Windows/releases"
}
#Write-Progress -Activity "Setting PS aliases"
#}

#"Setting PS aliases"
#if ((Get-Alias -Name st -ErrorAction SilentlyContinue) -eq $null) {
#    Add-Content $PROFILE "`r`n`r`nSet-Alias -Name st -Value (Join-Path `$env:ProgramFiles 'Sublime Text 3\sublime_text.exe')"
#}

#"Enabling Office smileys"
#if (Test-Path HKCU:\Software\Microsoft\Office\16.0) {
#    if (-not (Test-Path HKCU:\Software\Microsoft\Office\16.0\Common\Feedback)) {
#        New-Item HKCU:\Software\Microsoft\Office\16.0\Common\Feedback -ItemType Directory
#    }
#Set-ItemProperty -Path HKCU:\Software\Microsoft\Office\15.0\Common\Feedback -Name Enabled -Value 1
#}
#else {
#    Write-Warning "Couldn't find a compatible install of Office"
#}

#Write-Progress "Hiding desktop icons"
#if ((Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\).HideIcons -ne 1) {
#    Set-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ -Name HideIcons -Value 1
#    Get-Process explorer | Stop-Process
#}
#"Reloading PS profile"
#Write-Progress "Enabling PowerShell on Win+X"
#if ((Get-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\).DontUsePowerShellOnWinX -ne 0) {
#    Set-ItemProperty HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\ -Name DontUsePowerShellOnWinX -Value 0
#    Get-Process explorer | Stop-Process
#}

Write-Progress -Activity "Reloading PS profile"
. $PROFILE
