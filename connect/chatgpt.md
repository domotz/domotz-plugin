# ChatGPT

Needs a ChatGPT plan that supports custom plugins (MCP connectors) and skills.

## 1. Connect Domotz

1. In ChatGPT, open **Plugins → Add** and add a custom plugin with the MCP server URL
   `https://mcp.domotz.com/mcp`.
2. Sign in with your Domotz account when asked. ChatGPT acts with that account's permissions.

## 2. Add the playbooks

1. Download the playbooks you want from the latest release:
   [**alert-tune-up.zip**](https://github.com/domotz/domotz-ai-playbooks/releases/latest/download/alert-tune-up.zip),
   [**site-check-up.zip**](https://github.com/domotz/domotz-ai-playbooks/releases/latest/download/site-check-up.zip).
2. In ChatGPT, open **Skills → Add → Upload from your computer** and select a zip.

**Updating to a new version:** uploading a zip with the same name does not replace the skill you
already have. Open the skill with **⋯ → Edit** instead: replace the text below the name and
description with the new `SKILL.md` (everything after its `---` header), upload the new
`report-template.html` and remove the old one, then **Save changes**.

## 3. Ask

Start a new chat, choose the Domotz plugin under **Plugins** below the message box, and ask:

> Run an alert tune-up for my client Acme for the last 14 days.

ChatGPT reads your alert history, shows a report and numbered batches of fixes, and changes
nothing until you approve a batch. Where it can, it also shows the report as a one-page review.
