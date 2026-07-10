# CLAUDE.md

## Overview

PowerShell/Batch scripts that keep the Steam version of Cookie Clicker running on
a dedicated Windows VM. The scripts poll the owner's Steam profile and stop Cookie
Clicker (plus Steam) while another game is being played, restart it afterwards, and
minimize windows on Chrome Remote Desktop connections.

## Development commands

There is no build system or package manager; run the scripts directly with
PowerShell 7 (`pwsh`).

- `checkInGame.bat`: entry point. Runs an infinite loop of `git pull` +
  `pwsh -File checkInGame.ps1` + `timeout /T 180`.
- `pwsh -File checkInGame.ps1`: run one monitor/state-transition cycle manually.
- `pwsh -File chromerdp-clicker-minimalize.ps1`: minimize the Cookie Clicker window.
- `pwsh -File minimalize-steam.ps1`: minimize the Steam window.

## Architecture / key files

- `checkInGame.ps1`: core logic. Fetches `https://steamcommunity.com/id/<user>?xml=1`,
  parses `<onlineState>`/`<gameName>`, and decides whether to start Cookie Clicker
  (`steam://rungameid/1454400`) or stop it. Uses a `nextStartGame` marker file to
  defer a restart by one cycle.
- `chromerdp-clicker-minimalize.ps1` / `minimalize-steam.ps1`: window management via
  `user32.dll` (`Add-Type` P/Invoke). Windows-only.
- `checkInGame.bat`: batch wrapper that loops the PowerShell script.

## Coding conventions

- Language: PowerShell and Batch. Match the existing indentation and naming.
- Code comments: Japanese. Add/update a docstring-style comment for functions and
  complex logic.
- Error/log messages: English. When an existing message starts with an emoji, follow
  that style.
- Insert a half-width space between Japanese and alphanumeric characters.
- Commits: Conventional Commits (`<type>(<scope>): <description>`), description in
  Japanese. Branches: Conventional Branch short form (`feat`, `fix`, ...).

## Testing

No automated tests and no test framework. Verification requires a real Windows
environment with Steam and Cookie Clicker installed; behavior is confirmed by
running the scripts and observing process/window state.

## Repository-specific notes

- `$steam_username` at the top of `checkInGame.ps1` is the Steam Community vanity URL
  id (the `<id>` in `steamcommunity.com/id/<id>`), not the Steam login name. It is
  environment/owner-specific.
- `checkInGame.bat` self-updates via `git pull` on every loop, so committed changes to
  the scripts take effect on the VM without manual redeploy.
- Because the batch file loops forever with its own `timeout` interval, schedule it to
  start only once (e.g. Task Scheduler "at logon, once" or a startup shortcut).
  A recurring trigger would spawn duplicate loops.
- Windows-only: the window-management scripts depend on `user32.dll`.

## Security

- Do not commit credentials, API keys, or personal IDs beyond the existing
  `$steam_username` vanity id. Do not write secrets to logs.

## Documentation update rules

Update this file and `README.md` when scripts are added/removed/renamed, the run
commands change, or the Task Scheduler / VM setup assumptions change.
