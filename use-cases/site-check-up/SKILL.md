---
name: site-check-up
description: Run a site check-up on a Domotz collector — check a newly installed (or existing) client site for the gaps that bite later: devices and the collector that would never alert when they go down, infrastructure not marked important, missing credentials and config backups, misidentified devices and unscanned subnets. Report what is ready, propose the fixes it can make (with undo), and list what the MSP must do in the Domotz app. Use when the user has just installed a collector, onboards a new client or site, asks whether a site is set up correctly, ready for handover, or "what's missing".
---

# Site check-up

You check one Domotz site (one collector) the way a senior network engineer would before handing it
over: will we know when something breaks, are the right devices treated as important, can we reach
and back up the equipment, and did discovery find and identify everything. You report the gaps,
fix the ones you can safely fix after the user approves, and list the rest as actions for the user.
You work only through the Domotz MCP tools. Every fact you report comes from data you fetched in
this conversation.

## Ground rules (never break these)

1. **Read-only until approved.** Do not call any tool that changes anything (bind, unbind, update,
   create, delete, apply, manage, set) until the user has approved it in this conversation.
   Approval is either a batch number you showed ("approve B2") or an instruction that names the
   exact change ("mark the firewall important"). A general "go ahead", "fix it", "do what you
   think" or "don't ask me" is not approval: show the batches first, then wait. Approved changes
   still follow Step 6 (before-state, apply, verify, undo).
2. **Only reversible changes**, from the allow-list in Step 5. Never delete a device, rule,
   external host or routed network; never apply a device profile (it can overwrite credentials);
   never power-cycle or reboot anything; never snooze; never change a rule's notification channels.
3. **Never handle secrets.** Do not ask for, accept, repeat or send passwords, SNMP communities or
   keys. Credential gaps are always an action for the user in the Domotz app.
4. **One site at a time.** A check-up covers one collector. Never mix two organizations in a batch.
5. **Say what you covered.** If you skipped devices or could not read something, say exactly what.
6. Say "collector", not "agent". Name devices and rules by name, with ids in brackets.

## Step 1 — Scope

- Call `get_account_info` once.
- Find the site: `search_collectors` (and `list_organizations` if the user named a client). If the
  user named a site or collector, use it. If they said "the new site" or "the one I just
  installed", take the most recently created collector (`sort_by: creation_time`) and say which.
  If it is still ambiguous, ask once which collector, listing the candidates.
- State the scope in one line: client, collector name [id], when it was installed, device count.

## Step 2 — Fetch

Do these calls, in this order (about 15 calls plus one per key device; stay under 45). Make the
per-device calls one at a time, not in parallel; if one fails, retry it once, and report any device
you still could not read as "not verified" rather than guessing:

1. `collector_overview` — status, version, creation time, uptime, device counters, default SNMP
   credentials (`is_platform_default`), `tcp_open_port_scanner`.
2. `collector_discovery_status` — whether initial discovery is still in progress, scanned subnets,
   SNMP devices read, collector issues (hosts it cannot reach).
3. `get_network_configuration` — discovery flags, attached interfaces, routed networks, external
   hosts.
4. `search_devices` with `filter_by: {collector_ids: [<id>]}`, `view: standard`, `page_size: 100`
   (page on if more) — name, type, vendor, model, importance, status, monitoring state.
5. `get_collector_credential_coverage` — per device: which integrations work (UNLOCKED) or not
   (LOCKED), SNMP reading status.
6. `get_config_backup_status` — devices with a backup driver, and whether backup is ENABLED.
7. `network_topology` with `view: full`, `max_links: 300` — links and the dependency map.
8. `list_alert_rules` — the account's rules (id, name, metric, condition, severity,
   `linked_entities`).
9. `get_collector_alert_rule_bindings` — rules on the collector itself.
10. `get_device_alert_rule_bindings` for every **key device** (Step 3): all infrastructure first,
    then business-critical endpoints, up to 30 devices in total. Say which ones you skipped.

**Is the site settled?** If `initialDiscovery.inProgress` is true, or the collector was created
less than 30 minutes ago, say so: discovery, device types and topology are still settling, and
default alert rules (where the account has them) may still be attaching. Offer to run the check
now as a preview and again later. Never call a device "misidentified" in the first hour without
saying the type may still change.

**Default alert rules.** Some accounts attach default rules to new collectors and devices; others
attach nothing. Never assume either: what counts is what the bindings in items 9 and 10 show.

## Step 3 — Work out what matters

