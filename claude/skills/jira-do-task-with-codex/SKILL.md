---
name: jira-do-task-with-codex
description: 'Start work on a Jira ticket as a Claude + Codex pair in its own git worktree and a new agterm session: a tab named "<KEY> [<repo>]: <summary>" in the current workspace (one per repository when the ticket spans several, and one per part when a ticket split into layers or steps here is to be done in parallel, each in its own worktree and each told to do only its own part), Codex in the right pane of a vertical split, and Claude in the left pane told to read the ticket, plan the work and do it together with Codex. Every new session opens as a companion of the calling one, which stays open as the main session. When the plan was already made in this session, hands it over instead: the new Claude executes that plan rather than planning again. Use when the user runs /jira-do-task-with-codex <jira-url>, or asks to take a ticket, open a task or start a ticket "with codex" in a new tab, session or worktree ("возьми DL-7288 с codex", "открой задачу в новом табе с codex", "заведи сессию под тикет"), when a ticket planned here has to be implemented in another repository, and when the remaining parts of a ticket planned here are to be handed to parallel sessions ("запусти сессии на оставшиеся слои", "одна сессия — один слой", "раздай слои компаньонам"). Not for planning the ticket in this session, and not for creating or estimating tickets.'
argument-hint: <jira-url>
allowed-tools: Bash
---

# Do a Jira task with Codex

This session only sets the stage and stays open as the main one. The work happens in a new agterm
session opened as its companion: Claude on the left gets the prompt and runs the task, Codex on the
right is its peer through the `peer-chat` skill. Several tickets started from here all sit under
this session in the sidebar.
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

### Which repository

The worktree is made from the repository `--repo DIR` names, or the current working directory's
when it is left out. Decide it from the ticket before running, never by default from the cwd: a
summary like `admin-gateway: …` or the code paths in the description name the service. Look for it
under `~/src/work/` and its subdirectories. When the cwd's repository is that one,
`--repo` can be left out. When it is not, pass `--repo` with the right one. When the ticket names no
repository, ask the user which one. When it names several, ask which of them to open (`multiSelect`):
one or several.

Pass `--repo` rather than `cd` into the repository: a session isolated in a worktree refuses commands
that run git elsewhere, and the script's own `git -C` is the path that works from there.

### A ticket over several repositories

Run the script once per chosen repository: each run makes its own worktree, branch `<KEY>` and
session. Every new Claude is told to work only on the part of the ticket that changes its own
repository, and to read the others' code only where it meets its part (contract, rollout order).
That alone keeps two sessions from researching the same thing, but the line between the parts is
often finer than "this repository", so pass `--scope TEXT` to each run: one or two sentences in
Russian on what this session does and what the other sessions do, taken from the ticket (its
`Changes:` line, the implementation and acceptance items that belong to the repository). For
DL-7289, for example, ms-fuse gets "бронирование входящего депозита из транзакции Fuse, а не из тела
вебхука; проверка источника Fuse — часть gateway-v2, её делает другая сессия". Do not pass `--scope`
when only one repository is opened and the ticket has no other part.

### A plan made in this session

When this session already read the ticket and agreed a plan with the user (and Codex), do not let
the new session plan again. Write the plan to a file (the scratchpad is fine) and pass `--plan FILE`.
Make the file self-contained: the decisions the user took, the facts checked, file:line references,
what is still blocked. The new Claude gets only this file and the ticket, not this conversation.

With `--plan`, the script:

- copies the plan to `~/.claude/plans/<KEY>-<repo>.md`, because this session's scratchpad goes away
  with it; the repository is in the name so the runs of one ticket over several repositories do not
  overwrite each other's plan;
- starts Claude with a prompt to read that plan and carry it out with Codex, not to plan the ticket
  again.

```bash
<skill-base-dir>/scripts/open-task.sh '<jira-url>' [--repo DIR] [--plan FILE] [--scope TEXT] [--name SUFFIX]
```

### A ticket split into parts in one repository

When this session split one ticket into independent parts (layers, steps, separate MRs) and the user
wants them done in parallel, one session per part, run the script once per part with
`--name SUFFIX`. Without it every run of the same ticket in the same repository lands in one
worktree `<KEY>`, on one branch, with one plan file, and the second session overwrites the first
one's plan and writes into its tree.

- `SUFFIX` is a short kebab-case slug of the part, `[a-z0-9-]`: `account-id`, `inbox`. The worktree,
  the branch and `claude --worktree` become `<KEY>-<SUFFIX>`, the plan file
  `~/.claude/plans/<KEY>-<SUFFIX>-<repo>.md`, and the session is named `<KEY> <SUFFIX> [<repo>]: …`.
