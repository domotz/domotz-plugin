# Claude (claude.ai and Claude Desktop)

Needs a Claude plan that includes custom connectors and skills (Pro, Max, Team or
Enterprise).

## 1. Connect Domotz

1. In Claude, open **Customize → Connectors** and choose **Add → Custom connector**.
2. Name it `Domotz` and enter the URL `https://mcp.domotz.com/mcp`.
3. Click **Connect** and sign in with your Domotz account. Claude acts with that account's
   permissions.
4. Optional: under the connector's **Tool permissions**, keep write tools on
   **Needs approval**. The playbooks already ask before changing anything; this adds a second
   confirmation in Claude itself.

## 2. Add a playbook

1. Download [**alert-tune-up.zip**](https://github.com/domotz/domotz-ai-playbooks/releases/latest/download/alert-tune-up.zip) from the
   latest release.
2. In Claude, open **Customize → Skills**, add a skill, and upload the zip.
3. Check that the skill is switched on.

No skill support on your plan? Paste the contents of the playbook's `SKILL.md` as the first
message of a chat, or into a Project's instructions, and continue from there.

## 3. Ask

Start a new chat and ask, for example:

> Run an alert tune-up for my client Acme for the last 14 days.

Claude will read your alert history, show a report and numbered batches of fixes, and wait
for you to approve them. An audit usually takes 4–7 minutes and 40–60 tool calls; if Claude
says it reached its tool-use limit for the turn, reply **continue**.
