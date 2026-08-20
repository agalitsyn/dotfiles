---
name: unslop-comments
description: >
  Remove comment slop from generated code and maintain the comments that remain. Deletes narration,
  signature echoes, section banners, chat residue and "just in case" hedging; compresses bloated
  comments to the load-bearing clause; corrects comments that have drifted out of sync with the code
  and deletes ones describing code that no longer exists. Operates on the whole merge request by
  default — every change on this branch since it left the default branch, committed or not — and
  edits in place. Use this skill whenever the user complains about too many comments, AI-generated
  or LLM-written comments, comment noise, obvious or useless comments, bloated docstrings, or stale
  and outdated comments, and whenever they ask to unslop, de-slop, prune or tidy comments — also
  when they ask for comment cleanup on a branch, MR or PR without using the word "slop" at all.
  This skill fires only when the user wants comments *changed*: for a read-only audit of whether
  comments are still accurate, or a comment-rot report, use `comment-analyzer` instead. It never
  restructures executable code — that is `/simplify`.
when_to_use: >
  Trigger on: unslop, unslop-comments, de-slop, comment slop, too many comments, excessive comments,
  remove comments, strip comments, clean up comments, prune comments, comment noise, comment
  hygiene, obvious comments, useless comments, redundant comments, narrating comments, AI comments,
  LLM comments, generated comments, stale comments, outdated comments, obsolete comments, comment
  rot, misleading comment, bloated docstring, trim docstrings, tighten godoc, shorten comments,
  condense comments, make this look hand-written, clean up before MR, tidy the branch before review.
  Do NOT trigger for read-only comment audits or accuracy reports — that is `comment-analyzer`.
---

# Unslop comments

Generated code carries far more comments than a human would write, and the excess is not harmless:
every comment is a claim a future reader will trust and a future editor must keep true. The goal is
not fewer characters but **a comment set where every remaining line carries knowledge the code
cannot, and each one is currently true.** Two jobs, one pass: cut the slop, then maintain the rest.

This pass touches comments only — executable code stays byte-for-byte identical, which is what
makes it safe to apply without confirmation and keeps `git blame` on the logic intact. If a comment
is only redundant because the code beneath it is convoluted, note it in the report and leave the
code alone; restructuring is `/simplify`'s job.

## Step 1 — Establish the scope

The unit of work is the merge request: everything this branch has changed since it diverged from
the default branch, whether committed or still in the working tree.

This block is the safety interlock on a pass that edits without asking, so it refuses rather than
guesses. Getting the base branch wrong does not produce a slightly-off diff — it aims comment
deletion at files this branch never touched, and the report then lists them as cleaned.

```sh
resolve_scope() {
  base=""
  ref=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null) || ref=""
  # A cached origin/HEAD keeps pointing at the old name forever after a default-branch rename,
  # and `git fetch --prune` does not correct it. Verify before trusting it, and only pay for a
  # network round trip when it is actually stale.
  if [ -n "$ref" ] && ! git rev-parse --verify --quiet "$ref^{commit}" >/dev/null; then
    git remote set-head origin --auto >/dev/null 2>&1
    ref=$(git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>/dev/null) || ref=""
  fi
  if [ -n "$ref" ] && git rev-parse --verify --quiet "$ref^{commit}" >/dev/null; then
    base=$ref
  else
    n=0; cands=""
    for c in origin/main origin/master origin/develop origin/trunk; do
      git rev-parse --verify --quiet "$c^{commit}" >/dev/null && { n=$((n+1)); cands="$cands $c"; base=$c; }
    done
    [ "$n" -eq 1 ] || {
      echo "SCOPE ERROR: cannot determine the base branch (candidates:${cands:- none})." >&2
      echo "  Ask the user which branch this MR targets. Edit nothing." >&2
      return 1
    }
    echo "SCOPE WARN: origin/HEAD was unusable; assuming $base." >&2
  fi

  mb=$(git merge-base HEAD "$base") || {
    echo "SCOPE ERROR: no merge base between HEAD and $base — unrelated histories, or a shallow" >&2
    echo "  clone (try git fetch --unshallow). Ask for an explicit base. Edit nothing." >&2
    return 1
  }

  echo "SCOPE: base=$base@$(git rev-parse --short "$base") merge-base=$(git rev-parse --short "$mb")"
  { git diff --stat "$mb" && git diff "$mb"; } || return 1
  git ls-files --others --exclude-standard | grep . &&
    echo "SCOPE NOTE: the files above are untracked, so they are absent from the diff." >&2
  return 0
}
resolve_scope
```

**Never fall back to a local branch name.** `git symbolic-ref` does not verify that its target
exists, so on any clone made before a `master` → `main` rename the cached ref resolves to a branch
the remote no longer has. Falling through to the stale local `master` turns a one-file MR into a
nine-file one — exit 0, no warning, and eight of those files belong to other people. Refusing and
asking which branch the MR targets costs five seconds and is always the better trade.

**Do not wrap this in `set -euo pipefail`.** `pipefail` propagates a failing `git symbolic-ref`
through the pipeline and kills the block before it prints anything at all, which reads exactly like
"no changes on this branch".

