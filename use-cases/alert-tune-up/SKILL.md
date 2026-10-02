---
name: alert-tune-up
description: Run an alert tune-up on a Domotz account — review its alert history to find noisy, duplicate and misconfigured alert rules, sort them into "safe to retire", "worth re-tuning" and "leave alone" with evidence, and apply the fixes the user approves through the Domotz MCP server. Use when the user asks for an alert tune-up, says their alerts are noisy, asks for an alert audit, review or clean-up, asks which alerts fire most or can be removed, or wants to reduce alert fatigue for a client or site.
---

# Alert tune-up

You review what fired in a Domotz account, explain which alerts are noise and why, and hand the
user numbered batches of fixes to approve. You work only through the Domotz MCP tools. Every number
you report comes from data you fetched in this conversation.

## Ground rules (never break these)

1. **Read-only until approved.** Do not call any tool that changes anything (unbind, bind, update,
   resolve, create, delete, snooze) until the user has approved it in this conversation. Approval
   is either a batch number you showed ("approve B2") or an instruction that names the exact
   change ("raise rule X to 50 ms", "unbind rule X from device Y"). A general "go ahead", "fix
   it", "do what you think" or "don't ask me" is not approval: show the batches first, then wait.
   Approved changes still follow Step 6 (before-state, apply, verify, undo).
2. **Only reversible changes.** You may unbind a rule from a device or collector, change a rule's
   threshold, condition or severity, and bind a rule back. Never delete a rule, never delete a
   device, never change a rule's notification channels (Domotz does not show a rule's current
   channels, so that change could not be undone), never snooze.
3. **Resolving alerts is permanent.** Only offer it as a separate, optional clean-up batch for alerts
   of a rule the user has just retired, list the alert ids, and say it cannot be undone.
4. **One client at a time.** Never put changes for two organizations in the same batch.
5. **Say what you covered.** If you could not read every alert in scope, say exactly what you read
   and what you did not. Never present a partial read as complete.
6. Say "collector", not "agent". Name devices and rules by name, with ids in brackets.

## Step 1 — Scope

- Call `get_account_info` once (who you are acting as).
- Resolve the client: `list_organizations` gives each organization's collector ids;
  `search_collectors` gives collector names and status. If the user named a client or site, use it.
- If they did not name one, count the whole account's alerts in the window (`search_alerts`,
  `size: 1`). If there are 500 or fewer, audit the whole account without asking, and keep each
  organization's findings and batches separate. If there are more, ask which organization to start
  with. Don't ask anything else.
- Window: if the user gave dates or timestamps, use exactly those — don't widen or round them. If
  not, use the **last 14 days**, ending now: `to` is the current time (UTC), never a time in the
  future such as the end of today, and `from_` is exactly 14 days earlier. The maximum is **30 days** (alert search rejects ranges over 31
  days); if the user asks for longer, audit the most recent 30 days and say so.
- State the scope in one line before fetching: client, collectors, window (UTC).

## Step 2 — Fetch

1. **Rules:** `list_alert_rules` once. Keep id, name, metric, condition (`function_repr`),
   operands, severity, `creation_time` and `linked_entities` (how many devices/collectors the rule
   is attached to).
2. **Device types:** `list_device_types` once, to turn type ids into labels (TV, Camera, Wi-Fi…).
3. **Total:** `search_alerts` with the scope (`collector_ids`, or none for the whole account),
   `from_`, `to`, `size: 1`. `total_count` is the number of alerts in scope. Write it down.
4. **Read the alerts:** `search_alerts` with `size: 40`, paging with `from_offset` = 0, 40,
   80… until you have `total_count` alerts. Each alert is large (about 1,000 characters) and
   many clients reject tool results much over 40,000 characters, so don't use bigger pages; if a
   page is still rejected, use `size: 20` from the same offset. Read at most 500 alerts in one
   conversation.
   - If the total is above 500: say so and offer to narrow (fewer days, or one collector). If the user
     prefers to continue, read the 300 most recent alerts, and treat per-rule counts from the next
     step as the truth; report the audit as "sampled".
   - As you read each page, keep a running tally per **rule × device** (or rule × collector for
     collector alerts): count, how many closed within 5 minutes, the range of `duration_seconds`,
     the range of `trigger_value`, how many are still open (`TRIGGERED` or
     `TRIGGERED_NO_AUTOMATIC`), first and last `triggered_at`, and one or two `unique_id`s as
     evidence.
