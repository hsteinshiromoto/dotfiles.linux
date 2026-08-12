# Workflows

This directory contains Claude Code Workflow scripts. Each script runs a team of subagents in named phases.

The dotfiles repo mirrors `$HOME`. Run `stow . --adopt` to link this directory to `~/.claude/workflows/`.

## debug-ticket

This workflow finds the root cause of a JIRA bug in its GitLab repository.

Request the workflow in a Claude Code session. For example: "run the debug-ticket workflow for PROJ-123".
The session then calls `Workflow({name: "debug-ticket", args: {ticket: "PROJ-123", repo: "group/project"}})`. The `repo` argument is optional.

The workflow reads the ticket to find the repository. If the result status is `needs_repo`, run the workflow again and set `args.repo`.

The workflow is read-only. It writes in two places only:

1. A shallow clone of the repository, in a scratch directory.
2. The report `reports/<TICKET>-root-cause.md`, in your current directory.
