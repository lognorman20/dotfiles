---
name: pr-summary-drafting
description: Use when drafting PR summaries, diff overviews, or PR descriptions. Trigger phrases include "write a PR summary", "PR overview", "diff overview", "PR description", or "copyable PR body".
disable-model-invocation: true
---

# PR Summary Drafting

## TLDR

Write concise PR summaries that help reviewers understand: what changed, why, and how it was verified. Output a single copyable markdown block starting with `## TLDR`.

## Inputs

Determine the base branch:
1. If a PR exists: `gh pr view --json baseRefName -q .baseRefName`
2. Otherwise ask the user, or default to `staging`

Then run:
- `git diff $(git merge-base HEAD <base>)...HEAD` for the full diff
- `git log --oneline $(git merge-base HEAD <base>)..HEAD` for commit context

If a Linear ticket is provided, use it for additional context.

## Output Format

Return one copyable markdown code block. First line MUST be `## TLDR`. No `#` titles before it, no `### TL;DR` variant.

```markdown
## TLDR

[1-2 sentences: core change + impact]

## Why make this change?

[Problem, motivation, reviewer context]

## What changed?

[Meaningful changes grouped by behavior, not file-by-file]

## Verification

[Exact tests, commands, manual checks, or placeholder if unverified]

## Notes

[Optional: migrations, rollout risks, follow-ups, reviewer focus areas]
```

Omit `Notes` when empty.

## Style Rules

- Concrete behavior over file inventory
- Group by outcome, not implementation order
- No emojis, no long code snippets
- Clear product/engineering language, no filler
- If verification is missing, say so explicitly

## Example

```markdown
## TLDR

Replaced hand-written test mocks with factory classes so fixtures stay aligned with real database shapes.

## Why make this change?

Hand-written mocks duplicate schema fields, require manual updates when models change, and drift from production data. Factory-backed fixtures centralize construction and reduce maintenance.

## What changed?

Tests now use `CommentFactory`, `OrderFactory`, `UserFactory`, etc. instead of plain objects with hardcoded values. Indexer helpers like `seedTransaction` use `TransactionFactory` instead of raw Prisma writes.

## Verification

`pnpm run backend:test:ut` - all specs pass.
```
