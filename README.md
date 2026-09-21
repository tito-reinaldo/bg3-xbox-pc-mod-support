# BG3 Xbox Mod Manager

**Experimental package 0.2.1 · Xbox PC / Microsoft Store package 1.8.907.0 only**

**Player downloads are pending Nexus moderation review.** Version 0.2.0 was quarantined after antivirus detections on its outer launcher. Package 0.2.1 removes that unnecessary launcher completely and has been submitted on the [existing Nexus page](https://www.nexusmods.com/baldursgate3/mods/25202). Do not use 0.2.0 or bypass security warnings.

## What it does

An unofficial Xbox compatibility build of BG3 Mod Manager, with a **Set up** button for the compatible Script Extender and optional Mod Configuration Menu (MCM). It detects the supported game and Xbox profile, preserves other mods and settings, and creates backups. Undo is available inside the manager and refuses to overwrite later changes. No commands or global .NET installation are required.

## Installation after Nexus approval

1. Launch BG3 once through Xbox, open its in-game Mod Manager, then quit.
2. Extract the entire player ZIP into a writable folder outside the game.
3. Open the **App** folder, run **BG3ModManager.exe**, and click **Set up**. Leave MCM checked to include it.
4. Launch BG3 normally. Look for **Script Extender v33 loaded** and **Mod Configuration Menu** in the main menu.

Keep all files in App together. The player ZIP contains only required application/runtime files, SE/MCM payloads, license notices and a short text guide. No developer source, scripts, Markdown reports, logs, saves or test mods are included.

To add other mods, close BG3, use **File > Import Mod**, move the desired mods to Active, and **Export Order to Game**. Preserve the other mods you want active and follow each author’s dependencies and load order. Keep the app folder and its backups.

## Testing and limitations

Package 0.2.1 only removes the outer launcher and updates the short guide. All remaining application and mod binaries are byte-for-byte unchanged from 0.2.0; the app title still identifies manager build 0.2.0. Direct launch was verified with the Xbox profile and existing mods.

The unchanged manager passed 19 setup/restore fixture checks and live GUI checks for detection, reading mods, blocking setup while BG3 ran, installation, exact restoration of 21 tracked originals, preserving other mods and ordered IDs, export backups and Xbox launch.

Supports game build **4.1.1.7445165**, Microsoft package **1.8.907.0**, Windows x64 only. Not for Xbox consoles, cloud gaming, Steam or GOG. Future game updates need a newly tested release. Custom profile relocation is unsupported. Standard SE/manager automatic updates are disabled in this experimental copy.

SE v33 and MCM have loaded on this Xbox build. Earlier testing included Lua/Osiris, gameplay and modded save/reload; the full campaign test was not repeated on the exact later native DLL supplied here. Every mod/API, multiplayer, achievements and long-session stability are not established. An earlier launch hang/crash has no confirmed cause. Keep pre-mod saves and test new mods in a disposable campaign.

## Credits and corresponding source

- Norbyte: Script Extender, MIT with Commons Clause.
- LaughingLeader: BG3 Mod Manager, MIT.
- Volitio/AtilioA: Mod Configuration Menu, AGPLv3 plus component/font notices.
- Xbox integration and packaging: tito-reinaldo, with AI coding assistance.

This is not an official release or endorsement by those authors, Larian or Microsoft. Free distribution; no Donation Points. Required notices remain in App/THIRD PARTY NOTICES.txt.

[Full corresponding source and build instructions](https://github.com/tito-reinaldo/bg3-xbox-pc-mod-support/releases/tag/v0.2.1) are a separate developer archive. That release provides source and checksums only, not a player download. GitHub’s automatic Code/tag archives are not the complete corresponding source. The historical installer scripts in this repository root are from 0.1.0 and are not the current installation method.
