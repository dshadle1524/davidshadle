# Prompt: Wire up GitHub → Control Plane CI/CD

Paste this into a Claude Code session in the target project's repo.

---

I want to set up CI/CD deployment for this project: GitHub Actions should build a
Docker image on every push to `master` (or specify your branch) and deploy it to
Control Plane (cpln), the same way it's done on the `davidshadle-v4` project. Please
follow this exact process — it encodes fixes for real failures hit last time, so
don't deviate from the parts marked "must."

## 0. Reconnaissance first

- Confirm a Dockerfile exists for this app (multi-stage, produces a small runtime
  image). If missing, write one before touching CI.
- Run `cpln profile get` to confirm I'm already authenticated and see the org name.
- Run `cpln gvc get` and `cpln workload get --gvc <name>` to check whether a GVC/
  workload for this app already exists in Control Plane. If it does, reuse it —
  don't create a duplicate. If not, tell me and we'll create one (`cpln gvc create`,
  `cpln workload create`) before wiring CI to it.
- Note the workload's container `name` (from `cpln workload get <name> --gvc <gvc> -o
  yaml`, under `spec.containers[].name`) — the workflow needs it for
  `spec.containers.<name>.image`.

## 1. Service account (must: scoped, not superuser)

Create a dedicated CI service account rather than reusing my personal token:

```
cpln serviceaccount create --name <project>-ci --desc "GitHub Actions CI/CD for <project>"
```

Grant it exactly two things, nothing broader:

- `manage` on **all images** in the org (every CI build pushes a new tag, i.e. a new
  image resource, so this can't be scoped to one image name upfront):
  ```
  cpln policy create --name <project>-ci-image --target-kind image --all
  cpln policy add-binding <project>-ci-image --permission manage --serviceaccount <project>-ci
  ```
- `edit` on **just the one workload** being deployed (set gvc context via
  `CPLN_GVC=<gvc>` env var on the `policy create` call — the `--gvc` flag doesn't
  exist on `policy create`, this is the only way to scope `--resource <workload>`
  correctly):
  ```
  CPLN_GVC=<gvc> cpln policy create --name <project>-ci-workload --target-kind workload --resource <workload>
  cpln policy add-binding <project>-ci-workload --permission edit --serviceaccount <project>-ci
  ```

Generate the key last, right before storing it — treat the value as a secret from
the moment it's printed:

```
cpln serviceaccount add-key <project>-ci --desc "github-actions"
```

## 2. Store the token as a GitHub secret (must: don't paste it in chat)

Use `gh secret set` to write it directly rather than showing me the raw token and
asking me to paste it into GitHub's UI. Two account gotchas from last time:

- If `gh secret set` fails with a 403 about repo permissions, it's almost certainly
  because the active `gh` account doesn't own/have admin on this repo. **Do not**
  run `gh auth switch` to fix this — that changes my global active account as a
  side effect I have to notice and undo. Instead scope it to one command:
  ```
  GH_TOKEN=$(gh auth token --user <correct-account>) gh secret set CPLN_TOKEN --repo <owner>/<repo> --body "<token>"
  ```
- Verify immediately after with `gh secret list --repo <owner>/<repo>`, and confirm
  `gh auth status` still shows my original active account.

If the CI token value ever ends up printed in a chat transcript (it will, at least
once, since `serviceaccount add-key` prints it to stdout) — after storing it, rotate
it: `add-key` a replacement, update the GitHub secret to the new value, then
`serviceaccount remove-key <ref> --key <old-key-name>` to invalidate the exposed one.

## 3. The workflow file (must: exact package name, must: env vars not flags)

Two specific failures happened last time that look like success until you check the
actual deployed state:

1. **`npm install -g cpln` installs the wrong package.** The real CLI is published
   as `@controlplane/cli` — `cpln` on the npm registry is an unrelated placeholder
   that happens to print its own ASCII banner via `figlet`, which looks enough like
   real cpln output in CI logs that the job reports green while every `cpln`
   subcommand is silently a no-op. Always install `@controlplane/cli`.

2. **`--token`/`--org` CLI flags don't reach the docker-credential-cpln subprocess.**
   `cpln image build --push` shells out to `docker buildx build`, which — on push —
   spawns `docker-credential-cpln` as a separate child process to fetch registry
   credentials. That child inherits environment variables, not the CLI flags given
   to the parent `cpln` invocation. Passing `--token "$TOKEN"` on each `cpln`
   command builds and even logs in "successfully," but the actual `docker push`
   fails with `no profile defined` / `error getting credentials`. Fix: set
   `CPLN_TOKEN` and `CPLN_ORG` as **job-level `env:`**, not as flags.

Template — adjust names, branch, paths, and the workload's container name:

```yaml
name: Deploy <app> to Control Plane

on:
  push:
    branches: [master]
    paths:
      - "<app-subdir>/**"
      - ".github/workflows/<this-file>.yml"

jobs:
  deploy:
    runs-on: ubuntu-latest
    env:
      CPLN_ORG: <org>
      CPLN_TOKEN: ${{ secrets.CPLN_TOKEN }}
    steps:
      - uses: actions/checkout@v4

      - name: Install cpln CLI
        run: npm install -g @controlplane/cli

      - name: Docker login to Control Plane registry
        run: cpln image docker-login

      - name: Build and push image
        working-directory: <app-subdir>
        run: |
          TAG="${GITHUB_SHA::7}"
          cpln image build \
            --name "<image-name>:${TAG}" \
            --dockerfile Dockerfile \
            --dir . \
            --push

      - name: Point workload at the new image
        run: |
          TAG="${GITHUB_SHA::7}"
          cpln workload update <workload-name> \
            --gvc <gvc-name> \
            --set spec.containers.<container-name>.image="/org/<org>/image/<image-name>:${TAG}"
```

## 4. Verify — don't trust a green checkmark alone

A workflow can report success while doing nothing (that's exactly what happened
twice last time). After the first real run:

- `cpln workload get <workload> --gvc <gvc> -o yaml | grep image:` — confirm the
  image tag matches the commit's short SHA that triggered the run, not a stale tag.
- Actually curl or open the live endpoint and check for a change you know is in that
  commit (e.g. `grep -c "some-string-you-just-removed"` should be 0).
- Read the *actual* step logs (`gh run view <id> --log`), not just the checkmarks —
  specifically confirm the "Build and push image" step shows real `docker buildx`
  layer output (multi-second `RUN npm ci` / `npm run build` lines), not just a
  banner and an instant transition to the next step.

## 5. Confirm before creating standing access or pushing

Service-account creation, policy/permission grants, key generation, and the push
that makes the workflow live are all things to summarize and get a yes on before
running — don't chain them silently just because the overall task was approved
up front.
