---
name: plan-from-ticket
description: Build an implementation plan from a Linear ticket URL, issue key, or raw task idea. Fetch issue via Linear MCP when a Linear ticket is provided, then directly run /caveman, ce-brainstorm, ce-plan, deslop, code-simplifier, and ce-doc-review with an execution ledger proving each step ran. Use when the user says plan from ticket, plan this Linear issue, shares a ticket link or key, or gives an idea they want turned into a plan.
disable-model-invocation: true
---

# Plan From Ticket

Use this skill for a full planning workflow from a Linear issue or raw task idea with minimal back and forth.

## Communication Mode

- Always use caveman language throughout this workflow.
- Load and follow `/caveman` in full mode at the start of the skill.
- Keep caveman style in:
  - brainstorm discussion
  - requirements doc
  - plan doc
  - document review feedback
  - final closeout
- Keep technical meaning exact. Compress words, not correctness.
- Do not mention `caveman`, caveman mode, or style instructions inside generated requirements docs, plan docs, or review artifacts.
- Generated docs should simply read in the desired terse style without explaining the style.
- If a warning, irreversible action, or high-risk clarification needs extra precision, briefly use clearer normal wording for that part, then resume caveman.

## Non-Skip Contract

This skill is an ordered workflow, not guidance. The agent must execute every required step before final handoff.

- Before starting, create a visible execution ledger in the working notes with one row for each required step:
  - Linear MCP when the source is a Linear URL or issue key
  - `/caveman`
  - `ce-brainstorm`
  - `ce-plan`
  - `deslop`
  - `code-simplifier`
  - `ce-doc-review`
- Mark each ledger row `pending`, then `ran` only after that skill or MCP step actually ran.
- Do not infer that a skill ran because another skill mentioned similar work. Each named skill must be invoked directly.
- Do not combine `deslop`, `code-simplifier`, or `ce-doc-review` into one cleanup or review pass. They are separate required steps.
- If a required skill cannot run because a tool, auth, or environment step fails, stop and report the blocker. Do not produce a final plan.
- Before final response, verify the ledger shows `ran` for every required row. If any required row is not `ran`, run it before responding.

## Goal

Turn a ticket or idea into a reviewed implementation plan with this required flow:

1. Linear MCP when available
2. `ce-brainstorm`
3. `ce-plan`
4. `deslop`
5. `code-simplifier`
6. `ce-doc-review`

Do not implement code in this skill. Stop at a reviewed plan unless the user explicitly asks to continue.

## Input

Accept either:

- a Linear issue URL
- a Linear issue key like `SOF-1234`
- a raw idea or task description

If the user gives none of these, ask for one.

## Workflow

### 1. Get the source context first

- If the user provided a Linear URL or issue key:
  - treat the ticket as the primary source of truth
  - use the Linear MCP
  - read the Linear MCP tool schema before calling any tool
  - if auth is required, handle auth first
  - fetch enough issue context to plan responsibly:
    - title
    - description
    - identifiers
    - labels
    - project or team if available
    - linked docs or URLs if present
    - comments only if they look relevant to scope or requirements
  - after the Linear context is fetched, mark Linear MCP as `ran` in the execution ledger
- If the user provided a raw idea or task description:
  - use that idea as the primary source of truth
  - do not require a Linear ticket before continuing

Normalize the source into a short working summary before choosing the next step.

### 2. Always run `ce-brainstorm`

- Pass the source summary into `ce-brainstorm`.
- Always invoke `ce-brainstorm` directly, even when the ticket looks clear.
- After it finishes, mark `ce-brainstorm` as `ran` in the execution ledger.
- Use brainstorm to tighten product or behavior clarity and make sure the relevant codebase context is understood before planning.
- Use brainstorm to identify what parts of the codebase, existing patterns, constraints, and surrounding workflows matter for this task before deciding what actions are necessary.
- Goal: produce a requirements doc and enough shared context that planning does not invent behavior or miss important codebase realities.
- If the user already gave strong corrections in chat, include them as part of the source context.

### 2.5 Ask only wrapper-level questions

- Let `ce-plan` handle normal planning questions.
- Do not add extra generic questioning on top of `ce-plan`.
- Ask the user before planning starts if source inputs conflict in a material way, such as:
  - ticket title says one thing but description says another
  - comments or linked docs materially disagree with ticket body
  - raw idea in chat materially conflicts with Linear ticket context
- Ask the user before planning starts if brainstorm or codebase research reveals 2 real scope interpretations that would lead to meaningfully different plans.
- Ask one question at a time. Keep it short. Resolve wrapper-level ambiguity first, then continue into `ce-plan`.

### 3. Run `ce-plan`

After the source and relevant codebase context are clear enough:

- run `ce-plan`
- invoke `ce-plan` directly
- use the brainstorm requirements doc if one was created
- otherwise plan directly from the source summary
- make sure the plan reflects what the codebase actually does today, what patterns already exist, and what changes are truly necessary
- after it finishes, mark `ce-plan` as `ran` in the execution ledger

