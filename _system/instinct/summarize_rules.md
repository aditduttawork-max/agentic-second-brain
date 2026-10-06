# SUMMARIZE Instinct Rules

## Recognition

Recognize `SB: SUMMARIZE [topic]` when the user asks for a PDF summary of a topic from the Second Brain.

If the topic is not clear, ask the user for the topic.

## Queue job

Write the job directly to:

```text
_system/claude_queue/pending/
```

Use:

```text
ACTION: SUMMARIZE
TOPIC: [exact user topic]
SCOPE: [VAULT_ONLY or VAULT_AND_WEB]
CREATED_BY: instinct
CREATED_AT: [timestamp]
```

Write `TOPIC` with the user's exact words.

Use `VAULT_AND_WEB` only if the user explicitly asks for external research. Otherwise use `VAULT_ONLY`.

## Result handling

Read `RESPONSE`, `OUTPUT` and `OUTPUT_PATHS` from the completed result file.

Send the `RESPONSE` and the PDF link to WhatsApp.

If a link is `unavailable`, find the file in Google Drive at:

```text
My Drive/Instinct/Obsidian/Second brain/ + the path from OUTPUT_PATHS
```

Use current connector-returned links only.

Never construct a Google Drive URL.

If Instinct can attach files in WhatsApp, also attach the PDF.

Never change a result file.
