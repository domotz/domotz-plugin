# The playbook contract

Every playbook in `skills/` follows this contract, so users get the same behaviour
whichever one they run. Know-how skills (`skills/domotz-*`) have their own, shorter contract at
the end.

## Shape

- One folder per playbook: `skills/<name>/`. The repository root is a Claude plugin
  (`.claude-plugin/plugin.json`, `.mcp.json`); raise `version` in both `plugin.json` files with
  every release, then push a `v<version>` tag: the Release workflow builds the zips and attaches
  them to the GitHub release.
- Only Markdown, text, JSON, YAML and PNG/JPEG images go in the repository. The Claude plugin
  directory refuses any other file (HTML, scripts, files starting with `#!`) from organizations
  it has not verified, so an HTML template ships as `report-template.md`, with the HTML in one
  code block, and the build lives in `.github/workflows/release.yml`.
- `SKILL.md` is the playbook. It must be **self-contained**: a user can paste it into a chat
  (any client without skill support) and it still works. No scripts, no code execution, and no
  other file it depends on. An optional extra, such as the report template (`report-template.md`), may sit next
  to it if the playbook works without it.
- `README.md`: what it does, for a human deciding whether to use it.
- `prompts.md`: starter prompts and useful follow-ups.
- `example-report.md`: what a report looks like.
- `SKILL.md` frontmatter: `name` (lowercase, hyphens, ≤ 64 characters) and a `description`
  that says what it does *and* when to use it. Keep the description under 500 characters (the
  ChatGPT skill editor's limit; the Agent Skills limit is 1,024), and never put a colon followed
  by a space in it: strict YAML parsers, GitHub's included, reject it.

## Flow

Every playbook moves through the same phases, in order:

1. **Scope**: which client, collectors and time window. Ask only what can't be inferred.
2. **Fetch**: read-only tool calls. Page to exhaustion or say what was not read.
3. **Analyse**: fixed, named checks in a fixed order, so runs are repeatable.
4. **Report**: a fixed markdown template (no code blocks): the headline number and coverage first, then findings with their reason and key number; full evidence on request. An optional HTML template may ship next to `SKILL.md`; the assistant fills only its data block.
5. **Approve**: numbered batches of changes. Nothing is changed before approval.
6. **Apply**: record the before-state, apply, verify by reading again, show the undo.

A **report-only** playbook (such as the health report) stops after phase 4: it calls no tool
that changes anything, and points to the playbook that makes each fix it recommends.

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

# Know-how skills

`skills/domotz-*` hold Domotz product knowledge, not a procedure: how alerting, discovery,
collectors, accounts, security and pricing work, and which tools apply. The assistant loads one
on its own when a question needs it.

- **Source.** They are the plugin's copy of the knowledge skills of the AI assistant inside the
  Domotz app. Keep the facts in step with that source, but adapt anything that only holds inside
  the app: links relative to the web app, skills the plugin doesn't ship, statements about "the
  AI Agent" that would describe the user's own assistant wrongly.
- **Shape.** `SKILL.md` (self-contained: no extra files) and `README.md`. The frontmatter rules
  above apply, and the description says what the skill knows and when to load it.
- **Public.** This repository is public: never include material written for one customer, such as
  their questionnaire answers, or anything that names a customer.
- **Changes.** The rules for changes above apply, one change at a time instead of batches: change
  only after the user approves that exact change, say how to undo it, say before approving when
  something cannot be undone, and never delete (removing a routed network or an External Host
  deletes devices and their history, so it is the user's action in the app).
- **Secrets.** Never pass a password, community or key through the chat or a tool argument: use
  the Domotz credentials forms, or the app.
- **Prices.** State only the published starting price; everything else goes to sales.
