# aura-spec-workflow

A Claude Code plugin that adds a Kiro-style SPEC workflow (requirements / design / tasks) with **auto-surface on session start**. The point is: a new Claude session can pick up where the last one left off without you having to remind it.

English · [中文](./README_zh.md)

## What it does

- **`SessionStart` hook** scans `docs/specs/*/tasks.md` in your project and prints active SPECs (with `done/total` counts and the next unchecked task) into Claude's context — every session, automatically.
- **`/aura-spec-workflow:spec <name>`** scaffolds a fresh SPEC: `docs/specs/<name>/{requirements.md, design.md, tasks.md}`.
- **`/aura-spec-workflow:spec-status`** prints the same status summary on demand.

The hook stays silent when there is no `docs/specs/` directory or no active specs, so it never gets in the way on unrelated projects.

## Install

```shell
/plugin marketplace add tianyaxiang/aura-spec-workflow
/plugin install aura-spec-workflow@aura-spec-workflow
/reload-plugins
```

Or from a local clone:

```shell
/plugin marketplace add ~/IdeaProjects/aura-spec-workflow
/plugin install aura-spec-workflow@aura-spec-workflow
/reload-plugins
```

## Usage

1. **Start a SPEC.** In any project:
   ```
   /aura-spec-workflow:spec watchlist-extension
   ```
   Creates `docs/specs/watchlist-extension/{requirements,design,tasks}.md` from templates.

2. **Fill in the three files** in order: requirements → design → tasks. Tasks use GitHub-style checkboxes:
   ```markdown
   - [ ] 1. Add display_name fallback in render_premarket
   - [x] 2. Update push_log kind comment
   ```

3. **Open a new Claude session** in the same repo. The hook fires and Claude sees:
   ```
   📋 Active SPECs in this repo:
     • watchlist-extension  (1/2 done)  next: 1. Add display_name fallback in render_premarket
   ```
   No need to re-explain. Claude already knows what's pending.

4. **Update status** as you go. Mark `[x]` when done. The scanner re-reads on next session.

## Conventions

- One SPEC per feature or bugfix. Keep specs small enough to finish in days, not weeks.
- Task IDs are stable. **Never renumber.** Add new tasks at the end.
- The scanner counts only `[ ]` (todo) and `[x]` (done). `[~]` for "in progress" is allowed as a local marker but not counted.
- Tasks should be self-contained — a future session reading just `tasks.md` should understand what to do.

## Files

```
.claude-plugin/marketplace.json
plugins/aura-spec-workflow/
├── .claude-plugin/plugin.json
├── hooks/hooks.json
├── bin/spec-status.sh
├── skills/spec/SKILL.md
├── skills/spec-status/SKILL.md
└── templates/{requirements,design,tasks}.md
```

## Develop locally

```shell
claude --plugin-dir ~/IdeaProjects/aura-spec-workflow/plugins/aura-spec-workflow
# then in the session:
/reload-plugins
```

Make changes → `/reload-plugins` → test again.

## License

MIT.
