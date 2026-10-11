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

## 2. Add the playbooks

Install the repository as a plugin. It bundles both playbooks and the Domotz connector, so you can
skip step 1 if you sign in when prompted:

```text
/plugin marketplace add domotz/domotz-plugin
/plugin install domotz@domotz
```

Or copy a single playbook folder into your skills directory:

```bash
git clone https://github.com/domotz/domotz-plugin
mkdir -p ~/.claude/skills
cp -r domotz-plugin/skills/alert-tune-up ~/.claude/skills/
```

## 3. Ask

```text
Run an alert tune-up for my client Acme for the last 14 days.
```

Claude Code asks for permission before each tool call unless you allow it. Allow the Domotz
read tools freely; keep the write tools (`bind_*`, `unbind_*`, `update_alert_rule`,
`update_device_metadata`, `update_collector_settings`) on ask.
