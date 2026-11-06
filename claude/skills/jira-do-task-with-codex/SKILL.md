---
name: jira-do-task-with-codex
description: 'Start work on a Jira ticket as a Claude + Codex pair in its own git worktree and a new agterm session: a tab named "<KEY>: <summary>" in the current workspace, Codex in the right pane of a vertical split, and Claude in the left pane told to read the ticket, plan the work and do it together with Codex. When the plan was already made in this session, hands it over instead: the new session opens as a companion of this one and its Claude executes that plan rather than planning again. Use when the user runs /jira-do-task-with-codex <jira-url>, or asks to take a ticket, open a task or start a ticket "with codex" in a new tab, session or worktree ("возьми DL-7288 с codex", "открой задачу в новом табе с codex", "заведи сессию под тикет"), and when a ticket planned here has to be implemented in another repository. Not for planning the ticket in this session, and not for creating or estimating tickets.'
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

### Which repository

The worktree is made from the repository `--repo DIR` names, or the current working directory's
when it is left out. Decide it from the ticket before running, never by default from the cwd: a
summary like `admin-gateway: …` or the code paths in the description name the service. Look for it
under `~/src/work/delos/` and `~/src/work/delos/archive/`. When the cwd's repository is that one,
`--repo` can be left out. When it is not, pass `--repo` with the right one. When the ticket names no
repository, or names several, ask the user which one.

Pass `--repo` rather than `cd` into the repository: a session isolated in a worktree refuses commands
that run git elsewhere, and the script's own `git -C` is the path that works from there.

### A plan made in this session

When this session already read the ticket and agreed a plan with the user (and Codex), do not let
the new session plan again. Write the plan to a file (the scratchpad is fine) and pass `--plan FILE`.
Make the file self-contained: the decisions the user took, the facts checked, file:line references,
what is still blocked. The new Claude gets only this file and the ticket, not this conversation.

With `--plan`, the script:

- copies the plan to `~/.claude/plans/<KEY>.md`, because this session's scratchpad goes away with it;
- opens the new session as a companion of this one (`session new --parent`), so planning and
  execution sit together in the sidebar tree, instead of as a sibling after it;
- starts Claude with a prompt to read that plan and carry it out with Codex, not to plan the ticket
  again.

A companion closes when its parent closes. So with `--plan` this session is never closed by the
skill, whatever `--close-session` says: closing it would kill the session just started.

```bash
<skill-base-dir>/scripts/open-task.sh '<jira-url>' [--repo DIR] [--plan FILE]
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
4. creates a session named `<KEY>: <summary>`, rooted in the worktree: right after this one, or as
   its companion with `--plan`;
5. splits it vertically and starts `codex` in the worktree in the right pane;
6. once Codex is running, starts `claude --worktree <KEY>` in the left pane with the prompt
   `Прочти тикет <url>. Составь план выполнения задачи. Работай вместе с codex.`, or with `--plan`
   a prompt to execute the plan at `~/.claude/plans/<KEY>.md`; Claude opens the worktree the script
   made instead of creating its own;
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

With `--plan`, add the plan's path to the report and stop there: this session stays open as the
parent. Otherwise, unless `--close-session=false`, close this session as the very last step:

```bash
agtermctl session close --target "$AGTERM_SESSION_ID" --socket "$AGTERM_SOCKET"
```

Close it only after the script succeeded and the report line is written: the close ends this
Claude process and everything else in this session's panes, so nothing after it runs. If the
script failed in any way, keep the session open, because the error and what to do about it are
here.

## When it fails

- `not inside an agterm session`: this needs agterm. Say so and stop.
- `plan file missing or empty` or `not a directory`: nothing was created. Fix the argument and run
  again.
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
