> Historical record for withdrawn package 0.1.0. The original evidence below is preserved; it does not validate the current package. The matching installer and tests remain in the [v0.1.0 Git history](https://github.com/titoreinaldo/bg3-xbox-pc-mod-support/tree/v0.1.0). For current build and test instructions, see [BUILDING.md](../../BUILDING.md).

# Release 0.1.0 validation — 21 September 2026

## Release packaging

- Windows PowerShell 5.1 read-only installation check passed against Microsoft package 1.8.907.0 and the actual Xbox mod-cache profile.
- Eleven fixture assertions passed: installing a replacement; preserving its original backup; preview-only behavior; restoring the original; removing a newly added file; preserving newer edits; rejecting damaged backups; rejecting path traversal; rejecting an out-of-directory journal destination; preserving unrelated JSON settings; rejecting an unsupported package.
- A separate complete copy of the public installer was run against the supported game while it was closed. The private .NET 8.0.31 runtime opened the packaged patched manager with Profile XboxPC and Campaign Main, and it read the existing active order successfully.
- The uninstaller restored the four native/configuration files to their exact pre-test hashes. The load-order file also retained its exact pre-test hash. The test did not change campaign saves or export a new load order.
- Process detection covers BG3, the manager apphost and a manager hosted by dotnet.exe.
- Payload hashes cover native DLLs, manager libraries, the private runtime and optional MCM. The ZIP contains no InstallationState, real profile/load-order files, personal manager settings, logs, saves, diagnostic probe PAK or BG3 executable.

## Runtime evidence and scope

The native DLL SHA256 is `846057960E4D9E7544E87E15D58948BBC4F7E2BA08153007F7D2C0F1C2DFC85D`, from native source commit `220a4a468bf5496bdd2a80251718acda0cc13d7f`. Its September 19 isolated startup/client initialization retest passed after the optional-mapping correction. The upstream main-menu compile-date string can retain an earlier translation-unit build date; the hash identifies this artifact.

Full client/server Lua, Osiris, gameplay and modded save creation/restart/reload evidence belongs to the preceding September 15 native build. It is historical evidence, not a complete regression test of this exact DLL. The current MCM package's mouse-menu access, saved setting and callbacks were verified on September 15. On September 21 the game again showed v33 and opened MCM through the main menu. Screenshots capture actual running software.

The leftover personal diagnostic PAK that added `[PAK test]` to New Game was backed up and removed. It was never included in the public package.

No claim is made that every mod/API, multiplayer/cross-play, achievements, all campaign acts, or long-session stability is verified. The two unavailable optional bindings and earlier hang report are documented in README.md. Exact build and critical mapping checks remain active.
