# Domotz

The Domotz plugin for Claude and ChatGPT: ready-made playbooks that let your AI assistant do
real network-operations work in your Domotz account, and Domotz know-how it uses to answer
how-to questions. It reads the data, explains what it means, and makes only the changes you
approve. The plugin bundles the playbooks, the know-how and the Domotz connector, so once it is
listed in your assistant's plugin directory you add it, sign in to Domotz, and ask.

Works in Claude and ChatGPT; other MCP clients can paste the playbook. Each playbook is a single
instruction file (an [Agent Skill](https://agentskills.io)). There is no script to run:
connect your assistant to the Domotz MCP server, add the playbook, and ask.

## Playbooks

| Playbook | What you get | Changes it can make |
|---|---|---|
| [Alert tune-up](skills/alert-tune-up/) | Which alerts are noise, which rules need a better threshold, which are real signal, with evidence and ready-to-approve fixes ([example](skills/alert-tune-up/example-report.md)) | Unbind rules, adjust thresholds (only after you approve, all reversible) |
| [Site check-up](skills/site-check-up/) | Is a new (or existing) site ready: what would never alert, what isn't marked important, which credentials and backups are missing, with fixes to approve | Bind "went down" rules, set importance, turn the open-port scanner on or off (only after you approve, all reversible) |
| [Health report](skills/health-report/) | The monthly report for a client: availability of their important devices, outages, alerts and the work you did, compared with the month before, as a client-ready page plus a technician appendix ([example](skills/health-report/example-report.md)) | None: read-only |

More are on the way.

## Domotz know-how

Skills your assistant loads on its own when a question needs them. They carry the same facts as
the AI assistant inside the Domotz app, and work with or without a playbook.

| Skill | What it answers | Changes it can make |
|---|---|---|
| [Alerting](skills/domotz-alerting/) | Alert rules, contact channels (Teams, Slack, webhooks), alerts when the internet goes down, snoozing, PSA tickets and IT Glue sync, and why an alert or ticket didn't arrive | Create, update, bind and unbind rules, snooze a collector, map PSA and documentation customers (each after you approve) |
| [Device discovery](skills/domotz-device-discovery/) | Missing devices (VLANs, subnets, VPNs, cloud), wrong device types, credentials and ports, the network map, configuration backups | Add routed networks and External Hosts, scan settings, device types, importance and monitoring (each after you approve) |
| [Collector setup](skills/domotz-collector-setup/) | Installing, sizing, activating, troubleshooting, updating, moving and removing collectors | Collector name, location and settings (after you approve) |
| [Account management](skills/domotz-account-management/) | Users and Access Sets, 2FA and SSO, billing and subscription, API keys, connecting AI clients through MCP | None |
| [Contact Domotz](skills/domotz-contact-support/) | When and how to reach Domotz support or sales, with a message ready to send | None |
| [Security and compliance](skills/domotz-security-compliance/) | Certifications, data residency, encryption, access control, privacy, subprocessors, AI and data, vendor questionnaires | None |
| [Pricing and plans](skills/domotz-pricing-and-plans/) | Per-location and per-device pricing, the free trial, billing terms, the Domotz Box, marketplaces | None |

Playbooks need a frontier model (Claude Sonnet or Opus, or an equivalent). Small fast models
follow the steps but are not reliable at the counting these audits need.

## Get started

You need a Domotz account and an AI assistant that can use MCP connectors.

### 1. Connect your assistant to Domotz

[Claude (web and desktop)](connect/claude-ai.md) ·
[ChatGPT](connect/chatgpt.md) ·
[Claude Code](connect/claude-code.md) ·
[Other MCP clients](connect/other-clients.md)

### 2. Install the playbooks

**As a plugin:** this repository is a plugin for Claude (`.claude-plugin/plugin.json`) and for
ChatGPT (`plugin.json`, Agent Plugins format) that bundles the playbooks and the Domotz
connector. In Claude Code, add this repository as a plugin marketplace and install it:

```text
/plugin marketplace add domotz/domotz-plugin
/plugin install domotz@domotz
```

The playbooks then appear as `/domotz:alert-tune-up`, `/domotz:site-check-up` and
`/domotz:health-report`, the know-how skills load on their own when a question needs them, and
`/mcp` shows the Domotz connector, which asks you to sign in to Domotz the first time it is used.

**Claude (web and desktop), one playbook at a time:**

1. Download the playbook's zip, for example [**alert-tune-up.zip**](https://github.com/domotz/domotz-plugin/releases/latest/download/alert-tune-up.zip) from the
   latest release.
2. In Claude, open **Customize → Skills**, add a skill, and upload the zip.
3. Check that the skill is switched on.

**ChatGPT:** download the same zip and upload it under **Skills → Add → Upload from your
computer**.

**Claude Code:** copy the playbook folder into your skills directory:

```bash
git clone https://github.com/domotz/domotz-plugin
mkdir -p ~/.claude/skills
cp -r domotz-plugin/skills/alert-tune-up ~/.claude/skills/
```

**Any other assistant:** paste the contents of
[`skills/alert-tune-up/SKILL.md`](skills/alert-tune-up/SKILL.md) as the first message of
a chat, then ask your question.

### 3. Ask

> Run an alert tune-up for my client Acme for the last 14 days.

More starter prompts: [prompts.md](skills/alert-tune-up/prompts.md).

## What data it uses and sends

- The playbooks read and change data only in **your own Domotz account**, through the Domotz MCP
  server at `https://mcp.domotz.com/mcp`, signed in as you and limited to your permissions. They
  run inside your AI assistant, so what they read is processed by that assistant's provider
  under your agreement with them.
- Changes happen only after you approve them. Playbooks propose numbered batches of reversible
  changes; the know-how skills ask before each change and say when one cannot be undone (such as
  resolving an alert). Neither deletes devices, rules, networks or hosts.
- They never ask for, store or send passwords or other credentials.
- The optional one-page review is an HTML page your assistant builds from the template in
  `report-template.md`. It loads its fonts from Google Fonts (`fonts.googleapis.com`) and
  sends nothing anywhere.
- The plugin has no scripts, hooks or other servers, and nothing in this repository receives
  your data.

## How playbooks behave

Every playbook follows the same rules ([CONTRIBUTING.md](CONTRIBUTING.md)); the know-how skills
ask before each change instead of in batches, and say when one cannot be undone:

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
