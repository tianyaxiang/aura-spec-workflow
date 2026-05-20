# Changelog

All notable changes to this project are documented here. Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); this project follows [Semantic Versioning](https://semver.org/).

## [0.3.0] — 2026-05-20

### Added
- `LICENSE` file (MIT) — README already stated MIT but the file was missing.
- `CHANGELOG.md` (this file).
- `SessionStart` scanner now surfaces a **second section** for specs that exist but have no actionable tasks:
  - `⚠ <name> — tasks.md missing` when the spec dir has no `tasks.md`.
  - `⚠ <name> — no tasks defined yet` when `tasks.md` has neither `[ ]` nor `[x]`.
  - Helps new users notice they scaffolded a spec but never filled it. Fully-done specs (all `[x]`) remain silent to avoid noise.

### Changed
- Scanner output is now two-sectioned (active + missing-tasks) when both apply.

## [0.2.0] — 2026-05-20

### Added
- `SessionStart` hook output now ends with a **behavioral convention** instructing Claude to auto-flip `[ ]` to `[x]` in `tasks.md` after completing a task, without waiting to be asked. For partial progress, leave `[ ]` and append a brief note.
- README EN/CN: new mental-model section, 4-role table, 7-step workflow table, end-to-end walkthrough (with concrete prompts), 4 day-to-day patterns, prompt cheat sheet, troubleshooting.

### Changed
- Scanner footer line replaced from generic "Open tasks.md to update" to the auto-flip convention.

## [0.1.0] — 2026-05-20

### Added
- Initial release. Marketplace + plugin co-located in one repo (`tianyaxiang/aura-spec-workflow`).
- `SessionStart` hook (`startup|resume|clear|compact`) that scans `docs/specs/*/tasks.md` and surfaces active specs with `done/total` counts and the next unchecked task.
- `/aura-spec-workflow:spec <name>` skill that scaffolds `docs/specs/<name>/{requirements,design,tasks}.md` from templates.
- `/aura-spec-workflow:spec-status` skill that prints the same scan output on demand.
- Three templates (`requirements.md`, `design.md`, `tasks.md`).
- `bin/spec-status.sh` scanner, with silent-exit behavior when no specs exist.
- Bilingual README (EN + 中文).

[0.3.0]: https://github.com/tianyaxiang/aura-spec-workflow/releases/tag/v0.3.0
[0.2.0]: https://github.com/tianyaxiang/aura-spec-workflow/releases/tag/v0.2.0
[0.1.0]: https://github.com/tianyaxiang/aura-spec-workflow/releases/tag/v0.1.0
