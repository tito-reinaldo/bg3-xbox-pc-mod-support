#requires -Version 5.1
[CmdletBinding()]
param([string]$GameDirectory,[string]$ProfileDirectory,[switch]$CheckOnly)
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'Support.psm1') -Force
Assert-Payload $PSScriptRoot
$envInfo = Get-Environment $GameDirectory $ProfileDirectory
Write-Host "Supported game: $($envInfo.Game)"
Write-Host "Xbox mod profile: $($envInfo.Profile)"
if ($CheckOnly) { Write-Host 'Read-only checks passed. No files changed.'; exit 0 }
if (Get-ProtectedProcesses) { throw 'Close BG3 and BG3 Mod Manager before installing. Save your game first.' }
$state = Join-Path $PSScriptRoot 'InstallationState'
if (Test-Path -LiteralPath $state) { throw 'This copy already contains an installation record. Keep it for rollback. Use Uninstall.ps1 first, then extract a fresh release for another installation.' }
$manager = Join-Path $PSScriptRoot 'Manager'
$view = Join-Path $PSScriptRoot 'ManagerView'
if ((Test-Path -LiteralPath $view) -or (Test-Path -LiteralPath (Join-Path $manager 'Data\settings.json'))) { throw 'Use a freshly extracted release folder. Existing manager configuration is preserved.' }
[IO.Directory]::CreateDirectory($state) | Out-Null
$journal = [pscustomobject]@{Version='0.1.0';GameDirectory=$envInfo.Game;Package=$envInfo.Package;Files=@();Complete=$false}
Write-JsonFile (Join-Path $state 'installation.json') $journal
try {
    # Back up the order for reference only. This installer and uninstaller never overwrite it.
    Copy-Item -LiteralPath (Join-Path $envInfo.Profile 'modsettings.lsx') -Destination (Join-Path $state 'modsettings-before.lsx')
    $updater = Read-JsonObject (Join-Path $envInfo.Game 'ScriptExtenderUpdaterConfig.json')
    Set-Option $updater DebugLoadSE $true
    Set-Option $updater DisableUpdates $true
    $settings = Read-JsonObject (Join-Path $envInfo.Game 'ScriptExtenderSettings.json')
    $defaults = @{DeveloperMode=$true;EnableAchievements=$false;SendCrashReports=$false;DisableLauncher=$false;EnableDebugger=$false;EnableLuaDebugger=$false;EnableLogging=$false;LogRuntime=$false}
    foreach ($key in $defaults.Keys) { if (!$settings.PSObject.Properties[$key]) { Set-Option $settings $key $defaults[$key] } }
    Set-Option $settings CreateConsole $false
    Write-JsonFile (Join-Path $state 'ScriptExtenderUpdaterConfig.json') $updater
    Write-JsonFile (Join-Path $state 'ScriptExtenderSettings.json') $settings
    foreach ($name in @('BG3ScriptExtender.dll','ScriptExtenderUpdaterConfig.json','ScriptExtenderSettings.json','DWrite.dll')) {
        $source = if ($name.EndsWith('.dll')) { Join-Path $PSScriptRoot ('Native\'+$name) } else { Join-Path $state $name }
        Install-TrackedFile $source (Join-Path $envInfo.Game $name) $state $journal
    }
    [IO.Directory]::CreateDirectory((Join-Path $view 'PlayerProfiles')) | Out-Null
    New-Item -ItemType Junction -Path (Join-Path $view 'Mods') -Target $envInfo.Mods | Out-Null
    New-Item -ItemType Junction -Path (Join-Path $view 'PlayerProfiles\XboxPC') -Target $envInfo.Profile | Out-Null
    $orders=Join-Path $PSScriptRoot 'Orders'
    [IO.Directory]::CreateDirectory($orders) | Out-Null
    [IO.Directory]::CreateDirectory((Join-Path $manager 'Data')) | Out-Null
    $managerSettings = @{
        GameDataPath=(Join-Path $envInfo.Game 'Data');GameExecutablePath=(Join-Path $envInfo.Game 'bg3.exe')
        LaunchType='Custom';CustomLaunchAction=(Join-Path $env:WINDIR 'explorer.exe');CustomLaunchArgs=('shell:AppsFolder\'+$envInfo.Family+'!Game')
        DocumentsFolderPathOverride=$view;LoadOrderPath=$orders;LogEnabled=$false;DeleteModCrashSanityCheck=$false
        ExtenderSettings=$settings;ExtenderUpdaterSettings=$updater
        Window=@{X=-1;Y=-1;Width=-1;Height=-1}
    }
    Write-JsonFile (Join-Path $manager 'Data\settings.json') $managerSettings
    $journal.Complete=$true
    Write-JsonFile (Join-Path $state 'installation.json') $journal
    Write-Host 'Installed. Keep this folder in place, including InstallationState.'
    Write-Host 'Next: open Start Mod Manager.cmd, import your mods, then export your order to the game. Read README.md first.'
} catch {
    Write-Warning 'Installation did not finish. Rolling back the tracked native files; the installation record and backup are retained.'
    if ($journal.Files.Count -gt 0) { $null=Restore-TrackedFiles $state $journal -Apply }
    throw
}
