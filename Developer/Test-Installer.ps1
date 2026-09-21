#requires -Version 5.1
$ErrorActionPreference='Stop'
$pkg=Split-Path $PSScriptRoot -Parent
Import-Module (Join-Path $pkg 'Support.psm1') -Force
$root=Join-Path ([IO.Path]::GetTempPath()) ('BG3-Release-Fixture-'+[guid]::NewGuid().ToString('N'))
$game=Join-Path $root 'FakeGame';$state=Join-Path $root 'State'
foreach($d in @($root,$game,$state)){[IO.Directory]::CreateDirectory($d)|Out-Null}
function Assert($Condition,$Message){if(!$Condition){throw "FAIL: $Message"};Write-Host "PASS: $Message"}
$payload=Join-Path $root 'payload.bin';[IO.File]::WriteAllText($payload,'new release bytes')
$old=Join-Path $game 'DWrite.dll';[IO.File]::WriteAllText($old,'original unrelated loader')
$new=Join-Path $game 'BG3ScriptExtender.dll'
$original=Get-Hash $old
$journal=[pscustomobject]@{GameDirectory=$game;Files=@()}
Install-TrackedFile $payload $old $state $journal
Install-TrackedFile $payload $new $state $journal
Assert ((Get-Hash $old)-eq(Get-Hash $payload)) 'replacement installed'
Assert ((Get-Hash $journal.Files[0].Backup)-eq $original) 'original preserved exactly in backup'
$null=Restore-TrackedFiles $state $journal
Assert ((Test-Path -LiteralPath $new)-and (Get-Hash $old)-eq(Get-Hash $payload)) 'preview does not write'
$null=Restore-TrackedFiles $state $journal -Apply
Assert ((Get-Hash $old)-eq $original) 'original restored exactly'
Assert (!(Test-Path -LiteralPath $new)) 'new native file removed'
$journal=[pscustomobject]@{GameDirectory=$game;Files=@()}
Install-TrackedFile $payload $old $state $journal
[IO.File]::WriteAllText($old,'a newer user modification')
$changed=Get-Hash $old
$conflicts=Restore-TrackedFiles $state $journal -Apply
Assert ($conflicts-eq 1 -and (Get-Hash $old)-eq $changed) 'newer changed file preserved'
Copy-Item -LiteralPath $payload -Destination $old -Force
[IO.File]::WriteAllText($journal.Files[0].Backup,'damaged backup')
$caught=$false
try{$null=Restore-TrackedFiles $state $journal -Apply}catch{$caught=$true}
Assert ($caught -and (Get-Hash $old)-eq(Get-Hash $payload)) 'damaged backup rejected before restore'
$caught=$false
try{$null=Assert-Within (Join-Path $root '..\outside') $root}catch{$caught=$true}
Assert $caught 'path traversal rejected'
$journal.Files[0].Destination=Join-Path $root 'outside.dll'
$caught=$false
try{$null=Restore-TrackedFiles $state $journal -Apply}catch{$caught=$true}
Assert $caught 'journal cannot target a file outside the game directory'
$obj=[pscustomobject]@{ExistingOption='keep';CreateConsole=$true}
Set-Option $obj CreateConsole $false
Assert ($obj.ExistingOption-eq 'keep' -and !$obj.CreateConsole) 'updating an option preserves other configuration'
$caught=$false
try{Assert-GameVersion 'unsupported-package' $old}catch{$caught=$true}
Assert $caught 'unsupported package rejected'
Write-Host "All 11 assertions passed. Retained disposable fixture: $root"
