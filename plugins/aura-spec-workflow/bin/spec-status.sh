#!/usr/bin/env bash
# Scans $CLAUDE_PROJECT_DIR/docs/specs/*/tasks.md and prints a one-block summary.
# Three categories per spec:
#   - active     — has at least one "[ ]" → list with progress + next item
#   - empty      — spec dir exists but tasks.md missing OR has no [ ]/[x] → warn
#   - complete   — all items [x] → silent (don't spam after shipping)
# Silent exit when nothing in active or empty.
set -u

proj="${CLAUDE_PROJECT_DIR:-$PWD}"
specs_dir="$proj/docs/specs"
[ -d "$specs_dir" ] || exit 0

active_lines=()
empty_lines=()

for spec_dir in "$specs_dir"/*/; do
  [ -d "$spec_dir" ] || continue
  name=$(basename "$spec_dir")
  tasks="$spec_dir/tasks.md"

  if [ ! -f "$tasks" ]; then
    empty_lines+=("  ⚠ $name — tasks.md missing")
    continue
  fi

  todo=$(grep -cE '^[[:space:]]*-[[:space:]]*\[ \]' "$tasks" 2>/dev/null || true)
  done_=$(grep -cE '^[[:space:]]*-[[:space:]]*\[[xX]\]' "$tasks" 2>/dev/null || true)
  todo=${todo:-0}
  done_=${done_:-0}
  total=$((todo + done_))

  if [ "$total" -eq 0 ]; then
    empty_lines+=("  ⚠ $name — no tasks defined yet")
    continue
  fi
  if [ "$todo" -eq 0 ]; then
    # all done — silent
    continue
  fi
  next=$(grep -m 1 -E '^[[:space:]]*-[[:space:]]*\[ \]' "$tasks" \
         | sed -E 's/^[[:space:]]*-[[:space:]]*\[ \][[:space:]]*//' | cut -c1-70)
  active_lines+=("  • $name  ($done_/$total done)  next: $next")
done

[ ${#active_lines[@]} -eq 0 ] && [ ${#empty_lines[@]} -eq 0 ] && exit 0

if [ ${#active_lines[@]} -gt 0 ]; then
  echo "📋 Active SPECs in this repo:"
  printf '%s\n' "${active_lines[@]}"
fi

if [ ${#empty_lines[@]} -gt 0 ]; then
  [ ${#active_lines[@]} -gt 0 ] && echo ""
  echo "Specs missing tasks (fill requirements → design → tasks before working):"
  printf '%s\n' "${empty_lines[@]}"
fi

echo ""
echo "Convention: after completing a task, use Edit to flip its \`[ ]\` to \`[x]\` in tasks.md — do not wait to be told. For partial progress, leave \`[ ]\` and append a brief note. Run /aura-spec-workflow:spec-status anytime."
exit 0
