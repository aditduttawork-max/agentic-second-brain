# ASK Source Rules

## Purpose

Define how ASK results select and link supporting vault files.

## Source limits

- Use a maximum of 3 supporting sources.
- Every source must materially support the answer.
- If no vault note supports the answer, use `SOURCE: none` and `SOURCE_PATHS: none`.

## Required source fields

For each source, return:

```text
SOURCE: [real Google Drive link]
SOURCE_PATHS: [vault-relative/path.md]
```

Use forward slashes in `SOURCE_PATHS`.

## Google Drive lookup

1. Identify the expected vault-relative path.
2. Convert it to the expected parent folder under `My Drive/Instinct/Obsidian/Second brain/`.
3. Search Google Drive for the exact filename.
4. Check the full parent-folder chain for every match.
5. Keep only matches in the expected folder.
6. If more than one match remains in the expected folder, mark the source unavailable.
7. If no match remains, wait 30 seconds and search again.
8. Repeat at most 3 searches.
9. If the connector fails, mark every source unavailable and add `LINK_ERROR`.

Never construct a Google Drive URL.

Never reuse an old Drive link.

Ignore same-name files in other folders, including archive folders.

## Unavailable source

If a specific source cannot be resolved while the connector works, use:

```text
SOURCE: unavailable
SOURCE_PATHS: [vault-relative/path.md]
```

If the connector itself fails, use:

```text
SOURCE: unavailable
SOURCE_PATHS: unavailable
LINK_ERROR: [short reason]
```

## Instinct delivery

When Instinct reads an ASK result:

1. Read `SOURCE` and `SOURCE_PATHS`.
2. If `SOURCE` contains a real link, send that link with the `RESPONSE`.
3. If a link is `unavailable`, find the file in Google Drive at `My Drive/Instinct/Obsidian/Second brain/` + the path from `SOURCE_PATHS`.
4. Send a link only if Google Drive returns it.
5. If no link is available, send only the `RESPONSE`.
6. Never change a result file.

## Scope

These rules apply to ASK queue results only. Do not change PROCESS, CONNECT, REVIEW, SUMMARIZE, or PROMPT behavior.