The plan must stay scoped to the provided ticket or idea unless the user explicitly asks to widen scope.

### 4. Clean plan with `deslop`

After `ce-plan` writes the plan:

- run `deslop` on the generated plan document
- invoke `deslop` directly
- use it as a cleanup pass to remove AI slop, extra filler, repetitive wording, and awkward plan language
- preserve scope, meaning, requirements traceability, and technical intent
- after it finishes, mark `deslop` as `ran` in the execution ledger

### 5. Clean plan with `code-simplifier`

After `deslop`:

- run `code-simplifier` on the generated plan document
- invoke `code-simplifier` directly
- use it to tighten clarity, reduce redundancy, and keep the plan easy to execute
- preserve exact intent and plan behavior
- after it finishes, mark `code-simplifier` as `ran` in the execution ledger

### 6. Ensure document review happens

The final output of this skill must be a reviewed plan.

- Always invoke `ce-doc-review` directly on the generated plan, even if `ce-plan` already included review.
- Use the review to verify the plan still matches the original source exactly:
  - nothing required by the ticket or idea was dropped
  - nothing was only partially covered when the source clearly required full coverage
  - nothing unnecessary was added beyond the ticket or idea scope
  - the final plan still satisfies the source's correctness requirements, acceptance criteria, and stated constraints
  - required documentation updates were identified and included when needed
- If review finds drift, gaps, overreach, or weak correctness coverage, fix the plan before handoff.
- After review finishes and all required fixes are applied, mark `ce-doc-review` as `ran` in the execution ledger.

### 7. Update relevant docs when needed

- Check whether the planned change should also update docs.
- If the ticket or idea changes behavior, developer workflow, operations, observability, configuration, APIs, or user-facing flows, make sure the plan calls out the relevant doc updates.
- Prefer updating existing docs over inventing new docs unless a new document is clearly needed.
- Include doc work in the plan only when it is actually necessary for correctness, onboarding, operations, or future maintainability.
- If no doc updates are needed, say that clearly rather than leaving it ambiguous.

### 8. Stop at planning

Do not start implementation, `ce-work`, or code edits unless the user explicitly asks.

At the end, return:

- the Linear issue key if one exists
- otherwise note that the source was a raw idea
- confirm that every required skill ran:
  - `/caveman`
  - `ce-brainstorm`
  - `ce-plan`
  - `deslop`
  - `code-simplifier`
  - `ce-doc-review`
- confirm Linear MCP ran when the source was a Linear URL or issue key
- the final plan path
- any major unresolved planning questions that remain

## Decision Rules

### Default behavior

- Always use caveman language throughout whole flow, including generated docs.
- Always load `/caveman` before source fetching or planning, then mark `/caveman` as `ran` in the execution ledger.
- Always run `ce-brainstorm` before planning.
- Always run `ce-plan` after `ce-brainstorm`.
- Always run `deslop` and `code-simplifier` on the generated plan before the final handoff.
- Always run `ce-doc-review` after `code-simplifier`.
- Never send final output until the execution ledger proves every required skill ran.
- Prefer the smallest scope that still produces a reliable plan.

### What not to do

- Do not jump straight into implementation.
- Do not skip Linear MCP when the user provided a Linear URL or key.
- Do not skip any named skill because its work seems redundant.
- Do not say a skill ran unless it was invoked directly in this workflow.
- Do not silently ignore linked docs that materially change scope.
- Do not widen the ticket into adjacent cleanup unless the user asks.

## Examples

### Example 1

Input:

```text
/plan-from-ticket https://linear.app/factmachine/issue/SOF-1234/add-correlation-ids
```

Behavior:

- fetch issue through Linear MCP
- load `/caveman`
- run `ce-brainstorm`
- run `ce-plan`
- run `deslop`
- run `code-simplifier`
- run `ce-doc-review`
- verify execution ledger before final output

### Example 2

Input:

```text
/plan-from-ticket SOF-1389
```

Behavior:

- fetch issue through Linear MCP
- load `/caveman`
- run `ce-brainstorm`
- then run `ce-plan`
- run `deslop`
- run `code-simplifier`
- run `ce-doc-review`
- verify execution ledger before final output

### Example 3

Input:

```text
/plan-from-ticket add correlation ids to every backend request log and response error path
```

Behavior:

- use the raw idea as source context
- load `/caveman`
- run `ce-brainstorm`
- then run `ce-plan`
- run `deslop`
- run `code-simplifier`
- run `ce-doc-review`
- verify execution ledger before final output

## Output Shape

Keep the closeout brief:

```text
Ticket: SOF-1234
Skills: /caveman ran, ce-brainstorm ran, ce-plan ran, deslop ran, code-simplifier ran, ce-doc-review ran
Linear MCP: ran
Plan: /absolute/path/to/docs/plans/...
Open questions: none
```

If no Linear ticket exists:

```text
Source: raw idea
Skills: /caveman ran, ce-brainstorm ran, ce-plan ran, deslop ran, code-simplifier ran, ce-doc-review ran
Plan: /absolute/path/to/docs/plans/...
Open questions: none
```