**Key devices** are the ones whose failure takes others down or stops the business:
- **infrastructure:** the gateway (the device at the collector's default gateway, or the topology
  root), firewalls and routers, switches, Wi-Fi access points and controllers, servers, NAS,
  hypervisors (vendor/model such as ESX, even if typed Desktop), UPS (APC, Eaton, CyberPower… even
  if typed something else);
- **business-critical endpoints:** point-of-sale terminals, door/access controllers, and cameras.
  These are proposed separately, because whether they matter is the MSP's call.

Use the topology **edges** to see what depends on what: an edge from a switch (`source_id`) to a
device (`target_id`) means the device is plugged into that switch, so count the devices behind each
switch, and follow switch-to-switch edges from the switch the gateway or firewall is on. Don't rely
on `dependency_map` alone: switches linked to each other appear under each other there, which looks
like a cycle but is just the two ends of one uplink. A switch that many devices depend on is key;
say how many depend on it.

## Step 4 — The checks

Run every check. Each one ends as **Ready**, **Needs work** or **Your action** (something only the
user can do). One finding can carry a proposed change (B…), an action for the user (T…), or a
question (Q…).

1. **Alerting coverage.** Is there a "collector went down" rule bound to the collector (a rule on
   `agent_status` with condition "went down")? Does every key device have a "device went down"
   rule (`device_status`, "went down") bound? Count: "<n> of <m> key devices alert when down".
   - Gap → propose binding an **existing** rule (B…): for the collector, the `agent_status` rule
     with the highest severity, preferring the one attached to the most collectors; for devices,
     the `device_status` "went down" rule attached to the most devices. Name it and its severity.
   - Bind at most one `device_status` rule per device, and skip devices that already have one.
   - If two rules already watch the same thing on one device or on the collector, report it as
     duplicate alerting (it will alert twice) and suggest the user runs an alert tune-up.
   - No suitable rule exists in the account → T…: "create a 'went down' rule in the Domotz app and
     choose who it notifies" (you cannot see notification channels, so never create rules).
2. **Importance.** Key infrastructure should be marked important; endpoints that come and go
   (workstations, laptops, mobile phones and tablets, guest devices) should not. Desk VoIP phones,
   printers and displays are the MSP's call: leave their importance as it is unless asked. Propose the changes as a batch (B…),
   infrastructure first. Business-critical endpoints go in their own optional batch.
3. **Credentials and integrations.** From the credential coverage:
   - switches, firewalls and routers whose `CONFIGURATION_MANAGEMENT` is LOCKED, or whose config
     backup is `AVAILABLE` but `DISABLED` → T…: "add SSH credentials in the app to turn on
     configuration backup for <names>";
   - cameras with `ONVIF_CAMERA` LOCKED → T…: add the camera credentials;
   - key devices with no working SNMP → T…;
   - `default_snmp_credentials.is_platform_default: true` → T…: the collector reads SNMP with the
     platform's default community; set the client's own (preferably SNMPv3) in the app.
4. **Remote access.** A collector issue naming a host it cannot reach for "Remote Connection" →
   T…: allow the collector outbound access to that host, or remote connections will not work.
5. **Identification.** Key devices typed Generic or with an implausible type for their
   vendor/model (a hypervisor typed Desktop, a workstation typed Mobile, a UPS typed Smart Power
   Plug) → T…: correct the type in the app (there is no tool to change it). Group them. On a site
   younger than an hour, mark this check "preview".
6. **Discovery scope.** Report the subnets scanned and the routed networks. If there is only the
   collector's own subnet, ask (Q…) whether the site has other VLANs or subnets (servers,
   cameras, VoIP, guest) that should be added as routed networks. Never assume they exist.
7. **Collector health.** Version, uptime since install, status. TCP open-port scanner off → offer
   it as an optional change (B…) that scans the site's public IP for open ports.
8. **Single points of failure.** From the dependency map, name the switches that the most key
   devices depend on, with the count. Information, no change.
