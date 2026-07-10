# GitHub Copilot code review instructions

Guidance for reviewing pull requests in this repository.

## What this repository is

PowerShell/Batch scripts that keep the Steam version of Cookie Clicker running on a
dedicated Windows VM (auto start/stop around other games, window minimization). No
build system, package manager, or test framework.

## Conventions to enforce

- Commit messages follow Conventional Commits; descriptions are in Japanese.
- Code comments are in Japanese; log/error messages are in English.
- Insert a half-width space between Japanese and alphanumeric characters in comments
  and documentation.
- Match the existing indentation and naming style; do not reformat unrelated code.

## Review focus

- Process handling in `checkInGame.ps1`: `Stop-Process` / `Start-Process` calls should
  keep the graceful-then-force pattern and the retry/timeout counters. Flag changes that
  could leave Cookie Clicker or Steam in a stuck state or spin without an exit bound.
- Steam XML parsing: `<onlineState>` / `<gameName>` are matched by regex against
  `steamcommunity.com/id/<user>?xml=1`. Flag assumptions that break when a field is
  absent (e.g. `$Matches` used without a successful match).
- The `nextStartGame` marker file drives the deferred-restart logic; flag changes that
  create or remove it inconsistently.
- Window scripts use `user32.dll` P/Invoke and are Windows-only. Flag anything assuming
  a cross-platform runtime.
- Secrets: flag any newly hardcoded credential, API key, or personal ID.

## Known patterns — do NOT flag

- `$steam_username = "book000"` is the owner's public Steam vanity URL id, not a leaked
  secret.
- Absence of unit tests / a CI test job is expected for this repository.
- `checkInGame.bat` intentionally runs an infinite loop with `git pull` and `timeout`.
