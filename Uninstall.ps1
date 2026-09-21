#requires -Version 5.1
[CmdletBinding()]
param([switch]$Apply)
$ErrorActionPreference='Stop'
Import-Module (Join-Path $PSScriptRoot 'Support.psm1') -Force
$state=Join-Path $PSScriptRoot 'InstallationState'
$record=Join-Path $state 'installation.json'
if (!(Test-Path -LiteralPath $record)) { throw 'No installation record exists in this folder.' }
$journal=Get-Content -LiteralPath $record -Raw | ConvertFrom-Json
if ($Apply -and (Get-ProtectedProcesses)) { throw 'Save and close BG3 and BG3 Mod Manager first.' }
if ($journal.Files.Count -eq 0) { Write-Host 'No native files were installed.'; exit }
$conflicts=Restore-TrackedFiles $state $journal -Apply:$Apply
Write-Host 'Mods, load orders and saves are preserved. Remove mods through their authors'' instructions before resuming a campaign without Script Extender.'
Write-Host 'ManagerView contains links into the live mod cache. Never delete its contents recursively. Keep this folder and its backups for recovery.'
if (!$Apply) { Write-Host 'Preview only. Run Uninstall.ps1 -Apply to perform the listed changes.' }
if ($conflicts -gt 0) { Write-Warning 'Some files changed since installation and were preserved. Compare them with the backups before removing the extender.' }
