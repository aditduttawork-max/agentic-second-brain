# Agentic Second Brain Architecture

## Purpose

A personal Second Brain workflow with WhatsApp as the front end, Instinct as the capture and queue layer, Google Drive as shared storage, Obsidian as the local knowledge UI, and Claude Code as the reasoning and knowledge-management layer.

## Architecture

```text
WhatsApp
   ↓
Instinct
   ↓
Google Drive
   ↓
Second Brain queue
   ↓
Claude Code (run from vault)
   ↓
/run dispatcher
   ↓
PROCESS / ASK / CONNECT / REVIEW / SUMMARIZE / PROMPT
   ↓
Result file
   ↓
Instinct
   ↓
WhatsApp
```

## Core principle

Instinct receives explicit `SB: [ACTION] [REQUEST]` commands, creates queue jobs, reads results, and communicates concise results.

The six supported actions are PROCESS, ASK, CONNECT, REVIEW, SUMMARIZE and PROMPT.

CONNECT and REVIEW may have an empty request. The other actions require a request.

Claude Code performs the actual knowledge work.

`/run` is an explicit allowlisted dispatcher, not an unrestricted command executor.

## Vault

```text
H:\My Drive\Instinct\Obsidian\Second brain
```

Structure:

```text
Second brain/
├── .obsidian/
├── .claude/
│   └── commands/
├── 00_inbox/
├── 10_projects/
├── 20_areas/
├── 30_resources/
├── 40_archive/
├── 50_daily/
├── 60_outputs/
├── _system/
│   ├── templates/
│   ├── maps/
│   └── claude_queue/
│       ├── pending/
│       ├── processing/
│       ├── needs_approval/
│       ├── completed/
│       └── failed/
├── CLAUDE.md
└── Welcome.md
```

## Queue actions

| Action | Workflow |
|---|---|
| PROCESS | `/process` |
| ASK | `/ask` |
| CONNECT | `/connect` |
| REVIEW | `/review` |
| SUMMARIZE | `/summarize` |
| PROMPT | `/prompt` |

Only these actions may execute from `/run`.

Unknown actions fail safely and do not execute arbitrary commands, skills, schedules, or file operations.

## Workflow summary

### PROCESS
Processes `00_inbox/`, preserves the user's thinking, creates or updates appropriate notes, adds meaningful links, and archives processed captures.

### ASK
Answers from vault information. Queue results use real Google Drive links and vault-relative source paths. Drive URLs are never constructed or guessed.

### CONNECT
Finds genuine relationships, contradictions, clusters, isolated notes, and unanswered questions. Proposed changes require approval.

### REVIEW
Reviews recent vault activity without modifying the vault.

### SUMMARIZE
Creates a concise Markdown and PDF briefing from vault notes. It defaults to `VAULT_ONLY`. Sources begin on a new PDF page.

### PROMPT
Converts a user goal into an ASD-STE100 prompt for another AI. It never executes the underlying task.

## Result flow

Every queue job produces exactly one result file.

```text
pending/
   ↓
processing/
   ↓
completed/ | needs_approval/ | failed/
```

Instinct sends the concise `RESPONSE` to WhatsApp. ASK source links and SUMMARIZE output links are delivered according to their specific result formats.

## Operational requirement

Claude Code must run from the Second Brain vault.

```powershell
cd "H:\My Drive\Instinct\Obsidian\Second brain"
claude.cmd
```

Then:

```text
/run
```

## Design rule

Add future capabilities as explicit allowlisted workflows. Do not redesign the queue architecture unless there is a clear requirement.