- Give each part its own plan file with `--plan`, so every session executes rather than plans. Each plan holds only its own part: what to change with file:line,
  the decisions taken, the facts checked, and what the other parts do, so the session does not
  drift into them. Pass the same boundary as one line in `--scope`.
- End each plan with how the part is finished, since the new session gets nothing else from here.
  When the user asked for it, that is: commit, push, open the MR with `grothex:gitlab-mr-create`
  (the MR text in English), run `grothex:gitlab-mr-revmux` on it and fix what it finds before
  reporting back. Say whether to merge or to leave the MR for the user.
- A part in another repository needs no suffix: its worktree is `<KEY>` there. Use one anyway when
  the same ticket may get another part in that repository later.
- Parts that touch the same files will conflict when the second one merges. Say so in both plans,
  and tell the later one to rebase on `main` before its MR.

Each run is independent: when one fails, the others already started keep running. Report every
session in the result.

### From the quick terminal

agterm's quick terminal belongs to no session and no window: `AGTERM_SESSION_ID` and
`AGTERM_WINDOW_ID` are empty there. The script then takes the active window and places the new
session after the session selected in it. It cannot make a companion there, so the new session
opens after that one as a sibling, and the script says so on stderr.

The script:

1. reads the ticket summary with `acli jira workitem view <KEY> --fields summary`;
2. fetches origin's default branch (`main` or `master`) and creates the worktree
   `<repo>/.claude/worktrees/<KEY>` on a new branch `<KEY>` from `origin/<default>` (both
   `<KEY>-<SUFFIX>` with `--name`), because a task
   branch starts only from a fresh default branch; gitignored files listed in the repository's
   `.worktreeinclude` (such as `.env`) are copied in; the main checkout's branch and files are left
   alone;
3. marks the repository root as trusted in Claude Code (`~/.claude/trust-repos.sh`, which sets
   `hasTrustDialogAccepted` in `~/.claude.json` when it is missing), because interactive
   `claude --worktree` exits at once in a repository whose trust dialog was never accepted; the
   user trusts all their work repositories and asked for this; `~/.codex/trust-repos.sh` does the
   same for Codex in `~/.codex/config.toml`, whose trust prompt would otherwise stop it;
4. creates a session named `<KEY> [<repo>]: <summary>`, rooted in the worktree, as a companion of
   this one (`session new --parent`); when this session is itself a companion, agterm puts the new
   one under the same parent;
5. splits it vertically and starts Codex in the worktree in the right pane with
   `-a never -s workspace-write -c sandbox_workspace_write.network_access=true`: no approval
   prompts, writes confined to the worktree; network is on because peer-chat reaches agterm
   through its socket, which the sandbox blocks without it. `.git` stays read-only to Codex, so
   commits are Claude's. `-c check_for_update_on_startup=false` skips the update check, whose
   "update available" prompt would otherwise stop Codex before peer-chat reaches it;
6. once Codex is running, starts `claude --worktree <KEY>` in the left pane with a prompt to read
   the ticket, plan the work and do it with Codex, or with `--plan` a prompt to execute the plan at
   `~/.claude/plans/<KEY>-<repo>.md`; Claude opens the worktree the script made instead of creating
   its own. Either prompt limits the session to the ticket's part in its own repository, plus the
   `--scope` text when given. Either prompt first asks for a short recap in the session's language once the ticket (or
   the plan) is read: the key as a clickable link to the ticket with its summary, the repository
   name, and in two or three sentences what the task asks us to do. The script puts the summary
   and the repository name into the prompt, because the worktree directory is named after the key
   and would pass for the repository;
7. selects the new session and prints its id and the worktree path.

Codex goes first because "Работай вместе с codex" makes the new Claude reach for `peer-chat`
straight away, and `peer-chat` refuses when the other pane has no Codex in it.

When the worktree or the branch `<KEY>` already exists, the script opens it as it is and says so on
stderr: that is a ticket being resumed, and its branch keeps whatever work it has. Pass that on to
the user.

## After it runs

Report in one line: the session name, the worktree path, and that Claude and Codex are running in
it; with `--plan`, the plan's path too. Do not start working on the ticket here, and do not type
anything else into the new session's panes.

Never close this session: it is the parent, and closing it closes every companion it started.

## When it fails

- `not inside agterm`: this needs agterm. Say so and stop.
- `cannot find agterm's active window` or `no selected session in agterm's active window`: run from
  the quick terminal while no window or session is active. Nothing was created; ask the user to
  select a session in the window the task should open in, then run again.
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
