# Contributing

Bug reports, clearer instructions, and compatibility fixes are welcome.

## Report a problem

Use the **Report a bug** issue form. Include the package version, BG3 build, Microsoft Store package version, Windows version, and active mods with their load order. Describe what happened and how to reproduce it. Write "unknown" for a version you cannot find.

Search existing issues first. Test with a spare save or test profile if needed; do not remove mods from a save you depend on just to investigate a report. Share only relevant log excerpts, with private details removed.

Report security problems privately as explained in [SECURITY.md](SECURITY.md).

## Propose a change

Keep each pull request focused on one problem. Explain the current behavior, your change, and what you checked. Open an issue before starting a large redesign.

The complete component sources are in **BG3-Xbox-PC-Corresponding-Source-0.2.2.zip** on the [0.2.2 source release](https://github.com/titoreinaldo/bg3-xbox-pc-mod-support/releases/tag/v0.2.2). Read that archive's BUILDING.md for build and test instructions. The repository's historical installer scripts and GitHub's automatic source archives are not the complete current component sources.

For code that exists only in the source archive, include a text patch under Developer/ in your pull request. State the source archive version, affected component, paths relative to that component, and commands needed to apply and test the patch. Documentation and existing repository files can be edited directly.

For setup changes, run the archive's setup/restore fixture checks and verify that backups, other mods, and load order are preserved. For game behavior, state the exact game build, mods, and checks performed. Say clearly when something was not tested.

## Files and licenses

Keep generated binaries, player packages, saves, private logs, and personal account data out of pull requests. Preserve copyright and license notices. Changes to MCM remain under AGPLv3; the manager, Script Extender, and other components retain their own licenses. See the notices in the source archive.

Be respectful and follow the [code of conduct](CODE_OF_CONDUCT.md). This is a community project; review and fixes depend on maintainer availability.
