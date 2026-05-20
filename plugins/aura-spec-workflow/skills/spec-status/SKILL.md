---
description: Print active SPECs in this repo and their progress (counts unchecked vs checked tasks). Use when user asks for spec status, what's in progress, or "where were we".
---

# Show SPEC status

Run the scanner via Bash:

```
"${CLAUDE_PLUGIN_ROOT}"/bin/spec-status.sh
```

- If it prints output, relay it verbatim to the user.
- If output is empty (exit 0, no stdout), say: "No active SPECs in `docs/specs/`. Use `/aura-spec-workflow:spec <name>` to start one."

Do not editorialize or summarize — the scanner output is the authoritative status.
