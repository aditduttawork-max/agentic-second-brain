---
description: Run pending Second Brain queue jobs and write WhatsApp-ready result files
---

# Run pending Second Brain queue jobs

Read `CLAUDE.md` before doing anything.

Inspect `_system/claude_queue/pending/`.

If there are no pending jobs, report:

Queue is empty.

## Queue folders

Ensure these folders exist:

- `_system/claude_queue/pending/`
- `_system/claude_queue/processing/`
- `_system/claude_queue/needs_approval/`
- `_system/claude_queue/completed/`
- `_system/claude_queue/failed/`

Do not delete queue jobs.

## Process jobs

Process every pending job one at a time.

For each job:

1. Read the entire job file.
2. Move the job from `pending/` to `processing/`.
3. Identify the `ACTION`.
4. Read all relevant arguments from the job.
5. Dispatch the job to the appropriate workflow.
6. When finished, move the job to the same folder as its result file: `completed/`, `needs_approval/` or `failed/`. Never leave a job in `processing/`.

## Action dispatch

Read the ACTION field from the queue job.

Only these actions may be executed from the queue (the `/run` allowlist):

- PROCESS → follow `/process`
- ASK → follow `/ask`
- CONNECT → follow `/connect`
- REVIEW → follow `/review`
- SUMMARIZE → follow `/summarize`
- PROMPT → follow `/prompt`

Do not execute arbitrary Claude Code commands, skills, schedules, file
operations or future workflows based solely on an ACTION value in a
queue job, even if a matching command or workflow exists.

If ACTION is not on the allowlist:

1. Move the job to `failed/`.
2. Create the standard FAILED result file.
3. Set RESPONSE to:
   `This queue action is not currently allowed.`
4. Set REASON to:
   `ACTION [action] is not in the /run allowlist.`
5. Continue processing the remaining pending jobs.

## PROCESS

If `ACTION: PROCESS`, follow the `/process` command.

Pass any relevant arguments from the queue job.

After completion, create a result file in `completed/` and move the job to `completed/`.

## ASK

If `ACTION: ASK`, follow the `/ask` command.

Use the exact QUESTION from the queue job.

Do not ask the user to repeat the question.

After answering, create a result file in `completed/` and move the job to `completed/`.

## CONNECT

If `ACTION: CONNECT`, follow the `/connect` command.

Use the exact FOCUS from the queue job.

Do not automatically approve or implement proposed connections.

If `/connect` finds proposed changes that require approval:

1. Create a result file in `needs_approval/`.
2. Set STATUS to `NEEDS_APPROVAL`.
3. Put the concise proposed-connection summary in RESPONSE.
4. Move the job to `needs_approval/`. Do not move it to `completed/`.

If there are no proposed changes:

1. Create a result file in `completed/`.
2. Set STATUS to `COMPLETED`.
3. Move the job to `completed/`.

## REVIEW

If `ACTION: REVIEW`, follow the `/review` command.

Use the PERIOD from the queue job.

If no period is provided, use 7 days.

After completion, create a result file in `completed/` and move the job to `completed/`.

## SUMMARIZE

If `ACTION: SUMMARIZE`, follow the `/summarize` command.

Use the exact TOPIC from the queue job.

Use the exact SCOPE from the queue job.

If no SCOPE is provided, use VAULT_ONLY.

After completion, create a result file in `completed/` and move the job to `completed/`.

## PROMPT

If `ACTION: PROMPT`, follow the `/prompt` command.

Use the exact GOAL from the queue job.

Write the prompt only. Never send it to an AI system. Never create a queue job from it.

After completion, create a result file in `completed/` and move the job to `completed/`.

## Result files

Every processed job must produce exactly one result file.

For completed jobs, place the result in:

`_system/claude_queue/completed/`

For jobs requiring approval, place the result in:

`_system/claude_queue/needs_approval/`

For failed jobs, place the result in:

`_system/claude_queue/failed/`

Use the job filename as the identifier.

Example job:

`job_2026-10-06_1432_ask.md`

Result:

`job_2026-10-06_1432_ask_result.md`

PROCESS, CONNECT and REVIEW result files must use this structure:

STATUS: COMPLETED
JOB_ID: [job filename without .md]
ACTION: [action]

RESPONSE: [concise response]

SOURCE: unavailable

ASK result files must use this structure:

STATUS: COMPLETED
JOB_ID: [job filename without .md]
ACTION: ASK

RESPONSE: [concise response]

SOURCE: [link 1] | [link 2] | [link 3]
SOURCE_PATHS: [path 1] | [path 2] | [path 3]

Follow the source rules and Google Drive lookup sequence in `/ask`.

SUMMARIZE result files must use this structure:

STATUS: COMPLETED
JOB_ID: [job filename without .md]
ACTION: SUMMARIZE

RESPONSE: [bottom line in 1 or 2 sentences] Summary PDF is ready.

