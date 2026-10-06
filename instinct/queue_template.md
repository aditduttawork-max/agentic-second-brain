# Queue Job Templates

Queue jobs are stored in:

```text
_system/claude_queue/pending/
```

Every job must contain an `ACTION` and creation metadata.

## PROCESS

```markdown
ACTION: PROCESS
TARGET: 00_inbox
CREATED_BY: instinct
CREATED_AT: [timestamp]
```

## ASK

```markdown
ACTION: ASK
QUESTION: [exact question]
CREATED_BY: instinct
CREATED_AT: [timestamp]
```

## CONNECT

```markdown
ACTION: CONNECT
FOCUS: [relevant context]
CREATED_BY: instinct
CREATED_AT: [timestamp]
```

## REVIEW

```markdown
ACTION: REVIEW
PERIOD: [requested period]
CREATED_BY: instinct
CREATED_AT: [timestamp]
```

If no period is provided, `/review` uses the last 7 days.

## SUMMARIZE

```markdown
ACTION: SUMMARIZE
TOPIC: [exact topic]
SCOPE: VAULT_ONLY
CREATED_BY: instinct
CREATED_AT: [timestamp]
```

Use `VAULT_AND_WEB` only when the user explicitly requests external research.

If `SCOPE` is missing, use `VAULT_ONLY`.

## PROMPT

```markdown
ACTION: PROMPT
GOAL: [exact goal]
CREATED_BY: instinct
CREATED_AT: [timestamp]
```

PROMPT generates instructions only. It does not execute the underlying task.

## Result locations

Completed jobs:

```text
_system/claude_queue/completed/
```

Jobs requiring approval:

```text
_system/claude_queue/needs_approval/
```

Failed jobs:

```text
_system/claude_queue/failed/
```

Every processed job produces exactly one result file.

## Rules

- Do not delete queue jobs.
- Do not execute unknown actions.
- Do not invent arguments.
- Preserve exact user questions, topics, and goals.
- Move jobs through `pending/ → processing/ → final state`.