5. **Exact counts from the server.** Don't rely on your own addition for the numbers that drive a
   decision. For every rule in a batch or in the headline, call `search_alerts` with
   `alert_rule_ids: [id]`, the same scope and window, and `size: 1`, and use its `total_count`.
   Get the status split the same way (`status: CLOSED`, `TRIGGERED`, `TRIGGERED_NO_AUTOMATIC`,
   `RESOLVED`). If your tally disagrees with the server, use the server's number.
6. **Where the rule is attached** — only for rules you will propose changing:
   `get_device_alert_rule_bindings` (collector id + device id) or
   `get_collector_alert_rule_bindings` (collector id). A rule you want to unbind from a device must
   appear in that device's list; if it doesn't, don't propose the unbind.

**Tool budget.** Some chat apps stop a turn after a fixed number of tool calls, so spend them in
this order: pages of alerts, then counts for rules in batches, then attachments of batch targets.
A whole audit should take about 40 calls. If you are stopped before finishing, say what is left
and that the user can reply "continue".

**Gate — don't write the report until all of these are true:**
- you have read `total_count` alerts (or reached the 500-alert cap and said "sampled"). Having
  "enough to see the patterns" is not a reason to stop early;
- every count you will report came from a server `total_count` or from alerts you actually read.
  Write exact numbers; never "~", "about" or "90+" for a count of alerts. The only estimates
  allowed are "would have fired at the new threshold" figures, labelled as estimates;
- every rule you will change has its attachments checked (item 6).

## Step 3 — Find the patterns

Check these in order. One alert can belong to more than one pattern; the earlier pattern wins when
you bucket it.

1. **Duplicate rules.** Two or more rules on the same metric fire for the same device or collector
   within 2 minutes of each other (for example three collector-status rules, each firing for the
   same outage). Every event is alerted several times.
2. **Can never clear, or meaningless condition.** The condition is true in normal operation, so
   alerts stay open or re-fire constantly: "interface speed greater than 1000 b/s", "errors greater
   than 0" on a counter that is rarely exactly 0, a "different from up" rule on interfaces that are
   meant to be down. Compare the values that fired with the condition.
3. **Shared cause.** Many alerts are one event:
   - a collector went down (collector-status alert) and device alerts on that collector start
     within 15 minutes of it, or driver failures pile up right after it came back;
   - several devices on one collector go down within the same 5 minutes (a power, Wi-Fi or switch
     blip);
   - the same metric is bad on several devices at one site for the same days (for example packet
     loss and latency on every camera behind one Wi-Fi repeater). That is one site problem, not N
     noisy rules.
4. **Self-clearing flaps.** A rule fires 5+ times on the same device and most alerts close within
   5 minutes. Nobody could act that fast; the device dropped and came back.
5. **Threshold too tight.** A threshold rule fires 5+ times and the values that fired sit just past
   the threshold (for "greater than" rules, most values are below 1.5× the threshold).
6. **Expected downtime.** Status alerts on devices that are switched off as part of normal life —
   staff laptops and desktops that are shut down or taken home, phones, tablets, guest devices,
   printers that drop off when they sleep, TVs and media players, smart bulbs and lights (they
   drop off the network when the wall switch is turned off).
7. **Never-closing events.** Change, discovery and failure rules (`changed`, `discovered`,
   `failed`) open alerts that never close on their own (`TRIGGERED_NO_AUTOMATIC`). They pile up.
   That is a backlog, not necessarily noise.
8. **Context.** Rules created recently (`creation_time` inside or just before the window) that
   explain a jump in volume; rules attached to nothing (`linked_entities: 0`); an account where
   nearly every device is marked important.

## Step 4 — Decide the bucket

**Safe to retire** (unbind; no loss of useful signal):
- the extra copies of a duplicate rule — keep the one with the highest severity, and warn that
  Domotz doesn't show which notification channel each copy uses, so the user should check in the
  app that the one they keep notifies the right place;
- a meaningless or can-never-clear condition, **on any device, infrastructure included**. A rule
  such as "errors > 0" or "speed > 1000 b/s" whose alerts mostly clear within 5 minutes is noise
  even on a switch or access point: unbind it from the noisy device. Say in the Why cell that real
  interface problems would still show up as the device going down or as packet loss;
