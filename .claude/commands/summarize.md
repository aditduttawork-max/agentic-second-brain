---
description: Make a concise PDF briefing note on a topic from vault notes (summary first, Sources on a new page)
argument-hint: <topic> [VAULT_ONLY | VAULT_AND_WEB]
---

Summarize this topic from my vault:

$ARGUMENTS

## Inputs

- TOPIC: the exact topic words.
- SCOPE: `VAULT_ONLY` (default) or `VAULT_AND_WEB`.
- If SCOPE is missing, use `VAULT_ONLY`.

## Before you write

1. Read CLAUDE.md first and follow it throughout.
2. Check relevant Maps of Content in _system/maps first, if they exist.
3. Search the vault for TOPIC, its key terms, synonyms and related concepts.
4. Read every relevant note fully.
5. Do not modify, create, move or delete any notes. Only create the two summary files.
6. VAULT_ONLY: use only information in the vault.
7. If VAULT_ONLY and the vault does not cover TOPIC:
   - RESPONSE: Your notes don't cover this.
   - Do not create a Markdown file or a PDF.
8. VAULT_AND_WEB: you may use external research.
   - Label every external claim SOURCE CLAIM.
   - Put every external URL in Sources.
   - Vault notes remain the first source.

## Files

Folder: `60_outputs/summaries/`

Names:

- `[topic]_summary_YYYY_MM_DD.md`
- `[topic]_summary_YYYY_MM_DD.pdf`

`[topic]` is a short lowercase_with_underscores form of TOPIC. Use today's date.

If a summary of the same topic already exists:

1. Read the old version.
2. Create a new dated version.
3. Do not modify the old version.
4. Add a wikilink to the old version in Sources.

## Markdown structure

Start with YAML front matter. The PDF template reads `title` and `date`.

```markdown
---
title: "[Topic in plain words]"
date: "YYYY-MM-DD"
type: summary
topic: "[exact TOPIC]"
scope: VAULT_ONLY
---
```

Summary sections use `##`. `# Sources` is the only level-1 heading. The template starts a new page at every level-1 heading. Do not use `#` anywhere else.

The PDF is a concise, useful briefing note. It is not a full dump of the source notes.

Summary (main content):

1. Title and date: from the front matter. Do not repeat them in the body.
2. Synthesis: a concise synthesis of the topic in 2 to 4 sentences. Put it first. It can stand without a heading, or under a heading such as `## Executive summary`.
3. Flexible sections: choose the sections from the material. Possible sections include, but are not limited to:
   - Executive summary
   - Key ideas
   - Background
   - How it works
   - Architecture
   - Examples
   - Applications
   - Key numbers
   - Timeline
   - Risks / limitations
   - Different perspectives
   - Implications
   - Open questions
   - What to do next

Section rules:

- Use only sections that materially improve understanding.
- Do not create empty or low-value sections.
- The section names and their order depend on the topic.
- No section is required.

Sources (always on a new page after the summary):

4. `# Sources`: a numbered list. One line per source:
   - `1. [[note_name]] — supports: [what it supports].`
   - `2. [URL] — supports: [what it supports].` (VAULT_AND_WEB only)
   - `3. [[old_summary_name]] — previous version of this summary.` (only if one exists)

## Content selection

Core rule: information selection is more important than information coverage.

Discard information that is:

- repetitive
- trivial
- tangential
- obvious
- not useful for understanding the topic
- included only to fill available space

Do not try to represent everything in the source notes.

Prioritise, in this order:

1. Information that materially improves understanding.
2. Information that explains the core idea.
3. Important evidence, numbers or examples.
4. Important implications, risks or unanswered questions, when the notes support them.

Prefer omission over weak or repetitive content.

If the notes contain many facts, select the most decision-useful or explanatory facts. Do not list all of them.

In VAULT_ONLY mode, do not add facts from general knowledge.

## Length

- Strong preference: one page of substantive content.
- Use a second page only when the additional information is genuinely useful.
- Do not add information because space is available.
- Do not extend the document to use available space.
- Guide:
  - Simple topic: 1 page summary + Sources.
  - Normal topic: 1 page summary + Sources.
  - More complex topic: 2 pages summary + Sources.
  - Very complex topic: more pages only when genuinely necessary.
