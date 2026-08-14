# Journal Summary

A running summary of changes to this repository, newest first.

## 2026-08-14

- Added an `AWS login` phase to the `debug-ticket` workflow in `.claude/workflows/debug-ticket.js`, between Triage and CloudWatch. It maps the ticket environment to one of the eight profiles in `~/.aws/config`, tests the session with `aws sts get-caller-identity`, and runs `aws sso login --profile <env>` only when needed. A failed login stops the workflow with `status: "aws_login_required"` rather than querying CloudWatch with dead credentials. Added five AWS permissions to `.claude/settings.local.json`. See [2026-08-14.md](2026-08-14.md).

## 2026-08-13

- Added CloudWatch as the second phase of the `debug-ticket` workflow in `.claude/workflows/debug-ticket.js`. The new phase queries `aws logs filter-log-events` using triage facts (component, environment, errors, reported date) and threads findings through all downstream agents (lenses, skeptics, report). The phase is non-blocking: missing AWS credentials are recorded and the workflow continues. See [2026-13-08.md](2026-13-08.md).

## 2026-08-12

- Added a `### Unix Philosophy` subsection to `## Code Development Standards` in `.claude/CLAUDE.md`. Eight rules cover composition, plain text, scriptability, silence, loud failure, prototyping, and simplicity. The file is staged in git. See [2026-08-12.md](2026-08-12.md).
