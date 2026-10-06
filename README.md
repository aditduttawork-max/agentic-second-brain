# Second Brain — Instinct + Google Drive + Obsidian + Claude Code

## Purpose

A personal Second Brain workflow with WhatsApp as the front end, Instinct as the capture/queue layer, Google Drive as the shared storage layer, Obsidian as the local knowledge UI, and Claude Code as the reasoning/knowledge-management layer.

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

## Vault

Current vault:

```text
H:\My Drive\Instinct\Obsidian\Second brain
```

Structure:

```text
Second brain/
├── .obsidian/
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

## Core design principle

Instinct does not perform Second Brain reasoning. It captures, creates queue jobs, reads results, and communicates concise results to WhatsApp.

Claude Code performs the actual knowledge work.

`/run` is infrastructure. It is a dispatcher, not a knowledge workflow itself.

## WhatsApp → Instinct

Instinct uses an explicit `SB:` action command:

```text
SB: [ACTION] [REQUEST]
```

Supported actions:

```text
PROCESS
ASK
CONNECT
REVIEW
SUMMARIZE
PROMPT
```

The action after `SB:` is case-insensitive.

Examples:

```text
SB: PROCESS these new research notes
SB: ASK What do my notes say about data centre MEP?
SB: CONNECT data centre and MEP notes
SB: CONNECT
SB: REVIEW my recent project notes
SB: REVIEW
SB: SUMMARIZE AI data centres
SB: PROMPT Screener to validate this investment thesis
```

`CONNECT` and `REVIEW` may have an empty request. In that case, Instinct creates the normal CONNECT or REVIEW queue job and Claude runs the existing workflow.

PROCESS, ASK, SUMMARIZE and PROMPT require a request.

Instinct writes all action jobs directly to `_system/claude_queue/pending/`. It does not place these commands in `00_inbox/`.

## Queue jobs

Jobs are written to:

```text
_system/claude_queue/pending/
```

Example PROCESS job:

```markdown
ACTION: PROCESS
TARGET: 00_inbox
CREATED_BY: instinct
CREATED_AT: [timestamp]
```

Example ASK job:

```markdown
ACTION: ASK
QUESTION: [exact question]
CREATED_BY: instinct
CREATED_AT: [timestamp]
```

Example CONNECT job:

```markdown
ACTION: CONNECT
FOCUS: [relevant context]
CREATED_BY: instinct
CREATED_AT: [timestamp]
```

Example REVIEW job:

```markdown
ACTION: REVIEW
PERIOD: [requested period]
CREATED_BY: instinct
CREATED_AT: [timestamp]
```

## `/run` allowlist

Only these queue actions may execute:

| ACTION | Claude workflow |
|---|---|
| PROCESS | `/process` |
| ASK | `/ask` |
| CONNECT | `/connect` |
| REVIEW | `/review` |
| SUMMARIZE | `/summarize` |
| PROMPT | `/prompt` |

Do **not** allow arbitrary Claude Code commands, skills, schedules, file operations, or future workflows to execute solely because an ACTION value exists in a queue job.

Unknown ACTIONs:

1. Move the job to `failed/`.
2. Create the standard FAILED result.
3. Return:

```text
RESPONSE: This queue action is not currently allowed.
REASON: ACTION [action] is not in the /run allowlist.
```

Continue processing remaining jobs.

## Workflow commands

### `/process`

Processes `00_inbox/`.

Rules:

- search the vault before creating notes
- prefer updating an existing note
- split meaningful ideas into appropriate notes
- preserve original thinking
- use lowercase_with_underscore filenames
- add one-line summaries
- use evidence labels where relevant
- add wikilinks and Links sections
- archive processed raw captures to `40_archive/inbox_processed/`
- do not create notes from meaningless captures
- ask before operations affecting more than 20 files

### `/ask`

Answers from the vault only.

Every answer should cite supporting notes.

If the notes do not support the answer, return exactly:

```text
Your notes don't cover this.
```

No outside knowledge unless explicitly requested.

### `/connect`

Finds relationships between existing notes.

It proposes connections but does not automatically implement them when approval is required.

It can identify:

- same ideas
- reinforcement
- contradictions
- thesis/evidence relationships
- useful MOC opportunities

### `/review`

Reviews a requested period of the Second Brain.

It should identify:

- what was learned
- current projects
- emerging themes
- important connections
- open questions
- useful next actions

It should not modify the vault.

### `/summarize`

Creates a concise Markdown and PDF summary from vault notes.

- defaults to `VAULT_ONLY`
- uses flexible sections based on the topic
- prefers one page when useful
- starts Sources on a new page
- does not force content into a fixed template
- does not invent unsupported facts

### `/prompt`

Creates an ASD-STE100 prompt for another AI.

- searches the vault for relevant context
- selects up to 3 relevant files
- places the complete prompt in the result file
- does not execute the requested task
- does not create a separate prompt file

## Result protocol

Every queue job produces one result file. ASK and SUMMARIZE can include current Google Drive links. PROMPT includes the generated prompt and attachment paths.

Completed:

```text
_system/claude_queue/completed/
```

Needs approval:

```text
_system/claude_queue/needs_approval/
```

Failed:

```text
_system/claude_queue/failed/
```

Example:

```text
job_2026-10-06_1432_ask.md
job_2026-10-06_1432_ask_result.md
```

Standard result structure:

```text
STATUS: COMPLETED
JOB_ID: [job filename without .md]
ACTION: [action]

