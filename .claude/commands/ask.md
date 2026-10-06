---
description: Answer a question using only the notes in this vault
argument-hint: <question>
---

Answer this question using only my vault:

$ARGUMENTS

## Before you answer

1. Read CLAUDE.md first and follow it throughout.
2. Use only information contained in this vault. Do not supplement with outside knowledge.
3. Check relevant Maps of Content in _system/maps first, if they exist.
4. Search the vault for the question's key terms, synonyms and related concepts.
5. Read every relevant note fully before answering.
6. Do not modify, create, move or delete any notes.

## Answer

1. Answer first, in 3–6 concise sentences unless more detail is necessary.
2. Cite supporting notes using [[wikilinks]].
3. Clearly identify any disagreements, contradictions or gaps between notes.
4. Distinguish FACT, SOURCE CLAIM, MANAGEMENT GUIDANCE, MY VIEW, INFERENCE and QUESTION where relevant.
5. Never present an inference as a fact.
6. If the vault does not contain the answer, say exactly:

"Your notes don't cover this."

## Sources for ASK results

When this command runs from the queue (`/run`), the result file must not use wikilinks. Use these source rules instead.

1. Give a maximum of 3 sources.
2. A source must be a note that supports the answer.
3. Put the most relevant source first.
4. Never construct a Google Drive URL from a local path, filename, or guessed file ID.
5. Write a Google Drive link only when the Google Drive connector returns that link for the exact file.
6. Always write the vault-relative path of every source.
7. Use forward slashes in paths.
8. If RESPONSE is exactly:
   Your notes don't cover this.
   then write:
   SOURCE: none
   SOURCE_PATHS: none

## Google Drive lookup sequence

For every selected source:

1. Use the Google Drive connector to get its link.
2. The Google Drive vault root is:

   My Drive/Instinct/Obsidian/Second brain/

3. Resolve the expected parent folder from the file's vault-relative path. Example: `60_outputs/summaries/x.pdf` → `My Drive/Instinct/Obsidian/Second brain/60_outputs/summaries/`.
4. Search by the exact filename.
5. For each match, verify its full parent-folder chain up to My Drive.
6. Keep only the matches whose parent folder is exactly the expected parent folder.
7. Ignore files with the same name in other folders, including 40_archive/. They do not make a match ambiguous.
8. If exactly one file is in the expected parent folder, use its link.
9. If more than one file is in the expected parent folder, the match is genuinely ambiguous. Do not guess. Use:
   unavailable
10. If no file is in the expected parent folder, wait 30 seconds and search again.
11. Maximum 3 searches per file.
12. If there is still no file in the expected parent folder, use:
    unavailable
13. Use only a link returned by the connector in the current search. Never construct a Drive URL. Never reuse a Drive link from an earlier result or run.
14. If the connector itself does not work, use:
    SOURCE: unavailable
    for every source.
15. When the connector itself fails, add:
    LINK_ERROR: [short reason]
16. If a particular file cannot be found but the connector works, do not add LINK_ERROR. Use unavailable for that source.

## ASK result format

STATUS: COMPLETED
JOB_ID: [job filename without .md]
ACTION: ASK

RESPONSE: [concise response]

SOURCE: [link 1] | [link 2] | [link 3]
SOURCE_PATHS: [path 1] | [path 2] | [path 3]

The sequence in SOURCE and SOURCE_PATHS must be identical. If there are multiple sources, use the same position in both lines.

If a link cannot be obtained, write unavailable in that position:

SOURCE: unavailable
SOURCE_PATHS: 30_resources/solar_capex.md

If the response is not covered by the vault:

RESPONSE: Your notes don't cover this.
SOURCE: none
SOURCE_PATHS: none
