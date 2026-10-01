# Claude Code

## 1. Connect Domotz

With an MCP API key (Domotz webapp → **Account → Domotz MCP API → Create MCP API Key**):

```bash
claude mcp add --transport http domotz https://mcp.domotz.com/mcp \
  --header "Authorization: Bearer <your-mcp-api-key>"
```

Or without a key, and sign in when prompted:

```bash
claude mcp add --transport http domotz https://mcp.domotz.com/mcp
```

## 2. Add a playbook

Copy the playbook folder into your skills directory:

```bash
git clone https://github.com/domotz/domotz-ai-playbooks
mkdir -p ~/.claude/skills
cp -r domotz-ai-playbooks/use-cases/alert-tune-up ~/.claude/skills/
```

## 3. Ask

```text
Run an alert tune-up for my client Acme for the last 14 days.
```

Claude Code asks for permission before each tool call unless you allow it. Allow the Domotz
read tools freely; keep the write tools (`unbind_*`, `bind_*`, `update_alert_rule`) on ask.
