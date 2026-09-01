---
name: unslop-clip
description: >
  Take the current selection (read from the macOS clipboard) or, when the clipboard holds nothing
  from this session, the whole session dialogue; clean it with unslop-text; save a Markdown file;
  put the file plus its text on the clipboard, ready to paste into Slack or anywhere else.
disable-model-invocation: true
model: sonnet
compatibility: macOS only (pbpaste, pbcopy, osascript).
---

# unslop-clip

Turn session output into a clean Markdown file and load the clipboard so the user can paste it
straight into Slack or any other app. The deliverable is the clipboard; the file is a bonus copy.

## Step 1 — pick the source

Read the clipboard first:

```bash
pbpaste
```

Then decide:

- **Selection mode** — the clipboard text comes from this session. Terminal copies are mangled
  (re-wrapped lines, `⏺` bullets, box-drawing characters, status-line fragments), so compare
  loosely: ignore whitespace, line breaks, and terminal decorations when matching the clipboard
  against the conversation. A match against your own replies or the user's messages counts.
- **Dialogue mode** — the clipboard is empty or its content does not come from this session
  (stale copy from elsewhere). Use the whole session dialogue: every user message and every
  visible Claude reply, in order.

The user can force a mode with an argument: `clip` forces selection mode (use the clipboard text
even if it doesn't match the session), `all` or `session` forces dialogue mode. An argument that
is an existing directory path overrides the save location instead (see Step 4); arguments combine.

## Step 2 — rebuild clean Markdown

- **Selection mode**: don't paste the mangled terminal text into the file. You have the original
  in context — locate the region the clipboard corresponds to and reproduce its original Markdown
  (headings, lists, fenced code blocks) exactly as you wrote it. If the text genuinely isn't in
  context (forced `clip` mode with foreign text), use the clipboard text as-is, only stripping
  obvious terminal artifacts.
- **Dialogue mode**: format as a transcript. Label each turn in bold — `**User:**` and
  `**Claude:**` (Russian dialogue: `**Пользователь:**` / `**Claude:**`), blank line between turns. Skip
  tool calls, tool output, and system noise; keep only what a human said and what Claude visibly
  answered. Exclude the message that invoked this skill and everything after it.

Keep the language of the source. Do not summarize or shorten — the user is sharing the content
itself, not a digest of it.

## Step 3 — unslop

Invoke the `unslop-text` skill (Skill tool) and apply its rules to the draft.

- In selection mode, unslop the whole text.
- In dialogue mode, unslop only the **Claude** turns. The user's messages are quoted speech —
  rewriting them would falsify the record. Leave them verbatim, typos included.

Fenced code blocks stay untouched either way; unslop-text targets prose.

## Step 4 — save the file

Resolve the target directory (first hit wins):

```bash
dir="${UNSLOP_CLIP_DIR:-$(defaults read com.apple.screencapture location 2>/dev/null || true)}"
dir="${dir/#\~/$HOME}"
dir="${dir:-$HOME/Desktop}"
```

1. A directory path passed as a skill argument.
2. `$UNSLOP_CLIP_DIR` (the user's personal override).
3. The macOS screenshot location (`com.apple.screencapture location`).
4. `~/Desktop` (where screenshots go by default).

Name the file `claude-<slug>-<YYYYMMDD-HHMM>.md`, where `<slug>` is a 2–4 word kebab-case topic in
the language of the content — the filename is what Slack shows when the file is attached, so make
it say what's inside (e.g. `claude-nginx-timeout-fix-20260901-1745.md`).

Write the unslopped Markdown there with the Write tool.

## Step 5 — load the clipboard

```bash
<skill-dir>/scripts/copy_to_clipboard.sh "<file>"
```

The script puts the **file** on the clipboard first, then the **text** — two entries on purpose:
the user runs a clipboard-history manager and picks which one to paste. Final clipboard state is
the text, so a plain Cmd+V pastes text into Slack; the file entry one step back in history pastes
as an attachment.

## Step 6 — report

One short confirmation: which mode ran (selection or full dialogue), the file path, and a reminder
that the clipboard holds the text with the file one step back in history. If dialogue mode ran
because the clipboard content didn't look like it came from this session, say so — the user may
have meant to copy something first.
