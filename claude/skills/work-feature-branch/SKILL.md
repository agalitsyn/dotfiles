---
allowed-tools: Bash(git checkout --branch:*), Bash(git add:*), Bash(git status:*), Bash(git push:*), Bash(git commit:*)
description: Create feature branch, commit, push
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`

## Your task

Based on the above changes:

1. Ask user about task number from task tracker using `AskUserQuestionTool`
2. Create a new feature branch if on main or master using format `{task number}-{short description}`
3. Create a single commit with an appropriate message
4. Push the branch to origin
5. Parse git output and open gitlab merge request creation URL in default browser using `open {URL}`
6. You have the capability to call multiple tools in a single response. You MUST do all of the above in a single message. Do not use any other tools or do anything else. Do not send any other text or messages besides these tool calls.

