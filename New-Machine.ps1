﻿$ErrorActionPreference = 'Stop';

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
    }
    else
    {
        "Installing $name"
        & choco install $name
    }
}

Install-ChocoIfNotAlready git.install
Install-ChocoIfNotAlready putty.install
Install-ChocoIfNotAlready SublimeText3
Install-ChocoIfNotAlready SublimeText3.PackageControl

$OneDriveRoot = (gi HKCU:\Software\Microsoft\Windows\CurrentVersion\SkyDrive).GetValue('UserFolder')
if (-not (Test-Path $OneDriveRoot))
{
    throw "Couldn't find the OneDrive root"
}

$SshKeyPath = Join-Path $OneDriveRoot Tools\ssh\id.ppk
if (-not (Test-Path $SshKeyPath))
{
    throw "Couldn't find SSH key at $SshKeyPath"
}

"Setting Pageant shortcut to load the private key automatically"
$WshShell = New-Object -ComObject WScript.Shell
$PageantShortcut = $WshShell.CreateShortcut((Join-Path ([Environment]::GetFolderPath("CommonStartMenu")) Programs\PuTTY\Pageant.lnk))
$PageantShortcut.Arguments = "-i $SshKeyPath"
$PageantShortcut.Save()

"Setting plink.exe as GIT_SSH"
$PuttyDirectory = $PageantShortcut.WorkingDirectory
$PlinkPath = Join-Path $PuttyDirectory plink.exe
[Environment]::SetEnvironmentVariable('GIT_SSH', $PlinkPath)
$env:GIT_SSH = $PlinkPath
