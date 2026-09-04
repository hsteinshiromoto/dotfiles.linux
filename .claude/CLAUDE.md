# Global System Environment and Standards

If any of the below instruction conflict with a local `CLAUDE.md`, please use instruction coming the local file.

Always ask the user the following questions using the `AskUserQuestion` tool

## Start up

When you startup, do these things:
- Read all the git commits for the current branch.
- Read the latest note in the folder `journal`. If this folder does not exist, create it on the project root folder.
- Read the file `journal/summary.md`, this is a summary of the all of the changes done so far. If this file does not exist, create one.
Use these pieces of information as your long-term memory.

## Agent Workflow

Use always these subagents in this order:
- 1. Product Manager (PM) agent: assess request complexity. If simple, skip to step 1. If complex, reformulate the request, ask up to 3 clarifying questions, and evaluate answers (PASS/NO PASS). At most 2 rounds of clarification before handing off to step 1.
- 2. Plan agent: understand the request, analyse the context, and plan the implementation. Show the plan for user and ask for approval before moving to the next step.
- 3. Plan evaluator agent: critique the proposed plan for feasibility, completeness, standards compliance, risk, and modularity. If the verdict is NEEDS WORK, revise the plan and re-evaluate before proceeding.
- 4. Build agent: Execute the planned implementation. Ask the user for approval before modifying any file in accordance to the plan.
- 5. Build evaluator agent: critique the implementation using the code-reviewer skill. If the verdict is NEEDS WORK, address the recommendations before proceeding.
- 6. End-to-end evaluator agent: run `/sanity-check` and create an overall summary of plan, build, test results, and assess if the final implementation adress the requirements of the produce manager.
Each of these agents will execute at most three tasks.
- 7. If the end-to-end evaluator verdict is PASS, ask the user if he wants to add the code to the git staging area.
- 8. Conclude the workflow by updating the journal using the `/journal` skill.

For each of user permission request, offer only three options as a choice-selection menu:
1. Yes (Y).
2. No (N).
3. Something else: only here the user is prompted to type in text that will run a small change such execute a command with a different flag option.

## Commit and journal conventions
After completing a unit of work: update the repo journal entry, then commit with a scoped conventional-commit message covering only the files for that change. Confirm the working tree is clean afterwards. If `git` reports 'Another git process seems to be running' (index.lock from my zsh prompt), retry once then fall back to plain `rm`/`mv` rather than looping on git.

## Secrets and sensitive files
Before any commit or `.gitignore` change, scan staged/tracked files for credentials, API keys and anything under `_documents_/`. Never commit plaintext secrets; route them through sops-nix. Flag any leaked key immediately rather than continuing.

## DO NOT

Never perform any of the following tasks without human approval:
1. Modify any file.
2. Add any file to git staging area or commit.
3. Run shell commands that execute tests or build steps without first confirming the host OS is compatible with the project's test environment (e.g., NixOS tests cannot run from a macOS host).

## Don't guess API or config syntax
If you are unsure of the exact syntax for a third-party DSL, config schema or plugin API (Obsidian Bases formulas, Forgejo/Gitea options, Opencode plugin API, Ghostreader prompts, hledger CSV rules), fetch the official docs FIRST with WebFetch/WebSearch. Do not invent function or option names and iterate on errors.

## Code Development Standards

- Prefer functional implementation.
- Prefer readable implementation.
- Prefer modularized code: each function is responsible for only one task.
- Implement minimal code: 20% of the code should be capable of handling 80% of the requirements. Do not cater for edge cases.
- Use standard libraries for code implementation.
- Prefer orchestration over inheritance.
- When you finish your implementation run `/sanity-check`
- For every project that you are making changes. For each day, create a file of the format `YYYY-MM-DD.md` containing all changes done to the repository on that day.

### Unix Philosophy

When implementing code, ALWAYS use these guiding principles
- Write each program, module, and/or function to do one thing well.
- Design components that compose. The output of one component must be usable as the input of another.
- Use plain text for data and configuration. Text is the universal interface.
- Make tools scriptable. Do not build captive user interfaces.
- Follow the rule of silence: print nothing when there is nothing surprising to report.
- Fail loudly. When a program fails, stop early and show a clear error message.
- Build a small working version first. Improve it in small steps.
- Choose simplicity over cleverness. Add complexity only when measurements prove the need.

### Python

- All python projects use `uv` package manager.
- All added packages to `uv` will first be installed under the `dev` group and will only be moved into production group manually by a human.
- All python commands need to be prepended by `uv run`.
- All python functions require docstrings using Google format. The docstrings need to have examples.

### IDE

- The user's IDE is neovim with configuration located in `~/.config/nvim`. You are allowed to read/cat/grep/find any file located in there.
- The user's OS/system packages are located in `~/.config/nix`. You are allowed to read/cat/grep/find any file located in there.

### MCPs

- For Atlassian related work, use the Atlassian MCP.
- For repositories having origin hosted in github, use Github MCP.

### CLIs

- Use `glab` (Gitlab cli) to work with repositories having origin hosted in gitlab.

### LSPs

- Use the LSPs where available, instead of `grep`, `find` etc.

## Communication Style

Keep investigation and verification findings concise — use a table or bullet summary; avoid verbose multi-paragraph prose reports.
You MUST USE the `ste_writing` skill, when writing prose (docs, READMEs, PR descriptions, error messages, release notes, comments). DO NOT USE when writing code.

## Finishing up

When the user types `/quit`, `quit`, `/exit` or  `exit`, you run the command `journal/` BEFORE quitting.
# graphify
- **graphify** (`~/.claude/skills/graphify/SKILL.md`) - any input to knowledge graph. Trigger: `/graphify`
When the user types `/graphify`, invoke the Skill tool with `skill: "graphify"` before doing anything else.
