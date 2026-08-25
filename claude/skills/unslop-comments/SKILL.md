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
  The target is comments inside source code: line and block comments, docstrings, godoc, JSDoc —
  text a compiler, interpreter or linter reads past. Never prose files; that is `unslop-text`.
  Bare "unslop", "de-slop", "slop", "AI slop", "расслопить", "убрать слоп" name no target and fit
  both skills; decide by the artifact in front of the user, not by the word. Source file, code
  branch, diff, or an MR/PR whose subject is the code → `unslop-comments`. Document, README, any
  Markdown or docs file, commit message, MR/PR *description*, email, chat message or prose draft →
  `unslop-text`; a fenced code block inside such a file does not move it. Both present, such as a
  code branch plus the MR description written for it → run both, one on each, and say which ran
  where. Neither identifiable → ask before editing. An explicitly typed slash command overrides all
  of this.
  Do NOT trigger for read-only comment audits or accuracy reports — that is `comment-analyzer`.
  Trigger on: unslop-comments, comment slop, too many comments, excessive comments, remove
  comments, strip comments, clean up comments, prune comments, comment noise, comment hygiene,
  obvious comments, useless comments, redundant comments, narrating comments, AI comments, LLM
  comments, generated comments, stale comments, outdated comments, obsolete comments, comment rot,
  misleading comment, bloated docstring, trim docstrings, tighten godoc, shorten comments, condense
  comments, make this code look hand-written, clean the comments up before the MR, tidy the branch
  before review. По-русски: почисти комментарии, убери комментарии, слишком много комментариев,
  лишние комментарии, комментарии как у нейросети, комментарии от нейросети, устаревшие
  комментарии, комментарий не соответствует коду, причеши комментарии перед МР.
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

## Step 1 — Get the comments, not the code

The unit of work is the merge request: everything this branch has changed since it diverged from the
default branch, committed or still in the working tree. Reading that diff, or the files themselves,
is the slow way in — executable code is most of the bytes and none of the job.

```sh
~/.claude/skills/unslop-comments/scripts/unslop.sh scan
```

The script resolves the base branch, then prints comment lines only, from the ranges this branch
touched:

```
SCOPE: base=origin/main@a1b2c3d merge-base=e4f5a6b
=== internal/api/user.go [go] lines 2-22
     5| // ---- User handling ----
     9| 	// Validate the input
    11| 		return nil, ErrInvalidID // return early   <TRAILING>
    17| 	//go:noinline   <DIRECTIVE>
    18| 	// TODO: add error handling   <TODO>
TOTALS: 18 comment lines in 2 files
```

Tags mark what needs care rather than deciding for you: `<TRAILING>` is a comment after code on the
same line, `<DIRECTIVE>` matched the recognition rule in `languages.md`, `<TODO>` and `<LICENCE>`
are the report-don't-delete classes. Absence of a tag proves nothing — a directive the rule misses
still behaves like one.

Flags: `-c N` widens the window around each changed hunk (default 3 lines). Passing paths, or
`--all`, takes whole files instead of hunk windows — that is what a user naming a file means, and
it turns off the branch-adjacency rule below. Untracked files are listed but never scanned; a
freshly generated file is the densest slop there is and is invisible to every `git diff`, so it
comes into scope only when the user says so, by naming it as a path.

Scan also snapshots every file it lists under `.git/unslop-snapshot`, which is what `check` and
`restore` compare against later. Run it before editing anything.

**Where the script refuses, ask — do not guess.** A wrong base branch does not produce a
slightly-off diff; it aims comment deletion at files this branch never touched, and the report then
lists them as cleaned. Cached `origin/HEAD` refs survive a default-branch rename and `git fetch
--prune` does not correct them, so the script verifies the ref, re-resolves it once, and refuses
when several plausible bases exist. Falling back to a local branch name is never the answer.

Generated files, `vendor/`, `node_modules/`, `dist/`, `*/testdata/` and migrations are skipped and
listed under `SKIPPED:`. Edits there are lost on regeneration, and applied migrations are history
some tools checksum.

**Read code only where the printed line does not decide itself.** Banners, narration and signature
echoes are decidable from the scan output alone. When you do need the code — judging drift, or
whether a doc comment still describes the function — pull the narrowest window that answers it:

```sh
sed -n '40,60p' internal/api/user.go
```

**Scope the edits to what this branch touched.** A file the branch modified is in scope, but prefer
comments in or adjacent to the branch's own changes; do not sweep unrelated legacy comments out of a
file you happened to touch. Unrelated churn buries the real change and invites reviewers to reject
the whole thing.

If the scan exceeds roughly twenty files, summarise the plan and ask before proceeding — an
unreviewable diff defeats the purpose. If the files you are about to edit already have uncommitted
changes, say so in the report: your edits will interleave with the user's own in the same unstaged
hunks, so they lose selective revert. Suggesting they commit first costs nothing.

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

## Step 4 — Apply the edits

Deletions go through one batched call, not one Edit per comment. Feed `path:lineno` lines, exactly
as the scan numbered them:

```sh
printf '%s\n' internal/api/user.go:5 internal/api/user.go:9 svc.py:11 |
  ~/.claude/skills/unslop-comments/scripts/unslop.sh prune
```

`prune` re-checks that every target line is still a comment in that file's language and refuses the
whole file if one is not, so a stale line number cannot delete code. Whole-line comments are
deleted; a `<TRAILING>` line is stripped back to the code and its trailing whitespace; a comment
removed from between two blank lines takes one blank with it. It echoes every change — `-` deleted,
`~` stripped — and that echo is your removal record for the report. Add `--dry-run` to see the echo
without writing.

Line numbers shift as soon as a file is written, so build the whole plan for a file from one scan,
send it in one call, and re-scan before citing any number again.

Rewrites — tightening and drift corrections — are the minority and stay manual: edit them one at a
time with the Edit tool. Do them after the prune for a file, working from a fresh
scan of it.

`unslop.sh restore` puts every scanned file back the way it was, at any point.

## Step 5 — Verify before reporting

The no-confirmation guarantee rests on "only comments changed", so prove it rather than assuming it:

```sh
~/.claude/skills/unslop-comments/scripts/unslop.sh check
```

It strips every comment from the snapshot and from the current file and compares what is left, so
any executable line that moved, changed or vanished shows up as a `CHECK FAIL` with a diff. Then,
per language:

- **Go** — `gofmt -l` on the touched files. gofmt reformats doc-comment structure since 1.19, so a
  hand-shaped comment can fail a `gofmt -l`/`gofumpt` gate even with no executable change.
- **Python** — parse each edited file (`python -c "import ast,sys; ast.parse(open(sys.argv[1]).read())" FILE`).
  Deleting a docstring that is a function's entire body is an `IndentationError`, and that shape is
  common in one-line private helpers and `Protocol` stubs.
- **TypeScript** — if the project has a typecheck script, run it; `@ts-expect-error` becomes an
  error when the line below it stops failing, so a directive you thought was inert may not be.

`check` does not catch a deletion that breaks the parse — a Python docstring that was a function's
entire body leaves valid-looking code and an `IndentationError` — which is why the per-language
checks stay. If verification fails, fix it before reporting, or `restore` and start over. Reporting
a clean pass you did not verify is the one failure mode that destroys trust in every future run.

## Step 6 — Report

The report is what makes an unsupervised destructive pass reviewable,
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

Line numbers for anything that still exists are **post-edit**: re-run `scan` after the last edit and
cite from that, never from remembered positions. For removed comments, cite the file and quote the
comment — a post-edit line number for a deleted line points at whatever moved up into it. Omit an empty heading entirely
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

- `scripts/unslop.sh` — `scan` (comment-only view of the branch, plus the snapshot), `prune`
  (validated batch deletion), `check` (proves only comments changed), `restore` (undo). Lives at
  `~/.claude/skills/unslop-comments/scripts/unslop.sh`; run it from the repository root. Needs only
  git and awk.
- `languages.md` — the directive-recognition rule, per-language doc conventions, generated-file
  markers, and the exact-form hazards that make a directive silently stop working. Read it before
  editing Go, TypeScript or Python; the traps it lists are not the kind you notice by being fluent.
- `examples.md` — before/after pairs and the borderline calls. Read when calibrating how aggressive
  to be.
