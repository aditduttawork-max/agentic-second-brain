# Agentic Second Brain Setup

## Prerequisites

Install:

- Windows PowerShell
- Node.js
- Claude Code
- Obsidian
- Google Drive for Desktop
- Instinct with Google Drive access

## Create the vault

Create:

```text
H:\My Drive\Instinct\Obsidian\Second brain
```

Create the folder structure:

```text
00_inbox/
10_projects/
20_areas/
30_resources/
40_archive/
50_daily/
60_outputs/
_system/templates/
_system/maps/
_system/claude_queue/pending/
_system/claude_queue/processing/
_system/claude_queue/needs_approval/
_system/claude_queue/completed/
_system/claude_queue/failed/
```

## Configure Obsidian

Daily notes use:

```text
YYYY_MM_DD
```

Store daily notes in:

```text
50_daily/
```

## Add Claude instructions

Create `CLAUDE.md`.

Include:

- vault purpose
- folder structure
- routing rules
- daily note rules
- note creation rules
- evidence labels
- safety rules
- question and answer rules
- writing style
- approval rules

## Add Claude commands

Create:

```text
.claude/commands/process.md
.claude/commands/connect.md
.claude/commands/review.md
.claude/commands/run.md
.claude/commands/ask.md
.claude/commands/summarize.md
.claude/commands/prompt.md
```

## Add system rules and templates

Create:

```text
_system/instinct/ask_source_rules.md
_system/instinct/summarize_rules.md
_system/instinct/prompt_rules.md
_system/templates/summary_template.tex
_system/templates/summary_filter.lua
```

These files define connector source handling, Instinct delivery rules, and SUMMARIZE PDF rendering.

## Configure queue

Create:

```text
_system/claude_queue/pending/
_system/claude_queue/processing/
_system/claude_queue/needs_approval/
_system/claude_queue/completed/
_system/claude_queue/failed/
```

## Configure Instinct

Instinct must:

- recognize `SB: [ACTION] [REQUEST]`
- support PROCESS, ASK, CONNECT, REVIEW, SUMMARIZE and PROMPT
- allow an empty request for CONNECT and REVIEW
- require a request for PROCESS, ASK, SUMMARIZE and PROMPT
- create explicit queue jobs directly in `pending/`
- never perform Claude reasoning itself
- read result files
- send concise results to WhatsApp
- use real Google Drive links only
- track delivery separately from Claude result files

## Current actions

```text
PROCESS
ASK
CONNECT
REVIEW
SUMMARIZE
PROMPT
```

## Launch Claude Code

Always launch Claude Code from the vault:

```powershell
cd "H:\My Drive\Instinct\Obsidian\Second brain"
claude.cmd
```

Then run:

```text
/run
```

## End-to-end test

Confirm this flow:

```text
WhatsApp
→ Instinct
→ pending/
→ /run
→ workflow
→ result
→ Instinct
→ WhatsApp
```

Test each action individually before relying on the complete workflow.

## Safety

Do not allow unknown queue actions to execute.

Do not make large structural changes without approval.

Do not modify more than 20 files without approval.

Do not commit secrets, credentials, provider exports, or runtime queue data to GitHub.
