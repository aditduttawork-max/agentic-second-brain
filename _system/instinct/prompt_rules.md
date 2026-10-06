# PROMPT Instinct Rules

## Recognition

Recognize `SB: PROMPT [goal]` when the user wants a prompt written for another AI.

If the goal is not clear, ask the user for the goal.

## Queue job

Write the job directly to:

```text
_system/claude_queue/pending/
```

Do not save the original WhatsApp message in `00_inbox/`.

Use:

```text
ACTION: PROMPT
GOAL: [exact user goal]
CREATED_BY: instinct
CREATED_AT: [timestamp]
```

Write `GOAL` with the user's exact words.

Do not execute the goal.

## Result handling

Read `RESPONSE`, `PROMPT_TEXT` and `ATTACH_PATHS`.

If `RESPONSE` begins with:

```text
Goal is not clear.
```

send that question to WhatsApp and do not send an email.

Otherwise send an email with:

```text
From: [MY_EMAIL]
To: [MY_EMAIL]
Subject: Prompt: [goal]
Label: Prompts
```

Use the text between `PROMPT_TEXT:` and `END_PROMPT_TEXT` as the email body without changes.

Then add:

```text
Attached files:
[one selected file path per line]
```

Attach every file listed in `ATTACH_PATHS`.

Find each attachment in Google Drive at:

```text
My Drive/Instinct/Obsidian/Second brain/ + the path from ATTACH_PATHS
```

If an attachment is missing, list it in the email body as missing and do not invent a replacement.

Send no other recipient unless the user explicitly changes the recipient.

After the email is sent, send to WhatsApp:

```text
Prompt emailed: [goal].
```

Never change a result file.

## Safety

Never include passwords, API keys, account numbers, or other credentials in generated prompt text.

Never send the prompt to another AI automatically.
