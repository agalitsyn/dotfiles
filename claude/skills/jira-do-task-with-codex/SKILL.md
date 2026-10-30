---
name: jira-do-task-with-codex
description: 'Start work on a Jira ticket as a Claude + Codex pair in its own git worktree and a new agterm session: a tab named "<KEY>: <summary>" in the current workspace, Codex in the right pane of a vertical split, and Claude in the left pane told to read the ticket, plan the work and do it together with Codex. Use when the user runs /jira-do-task-with-codex <jira-url>, or asks to take a ticket, open a task or start a ticket "with codex" in a new tab, session or worktree ("возьми DL-7288 с codex", "открой задачу в новом табе с codex", "заведи сессию под тикет"). Not for planning the ticket in this session, and not for creating or estimating tickets.'
argument-hint: <jira-url> [--close-session=false]
allowed-tools: Bash
---

# Do a Jira task with Codex

This session only sets the stage. The work happens in a new agterm session: Claude on the left
gets the prompt and runs the task, Codex on the right is its peer through the `peer-chat` skill.
Each ticket gets its own git worktree, so several tickets of one repository run side by side
without touching the main checkout or each other.

Write everything you print here (the report, the questions, the failure explanations) in the
language the user writes to you in. If they write in Russian, answer in Russian, even though this
file and the script's messages are in English. Script errors and pane text go in as is; your
explanation around them follows the user's language.

## Run

The argument is the ticket URL, for example `https://gfoundation.atlassian.net/browse/DL-7288`. If
the user gave only a key like `DL-7288`, build the URL as
`https://gfoundation.atlassian.net/browse/<KEY>`. No argument at all: ask for the ticket and stop.

`--close-session` is optional and `true` by default: once the new session is up, this session (the
one the skill was called from) is closed, because its only job was to start the other one.
`--close-session=false` keeps it open, and so does the user saying in words not to close it ("не
закрывай эту сессию").

Run the bundled script from the user's current working directory. The worktree is made from the
repository that directory belongs to, so it must be the repository the ticket is about. If it is
clearly not (for example the dotfiles repo for a ticket whose summary starts with a service name
like `ms-hooks:`), ask before running.

```bash
<skill-base-dir>/scripts/open-task.sh '<jira-url>'
```

The script:

1. reads the ticket summary with `acli jira workitem view <KEY> --fields summary`;
2. fetches origin's default branch (`main` or `master`) and creates the worktree
   `<repo>/.claude/worktrees/<KEY>` on a new branch `<KEY>` from `origin/<default>`, because a task
   branch starts only from a fresh default branch; gitignored files listed in the repository's
   `.worktreeinclude` (such as `.env`) are copied in; the main checkout's branch and files are left
   alone;
3. marks the repository root as trusted in Claude Code (`~/.claude/trust-repos.sh`, which sets
   `hasTrustDialogAccepted` in `~/.claude.json` when it is missing), because interactive
   `claude --worktree` exits at once in a repository whose trust dialog was never accepted; the
   user trusts all their work repositories and asked for this; `~/.codex/trust-repos.sh` does the
   same for Codex in `~/.codex/config.toml`, whose trust prompt would otherwise stop it;
4. creates a session right after this one, named `<KEY>: <summary>`, rooted in the worktree;
5. splits it vertically and starts `codex` in the worktree in the right pane;
6. once Codex is running, starts `claude --worktree <KEY>` in the left pane with the prompt
   `Прочти тикет <url>. Составь план выполнения задачи. Работай вместе с codex.`; Claude opens the
   worktree the script made instead of creating its own;
7. selects the new session and prints its id and the worktree path.

Codex goes first because "Работай вместе с codex" makes the new Claude reach for `peer-chat`
straight away, and `peer-chat` refuses when the other pane has no Codex in it.

When the worktree or the branch `<KEY>` already exists, the script opens it as it is and says so on
stderr: that is a ticket being resumed, and its branch keeps whatever work it has. Pass that on to
the user.

## After it runs

Report in one line: the session name, the worktree path, and that Claude and Codex are running in
it. Do not start working on the ticket here, and do not type anything else into the new session's
panes.

Then, unless `--close-session=false`, close this session as the very last step:

```bash
agtermctl session close --target "$AGTERM_SESSION_ID" --socket "$AGTERM_SOCKET"
```

Close it only after the script succeeded and the report line is written: the close ends this
Claude process and everything else in this session's panes, so nothing after it runs. If the
script failed in any way, keep the session open, because the error and what to do about it are
here.

## When it fails

- `not inside an agterm session`: this needs agterm. Say so and stop.
- `not a git repository`, `cannot find origin's main or master branch`, or a failed `git fetch` /
  `git worktree add`: no session was created. Show the error and stop. A worktree add that fails
  because the branch is checked out in another worktree is for the user to sort out; do not remove
  worktrees or branches to get past it.
- `acli` errors: show the error. An auth failure is fixed by the user with `! acli jira auth login`.
- `timed out ... codex in the right pane` or `... claude in the left pane`: the session and the
  worktree exist but an agent did not start. Read the pane with
  `agtermctl session text --target <id> --pane right --socket "$AGTERM_SOCKET"` (or `--pane left`)
  and report what is on screen. A trust prompt, an update prompt or a login screen is for the user
  to answer; never answer it for them. Do not rerun the script on top of a half-built session,
  because it would create a second tab.
- Anything else from `agtermctl`: load the `agterm:agterm` skill to diagnose before touching the
  session by hand.
