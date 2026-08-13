# Journal Summary

A running summary of changes to this repository, newest first.

## 2026-08-13

- Added CloudWatch as the second phase of the `debug-ticket` workflow in `.claude/workflows/debug-ticket.js`. The new phase queries `aws logs filter-log-events` using triage facts (component, environment, errors, reported date) and threads findings through all downstream agents (lenses, skeptics, report). The phase is non-blocking: missing AWS credentials are recorded and the workflow continues. See [2026-13-08.md](2026-13-08.md).

## 2026-08-12

- Added a `### Unix Philosophy` subsection to `## Code Development Standards` in `.claude/CLAUDE.md`. Eight rules cover composition, plain text, scriptability, silence, loud failure, prototyping, and simplicity. The file is staged in git. See [2026-08-12.md](2026-08-12.md).
