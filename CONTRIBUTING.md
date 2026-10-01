# The playbook contract

Every playbook in `use-cases/` follows this contract, so users get the same behaviour
whichever one they run.

## Shape

- One folder per playbook: `use-cases/<name>/`.
- `SKILL.md` is the playbook. It must be **self-contained**: a user can paste it into a chat
  (any client without skill support) and it still works. No scripts, no code execution, and no
  other file it depends on. An optional extra, such as an HTML report template, may sit next to
  it if the playbook works without it.
- `README.md`: what it does, for a human deciding whether to use it.
- `prompts.md`: starter prompts and useful follow-ups.
- `example-report.md`: what a report looks like.
- `SKILL.md` frontmatter: `name` (lowercase, hyphens, ≤ 64 characters) and a `description`
  (≤ 1,024 characters) that says what it does *and* when to use it.

## Flow

Every playbook moves through the same phases, in order:

1. **Scope**: which client, collectors and time window. Ask only what can't be inferred.
2. **Fetch**: read-only tool calls. Page to exhaustion or say what was not read.
3. **Analyse**: fixed, named checks in a fixed order, so runs are repeatable.
4. **Report**: a fixed markdown template (no code blocks): the headline number and coverage first, then findings with their reason and key number; full evidence on request. An optional HTML template may ship next to `SKILL.md`; the assistant fills only its data block.
5. **Approve**: numbered batches of changes. Nothing is changed before approval.
6. **Apply**: record the before-state, apply, verify by reading again, show the undo.

## Rules for changes

- Read-only until the user approves a batch **by its number**. A general "go ahead" given
  before the batches are shown is not approval.
- Only reversible changes. Never delete, never change something whose current state can't be
  read back (so it could not be restored).
- Irreversible actions (such as resolving alerts) only as a separate, optional batch that says
  it cannot be undone.
- One organization per batch; at most 10 changes per batch.

## Rules for numbers

- Every number in a report comes from data fetched in the same conversation.
- Prefer counts the server computes (`total_count` on a filtered query) over the model's own
  addition.
- The report states what it covered, and labels anything partial as partial.

## Language

- "Collector", never "agent". "Drivers", never "scripts".
- Name devices and rules by name, with ids in brackets.
- Never hardcode facts about one account. Probe at runtime.

## Testing

A playbook is ready when it has been run on real Domotz data with at least two models and
shows correct counts, recommendations a competent MSP engineer agrees with, no harmful
recommendation, zero changes made before approval, and an apply → undo round trip that leaves
the account exactly as it was.
