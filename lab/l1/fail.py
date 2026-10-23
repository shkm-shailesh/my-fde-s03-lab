"""L1 · step 1: see it fail. The prototype trusts whatever the model says."""
import json
import pathlib
import sys

sys.path.insert(0, str(pathlib.Path(__file__).parent))

TEAM_QUEUES = {"disputes": "Q-DISPUTES", "fraud_ops": "Q-FRAUD", "digital_support": "Q-DIGITAL", "branch_services": "Q-BRANCH"}

from replies import REPLIES  # noqa: E402

print("The prototype's logic: json.loads(reply), then route on reply['team'] (unknown team -> Q-GENERAL)\n")
for complaint, raw in REPLIES.items():
    try:
        out = json.loads(raw)
        queue = TEAM_QUEUES.get(out.get("team"), "Q-GENERAL")
        print(f"  {complaint:<45} -> {queue:<10} priority={out['priority']!r}")
    except Exception as e:
        print(f"  {complaint:<45} -> CRASH  {type(e).__name__}")
print("""
What went wrong:
  C-013  the model wrote "fraud ops" (space) instead of fraud_ops, so a fraud complaint went to the GENERAL queue.
         Priority is the word "urgent", not a number. Nothing failed loudly: this is the dangerous one.
  C-014  no team at all, so it also went to the general queue.
  C-015  prose before the JSON, so json.loads crashed.
""")