RESPONSE: [concise response]

SOURCE: [Google Drive link, or unavailable (vault path: [path])]
```

For failures, include:

```text
STATUS: FAILED
JOB_ID: [job filename without .md]
ACTION: [action]

RESPONSE: Claude could not complete this request.
SOURCE: unavailable
REASON: [specific reason]
```

## WhatsApp response philosophy

Responses are designed to be clipped directly into WhatsApp.

Keep them extremely concise and direct.

Examples:

```text
Processed 3 captures. Created 2 notes and updated 1.
```

```text
No new connections found.
```

```text
$5 million per GW.
SOURCE: [Google Drive link]
```

If a user asks for a document/note/link, return only the relevant Google Drive link when available.

Never invent Google Drive links.

## Important operational requirement

Claude Code must be launched from the Second Brain vault. Otherwise `/run` may resolve to a different Claude Code command/skill.

PowerShell:

```powershell
cd "H:\My Drive\Instinct\Obsidian\Second brain"
claude.cmd
```

Then:

```text
/run
```

## Re-creation checklist

### 1. Install prerequisites

- Windows PowerShell
- Node.js
- Claude Code
- Obsidian
- Google Drive for Desktop
- Instinct with Google Drive access

### 2. Create the vault

Create:

```text
H:\My Drive\Instinct\Obsidian\Second brain
```

Create the folder structure shown above.

### 3. Configure Obsidian

Daily notes:

```json
{
  "format": "YYYY_MM_DD",
  "folder": "50_daily"
}
```

Do not depend on Obsidian Sync for this architecture.

### 4. Add Claude instructions

Create `CLAUDE.md` containing:

- vault purpose
- folder structure
- routing rules
- daily note rules
- note creation rules
- evidence labels
- safety rules
- question/answer rules
- writing style
- approval rules

### 5. Add Claude commands

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

### 6. Configure queue

Create:

```text
_system/claude_queue/pending/
_system/claude_queue/processing/
_system/claude_queue/needs_approval/
_system/claude_queue/completed/
_system/claude_queue/failed/
```

### 7. Configure Instinct

Instinct should:

- recognize `SB: [ACTION] [REQUEST]`
- write the six queue job types directly to `_system/claude_queue/pending/`
- replace `[MY_EMAIL]` in the PROMPT rules with your own address
- never perform Claude reasoning itself
- read result files
- send only the concise RESPONSE to WhatsApp
- append SOURCE only when it is a real Google Drive link
- track delivery separately from Claude result files

### 8. Test each action

Test in this order:

1. PROCESS
2. ASK
3. CONNECT
4. REVIEW
5. SUMMARIZE
6. PROMPT
7. unknown ACTION → must fail safely

### 9. Test end-to-end

Confirm:

```text
WhatsApp → Instinct → pending → /run → workflow → result → Instinct → WhatsApp
```

## Design decisions / lessons

### Why Google Drive?

It acts as the shared bridge between Instinct and the local Obsidian/Claude Code environment without requiring the entire system to run on a VM.

### Why Obsidian?

It provides a local, human-readable UI for the knowledge base while Claude Code operates directly on the vault.

### Why Claude Code?

It provides the reasoning and file-manipulation layer for processing, querying, connecting, and reviewing the Second Brain.

### Why `/run` is separate

`/run` is deliberately an infrastructure dispatcher. New applications should be added as explicit allowlisted workflows rather than turning `/run` into an unrestricted command executor.

Future workflow example:

```text
RESEARCH → /research
```

Add new capabilities deliberately to the allowlist.

## Current status

Core queue loop is working.

Successfully tested:

- PROCESS
- ASK
- REVIEW
- CONNECT
- queue result handling
- CONNECT approval routing
- unknown-action safety design

Current system is suitable for adding additional Second Brain applications later.

## Future improvements

- automate Claude Code startup
- automatically trigger `/run`
- add new workflows through explicit allowlist entries
- improve Instinct result delivery
- add more sophisticated project/application-specific Claude commands

Do not redesign the queue architecture unless there is a clear requirement.