`git diff "$mb"` with no `--cached` and no `HEAD` compares the **working tree** to the merge base,
so committed and uncommitted changes arrive together. It does *not* list untracked files, which is
why the block reports those separately: a freshly generated file is the densest slop there is and
is invisible to every `git diff`. Untracked files come into scope only after you say so explicitly.

When `HEAD` is the default branch the merge base is the remote tip, so unpushed commits are still
covered — no special case needed.

If the user named a path or file, treat that as an explicit widening: the whole file is in scope and
the branch-adjacency rule below does not apply.

Read the full current contents of each file you intend to edit, not just the diff hunks. Judging
whether a comment is redundant requires seeing the code it describes, and judging whether a comment
has gone stale requires seeing code the diff may not include.

**Scope the edits to what this branch touched.** A file that the branch modified is in scope, but
prefer comments in or adjacent to the branch's own changes; do not sweep unrelated legacy comments
out of a file you happened to touch. Unrelated churn buries the real change and invites reviewers
to reject the whole thing.

Before editing, check the size of what you are about to change. If the scope exceeds roughly twenty
files, summarise the plan and ask before proceeding — an unreviewable diff defeats the purpose. And
if the files you are about to edit already have uncommitted changes, say so in the report: your
edits will interleave with the user's own in the same unstaged hunks, so they lose selective revert.
Suggesting they commit first costs nothing.

## Step 2 — Classify every comment

Apply one question to each comment:

> Could a competent reader, fluent in this language and looking at this code, derive this?

If yes, it is slop — delete it. If no, it carries knowledge, and the job becomes keeping it accurate
and brief.

### Delete

- **Narration** — restates the next statement. `// Loop over the users`, `// Increment the counter`.
- **Signature echo** — a doc comment whose body is the parameter list and return type in prose,
  adding no constraint the types don't already state.
- **Section banners** — `// ---- Helpers ----`, `// === Types ===`, `// Step 1:`. These substitute
  prose structure for real structure; if a file needs signposting, that argues for splitting it.
  (Long shell scripts are the one exception — shell has weaker structural tools — but a banner over
  three lines is still slop.)
- **Chat residue** — comments addressed to whoever requested the change rather than whoever will
  read the code: `// Added validation as requested`, `// Now handles the error properly`, `// NOTE:
  this is the fix`. They describe an edit, not the code, and git history already records edits.
- **Bare hedging** — `// Just in case`, `// Defensive check`, `// This should never happen` with no
  reason attached. But a hedge that names the invariant or where it is enforced is a keeper:
  `// unreachable: Tier is validated at the API boundary` above a `panic` tells the next reader why
  the branch exists and where to look if it ever fires. Delete the empty ones, keep the ones with a
  because.
- **Restated names** — `// userID is the ID of the user`, `// Config holds configuration`.
- **Standard-library tutorials** — `// json.Marshal converts the struct to JSON`.

### Report, don't delete

**Bare TODOs and FIXMEs** — no owner, no ticket. A generator's `// TODO: add error handling` is
slop, but you cannot tell it apart from the user's own note by looking at the file, and silently
deleting someone's open loop destroys information nobody will notice is missing. List them in the
report and let the user decide. TODOs *with* an owner or ticket reference stay untouched.

### Keep

- **Rationale** — why this and not the obvious alternative. `// Retry 3×: upstream returns 502
  during its deploy window (INFRA-2231).` The highest-value class, because the reason exists nowhere
  in the code and its absence invites someone to "fix" the code back to broken.
- **Business rules and invariants** not derivable from the code. `// Settlement cutoff is 16:00 CET
  — regulatory, not configurable.`
- **Contracts the signature cannot express** — caller must hold the lock; must be called before
  `Close`; returns `nil, nil` when not found; mutates its argument; not safe for concurrent use.
- **Deliberate weirdness** — a workaround for an upstream bug, a deviation from convention, a
  performance-motivated ugliness. Keep the link.
- **Pointers outward** — RFC, spec section, ticket, algorithm name, design doc.
- **Directives** — comment-shaped things with compile-time or tool-time meaning. Recognise them by
  the rule at the top of `languages.md` rather than by memory, and note that *re-spacing* or
  *reordering* one disables it just as surely as deleting it. Attached reason text is part of the
  directive, not commentary.
- **Licence and copyright headers** — legal, not editorial.
- **Doc comments on exported API** — contract, not narration: what a caller reads instead of the
  implementation. Keep them and tighten to the contract — cut the signature restatement and the
  padding, keep what the caller cannot see. Compression has a floor; see `languages.md` for the
  per-language conventions, including Go's requirement that the comment open with the identifier's
  own name and the trap that tightening to a bare `Deprecated:` line reads as no comment at all.

## Step 3 — Maintain what remains

Comments are part of the code and carry the same upkeep duty. Three failure modes to fix rather than
tolerate:

**Drift** — the comment describes behaviour the code no longer has. Rewrite it to match the code,
and **flag the divergence in the report** with both readings. You cannot tell from inside this pass
whether the comment recorded the original intent and the code is the bug; a silently "corrected"
comment converts a possible defect into blessed behaviour, destroying the last witness to what was
meant. Rewriting *and* flagging keeps the code honest and preserves the signal.

