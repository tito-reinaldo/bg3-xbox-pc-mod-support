# BG3 Xbox Mod Manager 0.2.0 — corresponding source

This archive is for developers. Players only need the separate **BG3-Xbox-Mod-Manager-0.2.0.zip**.

`Source/BG3ModManager` is the exact updated manager source, including direct Xbox cache/profile discovery, local setup, MCM activation, verified backups/restoration, export backups and protected Xbox launch. It builds on the upstream `fc3535868935c16b7260be0d5749c0d84b2a9b1a` and the earlier compatibility changes `f64fe2effe9f2a22c6aaefa99b79361b03114fc5`. Assembly version remains 1.0.12.9; the app title identifies experimental 0.2.0.

`Source/bg3se`, `Source/BG3-MCM` and `Source/Tolk` are unchanged corresponding sources for the runtime, MCM and speech components. The native/MCM dependency revisions, upstream patches and detailed build notes are in `Developer/Native-and-MCM-BUILDING.md` and the other Developer files. Ignore its old installer sections; 0.2.0 replaces that installer with the manager's setup window.

## Build the manager

Install Microsoft's .NET 8 SDK (release built with SDK 8.0.425). Extract the player ZIP separately to obtain the shipped reference/dependency libraries, or rebuild those using the included submodule sources. In PowerShell at this source archive's root:

```powershell
.\Build-Manager.ps1 -PlayerApp 'C:\path\to\player\App'
```

The output is `Build/Manager/App/BG3ModManager.exe`, a self-contained .NET 8 Windows x64 folder deployment. Do not use single-file publishing: the C++/CLI LSLibNative dependency requires its native loader and normal file layout. `Ijwhost.dll` must be alongside `LSLibNative.dll`. The `_Lib` directory contains only the three speech native libraries. Players do not need a global .NET installation.

## Build the root launcher

`Launcher.c` is a small Windows GUI program which starts `App/BG3ModManager.exe` with the correct working directory. It performs no downloads, setup or elevation. Build with MSVC x64 using `/O2 /MT /W4 /link /SUBSYSTEM:WINDOWS kernel32.lib user32.lib`. `Build-Launcher.ps1` supports the recorded portable MSVC/SDK layout and writes `CleanPlayer/BG3 Xbox Mod Manager.exe`; create `Build` and `CleanPlayer` first. Compiler version 19.51.36257 and SDK 10.0.26100.0 were used.

## Rebuild MCM

The updated `Developer/PakTools.psm1` expects an extracted player `App` folder beside `Source` and `Developer`. Run `Developer/Build-MCM.ps1 -Tag my-build` using PowerShell 7. It produces an LZ4 version-18 PAK with priority **30**, without installing it. All Lua/XAML/font/localization sources and notices are included.

## Test setup safely

```powershell
dotnet run --project Tests/SetupTests.csproj -c Release -- 'C:\path\to\player\App\Payload'
```

This creates synthetic game/profile fixtures under the temporary directory and verifies installation, exact restoration, preservation of other mods/settings, version/path/payload validation, later-change conflicts and XML protections. It does not discover or write the real game. Private live-test settings, logs, account identifiers and saves are excluded from this archive.

## Licenses and provenance

Norbyte's Script Extender: MIT with Commons Clause. LaughingLeader's manager: MIT. Volitio/AtilioA's MCM: AGPLv3 with component/font notices. Tolk/CrossSpeak: their included licenses. Copyright and dependency license texts are preserved. Original launcher, setup integration and release helpers by tito-reinaldo (2026), developed with AI coding assistance, under MIT; component terms remain applicable. This is not endorsed by the upstream authors, Larian or Microsoft.

Repacking/recompiling may not reproduce identical bytes because of timestamps and toolchain differences. `Developer/Source-Revisions.json`, the original patches and payload hashes describe the unchanged native/MCM inputs; the updated manager tree in this archive is authoritative for 0.2.0.
