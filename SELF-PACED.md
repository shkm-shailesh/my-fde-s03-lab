# Self-paced: L3, L4 and the handover (about 60 minutes)

Finish L1 and L2 first (`bash grade.sh l1` and `bash grade.sh l2` both green).
Work in your codespace. In Colab you can do L3; do L4 in a codespace.

## L3 Observability (20 min)

**Why:** the CISO's rule is that every decision has an audit trail, and no account numbers reach the logs.
A `print()` line can't be searched, joined or trusted. One JSON line per request can.

**See it fail first (1 min):** run `python triage_prototype.py | head -2` from the lab folder. Look at the first
line: the full account number, no request ID, nothing a machine can search. At the end of L3, compare it with
your own JSON line.

1. **L3.1 `mask()`** in `app/logging_setup.py`: replace each `EB-` + 10 digits with `EB-******` + the last 4.
   Use `ACCOUNT_RE.sub(...)`.
2. **L3.2 `JsonFormatter.format()`**: build a dict with `ts` (UTC, ISO 8601), `level`, `msg`, plus every
   name in `FIELDS` that's present on the record (`hasattr(record, name)`). Return `mask(json.dumps(entry))`.
   Masking the whole line means no field can leak.
3. **L3.3 middleware** in `app/main.py`, under the TODO. Add `@app.middleware("http")` with an async function that:
   - takes the request ID from the `X-Request-ID` header, or makes one (`uuid.uuid4().hex[:12]`)
   - sets `request.state.log = {}`, notes the start time, and calls `response = await call_next(request)`
   - adds `X-Request-ID` to the response headers
   - logs one line: `logger.info("request", extra={"request_id": ..., "route": request.url.path,
     "status": response.status_code, "latency_ms": ..., **request.state.log})`
4. **L3.4** in `triage()`: before returning, set `request.state.log` to `model` (`llm.model`),
   `prompt_version` (`PROMPT_VERSION`), `outcome` (`"human_review"` or `"routed"`) and
   `complaint_excerpt` (the first 80 characters of the text).
5. Call `setup_logging()` once, near the top of `app/main.py` (after `llm = get_llm()`).

Check: `bash grade.sh l3`. Then run the service and watch the terminal while you call `/triage` from `/docs`.

## L4a Git (15 min)

**Why:** at a customer you work in *their* repo, under *their* review rules. Small branches and clear PRs
are how you earn merge rights.

```bash
git switch -c feat/triage-service
cp .env.example .env            # local settings; must never be committed
echo ".env" >> .gitignore       # now git ignores it
git status                      # .env must NOT be listed
git add app/ .gitignore         # stage deliberately: never `git add -A` with untracked files around
git commit -m "feat: triage service with contract, timeout and JSON logs"
git push -u origin feat/triage-service
```

Then open a pull request on GitHub (into your own copy's `main`). Fill in the template.
Check: `bash grade.sh l4` (the Git part).

## L4b Docker (15 min)

**Why:** the platform team runs containers, not scripts. They'll check the base image, the user, secrets and health.

**See it fail first (2 min):** build the starter Dockerfile as it is, and look at it the way the platform team will:

```bash
docker build -t s03-before .
docker history --no-trunc s03-before | grep SERVICE_API_KEY   # the key is readable in the image
docker run --rm s03-before id -u                              # 0 means it runs as root
```

Fix the five TODOs in `Dockerfile`:

1. `FROM public.ecr.aws/docker/library/python:3.12.15-slim-bookworm` (pinned to a patch version, slim, and mirrored on
   ECR Public, which avoids Docker Hub's anonymous limit of 100 pulls per 6 hours)
2. Delete the `ENV SERVICE_API_KEY=...` line. Secrets go in at run time: `docker run -e LLM_API_KEY=...`
3. Copy only what's needed: `COPY requirements.txt .`, `RUN pip install --no-cache-dir -r requirements.txt`,
   `COPY app ./app`. Create `.dockerignore` with at least `.env`, `.git`, `__pycache__/`
4. `RUN useradd --create-home --uid 10001 appuser` then `USER appuser`
5. `HEALTHCHECK --interval=5s --timeout=3s --start-period=5s CMD python -c "import urllib.request as u; u.urlopen('http://127.0.0.1:8000/healthz', timeout=2)"`
   (without `--interval`, Docker waits 30 s before the first check)

```bash
docker build -t s03-triage .
docker run --rm -p 8000:8000 s03-triage          # in another terminal: curl localhost:8000/healthz
docker history --no-trunc s03-triage | head      # no keys in here
docker image ls s03-triage                       # note the size: the full python:3.12 image is several times larger
```

Check: `bash grade.sh l4`.

## Handover (10 min)

Fill in `HANDOVER.md`: half a page for the Sr. Platform Engineer. Then:

```bash
bash grade.sh all
git add Dockerfile .dockerignore HANDOVER.md && git commit -m "docs: handover note" && git push
```

Clean up: `docker system prune -f`, stop your codespace, and delete it once you've finished.