- Never fit content by reducing the font size, the margins, the line spacing or readability.
- If important information does not fit on one page, the summary may continue onto page 2.
- Sources always start on a new page after the summary.

## Writing rules

- Write in ASD-STE100 style.
- Descriptive sentences: 25 words or fewer.
- Procedural sentences: 20 words or fewer.
- One idea per sentence.
- Active voice.
- Simple, common words.
- Use the same term for the same thing.
- Explain technical terms on first use.
- Use numbered lists for sequences.
- Use tables for numbers and comparisons.
- Never use "should".
- Do not invent facts. Never present an inference as a fact.
- Use evidence labels (FACT, SOURCE CLAIM, MANAGEMENT GUIDANCE, MY VIEW, INFERENCE, QUESTION) only where they are needed to separate evidence types.
- Preserve my views as mine. Label them MY VIEW.

## Markdown rules for the PDF

- Do not write raw LaTeX.
- Write every dollar sign as `\$` so pandoc does not read it as maths.
- Obsidian callouts (`> [!note] Title`) are allowed. They render as boxes.
- Wikilinks render as note names. `[[note|Name]]` renders as "Name".
- Tables render with full borders.

## Convert to PDF

Run from the vault root:

```
pandoc "60_outputs/summaries/[name].md" -f markdown+wikilinks_title_after_pipe --pdf-engine=xelatex --template="_system/templates/summary_template.tex" --lua-filter="_system/templates/summary_filter.lua" -o "60_outputs/summaries/[name].pdf"
```

Requirements: pandoc 3.12 or later, XeLaTeX, Nirmala UI. Ignore the MiKTeX "not checked for updates" message.

Conversion attempts:

1. Maximum 3 conversion attempts.
2. If conversion fails, read the error, fix the Markdown, and try again.
3. Treat any pandoc `Missing character` warning as a failure. Fix the Markdown.
4. Never change the template, the filter, the font size, the margins or the line spacing to make a summary fit.

## Check the PDF

1. Page count: `pdfinfo "[name].pdf"`.
2. Page text: `pdftotext -enc UTF-8 -layout -f N -l N "[name].pdf" -`, one page at a time.
3. Find the page that starts with `Sources`. The pages before it hold the summary.
4. The summary pages must contain the title, the date and all summary sections, and nothing from Sources.
5. Sources must start on a new page after the summary.
6. Compare the PDF text with the Markdown:
   - Remove Markdown syntax (front matter keys, `#`, `**`, list markers, table pipes, `[!type]` markers, `[[` `]]`, the target part of piped wikilinks, and the `\` before `$`).
   - Normalise whitespace, quotes, and hyphens (pdftotext can return U+2010 for `-`).
   - Normalise spaces around symbols such as `→`. They use a fallback font, and pdftotext can drop the spaces next to them.
   - Every word, number, symbol and table row in the Markdown must appear in the PDF text.
7. Check the length against the Length rules:
   - If the summary runs past page 1, keep the extra content only if it is genuinely useful.
   - If it is not, shorten the content. Remove the least important points first.
   - Do not reduce the font, the margins, the line spacing or readability.
   - Convert and check again.
   - Maximum 3 shortening attempts.
8. If the PDF still fails after the attempts above:
   - Keep the Markdown file.
   - Return FAILED with a short REASON.

## Google Drive links

Get links for the PDF and the Markdown file.

Use the "Google Drive lookup sequence" in `.claude/commands/ask.md` for each file. Follow every step exactly, including the parent-folder check, the 30-second wait, the 3-search maximum and LINK_ERROR.

Never construct or guess a Google Drive URL.

## Result

When run from the queue (`/run`), write the result file in the SUMMARIZE format defined in `.claude/commands/run.md`.

When run directly, report:

- Bottom line in 1 or 2 sentences.
- PDF path and Drive link (or unavailable).
- Markdown path and Drive link (or unavailable).
- Page count, the number of summary pages, and whether Sources starts on a new page.
