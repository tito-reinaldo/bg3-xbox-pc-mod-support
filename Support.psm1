# Packaging and installation helpers, Copyright (c) 2026 tito-reinaldo. MIT.
Set-StrictMode -Version 2
$ErrorActionPreference = 'Stop'
function Get-ProtectedProcesses {
    Get-Process bg3,bg3_dx11,BG3ModManager -ErrorAction SilentlyContinue
    # The bundled manager is hosted by dotnet.exe, so its process name is not BG3ModManager.
    Get-CimInstance Win32_Process -Filter "Name='dotnet.exe'" -ErrorAction Stop | Where-Object { $_.CommandLine -match '(?i)BG3ModManager\.dll' }
}
function Write-JsonFile($Path, $Value) {
    [IO.File]::WriteAllText($Path, ($Value | ConvertTo-Json -Depth 30), [Text.UTF8Encoding]::new($false))
}
function Get-Hash($Path) {
    if (Test-Path -LiteralPath $Path -PathType Leaf) { return (Get-FileHash -LiteralPath $Path -Algorithm SHA256).Hash }
    return $null
}
function Read-JsonObject($Path) {
    if (!(Test-Path -LiteralPath $Path)) { return [pscustomobject]@{} }
    $v = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
    if ($null -eq $v -or $v -isnot [pscustomobject]) { throw "Expected a JSON object: $Path" }
    return $v
}
function Set-Option($Object, $Name, $Value) {
    $Object | Add-Member -NotePropertyName $Name -NotePropertyValue $Value -Force
}
function Assert-Within($Path, $Root) {
    $p = [IO.Path]::GetFullPath($Path)
    $r = [IO.Path]::GetFullPath($Root).TrimEnd('\') + '\'
    if (!$p.StartsWith($r, [StringComparison]::OrdinalIgnoreCase)) { throw "Path escapes expected directory: $Path" }
    return $p
}
function Assert-Payload($Root) {
    $manifest = Get-Content -LiteralPath (Join-Path $Root 'payload-sha256.json') -Raw | ConvertFrom-Json
    foreach ($entry in $manifest) {
        $p = Assert-Within (Join-Path $Root $entry.Path) $Root
        if ((Get-Hash $p) -ne $entry.SHA256) { throw "Missing or damaged payload: $($entry.Path). Extract the complete original download again." }
    }
}
function Assert-GameVersion($PackageFullName, $Exe) {
    if ($PackageFullName -cne 'LarianStudiosGamesLtd.baldurssgate3_1.8.907.0_x64__551z37b1dechw') { throw 'Unsupported Xbox PC package. This release supports 1.8.907.0 only.' }
    if (!(Test-Path -LiteralPath $Exe -PathType Leaf)) { throw 'The selected folder does not contain bg3.exe.' }
    # GDK protects executable reads outside the game. Inspect its readable package config;
    # the runtime independently enforces package identity, fixed version, SpecialBuild and x64 PE.
    $config=Join-Path (Split-Path $Exe -Parent) 'MicrosoftGame.config'
    $xml=[xml]::new(); $xml.XmlResolver=$null
    $options=[Xml.XmlReaderSettings]::new();$options.DtdProcessing=[Xml.DtdProcessing]::Prohibit;$options.XmlResolver=$null;$options.MaxCharactersInDocument=1048576
    $reader=[Xml.XmlReader]::Create($config,$options)
    try {$xml.Load($reader)} finally {$reader.Dispose()}
    if ($xml.Game.Identity.Name -cne 'LarianStudiosGamesLtd.baldurssgate3' -or $xml.Game.Identity.Version -cne '1.8.907.0' -or $xml.Game.Identity.Publisher -cne 'CN=1EE724DE-ED65-4143-99F1-FAC7C9BE0B9F') { throw 'This game folder does not match the supported Microsoft package.' }
}
function Get-Environment($GameDirectory, $ProfileDirectory) {
    $packages = @(Get-AppxPackage -Name LarianStudiosGamesLtd.baldurssgate3)
    if ($packages.Count -ne 1) { throw 'Install BG3 through Xbox PC / Microsoft Store and launch it once using this Windows account.' }
    $pkg = $packages[0]
    if (!$GameDirectory) {
        $candidates = @(foreach ($drive in Get-PSDrive -PSProvider FileSystem) {
            $base = Join-Path $drive.Root 'XboxGames'
            if (Test-Path -LiteralPath $base) {
                foreach ($dir in Get-ChildItem -LiteralPath $base -Directory -ErrorAction SilentlyContinue) {
                    $p = Join-Path $dir.FullName 'Content'
                    if (Test-Path -LiteralPath (Join-Path $p 'bg3.exe')) { $p }
                }
            }
        })
        if ($candidates.Count -ne 1) { throw 'Could not choose the game folder. Run Install.ps1 -GameDirectory "D:\your Xbox folder\Baldur''s Gate 3\Content". Use the folder containing bg3.exe.' }
        $GameDirectory = $candidates[0]
    }
    $game = (Resolve-Path -LiteralPath $GameDirectory).ProviderPath
    if ($game -match '\\WindowsApps(?:\\|$)') { throw 'Use the writable XboxGames Content folder shown by Xbox > Manage > Files > Browse. Do not take ownership of WindowsApps.' }
    Assert-GameVersion $pkg.PackageFullName (Join-Path $game 'bg3.exe')
    $mods = Join-Path ([Environment]::GetFolderPath('LocalApplicationData')) ('Packages\' + $pkg.PackageFamilyName + '\LocalCache\Local\Mods')
    if (!(Test-Path -LiteralPath $mods)) { throw 'No Xbox mod cache exists yet. Start BG3, open Mod Manager, then quit normally and retry.' }
    if (!$ProfileDirectory) {
        $profiles = @(Get-ChildItem -LiteralPath $mods -Directory | Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName 'modsettings.lsx') })
        if ($profiles.Count -ne 1) { throw 'No unique cached mod profile. Launch BG3 with your intended Xbox profile first, or specify -ProfileDirectory pointing to its folder under the Xbox Mods cache.' }
        $ProfileDirectory = $profiles[0].FullName
    }
    $profile = Assert-Within ((Resolve-Path -LiteralPath $ProfileDirectory).ProviderPath) $mods
    if (!(Test-Path -LiteralPath (Join-Path $profile 'modsettings.lsx'))) { throw 'The selected profile has no modsettings.lsx. Launch the game once first.' }
    [pscustomobject]@{Game=$game; Mods=$mods; Profile=$profile; Package=$pkg.PackageFullName; Family=$pkg.PackageFamilyName}
}
function Install-TrackedFile($Source, $Destination, $StateDirectory, $Journal) {
    $backup = $null; $oldHash = Get-Hash $Destination
    if ($oldHash) {
        $backup = Join-Path $StateDirectory ('backup-' + $Journal.Files.Count + '.bin')
        Copy-Item -LiteralPath $Destination -Destination $backup
        if ((Get-Hash $backup) -ne $oldHash) { throw 'Backup verification failed.' }
    }
    $entry = [pscustomobject]@{Destination=$Destination; Backup=$backup; OriginalHash=$oldHash; InstalledHash=(Get-Hash $Source); Restored=$false}
    $Journal.Files = @($Journal.Files) + $entry
    Write-JsonFile (Join-Path $StateDirectory 'installation.json') $Journal
    Copy-Item -LiteralPath $Source -Destination $Destination -Force
    if ((Get-Hash $Destination) -ne $entry.InstalledHash) { throw "Installed hash mismatch: $Destination" }
}
function Restore-TrackedFiles($StateDirectory, $Journal, [switch]$Apply) {
    $conflicts = 0
    foreach ($entry in @($Journal.Files)[($Journal.Files.Count-1)..0]) {
        if ($entry.Restored) { continue }
        $dest = [IO.Path]::GetFullPath($entry.Destination)
        $allowed = @('DWrite.dll','BG3ScriptExtender.dll','ScriptExtenderSettings.json','ScriptExtenderUpdaterConfig.json')
        if ((Split-Path $dest -Parent) -ne $Journal.GameDirectory -or (Split-Path $dest -Leaf) -notin $allowed) { throw 'Invalid destination in installation record.' }
        $currentHash = Get-Hash $dest
        if ($currentHash -eq $entry.OriginalHash) {
            if ($Apply) { $entry.Restored=$true; Write-JsonFile (Join-Path $StateDirectory 'installation.json') $Journal }
            continue
        }
        if ($currentHash -ne $entry.InstalledHash) { Write-Warning "Preserved changed file: $dest"; $conflicts++; continue }
        if ($entry.Backup) {
            $backup = Assert-Within $entry.Backup $StateDirectory
            if ((Get-Hash $backup) -ne $entry.OriginalHash) { throw 'Backup hash mismatch; nothing will be restored from that backup.' }
            Write-Host "Restore original: $dest"
            if ($Apply) { Copy-Item -LiteralPath $backup -Destination $dest -Force }
        } else {
            Write-Host "Remove installed file: $dest"
            if ($Apply) { Remove-Item -LiteralPath $dest }
        }
        if ($Apply) { $entry.Restored=$true; Write-JsonFile (Join-Path $StateDirectory 'installation.json') $Journal }
    }
    return $conflicts
}
Export-ModuleMember -Function *