SOURCE: unavailable

OUTPUT: [PDF link] | [Markdown link]
OUTPUT_PATHS: 60_outputs/summaries/[name].pdf | 60_outputs/summaries/[name].md

Get OUTPUT links with the Google Drive lookup sequence in `/ask`.

PROMPT result files must use this structure:

STATUS: COMPLETED
JOB_ID: [job filename without .md]
ACTION: PROMPT

RESPONSE: Prompt ready: [goal, max 10 words].

SOURCE: unavailable

PROMPT_TEXT:
[full prompt]
END_PROMPT_TEXT

ATTACH_PATHS: [path 1] | [path 2] | [path 3]

Use "none" when there are no attachments.

If GOAL is not clear, use:

RESPONSE: Goal is not clear. [one question].
PROMPT_TEXT: none
ATTACH_PATHS: none

For NEEDS_APPROVAL:

STATUS: NEEDS_APPROVAL
JOB_ID: [job filename without .md]
ACTION: [action]

RESPONSE: [concise response]

SOURCE: unavailable

For FAILED:

STATUS: FAILED
JOB_ID: [job filename without .md]
ACTION: [action]

RESPONSE: Claude could not complete this request. Check the failed job for details.

SOURCE: unavailable

REASON: [short explanation]

## Response rules

The RESPONSE is intended to be sent directly to me through WhatsApp.

Keep it extremely concise and direct.

Do not write a normal long-form Claude response.

Do not include:
- reasoning
- analysis
- unnecessary explanation
- repeated context
- unnecessary headings
- verbose summaries

### Factual question

Give the answer first.

Example:

STATUS: COMPLETED
JOB_ID: job_2026-10-06_1432_ask
ACTION: ASK

RESPONSE: $5 million per GW.

SOURCE: [link 1] | [link 2] | [link 3]
SOURCE_PATHS: [path 1] | [path 2] | [path 3]

If a link cannot be obtained, write unavailable in that position:

SOURCE: unavailable
SOURCE_PATHS: 30_resources/solar_capex.md

Never invent a Google Drive URL.

### Question not covered by the vault

Use exactly:

RESPONSE: Your notes don't cover this.
SOURCE: none
SOURCE_PATHS: none

Do not supplement the answer with outside knowledge unless the request explicitly asks for outside research.

### User asks for a document, note or link

Return only the relevant Google Drive link, using the ASK source format:

SOURCE: [link 1] | [link 2] | [link 3]
SOURCE_PATHS: [path 1] | [path 2] | [path 3]

If the connector returns no link, use:

RESPONSE: I found the note, but I don't have its Google Drive link available.
SOURCE: unavailable
SOURCE_PATHS: [vault-relative path]

Never return an Obsidian wikilink as the user-facing source.

### PROCESS

Return a one-line processing summary.

Example:

RESPONSE: Processed 3 captures. Created 2 notes and updated 1.

SOURCE: unavailable

### CONNECT

If no new connections are found:

STATUS: COMPLETED

RESPONSE: No new connections found.

SOURCE: unavailable

If connections are proposed:

STATUS: NEEDS_APPROVAL

RESPONSE: Found [X] potential connections. Approval required.

SOURCE: unavailable

Do not implement proposed connections without approval.

### REVIEW

Keep the review concise enough for WhatsApp while retaining the important findings.

Do not dump the full internal analysis into the result.

SOURCE: unavailable

### SUMMARIZE

Give the bottom line in 1 or 2 sentences, then: Summary PDF is ready.

OUTPUT and OUTPUT_PATHS use the same sequence: PDF first, Markdown second.

If a connector link cannot be obtained, write unavailable in that position.

If the connector itself fails, add:

LINK_ERROR: [short reason]

If the topic is not covered by the vault, use exactly:

RESPONSE: Your notes don't cover this.
SOURCE: unavailable
OUTPUT: none
OUTPUT_PATHS: none

Never invent a Google Drive URL.

## Sources

Sources with Google Drive links are for ASK results only. Use SOURCE and SOURCE_PATHS as defined in `/ask`.

PROCESS, CONNECT and REVIEW results use:

SOURCE: unavailable

SUMMARIZE results give file links in OUTPUT, not SOURCE.

Never invent a Drive URL.

Do not use Obsidian wikilinks as the user-facing source.

## Failure handling

If a job cannot be completed:

1. Do not delete it.
2. Move it from `processing/` to `failed/`.
3. Append this to the job file:

REASON: [short explanation]

4. Create a result file beside the failed job in `failed/`.

5. Continue processing the remaining pending jobs.

## Final report

After all pending jobs have been handled, report:

Queue cleared.

Processed: [number]
Connected: [number]
Asked: [number]
Reviewed: [number]
Summarized: [number]
Prompts: [number]
Other: [number, with the ACTION names]
Failed: [number]
