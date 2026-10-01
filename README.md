# Domotz AI Playbooks

Ready-made workflows that let your AI assistant do real network-operations work in your
Domotz account: read the data, explain what it means, and make the changes you approve.

Built for Claude; other MCP clients can paste the playbook. Each playbook is a single
instruction file (an [Agent Skill](https://agentskills.io)). There is no script to run:
connect your assistant to the Domotz MCP server, add the playbook, and ask.

## Playbooks

| Playbook | What you get | Changes it can make |
|---|---|---|
| [Alert tune-up](use-cases/alert-tune-up/) | Which alerts are noise, which rules need a better threshold, which are real signal, with evidence and ready-to-approve fixes ([example](use-cases/alert-tune-up/example-report.md)) | Unbind rules, adjust thresholds (only after you approve, all reversible) |

More are on the way.

Playbooks need a frontier model (Claude Sonnet or Opus, or an equivalent). Small fast models
follow the steps but are not reliable at the counting these audits need.

## Get started

You need a Domotz account and an AI assistant that can use MCP connectors.

### 1. Connect your assistant to Domotz

[Claude (web and desktop)](connect/claude-ai.md) ·
[Claude Code](connect/claude-code.md) ·
[Other MCP clients](connect/other-clients.md)

### 2. Install the playbook

**Claude (web and desktop):**

1. Download [**alert-tune-up.zip**](https://github.com/domotz/domotz-ai-playbooks/releases/latest/download/alert-tune-up.zip) from the
   latest release.
2. In Claude, open **Customize → Skills**, add a skill, and upload the zip.
3. Check that the skill is switched on.

**Claude Code:** copy the playbook folder into your skills directory:

```bash
git clone https://github.com/domotz/domotz-ai-playbooks
mkdir -p ~/.claude/skills
cp -r domotz-ai-playbooks/use-cases/alert-tune-up ~/.claude/skills/
```

**Any other assistant:** paste the contents of
[`use-cases/alert-tune-up/SKILL.md`](use-cases/alert-tune-up/SKILL.md) as the first message of
a chat, then ask your question.

### 3. Ask

> Run an alert tune-up for my client Acme for the last 14 days.

More starter prompts: [prompts.md](use-cases/alert-tune-up/prompts.md).

Your assistant talks to Domotz directly; your data never passes through anything in this
repository.

## How playbooks behave

Every playbook follows the same rules ([CONTRIBUTING.md](CONTRIBUTING.md)):

- **Read first, change later.** Nothing changes in your account until you approve a
  numbered batch of changes.
- **Only reversible changes**, each with its undo shown before and after.
- **Evidence, not opinions.** Every recommendation cites the counts, devices and dates it
  is based on, and the report says exactly what data it covered.
- **One client at a time.** A batch never mixes organizations.

Each playbook is tested on real Domotz data before release, including applying its changes
and undoing them.

## License

[MIT](LICENSE)
