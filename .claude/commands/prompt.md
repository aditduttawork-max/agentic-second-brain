---
description: Write an AI prompt for a goal, using related vault notes as context
argument-hint: <goal>
---

Write a prompt for this goal:

$ARGUMENTS

## Purpose

Write the prompt only.

- Never send the prompt to an AI system.
- Never create a queue job from the generated prompt.
- Never create or modify a prompt file.
- Do not modify, create, move or delete any notes.
- When run from the queue (`/run`), write the full prompt only in the result file.

## Before you write

1. Read CLAUDE.md first and follow it throughout.
2. Check relevant Maps of Content in _system/maps first, if they exist.
3. Search the vault for GOAL, its key terms, synonyms and related concepts.
4. Read every related note fully.
5. If no relevant note exists, write the prompt from GOAL only.

## Unclear goal

If GOAL is not clear, do not write a prompt. Ask exactly one question.

Result:

RESPONSE: Goal is not clear. [one question].
PROMPT_TEXT: none
ATTACH_PATHS: none

## Attachments

1. Select a maximum of 3 relevant documents.
2. Select only documents that help the AI system do the task.
3. Put the most relevant document first.
4. Total attachment size must be below 20 MB.
5. Check each file size before you select it.
6. Write vault-relative paths with forward slashes.
7. If there are no attachments, write `ATTACH_PATHS: none`.

## Prompt content

1. Include useful personal information when relevant.
2. Never include passwords, API keys or account numbers.
3. Never include wikilinks in the prompt.
4. Never include vault paths in the prompt.
5. Refer to attachments by plain document name only.
6. Maximum prompt length: 5,000 characters.

## Prompt sections

Use this section order:

1. ROLE
2. GOAL
3. CONTEXT
4. ATTACHED FILES
5. TASK
6. CONSTRAINTS
7. OUTPUT FORMAT
8. QUALITY CHECK
9. QUESTIONS

Omit empty sections.

## Writing rules (ASD-STE100)

- Use imperative sentences.
- One instruction per sentence.
- Procedural sentences: 20 words or fewer.
- Descriptive sentences: 25 words or fewer.
- Use active voice and simple words.
- Use one word for one meaning.
- Use numbered steps for sequences.
- Use tables for comparisons.
- Never use "should".
- Do not label the user's views.

## Check before you finish

1. The prompt is below 5,000 characters.
2. The sections are in the correct order.
3. The prompt contains no wikilinks.
4. The prompt contains no vault paths.
5. The prompt contains no passwords, API keys or account numbers.
6. There are 3 attachments or fewer.
7. Every attachment path exists.
8. Total attachment size is below 20 MB.

## Result

When run from the queue (`/run`), write the result file in the PROMPT format defined in `.claude/commands/run.md`.

When run directly, report:

- The full prompt.
- The attachment paths, or none.
- The prompt character count.
