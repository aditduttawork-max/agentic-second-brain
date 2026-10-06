# Instinct WhatsApp Protocol

## Purpose

WhatsApp is the front end for the Second Brain.

Instinct receives commands, creates queue jobs, reads results, and communicates concise results.

Claude Code performs the knowledge work.

## SB command format

Use this format for Second Brain actions:

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

`SB:` is an action trigger. It is not a raw-capture command.

## PROCESS

Use:

```text
SB: PROCESS [request]
```

Create a PROCESS queue job.

A request is required.

## ASK

Use:

```text
SB: ASK [question]
```

Create an ASK queue job with the exact question.

A question is required.

Use real Google Drive source links returned by the connector when available.

Never construct or guess a Drive URL.

## CONNECT

Use either:

```text
SB: CONNECT
```

or:

```text
SB: CONNECT [request]
```

Create a CONNECT queue job.

The request is optional.

If no request is provided, create the normal CONNECT job. Claude runs the existing `/connect` workflow across the vault.

Do not implement proposed connections without approval.

## REVIEW

Use either:

```text
SB: REVIEW
```

or:

```text
SB: REVIEW [request]
```

Create a REVIEW queue job.

The request is optional.

If no request is provided, create the normal REVIEW job. Claude runs the existing `/review` workflow.

If no period is specified, `/review` uses its existing default of 7 days.

## SUMMARIZE

Use:

```text
SB: SUMMARIZE [topic]
```

Create a SUMMARIZE queue job.

A topic is required.

Default scope:

```text
VAULT_ONLY
```

Use `VAULT_AND_WEB` only when the user explicitly requests external research.

## PROMPT

Use:

```text
SB: PROMPT [goal]
```

Create a PROMPT queue job.

A goal is required.

Do not execute the underlying task.

Do not send the generated prompt to another AI.

The PROMPT workflow searches the vault for context and selects up to three relevant files.

Email delivery:

```text
From: [MY_EMAIL]
To: [MY_EMAIL]
Subject: Prompt: [goal]
Label: Prompts
```

Email body:

1. `PROMPT_TEXT` unchanged.
2. `Attached files:`
3. The selected file paths.

Attach the selected files.

If the goal is unclear, ask exactly one question. Do not create the queue job or send an email.

## Invalid commands

If the action after `SB:` is not one of the six supported actions, ask which action is required.

If PROCESS, ASK, SUMMARIZE, or PROMPT has no request, ask one concise question.

Do not ask for a request for CONNECT or REVIEW.

## Queue

Write all six action jobs directly to:

```text
_system/claude_queue/pending/
```

Do not place action jobs in `00_inbox/`.

## /run

Only `/run` executes queued jobs.

Never execute a request merely because it was discussed or because a PROMPT was generated.

## WhatsApp responses

Keep responses extremely concise.

Do not send internal reasoning or analysis.

Use the result file's `RESPONSE`.

## Final action list

```text
PROCESS
ASK
CONNECT
REVIEW
SUMMARIZE
PROMPT
```

Preserve existing workflow behavior unless the user explicitly requests a change.
