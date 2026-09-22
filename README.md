# BG3 Mod Support for the Xbox App on PC


**Experimental package 0.2.2 · Xbox PC / Microsoft Store package 1.8.907.0 only**


**Player downloads are hosted on Nexus Mods and are subject to its scanning and moderation.** Version 0.2.0 was quarantined after antivirus detections on its outer launcher. Package 0.2.1 removed that unnecessary launcher completely. Package 0.2.2 adds the full AGPLv3 license and copyright notices and has been submitted on the [Nexus page](https://www.nexusmods.com/baldursgate3/mods/25204). Do not use 0.2.0 or bypass security warnings.


## What it does


An unofficial Xbox compatibility build of BG3 Mod Manager, with a **Set up** button for the compatible Script Extender and optional Mod Configuration Menu (MCM). It detects the supported game and Xbox profile, preserves other mods and settings, and creates backups. Undo is available inside the manager and refuses to overwrite later changes. No commands or global .NET installation are required.


## Installation after Nexus approval


1. On your PC, launch BG3 once through the Xbox app, open its in-game Mod Manager, then quit.
2. Extract the entire player ZIP into a writable folder outside the game.
3. Open the **App** folder, run **BG3ModManager.exe**, and click **Set up**. Leave MCM checked to include it.
4. Launch BG3 normally. Look for **Script Extender v33 loaded** and **Mod Configuration Menu** in the main menu.


Keep all files in App together. The player ZIP contains only required application/runtime files, SE/MCM payloads, license notices and a short text guide. No developer source, scripts, Markdown reports, logs, saves or test mods are included.


To add other mods, close BG3, use **File > Import Mod**, move the desired mods to Active, and **Export Order to Game**. Preserve the other mods you want active and follow each author’s dependencies and load order. Keep the app folder and its backups.


## Testing and limitations


Package 0.2.1 removed the outer launcher and updated the short guide. Package 0.2.2 changes licensing and documentation only; its application and mod files are identical to 0.2.1. All remaining application and mod binaries are byte-for-byte unchanged from 0.2.0; the app title still identifies manager build 0.2.0. Direct launch was verified with the Xbox profile and existing mods.


The unchanged manager passed 19 setup/restore fixture checks and live GUI checks for detection, reading mods, blocking setup while BG3 ran, installation, exact restoration of 21 tracked originals, preserving other mods and ordered IDs, export backups and Xbox launch.


Supports game build **4.1.1.7445165**, Microsoft package **1.8.907.0**, Windows x64 only. Not for Xbox consoles, cloud gaming, Steam or GOG. Future game updates need a newly tested release. Custom profile relocation is unsupported. Standard SE/manager automatic updates are disabled in this experimental copy.


SE v33 and MCM have loaded on this Xbox build. Earlier testing included Lua/Osiris, gameplay and modded save/reload; the full campaign test was not repeated on the exact later native DLL supplied here. Every mod/API, multiplayer, achievements and long-session stability are not established. An earlier launch hang/crash has no confirmed cause. Keep pre-mod saves and test new mods in a disposable campaign.


## Credits and corresponding source


- Norbyte: Script Extender, MIT with Commons Clause.
- LaughingLeader: BG3 Mod Manager, MIT.
- Volitio/AtilioA: Mod Configuration Menu, AGPLv3 plus component/font notices.
- Xbox integration and packaging: tito-reinaldo, with AI coding assistance.


This is not an official release or endorsement by those authors, Larian or Microsoft. Free distribution; no Donation Points. Required notices remain in App/THIRD PARTY NOTICES.txt.


[Full corresponding source and build instructions](https://github.com/titoreinaldo/bg3-xbox-pc-mod-support/releases/tag/v0.2.2) are a separate developer archive. That release provides source and checksums only, not a player download. GitHub’s automatic Code/tag archives are not the complete corresponding source. The withdrawn 0.1.0 installer and its tests remain in the [v0.1.0 history](https://github.com/titoreinaldo/bg3-xbox-pc-mod-support/tree/v0.1.0). Its [validation record](Developer/Historical/VALIDATION-0.1.0.md) is preserved as historical evidence. See [BUILDING.md](BUILDING.md) for the current source archive and build instructions.

## Reports and contributions

Use the [bug report form](https://github.com/titoreinaldo/bg3-xbox-pc-mod-support/issues/new/choose) for problems and [CONTRIBUTING.md](CONTRIBUTING.md) for proposed fixes. Report security vulnerabilities privately through the route in [SECURITY.md](SECURITY.md). Please follow the [code of conduct](CODE_OF_CONDUCT.md).
