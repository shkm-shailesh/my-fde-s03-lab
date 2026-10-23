# Session 3 lab: Python & Production Engineering

**From prototype to a service the platform team will run.**

**AI Forward Deployed Engineering · IIT Delhi × Varsity · Session 3 · Sat 24 Oct 2026**

Example Bank (fictional) has a complaint-triage prototype, `triage_prototype.py`. It works on a laptop.
The Head of Retail Ops wants it live; the Sr. Platform Engineer won't run a script; the CISO wants an
audit trail with no account numbers in the logs. You'll turn it into a typed, logged, containerised service.

| Rung | When | You build | Check |
|---|---|---|---|
| **L1 Contract** | Live lab | Pydantic models; bad model output goes to a human | `bash grade.sh l1` |
| **L2 Service** | Live lab | FastAPI `/triage` (async, with a timeout) and `/healthz` | `bash grade.sh l2` |
| **L3 Observability** | Self-paced | One JSON log line per request, request ID, masked account numbers | `bash grade.sh l3` |
| **L4 Ship** | Self-paced | Git branch + PR; a Dockerfile the platform team would accept | `bash grade.sh l4` |
| **Handover** | Self-paced | `HANDOVER.md`, half a page for the Sr. Platform Engineer | `bash grade.sh handover` |

**Live lab:** follow `lab/L1.md` (more rungs are coming). Every step is one command (`bash lab.sh …`); you write no code during the session.

No API key is needed: an offline stub model answers by default. Everything here is fictional (the bank,
customers, accounts and teams). Never paste real customer data into this lab.

## Option A (recommended): GitHub Codespaces

Everything works here, including Git and Docker. Nothing to install on your laptop.

1. Sign in to GitHub (a free account is fine).
2. Create **your own copy** of this repository (**Use this template** → **Create a new repository**), so you can push branches and open PRs.
3. In your copy: **Code** → **Codespaces** → **Create codespace on main**. The first start can take a few minutes.
4. In the terminal: `bash check_setup.sh`. You should see **All good. You are ready for the session.**

During the lab, run the service with `uvicorn app.main:app --reload --port 8000`, open the **Ports** tab, and
click the globe icon on port 8000. Add `/docs` to the URL. Keep the port **Private** (the default).

Free allowance: GitHub Free includes 120 core-hours a month. A 2-core codespace uses 2 per hour, so you get
about 60 hours. **Stop** your codespace after each session (github.com/codespaces → ⋯ → Stop) and delete it
when you've finished the self-paced work.

## Option B (fallback): Google Colab

Use this if GitHub or Codespaces is blocked on your laptop (common on company laptops), or your codespace
won't start. Colab covers **L1, L2 and L3**. It can't run Git or Docker, so watch the L4 demo in class and do
L4 later in a codespace.

1. Open `colab/s03_lab.ipynb` from this repo in Colab (File → Open notebook → GitHub, or upload it).
2. Runtime → Run all. Edit the cells marked **YOUR CODE**, then re-run the check cell below each one.

Colab's runtime storage is temporary: File → Save a copy in Drive.

## Optional: a real model

Add a secret named `GEMINI_API_KEY` (Codespaces: github.com/settings/codespaces → Secrets; Colab: the 🔑 panel).
A free key is at https://aistudio.google.com/apikey. On free tiers, providers may use your prompts to improve
their products: use only the fictional data here. The grader always uses the offline stub.

## Files

| Path | What |
|---|---|
| `triage_prototype.py` | The "before". Run it: `python triage_prototype.py` |
| `app/models.py` | L1: the contract |
| `app/main.py` | L2: the service; L3: request logging |
| `app/logging_setup.py` | L3: JSON logs and masking |
| `app/llm.py` | The model client (offline stub + optional live model). No changes needed |
| `tests/` | What the grader checks |
| `Dockerfile` | L4b: works, but the platform team would refuse it. Fix it |
| `SELF-PACED.md` | Step-by-step guide for L3, L4 and the handover |
| `GLOSSARY.md` | One-page glossary for L1/L2/L3/L4 and lab terms |
| `HANDOVER.md` | Your handover note (template) |

## Stuck?

- `ModuleNotFoundError`: run `pip install -r requirements.txt`.
- Port 8000 already in use: stop the other `uvicorn` (Ctrl+C), or use `--port 8001`.
- `docker` not found in a codespace: Ctrl/Cmd + Shift + P → **Codespaces: Full Rebuild Container**.
- Company laptop blocks github.com: use Option B, or a personal device.
- Still stuck: post in the session chat with the exact error.