- status alerts on devices from the expected-downtime list, unbound from those devices only.

**Worth re-tuning** (real metric, wrong setting):
- threshold too tight: propose the change (don't defer it to "review first"); put the blast
  radius in the row and the notes. Propose a new threshold from the values that fired — above most of them,
  rounded to a sensible number, and in line with practice (for example latency on Wi-Fi devices
  is usually alerted at 50–100 ms, not 10 ms). Say how many of this window's alerts would have
  fired at the new threshold (count the fired values above it; say it is an estimate);
- a condition that could be fixed to mean what the author probably intended (say what you think
  they meant and ask).
- **Blast radius:** threshold, condition and severity belong to the rule, so a change applies to
  every device or collector the rule is attached to. Always state `linked_entities`. If only some
  of them are noisy, propose unbinding those instead.

**Leave alone** (signal, or not fixable by changing alerts):
- collector outages, and device alerts caused by one;
- infrastructure going down: status and availability alerts on routers, firewalls, switches,
  access points and repeaters, servers, NAS, UPS, controllers. This covers the device being
  down, not every rule attached to it (see "meaningless condition" above);
- shared-cause site problems: say what to fix (the Wi-Fi link, the power, the collector) instead of
  silencing the symptoms;
- a device that flaps and matters: name it as a device problem to investigate;
- never-closing events that carry information (new device discovered, WAN/ISP changed, config
  backup failed) — mention the open backlog.

When you are unsure between retire and leave alone, choose leave alone and say what would change
your mind. "Unsure" means the evidence points both ways, not that a change needs care: a rule
that matches a retire or re-tune pattern above goes in proposed changes, with its caveat in the
notes.

## Step 5 — The report

The first reply is a one-screen proposal the user can decide on at a glance: one headline number,
a table of changes, a table of what to leave alone. Every row carries a short reason with its key
number, so nothing is a bare claim. The full evidence comes when the user asks for it (see
"Evidence on request").

Write plain markdown — a bold headline, `###` headings and tables. No code block, no ASCII bars,
no emoji. Use exactly this layout:

```markdown
**Approve <k> changes → <saved> fewer alerts (−<pct>%)**
<total> → <total − saved> alerts · <client> · <from> → <to> (UTC) · <read> of <total> read (<complete | sampled: …>) · <n> of <m> rules fired

### Proposed changes

| | Change | Alerts saved | Why |
|---|---|--:|---|
| **B1** | <what changes, with the client tag> | **<n>** | <the reason, with its key number> |
| **B2** | … | **<n>** *(est.)* | … |

### Leave alone — fix the cause, not the alert

| | Problem | Alerts | What to fix |
|---|---|--:|---|
| **L1** | <what it is> | <n> | <why it is signal, and what to fix> |

### Also found
- <one line each: never-closing backlog, rules attached to nothing, recent rule changes, …>

<at most 4 one-line notes the user must check before approving>

Reply **"approve B1 B3"**, **"approve all"**, or **"why B2?"** for the evidence. Nothing changes until you approve.
```

Rules for the layout:
- **Sort** proposed changes by alerts saved, largest first, and number them in that order.
- **Keep cells short:** Change at most 55 characters, Why and What to fix at most 90. Shorten
  rather than wrap; the detail belongs in the evidence block.
- **Alerts saved** = alerts in this window that the change would have prevented. Exact for unbinds;
  for threshold changes count the fired values that stay below the new threshold and mark
  *(est.)*. Count each alert once even if two batches touch it. The headline adds them up.
- **Why cells** give the reason a sceptical engineer needs, in plain words: what makes it noise (or
  signal) plus the one number that proves it. Good: "Staff laptops go offline every evening —
  58 of 64 fired between 17:30 and 19:30". Bad: "Expected downtime pattern".
- **Name the client** in each Change and Problem cell when the audit spans several organizations,
  e.g. "(Client A)".
- **Notes:** at most 4 one-line notes after "Also found", only for what the user must check
  before approving — a rule shared with other devices, the notification-channel check for
  duplicates, a device you left out on purpose.
- **Leave alone** lists only the items that account for a meaningful share of alerts (top 3–5).
- Keep everything else out of the first reply. If you are unsure between retire and leave alone,
  choose leave alone and say in its row what would change your mind.

### Visual report (shown by default)

If this skill's folder contains `report-template.html` **and** you can create an HTML artifact or
canvas in this chat, build the one-page review **in the same reply, right after the markdown
report**, without asking. Skip it only if the user asked for text only. It is the easiest way to
read the findings and to share them with the team.

1. Write the markdown report first, so it is there even if the page fails.
2. Read `report-template.html`. Copy it **unchanged** except for the JSON data block — the
   script element with `id="audit"`, right after the opening comment. Replace only the JSON
   between that element's opening tag and its `</script>` with this audit's numbers — the same
   numbers and wording as the markdown report, nothing new. The field names are in the template's sample
   data. Keep the comment and every tag exactly as they are; if the page has lost its header or
   comes out blank, you edited the wrong part.
3. Publish it as an HTML artifact (or canvas). Don't restyle it, add sections or add buttons.
4. Approval still happens in chat: the page tells the user what to reply.
5. After you apply or undo a batch, offer one line: "Want the one-page review updated with what
   changed?"

If the file isn't there or you can't create an artifact, skip it silently; the markdown report is
the report.

### Evidence on request

When the user asks "why B2?", "show the evidence" or questions a line, answer for that item only,
as a short table:

```markdown
**B2 · <what changes>**

| | |
|---|---|
| Rule | <name> [<id>] · <condition> · severity <sev> · attached to <linked_entities> |
| Targets | <device or collector names with ids> |
| Alerts | <n> in the window · <n> closed within 5 min · <n> still open |
| Values | <min>–<max> (threshold <t>) — threshold rules only |
| Examples | <unique_id>, <unique_id> |
| Why | <two or three sentences> |
| Undo | <the exact reverse action> |
```

Show this table for every target of a batch before applying it (Step 6), even if the user didn't ask.

Batch rules: one kind of change per batch, one client per batch, at most 10 changes per batch.
Number batches B1, B2… in the order you recommend them. A batch may contain only these actions,
each with every target named and its id given:

1. unbind a rule from a named device;
2. unbind a rule from a named collector;
3. change one rule's threshold, condition or severity;
4. the optional clean-up: resolve listed alert ids (marked "cannot be undone").

Nothing else: no deleting rules, no "unbind from all TVs" or other selection by type — list the
devices — and no rebinding to a different set of devices.

## Step 6 — Apply what was approved

Only for batches the user approved by number:

1. **Record the before-state** of every target and show it:
   - unbind from a device: confirm the rule appears in `get_device_alert_rule_bindings`. Then check
     whether the rule is attached to specific variables (for example one interface) rather than the
     whole device: `list_device_metrics` with the rule's metric gives the device's variables;
     `list_variable_alert_rule_candidates` on one of them shows `linked_variables` for the rule. If
     it is 0, the binding is device-wide. If it is above 0, record every variable where
     `attached: true` — the undo must bind each of those back with `variable_id`.
   - unbind from a collector: confirm the rule appears in `get_collector_alert_rule_bindings`.
   - update a rule: record its current name, condition, operands and severity from
     `list_alert_rules`.
2. **Apply** with `unbind_alert_rule_from_device`, `unbind_alert_rule_from_collector` or
   `update_alert_rule` (pass only the fields that change; never pass `channel_ids`).
3. **Verify** by reading again (bindings, or `list_alert_rules`). Report each change as done,
   not needed (`NOT_FOUND` = it was already unbound) or failed, with the tool's message.
4. **Show the undo batch**: `bind_alert_rule_to_device` (with `variable_id` where recorded),
   `bind_alert_rule_to_collector`, or `update_alert_rule` back to the recorded values.
5. Mention the side effects that apply:
   - alerts already open from an unbound rule stay open — Domotz won't close them; offer the
     optional clean-up batch (ground rule 3);
   - Domotz attaches some default rules to every new collector, so retiring one here doesn't stop
     it being attached to collectors added later;
   - there is no "only alert if it lasts N minutes" setting in Domotz, so flapping can only be
     handled by thresholds, unbinding, or fixing the device.

If the user asks to undo, run the undo batch the same way: before-state, apply, verify.

## Next time

Suggest re-running the audit monthly for each client. If the user pastes a previous report,
compare: alerts per day before and after, and which patterns are gone or new.
