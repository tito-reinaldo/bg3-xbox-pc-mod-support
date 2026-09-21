# Download the complete release ZIP

Use [GitHub Releases](https://github.com/tito-reinaldo/bg3-xbox-pc-mod-support/releases) or [Nexus Mods](https://www.nexusmods.com/baldursgate3/mods/25195). The GitHub Code ZIP contains installer sources and patches, not the binary payload. Full corresponding component source is inside the complete release download. See BUILDING.md.

# BG3 Xbox PC / Microsoft Store Mod Support

**Experimental release 0.1.0 — Windows PC only.** This community compatibility package enables a local Script Extender v33 port and configures a patched BG3 Mod Manager for the Xbox app / Microsoft Store edition of Baldur's Gate 3.

**Supported target: Microsoft package 1.8.907.0, engine build 4.1.1.7445165, x64 DX11.** It is not for Xbox consoles, Steam, GOG, cloud gaming, or other game builds. It is not an official release by Larian, Microsoft, Norbyte, LaughingLeader, or Volitio. Individual mods can still be incompatible.

- Project, source and issue reports: https://github.com/tito-reinaldo/bg3-xbox-pc-mod-support
- Nexus download: https://www.nexusmods.com/baldursgate3/mods/25195

## Install

1. Install and launch the Xbox PC / Microsoft Store game normally at least once. Sign into the Xbox profile you intend to use and open the in-game Mod Manager. Quit normally after the game has created its mod cache.
2. Download the **complete 0.1.0 ZIP**, and use **Extract All** into a permanent, writable folder such as `C:\Games\BG3-Xbox-Mod-Support`. Do not extract into WindowsApps or the game folder. Keep all subfolders together. This is a manual installation; do not send this ZIP to Vortex or import the whole ZIP as a PAK mod.
3. Save and close BG3 and any running BG3 Mod Manager. Double-click **Check.cmd** for read-only package, path and payload checks.
4. Double-click **Install.cmd**. The installer detects the registered Microsoft package, locates the XboxGames Content folder, finds your cached mod profile, and backs up the four files it changes. It leaves the game executable, installed PAKs, load order and saves intact. No administrator or WindowsApps ownership change is required.
5. Double-click **Start Mod Manager.cmd**. Use **Profile: XboxPC**, **Campaign: Main**. Import each mod from its author, read its requirements, and move it from Inactive to Active. Put dependencies before dependent mods and follow the author's order for conflict patches.
6. Choose **Save Order As** to retain a named order, then **Export Order to Game**. Saving the named order alone does not activate mods. Preserve official/catalogue mods you want when exporting the order.
7. Launch from the Xbox app, your normal Xbox shortcut, or the configured manager Launch Game button. Check the main menu for **Script Extender v33 loaded**. Try new mods in a disposable campaign and test save/reload before committing to a long playthrough.

The package includes a private Microsoft .NET 8.0.31 desktop runtime for the manager. It does not install .NET globally. The command launchers use Windows PowerShell only for this operation; they do not change your persistent execution policy.

### Custom game folder or multiple Xbox profiles

If automatic detection cannot choose a folder, open PowerShell in the extracted release folder and run:

```powershell
.\Install.ps1 -GameDirectory "D:\XboxGames\Baldur's Gate 3\Content"
```

Use Xbox **Manage > Files > Browse** to find the folder containing `bg3.exe` and `MicrosoftGame.config`. If more than one cached profile exists, add `-ProfileDirectory` with the full path to the intended folder containing `modsettings.lsx` under:

```text
%LOCALAPPDATA%\Packages\LarianStudiosGamesLtd.baldurssgate3_551z37b1dechw\LocalCache\Local\Mods
```

No cached profile found? Start the game using the intended Xbox account, open Mod Manager and quit normally, then retry. Do not invent a profile ID or point the manager at Xbox cloud-save containers.

### Optional Mod Configuration Menu

`OptionalMods\BG3MCM.pak` is an optional, modified **MCM 1.41.0.0** from Volitio/AtilioA, with a mouse-menu compatibility fix and package priority 30. Import this PAK into the supplied manager, activate it, place it before MCM-dependent mods, and export. Do not install it alongside a second MCM PAK with the same UUID. Keep a copy of any existing MCM package before replacing it.

Open **Mod Configuration Menu** from BG3's main menu or the in-game menu. Its presence in the official Installed list is not a reliable indicator of activation. This modified MCM is distributed under AGPLv3; its full corresponding source, font/library notices and build helper are included. It is not a new official MCM version. MCM is optional; the installer does not automatically install or activate it.

## What changes

The installer writes only these native/configuration files beside `bg3.exe`:

- `DWrite.dll`: Norbyte's unmodified upstream v32 loader.
- `BG3ScriptExtender.dll`: the local v33 Microsoft compatibility port.
- `ScriptExtenderUpdaterConfig.json`: selects the loader's local development runtime and disables ordinary runtime updates.
- `ScriptExtenderSettings.json`: preserves existing options and hides the debug console; supplies conservative defaults for a new configuration.

Original files and their hashes are retained in `InstallationState`. Manager settings, named orders and two directory junctions are created inside this extracted release folder. The junctions connect the manager to the game's real mod cache. The installer copies your existing load order into InstallationState for reference but never overwrites it. It does not change achievements/launcher options in an existing configuration; a new configuration leaves the achievement override disabled. No title-bar helper or personal graphics changes are included.

**Keep this folder in its installed location. Do not recursively delete the contents of ManagerView: its junctions lead into your real mod cache.**

## Tested behavior and limits

- September 15 native build: client/server Lua, Osiris callbacks and queries, gameplay, creating a modded save, normal quit/restart, and loading that save passed in a disposable campaign.
- MCM mouse-menu build: main/in-game menu access and a harmless test setting's saved value and callbacks were verified.
- September 19 native DLL included here: isolated startup and client initialization passed after correcting the handling of two audited optional mappings. The earlier full campaign/save/reload test was **not repeated on this exact DLL**.
- September 21: the running Xbox PC game showed Script Extender v33 and opened MCM through the main menu. Included screenshots document that observation. This is not a full campaign regression test.
- Mod manager: the patched export and Microsoft package launch were verified locally. Release packaging and installer rollback tests are described in `VALIDATION.md`.

The runtime retains exact package, fixed resource version (4.1.1.39597), SpecialBuild (7445165), architecture and critical mapping guards. The installer checks the registered package and readable Microsoft game configuration; GDK can block external reads of the protected executable. The runtime performs its additional checks inside the game.

Unresolved optional bindings: custom profile relocation (`App::UpdatePaths`) and an unused data-context command-queue callback. Custom profile relocation is unsupported. Other missing critical bindings are still errors. Complete engine ABI coverage, every SE API, every mod, multiplayer/cross-play, achievements and long-session stability are not established. A hang was reported during earlier use; a subsequent launch worked, and its cause was not established. Use a test campaign and keep pre-mod saves.

## Updating and troubleshooting

- **Do not use the manager's Download/Update Script Extender command or replace the two SE JSON files with generic instructions.** The normal upstream download does not contain this experimental port. Keep `DebugLoadSE: true` and `DisableUpdates: true` in the updater configuration.
- Do not accept a manager auto-update over this portable patched copy until an equivalent compatibility fix is available.
- A future game/package update requires a new audited release. This installer rejects other package versions; the runtime also rejects other builds. Do not weaken those checks to force it to load.
- If an imported mod does not activate, check its dependencies, export the intended order, inspect the in-game Installed tab, and restart after enabling it there if offered. After official catalogue updates, refresh the external manager and re-export the full intended order.
- The debug console is hidden by default. For a useful bug report, enable `CreateConsole` or `LogRuntime` temporarily in your own SE settings. Remove user paths/account identifiers and other personal information from logs before sharing.
- Report the package/game version, release number, a minimal mod list, steps to reproduce, and whether it happens with only this port. Do not attach game executables, saves or raw memory dumps.

## Uninstall / rollback

First remove or disable mods according to their authors' instructions and use an appropriate pre-mod save. Removing Script Extender does not make a mod-dependent save vanilla again.

1. Save and close BG3 and BG3 Mod Manager.
2. Run **Uninstall-preview.cmd** to see what would change.
3. In PowerShell in this release folder, run ` .\Uninstall.ps1 -Apply ` to restore tracked originals or remove files that this installer added.

Rollback checks hashes and preserves anything changed since installation. Conflicts are reported for manual comparison with the backups; it does not overwrite newer files. It leaves PAKs, orders, saves, manager files and junctions intact. Keep InstallationState for recovery. To reinstall, roll back the prior installation first and extract a fresh release into a new permanent folder.

## Credits and source

Compatibility integration and release: **tito-reinaldo / titoreinaldo**, developed with AI coding assistance. The underlying tools are the work of their respective authors:

- [Norbyte's BG3 Script Extender](https://github.com/Norbyte/bg3se): MIT **with the Commons Clause no-sale condition**. Preserve both notices. Free distribution; no paid access or support sold for this port.
- [LaughingLeader's BG3 Mod Manager](https://github.com/LaughingLeader/BG3ModManager): MIT. This is a modified build retaining the upstream assembly version 1.0.12.9.
- [Volitio/AtilioA's Mod Configuration Menu](https://github.com/AtilioA/BG3-MCM): AGPLv3, with its included font/library licenses.
- Microsoft and the other dependency authors: see `Runtime\LICENSE.txt`, `Runtime\ThirdPartyNotices.txt`, `Licenses`, and the notices in `Source`.

The included `Source` tree contains the three corresponding project sources; `Developer` includes upstream-relative patches, revision/dependency records and MCM build helpers. See `BUILDING.md`. The original installer/docs are MIT-licensed. This collection does not replace component licenses or imply endorsement from upstream authors. No game executable or game data files are distributed.
