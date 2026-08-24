# David Shadle Website v4

Replacement for davidshadle.com. An Effortless Rulebook (ERB) project: site
content (bio variants, how-I-work sections, proof/work entries, resume
content) is modeled as rulebook data and generated into Postgres, rather than
hardcoded into page templates. See `CLAUDE.md` for the full methodology
rules.

This is **setup only** — no visual design yet. That's the next phase.

## Stack

- **Content/data:** `effortless-rulebook/effortless-rulebook.json` (hand-authored, no Airtable/Excel input)
- **Database:** Postgres 16, running in Docker locally
- **App:** Next.js (App Router) in `web/`, reading the generated `vw_*` views directly via `pg`
- **Deploy target:** local for now; Control Plane (cpln) later, not yet configured

## Local dev

```bash
./start.sh          # starts Postgres (Docker), then the Next.js dev server on :8731
./start.sh db        # (re)runs postgres/init-db.sh against the running container
./start.sh build      # runs `effortless build` (regenerates rulebook output + re-inits DB)
```

App: http://localhost:8731
Health/DB check: http://localhost:8731/api/health

Postgres runs in Docker (`docker-compose.yml`), exposed on `localhost:5732`
(5432 was already taken by another local project). There's no native
Postgres/psql install on this machine — `bin/psql` is a thin wrapper that
proxies `psql` calls to the running container, used by `postgres/init-db.sh`
and `effortless build`.

## Content source

The source documents this rulebook was authored from live at the project
root:

- `David_Shadle_Content_Strategy_v1.md` — positioning, voice, site structure (Sections 9-11)
- `David_Shadle_Bio_Set_v1.md`
- `David_Shadle_How_I_Work_v1.md`
- `David_Shadle_Resume_Variants_v1.md`

## Open items (not blocking this phase, but will block Phase 2 design)

Carried over from Content Strategy Section 8:

1. Whether Banyan screenshots (portal, dashboards) can be shown on the Work page — permission not yet confirmed.
2. Whether the materials-discovery (Vortent) client can be named, or stays category-only like the medical device client.
3. The `CurrentlyText` field in `SiteSettings` is a placeholder — needs real, current copy before launch.
4. Which 2-3 `ProofPoints` are "featured on Work page" is a first-pass pick (PM Portal, Experience layer, Project brief) — confirm with David.
