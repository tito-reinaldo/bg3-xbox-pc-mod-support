# Reproduce the local MCM package without modifying the installed game.
#requires -Version 7.0
[CmdletBinding()]
param([string]$Tag=(Get-Date -Format 'yyyyMMdd-HHmmss'))
$ErrorActionPreference='Stop'
if($Tag -notmatch '^[a-zA-Z0-9_-]+$'){throw 'Tag must contain only letters, numbers, underscore or hyphen.'}
$work=Split-Path $PSScriptRoot -Parent
$repo=Join-Path $work 'Source\BG3-MCM'
$commit='8a754fcb9689245ee28439034bc55bb65d11d8af'
foreach($dir in @('Build','Downloads','Logs')){[IO.Directory]::CreateDirectory((Join-Path $work $dir))|Out-Null}
$stage=Join-Path $work ('Build\MCM-'+$Tag)
$output=Join-Path $work ('Downloads\MCM-'+$Tag+'.pak')
if((Test-Path -LiteralPath $stage) -or (Test-Path -LiteralPath $output)){throw 'Choose a new tag; build artifacts are retained.'}
Import-Module (Join-Path $PSScriptRoot 'PakTools.psm1') -Force
Copy-Item -LiteralPath (Join-Path $repo 'Mod Configuration Menu') -Destination $stage -Recurse
foreach($file in Get-ChildItem -LiteralPath (Join-Path $stage 'Localization') -Filter '*.loca.xml' -Recurse -File){
    $loca=[LSLib.LS.LocaUtils]::Load($file.FullName)
    [LSLib.LS.LocaUtils]::Save($loca,$file.FullName.Substring(0,$file.FullName.Length-4))
}
New-BG3Pak -Source $stage -Destination $output -Priority 30
[pscustomobject]@{SourceCommit=$commit;SourceChanges=@('Public build path adapter');Priority=30;Package=$output;SHA256=(Get-FileHash -LiteralPath $output).Hash;RuntimeVerified=$false}|
  ConvertTo-Json -Depth 5|Set-Content -LiteralPath (Join-Path $work ('Logs\MCM-Build-'+$Tag+'.json')) -Encoding utf8
