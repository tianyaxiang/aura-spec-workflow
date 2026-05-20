---
description: Scaffold a SPEC (requirements/design/tasks) at docs/specs/<name>/. Use when user types "/aura-spec-workflow:spec <name>" or asks to start a new SPEC.
---

# Scaffold a new SPEC for "$ARGUMENTS"

You will create a three-file SPEC at `docs/specs/$ARGUMENTS/`.

Steps:

1. **Validate the name.** `$ARGUMENTS` should be kebab-case (lowercase letters, digits, hyphens). If empty or invalid, ask the user for a name and stop.
2. **Check for existing spec.** If `docs/specs/$ARGUMENTS/` already exists, abort and tell the user the path; do not overwrite.
3. **Create the directory.** `mkdir -p docs/specs/$ARGUMENTS`.
4. **Copy the three templates verbatim** from the plugin install dir:
   - `${CLAUDE_PLUGIN_ROOT}/templates/requirements.md` → `docs/specs/$ARGUMENTS/requirements.md`
   - `${CLAUDE_PLUGIN_ROOT}/templates/design.md`       → `docs/specs/$ARGUMENTS/design.md`
   - `${CLAUDE_PLUGIN_ROOT}/templates/tasks.md`        → `docs/specs/$ARGUMENTS/tasks.md`

   Use `cp` via Bash. Do not re-render the templates.
5. **Report back.** Tell the user the three paths you created and the recommended fill order: requirements → design → tasks. Mention they can run `/aura-spec-workflow:spec-status` anytime to see progress.

Do NOT pre-fill any content beyond the template. The user owns the spec content.
