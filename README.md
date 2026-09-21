# BG3 Xbox Mod Manager

**Experimental 0.2.0 · Xbox PC / Microsoft Store · package 1.8.907.0 only**

[Download the player ZIP](https://github.com/tito-reinaldo/bg3-xbox-pc-mod-support/releases/tag/v0.2.0). Choose **BG3-Xbox-Mod-Manager-0.2.0.zip**. The separately labelled source archive is for developers.

An unofficial Xbox compatibility build of BG3 Mod Manager, with a **Set up** button that installs the compatible Script Extender and optional Mod Configuration Menu (MCM).

## Install

1. Launch BG3 once through Xbox, open its in-game Mod Manager, then quit.
2. Extract the full player ZIP into a writable folder outside the game.
3. Open **BG3 Xbox Mod Manager.exe** and click **Set up**. Leave MCM checked to include it.
4. Launch BG3 normally. Look for **Script Extender v33 loaded** and **Mod Configuration Menu** in the main menu.

Keep the App folder beside the program. No commands, manual JSON editing or global .NET installation are needed. If detection needs help, select the game's Content folder using the folder picker. Find that folder through Xbox > Manage > Files > Browse. For multiple cached profiles, choose the intended profile in the manager.

Close BG3 before importing mods or exporting an order. Use **File > Import Mod**, move the desired mods to Active, and **Export Order to Game**. Preserve all other mods you want active and follow each author's dependency/load-order instructions. Launch through Xbox or the manager's Launch Game button.

## What is included

The player download contains only the launcher, application/runtime files, compatible SE/MCM payloads, required notices and a short guide. No developer source, scripts, reports, logs, saves or diagnostic mods. It is a portable utility; extract it manually rather than importing its ZIP into Vortex or the in-game mod browser.

Setup detects the supported game and cached Xbox profile directly, backs up all changed files and preserves existing settings and other mods. MCM is selected by default and can be unchecked. Undo is under **Xbox PC > Undo setup** and refuses to overwrite later changes. Exporting a mod order also creates a backup. Keep the extracted app folder because it holds those backups.

## Compatibility and testing

Supports **LarianStudiosGamesLtd.baldurssgate3 1.8.907.0**, game build **4.1.1.7445165**, on Windows x64. This is not for Xbox consoles, cloud gaming, Steam or GOG. Other versions are rejected; a game update needs a newly tested compatibility release.

0.2.0 passed 19 automated setup/rollback fixture checks. The packaged GUI was tested on the Xbox installation: reading the existing mods/profile, blocking setup while the game ran, installation with six verified files, preserving the ordered mod IDs and every other PAK, exact restoration of all 21 tracked originals, and export with an exact pre-export backup. Native SE and MCM binaries are unchanged from the earlier tested port.

The native port has shown Script Extender v33 and opened MCM on this Xbox build. Earlier September 15 testing covered Lua/Osiris, gameplay and a modded save/reload. The later exact native DLL included here passed startup/client checks, but that complete campaign/save/reload test was not repeated on this exact DLL. Every mod/API, multiplayer, achievements and long-session stability are not established. An earlier launch hang/crash report has no confirmed cause. Custom profile relocation is unsupported. Keep pre-mod saves and test new mods in a disposable campaign.

This is a local experimental runtime. Standard SE/manager automatic updates are disabled in this copy so they cannot replace the Xbox build. The debug console is hidden by default. Setup never replaces the game executable or changes Xbox save containers.

## Credits and source

- [Norbyte's Script Extender](https://github.com/Norbyte/bg3se): MIT with Commons Clause.
- [LaughingLeader's BG3 Mod Manager](https://github.com/LaughingLeader/BG3ModManager): MIT; modified app keeps upstream assembly version 1.0.12.9.
- [Volitio/AtilioA's MCM](https://github.com/AtilioA/BG3-MCM): AGPLv3 and component/font notices.
- Xbox compatibility integration and packaging: tito-reinaldo, with AI coding assistance.

This is not an official release or endorsement by those authors, Larian or Microsoft. Free distribution; no Donation Points. Required notices are in **App/THIRD PARTY NOTICES.txt**. Full corresponding sources, dependency revisions and build instructions are in **BG3-Xbox-PC-Corresponding-Source-0.2.0.zip**, a separate release asset. Do not use GitHub's automatically generated Code ZIP as the player download.

The old 0.1.0 Nexus listing was deleted at the uploader's request. The scripts retained in this repository root describe that historical installer; use the 0.2.0 release and its corresponding-source archive for the current application. Scanner results and download availability are determined by the hosting service; this project cannot guarantee automatic approval.
