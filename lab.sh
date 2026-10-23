#!/usr/bin/env bash
# Session 3 lab runner. Every step is one command; nothing to type into the code.
#   bash lab.sh l1 fail | show | apply | pass | try      (L1 Contract)
#   bash lab.sh reset l1                                  (put the TODO version back, e.g. for the assignment)
set -euo pipefail
cd "$(dirname "$0")"
PY=${PY:-python}
hdr() { printf '\n\033[1m━━━ L1 Contract · %s ━━━\033[0m\n%s\n\n' "$1" "$2"; }

case "${1:-}:${2:-}" in
  l1:fail)  hdr "step 1 · SEE IT FAIL" "Objective: model output is untrusted input. Deck: slide 12."
            "$PY" lab/l1/fail.py ;;
  l1:show)  hdr "step 3 · READ THE FIX" "Objective: see exactly what Pydantic adds. Deck: slides 13-14."
            cat lab/l1/explain.txt ;;
  l1:apply) hdr "step 4 · APPLY THE FIX" "Copies the finished contract into app/models.py (your TODO version is kept in lab/l1/models_start.py)."
            cp lab/l1/models_done.py app/models.py
            echo "  ✅ app/models.py now has the contract. Next: bash grade.sh l1" ;;
  l1:pass)  hdr "step 5 · SEE IT PASS" "Objective: the same bad replies, now caught. Deck: slide 14 (bottom line)."
            "$PY" lab/l1/pass.py ;;
  l1:try)   hdr "step 6 · TRY IT" "Objective: read Pydantic's error types. Predict first. Deck: slide 16."
            "$PY" lab/l1/try.py ;;
  reset:l1) cp lab/l1/models_start.py app/models.py
            echo "  ↩️  app/models.py is back to the TODO version (for the write-it-yourself assignment)." ;;
  *) sed -n '2,5p' "$0"; exit 1 ;;
esac