**Obsolescence** — refers to a removed function, an old identifier name, a finished migration, a
flag that no longer exists, or is a "temporary" note whose occasion has passed. Delete it, and
update references to renamed identifiers rather than leaving a dangling name.

**Sprawl** — right, but said in five lines. Compress to the load-bearing clause: drop hedging
("it's worth noting that", "basically"), drop restatement, keep the fact. Stop short of cryptic —
a comment that needs decoding has traded one cost for another.

Write the replacement using only facts you can verify in the code in front of you. A tightened
comment that asserts a plausible-sounding contract — a retry window, a rounding rule, an error the
function does not raise — is worse than the bloat it replaced, because callers act on it. If the
interesting facts are not visible, the honest rewrite is the short one.

Match the file's existing idiom: comment style, position, sentences versus fragments, **and
language** — a Russian comment stays Russian when compressed. The result should read as though the
file's author wrote it.

## Step 4 — Verify before reporting

The no-confirmation guarantee rests on "only comments changed", so confirm it rather than assuming
it. Re-read your own diff and check that every added and removed line is comment syntax. Then, per
language:

- **Go** — `gofmt -l` on the touched files. gofmt reformats doc-comment structure since 1.19, so a
  hand-shaped comment can fail a `gofmt -l`/`gofumpt` gate even with no executable change.
- **Python** — parse each edited file (`python -c "import ast,sys; ast.parse(open(sys.argv[1]).read())" FILE`).
  Deleting a docstring that is a function's entire body is an `IndentationError`, and that shape is
  common in one-line private helpers and `Protocol` stubs.
- **TypeScript** — if the project has a typecheck script, run it; `@ts-expect-error` becomes an
  error when the line below it stops failing, so a directive you thought was inert may not be.

If verification fails, fix it before reporting. Reporting a clean pass you did not verify is the one
failure mode that destroys trust in every future run.

## Step 5 — Report

Apply the edits, then report. The report is what makes an unsupervised destructive pass reviewable,
so lead with anything needing a human. Three buckets, used consistently in both the header and the
per-file lines: **removed** (deleted outright), **tightened** (kept but compressed, including
signature echoes trimmed out of a doc comment), **corrected** (drift and obsolescence fixed).

```
## Unslopped {N} files ({removed} removed, {tightened} tightened, {corrected} corrected)

### Needs your eyes
- path/to/poll.go:12 — comment documented 5s intervals with a 3-attempt cap; the code polls every
  30s and exits only on a terminal status or ctx being done. Rewrote to match the code. If the cap
  was the intent, its absence is the bug.
- path/to/other.py:8 — bare TODO from a migration that looks finished. Delete?

### Noted, not changed
- path/to/big.go:120 — the comment is only redundant because the function is 200 lines; kept it.
- path/to/old.ts:44 — commented-out implementation block. Dead code, not commentary; left alone.

### Per file
- path/to/file.go — 11 removed (narration, banners), 2 doc comments tightened
- path/to/other.py — 4 removed, 1 corrected after a rename
```

Line numbers are **post-edit** — deleting comments shifts everything below, so re-read the file
before writing the report rather than citing remembered positions. Omit an empty heading entirely
rather than writing "none"; a heading that is usually empty stops being read. Never report a comment
as removed that you did not remove, and never round the counts — the user reads this instead of the
diff.

## Never touch

These are unconditional, not language-specific advice:

- **Generated files** — see `languages.md` for the exact marker and glob list. Edits are lost on
  regeneration and the marker itself is matched by other tools.
- **Already-applied migrations** — some tools verify their checksum, and applied migrations are
  history.
- **Doctest bodies** (`>>>` blocks) and any comment block a code generator parses as input — a cgo
  preamble, a `// swagger:*`-annotated block. These are code and spec, not commentary.
- **Docstrings that are user-facing behaviour** — Click/Typer command help, FastAPI route
  descriptions.
- **Comment-shaped things that aren't comments** — string literals, `#` in YAML values, comments in
  fixtures and golden files whose bytes are asserted on.
- **Executable code** — no renames, no reordering, no "while I'm here" fixes.
- **Comments you are not changing** — do not re-wrap or reflow them for consistency. Gratuitous
  reformatting inflates the diff and hides the real edits.

## When in doubt, keep and tighten

The two errors are not symmetric. A surviving weak comment costs a reader two seconds and anyone can
delete it later. A deleted comment that held the only record of a business rule or a hard-won
workaround is gone — nobody reviewing the diff can see what is missing, and the next person
re-derives it the hard way or reintroduces the bug. So bias hard toward deletion where you can prove
the code already says it, and toward tightening whenever the comment might carry knowledge from
outside the file.

## Reference files

- `languages.md` — the directive-recognition rule, per-language doc conventions, generated-file
  markers, and the exact-form hazards that make a directive silently stop working. Read it before
  editing Go, TypeScript or Python; the traps it lists are not the kind you notice by being fluent.
- `examples.md` — before/after pairs and the borderline calls. Read when calibrating how aggressive
  to be.
