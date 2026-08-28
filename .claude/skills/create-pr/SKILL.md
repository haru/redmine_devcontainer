---
name: create-pr
description: Create a GitHub pull request from develop to main with an English Conventional Commit title and an English bulleted list of the main changes as the body. Use this skill whenever the user wants to open, raise, or file a PR — including phrases like "PRを作って", "プルリク作成", "develop から main に PR", "open a PR", "release develop to main", or when they finish a batch of work on develop and ask what's next for shipping it. Also use it to update the title/body of an existing develop→main PR.
---

# Create a develop → main pull request

This skill turns the accumulated work on `develop` into a pull request against `main`
whose title and body a reviewer can understand without opening the diff.

The whole point is the *writing*: `gh pr create` is one command, but a PR titled
"Update files" is worthless. Spend your effort on reading the diff and describing
what actually changed and why.

## Workflow

### 1. Gather the facts before writing anything

Run these to see what the PR would contain. Do them in one batch — they're independent:

```bash
git fetch origin                                    # make sure main/develop refs are current
git status --short --branch                         # uncommitted work? branch ahead/behind?
git log origin/main..develop --oneline              # commits that this PR would introduce
git diff origin/main...develop --stat               # which files, how much churn
gh pr list --base main --head develop --state open  # is there already an open PR?
```

Then read the actual diff for the files that matter:

```bash
git diff origin/main...develop -- <path>
```

Note the three-dot `...` — it diffs against the merge base, so you see only what
`develop` added, not changes that landed on `main` separately. Two dots would show
`main`'s own commits as reversed changes and mislead you badly.

Read the real diff, not just commit messages. Commit messages are written mid-work
and often describe intent that later commits changed or reverted; the diff is what
the reviewer will actually merge. If the branch has 15 commits touching 4 files, the
PR describes those 4 files' net effect, not 15 bullet points.

### 2. Handle the situations that mean "don't create a PR yet"

- **No commits on `develop` beyond `main`** — there is nothing to open. Say so and stop.
- **Uncommitted or unpushed changes** — the PR would silently omit them. Report exactly
  what's outstanding and ask whether to include it, rather than opening a partial PR.
- **A PR is already open** — do not create a duplicate; `gh pr create` will fail anyway.
  Update it instead with `gh pr edit <number> --title ... --body ...` and tell the user
  you updated the existing PR rather than creating a new one.
- **Current branch isn't `develop`** — mention which branch you're on. The PR is still
  `develop → main` unless the user says otherwise; you don't need to check out `develop`
  to open it, since `--head develop` uses the remote branch.

Push `develop` before creating the PR if it's ahead of `origin/develop`:

```bash
git push origin develop
```

### 3. Write the title

English, Conventional Commit format, imperative mood, no trailing period, ≤72 characters.

```
<type>: <what changed, concretely>
```

Types that fit this repo: `feat`, `fix`, `docs`, `chore`, `refactor`, `ci`, `build`, `test`.
Pick the type from the dominant change, not the largest file count — a branch that adds
Ruby 4.0 support plus a README line is `feat`, not `docs`.

The title should summarize the *branch*, so when a branch does several unrelated things,
raise the altitude to whatever unifying statement is honest rather than picking one
change and hiding the rest:

**Good:**
- `feat: add Ruby 4.0 and Redmine 7.0 to the Docker build matrix`
- `ci: build multi-arch images on native runners instead of QEMU`
- `fix: keep .bashrc customizations when the image rebuilds`

**Bad, and why:**
- `Update Dockerfile` — names a file, not a change; tells the reviewer nothing
- `feat: various improvements` — "various" is a confession that you didn't read the diff
- `feat: add Ruby 4.0 support, update docs, and bump the Node version` — three changes
  crammed in; use a unifying summary like `feat: support Ruby 4.0 across the build matrix`

### 4. Write the body

A flat English bullet list of the **main** changes. No headings, no summary paragraph,
no test plan, no signature — the bullets are the entire body.

This is a highlights list, not an inventory. The reviewer is deciding whether to merge,
and a list that gives a comment tweak the same weight as a dropped platform buries the
thing they actually need to see. Exhaustive enumeration is what the diff is for.

Each bullet is one significant change, starting with a present-tense verb, naming the
file, version, flag, or setting involved so the reviewer can map it onto the diff:

```markdown
- Add Redmine 7.0 and Ruby 4.0 combinations to the supported version matrix
- Stop building 5.1-stable images, since its bullseye/bookworm bases are EOL
- Bump the bundled devcontainer defaults to Redmine 6.1-stable and Ruby 3.2
```

Aim for **3–6 bullets**. Beyond that you're almost certainly listing changes that don't
need listing.

**What earns a bullet:** anything that changes behavior, supported versions, defaults,
or the developer's workflow — and anything a reviewer would be surprised to discover in
the diff if it weren't mentioned.

**What to leave out:**
- Mechanical consequences of a bullet you already wrote. If you say the version matrix
  gained Redmine 7.0, the README table and the workflow matrix updating to match is
  implied — fold it into that bullet or drop it.
- Comments, formatting, whitespace, typo fixes, dead-code removal.
- Per-file or per-commit breakdowns of one logical change. Four files edited to add one
  version combination is *one* bullet.

When a small change genuinely matters, it still belongs — a one-line default that alters
what everyone's container builds is a main change even though it's a one-line diff.
Judge by consequence, not by diff size.

Keep bullets specific but not diff-shaped: `Bump the default Node version from 20 to 22`
is useful; `Change line 47 of Dockerfile` is not. Mention *why* only when the change
would look wrong or arbitrary without it — e.g. "Remove the Ruby 4.1 rows, since no
upstream image is published yet".

### 5. Create the PR

Use a heredoc for the body so newlines and backticks survive the shell intact:

```bash
gh pr create --base main --head develop \
  --title "feat: add Ruby 4.0 and Redmine 7.0 to the Docker build matrix" \
  --body "$(cat <<'EOF'
- Add Ruby 4.0 and Redmine 7.0 combinations to the supported version matrix
- Drop the Debian bullseye rows now that upstream images are gone
EOF
)"
```

Report the PR URL that `gh` prints back so the user can click through.

## Repository notes

This repo (`haru/redmine_devcontainer`) builds Docker devcontainer images for Redmine
plugin development. When summarizing changes here, the things reviewers care about are:

- **Version matrix changes** — name the Redmine/Ruby/Debian combinations added or removed.
  `docker/supported_versions.conf`, the matrix in `.github/workflows/release.yml`, and the
  README table all move together, so that's one bullet about the versions, not three about
  the files. Do check they were all updated, though — a missing one is worth flagging to
  the user even if it doesn't belong in the body.
- **Dockerfile changes** — name the tool or package involved, not just "update Dockerfile".
- **`dot_devcontainer/` changes** — these ship to plugin developers in `dot_devcontainer.tgz`,
  which CI does *not* rebuild. That's a real follow-up action rather than a formatting
  detail, so it earns a bullet when the branch touches those assets.
