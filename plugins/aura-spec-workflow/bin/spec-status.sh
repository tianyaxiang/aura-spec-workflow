#!/usr/bin/env bash
# Scans $CLAUDE_PROJECT_DIR/docs/specs/*/tasks.md and prints a one-block summary
# of specs that still have unchecked items. Stays silent when nothing is active.
set -u

proj="${CLAUDE_PROJECT_DIR:-$PWD}"
specs_dir="$proj/docs/specs"
[ -d "$specs_dir" ] || exit 0

lines=()
for spec_dir in "$specs_dir"/*/; do
  [ -d "$spec_dir" ] || continue
  tasks="$spec_dir/tasks.md"
  [ -f "$tasks" ] || continue
  name=$(basename "$spec_dir")
  todo=$(grep -cE '^[[:space:]]*-[[:space:]]*\[ \]' "$tasks" 2>/dev/null || true)
  done_=$(grep -cE '^[[:space:]]*-[[:space:]]*\[[xX]\]' "$tasks" 2>/dev/null || true)
  todo=${todo:-0}
  done_=${done_:-0}
  total=$((todo + done_))
  [ "$total" -eq 0 ] && continue
  [ "$todo" -eq 0 ] && continue
  next=$(grep -m 1 -E '^[[:space:]]*-[[:space:]]*\[ \]' "$tasks" \
         | sed -E 's/^[[:space:]]*-[[:space:]]*\[ \][[:space:]]*//' | cut -c1-70)
  lines+=("  • $name  ($done_/$total done)  next: $next")
done

[ ${#lines[@]} -eq 0 ] && exit 0
echo "📋 Active SPECs in this repo:"
printf '%s\n' "${lines[@]}"
echo ""
echo "Open docs/specs/<name>/tasks.md to update. Run /aura-spec-workflow:spec-status anytime."
exit 0
