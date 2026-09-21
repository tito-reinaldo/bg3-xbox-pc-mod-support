# Corresponding source and build notes

The release ZIP includes the full tracked sources for all three modified projects. The public source tree has path-only build/documentation adapters; these do not change the supplied native or manager binaries. Upstream-relative patches and exact source/dependency revisions are under Developer. Sources omit Git history, private settings, logs, caches and game files.

## Native Script Extender

Upstream base: `77e9072f1092eda7c657352ed21040f1664f3ee5` (Norbyte/bg3se).
Binary source commit: `220a4a468bf5496bdd2a80251718acda0cc13d7f`.
Archived source commit: `415980445ec16d5e586e7074a0dbb4a2a4ccc8b9` (adds documentation only).
DLL SHA256: `846057960E4D9E7544E87E15D58948BBC4F7E2BA08153007F7D2C0F1C2DFC85D`.

Use PowerShell 7, Python 3, Git, Microsoft MSVC 14.51.36231 (compiler 19.51.36257), Windows SDK 10.0.26100.0, CMake 4.4.3 and Ninja 1.13.2. These are developer requirements, not installation requirements. Obtain toolchains from their official publishers; they are not redistributed here.

The source build scripts expect this layout beneath a build root:

```text
Source/bg3se/                         included source
Tools/PortableMSVC/VC/Tools/MSVC/...  Microsoft compiler
Tools/PortableMSVC/Windows Kits/10/  Windows SDK
Tools/CMake/bin/cmake.exe
Tools/ninja/ninja.exe
Build/
Downloads/
Logs/
```

Run `Source\bg3se\MicrosoftCompatibility\Fetch-Dependencies.ps1`, then check out the exact dependency commits in `Developer\BG3SE-Dependencies.json` before compiling. Some upstream dependency refs follow a branch, so the recorded commit list is the authority for this release. Archive sources and SHA256 values are recorded there too. Preserve all upstream licenses and observe any SDK terms.

Run `Source\bg3se\MicrosoftCompatibility\Build-Microsoft.ps1 -Jobs 2 -Python python.exe`. This opt-in build defines `BG3SE_MICROSOFT_7445165`, generates the Microsoft mappings, enums/property maps/protobuf code/Lua bundle and builds the DLL without deployment. It leaves normal upstream builds unchanged. See the included MicrosoftCompatibility README for the engine changes. Output is `Build\BG3SE-Microsoft\BG3ScriptExtender.dll`. Compiler timestamps may prevent byte-for-byte reproduction; compare source and test behavior as well as hashes.

The unmodified DWrite loader comes from Norbyte's v32 updater release (2026-06-21); SHA256 `8F3C0782461CC280CAB4ADFC270979549211F6CAC91AD851BAA2B2716118ECB0`.

## Mod manager

Upstream base: `fc3535868935c16b7260be0d5749c0d84b2a9b1a`.
Modified source: `f64fe2effe9f2a22c6aaefa99b79361b03114fc5`.
The assembly version stays 1.0.12.9. Changes include the WPF export scheduler, SharpCompress 0.48 APIs, existing-SE-configuration preservation and local runtime detection.

Install the official .NET 8 SDK. From the release root, using PowerShell:

```powershell
$root = (Get-Location).Path
dotnet build "$root\Source\BG3ModManager\src\GUI\GUI.csproj" -c Release -p:Platform=x64 "-p:SolutionDir=$root\Source\BG3ModManager\" "-p:BG3MMReleaseLibraries=$root\Manager\_Lib" "-p:OutputPath=$root\Build\BG3ModManager\" --nologo
```

This uses LSLib/CrossSpeak reference libraries from the accompanying manager distribution. To build those dependencies yourself, use the upstream submodule revisions recorded by the manager project. The normal upstream references remain when BG3MMReleaseLibraries is absent. Use the Release build, not the upstream Publish scripts that perform their own cleanup/deployment. The private runtime included for users is not an SDK.

## Optional MCM

Upstream author commit: `aa49f4436b4d1dd0cb9f1d3265bde8522883c653` (1.41.0.0).
Modified source: `8a754fcb9689245ee28439034bc55bb65d11d8af`.
PAK SHA256: `047EF751C333BCAB1180779350ED39EEC09FCE276D65745B9D174723C72E027C`.

All corresponding Lua, XAML, localization, metadata and other source assets are included in `Source\BG3-MCM`, with AGPLv3 and embedded dependency notices. The small local menu change is in `Developer\BG3-MCM.patch`.

Use PowerShell 7 and run `Developer\Build-MCM.ps1 -Tag my-build`. The helper loads LSLib from `Manager\_Lib`, converts localization XML to LOCA, and creates a version-18 LZ4 package with **priority 30**. This priority is required for the menu override; priority 0 does not reproduce the working package. Outputs go to Build/Downloads/Logs under the extracted release. The helper never installs or activates its output. Repacked bytes can differ because file enumeration and compression need not be deterministic.

## Release installer tests

`Developer\Test-Installer.ps1` exercises backup/restore of originals, removal of newly added files, preview-only behavior, changed-file preservation, damaged backup rejection and path-traversal rejection in temporary fixture folders. It never writes to the real game or saves. Run with Windows PowerShell 5.1 or PowerShell 7.