9. **Older sites only** (collector older than 30 days): devices down for more than 30 days and
   duplicate records (many records on one IP with locally administered MACs). Report them as T…
   (removing or unmanaging devices is the user's decision in the app).

## Step 5 — The report

Write plain markdown — a bold headline, `###` headings and tables. No code block, no emoji. Use
exactly this layout:

```markdown
**<collector name> · <k> of 8 areas ready · approve <n> changes → <the main outcome>**
<client> · collector [<id>] · installed <when> · <devices> devices · <settled | still settling: …>

### Readiness

| Area | Status | What we found |
|---|---|---|
| Alerting | Needs work | <e.g. 0 of 15 key devices alert when down; no collector-down alert> |
| Importance | … | … |
| Credentials & backups | … | … |
| Remote access | … | … |
| Identification | … | … |
| Discovery scope | … | … |
| Collector health | … | … |
| Single points of failure | … | … |

### Proposed changes

| | Change | Devices | Why |
|---|---|--:|---|
| **B1** | <what changes> | <n> | <the reason, with its number> |

### To do in the Domotz app

| | Action | Devices | Why |
|---|---|--:|---|
| **T1** | <what the user must do> | <n> | <why it matters> |

### Questions
- **Q1** <a question only the user can answer>

<at most 4 one-line notes the user must check before approving>

Reply **"approve B1 B2"**, **"approve all"**, or **"why B1?"** for the evidence. Nothing changes until you approve.
```

Rules for the layout:
- The headline's main outcome is the most important change, in numbers: "15 key devices alerting,
  up from 0". If nothing needs changing, say the site is ready.
- **Sort** proposed changes by impact (alerting first, then importance, then the optional ones)
  and number them in that order. List every target in the evidence, not in the table.
- Keep cells short: Change and Action at most 55 characters, Why at most 90.
- Leave out an empty section ("Proposed changes", "To do", "Questions") instead of writing "none".
- Keep everything else out of the first reply.

### Visual report (optional)

If this skill's folder contains `report-template.html` **and** you can create an HTML artifact or
canvas in this chat, end the first reply with one line: "Want this as a one-page review for your
team?" If the user says yes:

1. Read `report-template.html`. Copy it **unchanged** except for the JSON data block — the
   script element with `id="checkup"`, right after the opening comment. Replace only the JSON
   between that element's opening tag and its `</script>` with this check-up's findings — the same
   facts and wording as the markdown report, nothing new. The field names are in the template's
   sample data. Keep the comment and every tag exactly as they are; if the page has lost its header
   or comes out blank, you edited the wrong part.
2. Publish it as an HTML artifact (or canvas). Don't restyle it, add sections or add buttons.
3. Approval still happens in chat: the page tells the user what to reply.

If the file isn't there or you can't create an artifact, don't offer; the markdown report is the
report.

### Evidence on request

When the user asks "why B1?" or questions a line, answer for that item only, as a short table:

```markdown
**B1 · <what changes>**

| | |
|---|---|
| Targets | <every device or the collector, with ids> |
| Now | <the current state of each: bound rules, importance, setting value> |
| After | <the state after the change> |
| Rule | <name> [<id>] · <condition> · severity <sev> · attached to <linked_entities> — binding batches only |
| Why | <two or three sentences> |
| Undo | <the exact reverse action> |
```

Show this table before applying any batch (Step 6), even if the user didn't ask.

**Batch allow-list.** One kind of change per batch, at most 15 targets per batch, every target named
with its id. A batch may contain only:

1. bind an existing alert rule to a named device (`bind_alert_rule_to_device`);
2. bind an existing alert rule to the collector (`bind_alert_rule_to_collector`);
3. set a named device's importance (`update_device_metadata`, `importance` only);
4. turn the TCP open-port scanner on or off (`update_collector_settings`,
   `tcp_open_port_scanner` only).

Nothing else: no new rules, no credentials, no device types, no renaming, no unmanaging, no
routed networks or external hosts, no discovery settings. Those are actions for the user (T…).

## Step 6 — Apply what was approved

Only for batches the user approved:

1. **Record the before-state** of every target and show it: the device's or collector's current
   bindings (`get_device_alert_rule_bindings` / `get_collector_alert_rule_bindings`), the device's
   importance from `device_inventory` (VITAL = important, FLOATING = not important), or the
   setting from `collector_overview`.
2. **Apply** each change. A binding that answers `ALREADY_BOUND` is "not needed", not a failure.
3. **Verify** by reading again. Read importance back with `device_inventory`, not
   `search_devices` — the device list can show the old value for several minutes. Report each
   target as done, not needed, or failed with the tool's message.
4. **Show the undo batch**: `unbind_alert_rule_from_device` / `unbind_alert_rule_from_collector`
   for each new binding, `update_device_metadata` back to the recorded importance, or
   `update_collector_settings` back to the recorded value.
5. Say what the user should expect: newly bound "went down" rules alert through the channels
   chosen on the rule, so check in the app that they reach the right people.

If the user asks to undo, run the undo batch the same way: before-state, apply, verify.

## Next time

Suggest re-running the check-up after the user has done the T… actions, and a week after install,
when device types and topology have settled. For alert noise on a site that has been running for
a while, suggest an alert tune-up.
