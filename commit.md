---
name: commit
description: Generate a Conventional Commit message from all changes since the last commit.
model: gpt-5.5
---

Generate a commit message from the current repository changes since `HEAD`. NEVER actually commit unless the user tells you to.

Follow the [Conventional Commits 1.0.0 summary](https://www.conventionalcommits.org/en/v1.0.0/#summary):

- Format the title as `<type>[optional scope]: <description>`
- Use lowercase commit types
- Prefer these types when they fit: `feat`, `fix`, `refactor`, `test`, `docs`, `build`, `ci`, `chore`, `perf`
- Use `!` and a `BREAKING CHANGE:` footer only when the diff clearly introduces a breaking change

What to analyze:

1. Inspect all staged and unstaged changes since the last commit.
2. Review the changed files and the actual diff, not just filenames.
3. Check recent commit messages to match the repository's tone and scope style.

How to decide the message:

- Choose the single best commit type for the primary intent of the changes.
- Add a scope only if one is clearly helpful and consistent with recent history. This should be either the app/package that has chaned (e.g. backend, core, math, etc...)
- Write a short subject line that explains the main outcome, not a vague summary.
- Write a brief body that explains the most important changes and why they matter.
- If the work spans multiple areas, unify them under the main purpose instead of listing every file.
- Do not invent behavior, tickets, or breaking changes that are not present in the diff.

Output rules:

- Return only one copy-ready commit message in a single Markdown code block.
- Do not include commentary before or after the code block.
- Keep the subject concise.
- Keep the body short and useful.
- If there are no changes since `HEAD`, output `No changes to commit.` in a code block.

Preferred output shape:

```text
type(scope): short summary

Why this change matters.

- Key change one
- Key change two
```
