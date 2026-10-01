# ChatGPT

Needs a ChatGPT plan that supports custom plugins (MCP connectors) and skills.

## 1. Connect Domotz

1. In ChatGPT, open **Plugins → Add** and add a custom plugin with the MCP server URL
   `https://mcp.domotz.com/mcp`.
2. Sign in with your Domotz account when asked. ChatGPT acts with that account's permissions.

## 2. Add the playbook

1. Download [**alert-tune-up.zip**](https://github.com/domotz/domotz-ai-playbooks/releases/latest/download/alert-tune-up.zip)
   from the latest release.
2. In ChatGPT, open **Skills → Add → Upload from your computer** and select the zip.

## 3. Ask

Start a new chat, choose the Domotz plugin under **Plugins** below the message box, and ask:

> Run an alert tune-up for my client Acme for the last 14 days.

ChatGPT reads your alert history, shows a report and numbered batches of fixes, and changes
nothing until you approve a batch. Where it can, it also offers the report as a one-page review.
