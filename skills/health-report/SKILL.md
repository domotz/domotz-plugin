---
name: health-report
description: Write a monthly health report for a Domotz client or site — availability of the important devices, outages and incidents, collector connectivity, alerts raised and work performed over the month, compared with the month before, as a client-ready page plus a technician appendix. Read-only. Use when the user asks for a monthly report, health report, service report, QBR or review material, uptime or SLA summary, or what happened at a client or site last month.
---

# Health report

You write the monthly service report an MSP sends to a client: how available the client's
important equipment was, what went wrong and for how long, what the alerts said, and what the MSP
did about it, compared with the month before. The first part is written for the client (a business
owner, not an engineer). The second part, the technician appendix, is for the MSP. You work only
through the Domotz MCP tools. Every number you report comes from data you fetched in this
conversation.

## Ground rules (never break these)

1. **Read-only.** This playbook never changes anything. Do not call any tool that binds, unbinds,
   updates, creates, deletes, applies, manages, sets, snoozes, resolves, executes or powers
   anything, even if the user asks for a fix during the report. Recommend the fix and name the
   playbook or the app action that does it (see "Next steps").
2. **One client at a time.** A report covers one organization (all its collectors) or one
   collector. Never mix two organizations in one report.
3. **Only numbers you read.** Write exact numbers from tool results; never "~", "about" or
   "90+". Percentages come from the server (`uptime` in `get_uptime` or `collector_overview`);
   don't compute availability yourself. If you could not read something, say what in the
   appendix, and never fill the gap with a guess.
4. **Never mislead the client.** A number goes on the client page only if it is complete for the
   period. Anything partial goes in the appendix, labelled partial. A month that cannot be
   compared (history starts mid-month, a collector added mid-month) says "no comparison" instead
   of a trend.
5. **No people's details.** Audit logs carry user names and email addresses. Never put a name or
   an address in the report; say "your team", "the Domotz API" or "an AI assistant".
6. Say "collector", not "agent", in the appendix; on the client page say "monitoring at <site>".
   Name devices by their name. Ids appear only in the appendix.

## Step 1 — Scope

- Call `get_account_info` once.
- Resolve the client: `list_organizations` (its collector ids) and `search_collectors` with
  `view: detailed` (names, status, `creation_time`, `monitoring_mode`). If the user named a
  client or site, use it. If the name matches both an organization and a collector, prefer the
  organization. If it is ambiguous or missing, ask once, listing up to 6 organizations with their
  collector counts.
- Skip collectors that were offline for the whole period (status OFFLINE and `status.last_change`
  before the period started): list them in the appendix as "offline all period, not reported".
- **Period.** Domotz keeps per-device availability readable only for periods that start at most
  31 days ago, so the default is the **last 30 days**, ending now (UTC). If the user names a
  calendar month: use it when it started at most 31 days ago (run on 1 or 2 October, "September"
  works); otherwise say once that device availability for that month is no longer readable,
  and offer the last 30 days instead (or, if they insist, report the month without device
  availability, saying so in the summary). If the user gave dates, use exactly those. The
  **comparison period** is the period of the same length right before it; it never has device
  availability. The longest period is 31 days.
- **Size.** Up to 6 collectors in one report. More than 6: ask the user to pick up to 6, or to
  accept a report on connectivity, alerts and work performed only (no device availability).
- State the scope in one line before fetching: client, collectors (names), period, comparison.

## Step 2 — Fetch

Make the calls one at a time, not in parallel. If one fails, retry it once; if it still fails,
mark that item "not read" in the appendix.

**Tool budget.** Chat apps such as claude.ai stop a turn after about 40 tool calls, and the report
is only useful if it is finished in one turn. Plan for **at most 35 calls**, in this order: the
fixed calls first (items 1–3 and 5–9, about 20 for two collectors), then device availability
(item 4) with what is left, at most 15 devices. If you are stopped anyway, write the report with
what you have, say what is left, and that the user can reply "continue".

Large results: `collector_overview` and `get_uptime` list every downtime interval, and a collector
that flapped can return hundreds. Don't copy intervals into your reply. As you read each result,
keep only: the `uptime` percentage, the number of intervals, the total and the longest duration,
the 3 longest intervals (start and duration), and the days with the most intervals. Count the
intervals exactly up to 60; above that, write "more than 60" and name the days they fall on.

**Per collector** (for each collector in scope):
1. `collector_overview` with `lookback` = the number of days from the period start to now (at
   most 90). Keep the status, version, creation time, `counters`, `security_issues`,
   `speed_test` and its thresholds, `default_snmp_credentials.is_platform_default` and
   `alerts_snoozed`. When the period ends now (the default), its uptime is the collector's uptime
   for the period.
2. `get_uptime` (collector only, no device) for the **comparison period**, and also for the
   period when it doesn't end now. Use the server's `uptime`.

**Important devices** (the equipment the client cares about):
3. `search_devices` with `filter_by: {collector_ids: [<all in scope>], importance: "important"}`,
   `view: detailed`, `page_size: 100`. Keep name, type, vendor, model, status, `monitoring_state`
   and `has_shared_alerts`. Devices whose `monitoring_state` is `unmanaged` are not monitored and
   have no uptime history: count them as "important but not monitored" for the appendix and the
   next steps, and don't call `get_uptime` for them. Any other value has uptime.

**Alerts:**
5. `list_alert_rules` once. If it says the Alert Rules feature is not enabled, the account uses
   classic alerts only: skip items 6 and 7 and see "Alert coverage" below. Otherwise keep each
   rule's id, name, severity and `creation_time`.
6. Counts from the server, each with `collector_ids` = the scope and `size: 1`, using
   `total_count`:
   - the period, then the comparison period;
   - alerts still open now: `status: TRIGGERED`, then `TRIGGERED_NO_AUTOMATIC` (no date range);
   - the period for each severity (`severity` = `Critical`, `Warning`, `Info`), only when the
     alerts you read in item 7 mix severities; otherwise write the one severity you saw and
     say the split comes from the alerts you read.
7. Read the most recent alerts of the period: `search_alerts`, `size: 40`, paging with
   `from_offset` up to 120 alerts (3 pages). Tally per rule and per device: count, how many
   closed within 5 minutes, and the first and last time. Then, for the 3 rules with the most
   alerts in what you read, get each rule's exact count for the period (`alert_rule_ids: [id]`,
   `size: 1`). If the period has more than 120 alerts, say in the appendix that the "top rules"
   come from the 120 most recent and their counts from the server.

**Work performed:**
8. `search_audit_logs` for the period, `size: 100`, paging with `from_offset` until you have read
   `total_count` entries (at most 500; say so if you stopped). Keep every entry whose
   `operation_context_collector_id` is a collector in scope, whatever its category (an alert
   rule bound to or unbound from one of these collectors or their devices counts). Entries with
   no collector (account-wide, such as `Update alert rule`) count only when the account has a
   single organization. Ignore
   the `AUTHENTICATION`, `ACCESS MANAGEMENT` and `BILLING` categories and anything with
   `outcome_status: FAILURE` (count failures separately for the appendix).
   Group what is left:
   - **Remote support sessions**: `VPN_SESSION_START`, `START REMOTE SESSION`,
     `OPEN REMOTE ACCESS SESSION`, `OPEN VPN SESSION` (count starts only, not stops);
   - **Alerting changes**: category `ALERT RULE` and `CONTACT CHANNEL`;
   - **Device work**: category `DEVICE MANAGEMENT` (split out reboots and power actions:
     `DEVICE_REBOOT`, `DEVICE_SOFTWARE_REBOOT`, `CYCLE OUTLET POWER`, `TURN ON OUTLET`,
     `TURN OFF OUTLET`; and configuration restores: `DEVICE_CONFIG_RESTORE`);
   - **Network and collector settings**: `NETWORK MANAGEMENT`, `COLLECTOR SETTINGS`,
     `NETWORK TOPOLOGY`, `USER CREDENTIALS`, `DEVICE PROFILE`;
   - **Diagnostics**: `DIAGNOSTICS`.
   Category and type names come in mixed case ("Alert rule", "ALERT RULE"): match them ignoring
   case. A driver run is logged twice, as `Execute script` and `DEVICE_CUSTOM_DRIVER_EXECUTE`
   with the same time and device: count it once, as a "driver run" (never say "script").
   Also count by `source_application`: `WEB_APP` = the Domotz app, `PUBLIC_API` = automations,
   `MCP` = an AI assistant, `BACKOFFICE` = Domotz support.
9. The same search for the comparison period with `size: 1`, for its `total_count` only. It
   counts the whole account, so compare it only when the account has a single organization;
   otherwise write "no comparison".

**Device availability** (last, with the budget left):
4. `get_uptime` with `device_id` for monitored important devices, for the **period**: 15 devices
   (8 when the scope has 4 or more collectors), or all of them if there are fewer. Use that
   budget in full; checking fewer makes the headline figure weaker for no reason. Pick them in this order, so the devices that had
   problems are never the ones skipped:
   1. important devices that are offline now (`status` from item 3);
   2. important devices that appear in the alerts you read (item 7), most alerts first;
   3. infrastructure (gateway, firewall, router, switch, Wi-Fi, NAS, server, hypervisor, UPS);
   4. the rest, by name.
   The devices you don't read count as "<n> other important devices, online now, not checked one
   by one" (from their `status`), never as 99.9% or better. Say in the appendix which you skipped.
   - `uptime` 0 for the whole period means the device was off all month. Report it as "offline
     all period" (probably retired or unplugged), not as an outage.
   - The device's `agent_uptime` is how much of the period its collector was online. When the
     collector was offline, the device's state is unknown; say so if `agent_uptime` is below 99%.
   - Check the percentage against the intervals: 1% of 30 days is about 7 hours. If the
     percentage implies at least twice the downtime the intervals add up to (for example 95.5%,
     about 32 hours, with intervals totalling 40 minutes), the figure is unreliable. Report that
     device's outages and longest outage, write "under review" instead of its availability, leave
     it out of the headline figures, and note it in the appendix ("Domotz reports 95.49% but its
     outages add up to 40 min").
   - An answer `DEVICE_NOT_MANAGED` for a device that `search_devices` shows as monitored
     usually means the period starts more than 31 days ago. Don't retry it device by device:
     treat device availability as not readable for this period and say so.

**Alert coverage.** Domotz has two alerting systems and these tools read only one of them (alert
rules). Older accounts may also have classic alerts (shared and personal), which the tools can't
count. If any important device has `has_shared_alerts: true`, or the account's oldest collector
was installed before May 2026, the alert counts may be incomplete: put alert counts in the
appendix only, not on the client page, and say why. If every rule was created inside the period
or the comparison period (`creation_time`), alert history doesn't cover the whole comparison: say
"no comparison" for alerts.

## Step 3 — Analyse

Work these out, in this order:

1. **Availability.** For each important monitored device you read: its uptime, the number of
   downtime intervals, the longest. An **outage** is an interval of 5 minutes or more; shorter
   ones are **blips**. The headline availability figure is "<k> of <n> important devices at
   99.9% or better", with the lowest device named. Devices offline all period are left out of
   <n> and listed separately.
   **Outages during a monitoring outage don't count.** While a collector is offline or flapping,
   its devices' status isn't updated, so a device outage that starts during a collector downtime
   interval, or on a day the collector flapped, is not a confirmed outage. Leave it out of the
   outage counts, the incidents and the client page, and list it in the appendix ("c3750 [id]
   offline 9 h 47 min on 4 Oct, during the monitoring outage at Main; not confirmed"). Keep the
   device's availability figure, and add "includes time the monitoring connection was down"
   when its `agent_uptime` is below 99%.
2. **Site connectivity.** Each collector's uptime for the period and the comparison. If a
   collector has 20 or more intervals in the period, or more than 5 on one day, call it
   **flapping** and name the days. A collector going offline means monitoring stopped, not that
   the client's network was down: on the client page call it "monitoring connection", and only
   call it an outage if important devices on that site also went down at the same time.
3. **Incidents.** The 5 most significant events of the period, longest first: collector outages
   of 15 minutes or more, device outages of an important device of 15 minutes or more, a flapping
   episode (as one incident), and Critical alerts. Merge events on one site that start within 15
   minutes of each other into one incident ("the site lost power or its internet link").
4. **Alerts.** Total for the period and the comparison, the split by severity, how many are still
   open, and the top rules. Read the top rules like an engineer: a rule whose alerts mostly close
   within 5 minutes is noise; "discovered" and "changed" rules open alerts that never close on
   their own and pile up; many alerts from one device usually mean one problem.
5. **Work performed.** The groups from item 8, with counts and the comparison total.
6. **Monitoring gaps** (appendix and next steps only): important devices not monitored, important
   devices offline all period, the collector reading SNMP with the platform default community,
   alerts snoozed, a collector more than one major version behind the others, speed test below
   its threshold.
7. **Verdict.** One of three, for the headline:
   - **Healthy**: every important device at 99.9% or better (or its only outages were planned or
     overnight blips), no collector flapping, no Critical alert open;
   - **Stable with issues**: everything works, but there were outages, flapping or a monitoring
     gap worth fixing;
   - **Needs attention**: an important device below 99%, a confirmed outage over 4 hours, or a
     Critical alert still open.
   Devices that are switched off as part of normal life (TVs and media players, laptops and
   desktops, phones and tablets, smart lights and plugs) don't set the verdict even when marked
   important: report them, and suggest in the next steps unmarking them or checking their
   standby setting.
   Judge only confirmed figures: a device below 99% because its collector was offline or
   flapping (`agent_uptime` below 99% and no confirmed outage) points to the monitoring
   connection, which is "Stable with issues", not "Needs attention".

## Step 4 — The report

Write plain markdown: a bold headline, `###` headings and tables. No code block, no emoji. Use
exactly this layout:

```markdown
**<Client> · <Month YYYY or the period> · <Healthy | Stable with issues | Needs attention>**
<site names> · <period dates> compared with <comparison dates> · <devices> devices, <important> important

### Summary
<three or four sentences for the client, plain language, no jargon: how the network did, the most
significant incident and what was done, and what comes next>

| | <period> | <comparison> |
|---|--:|--:|
| Important devices at 99.9% or better | <k> of <n checked> | — |
| Lowest device availability | <name> <x>% | — |
| Monitoring connection | <x>% | <y>% |
| Outages of important devices (5 min or more) | <n> | — |
| Alerts raised | <n> | <n or "no comparison"> |
| Remote support sessions | <n> | — |
| Changes made by your team | <n> | <n or "no comparison"> |

### Availability
| Device | Site | Availability | Outages | Longest |
|---|---|--:|--:|--:|
<the important devices below 99.9%, lowest first, up to 10; then one row "<n> other important
devices" with "99.9% or better"; then, if you skipped any, one row "<n> other important devices"
with "online now, not checked">

### Incidents
| When | What happened | How long |
|---|---|--:|
<up to 5, from Step 3>

### Alerts
<one sentence: total, the split by severity, how many still open>

| Rule | Alerts | What it means |
|---|--:|---|
<the top rules, up to 5>

### Work performed
| Area | Actions | Examples |
|---|--:|---|
<one row per group with at least one action>

### Next steps
- **R1** <a recommendation, with the number that justifies it>

---

### Technician appendix
| Collector | Status | Version | Connectivity | Intervals | Longest | Notes |
|---|---|---|--:|--:|--:|---|

- **Monitoring gaps:** <the list from Step 3, with device names and ids>
- **Alert coverage:** <rules only / classic alerts present / history starts on …>
- **Sources:** <changes by source: Domotz app n, API n, AI assistant n, Domotz support n; failed
  actions n>
- **Not covered:** <devices skipped, collectors skipped, pages not read; "nothing" if complete>

Reply **"text for the client"** for a version ready to paste in an email, or **"why R1?"** for
the evidence.
```

Rules for the layout:
- The summary and the client tables never contain jargon (collector, rule ids, SNMP, MCP,
  intervals) or IP addresses. Write "monitoring connection" for the collector, "internet link" for the gateway's
  uplink, and say what a device is when its name doesn't ("FRITZ!Box (internet router)").
- A row whose number is partial or not comparable says "—" or "no comparison", never a guessed
  value.
- Write percentages with two decimals (98.12%, 99.97%), rounding the server's figure; 100% and
  0% stay whole. Write times in UTC and say "UTC" once, in the scope line.
- When alert counts are not complete (see "Alert coverage"), leave the "Alerts raised" row and
  the Alerts section out of the client part and put them in the appendix.
- When nothing happened in a section, write one line instead of an empty table ("No outages of
  important devices this month.", "No configuration changes this month."). Never leave out
  Availability or Work performed: an empty month is good news for the client.
- Keep cells short: "What happened" and "What it means" at most 80 characters.
- Up to 5 next steps, the most important first.

### Next steps

Every recommendation names its evidence and how to act on it. Use these, in this order of
priority, when they apply:
- An important device below 99% or with repeated outages → investigate it; name the device and
  its outage count.
- A collector flapping → check the collector's power and network link at <site> (the dates).
- Important devices not monitored → turn on monitoring for them in the Domotz app (names).
- Important devices offline all period → confirm they were retired and remove or unmark them.
- A noisy top rule (most alerts closing within 5 minutes) or a pile of open discovery alerts →
  "run an alert tune-up for <client>".
- No "went down" alerts on key devices, devices not marked important, platform-default SNMP →
  "run a site check-up on <site>".
- Speed test below its threshold → raise it with the internet provider (the numbers).

### Text for the client

When the user asks for it, write the client part only (headline, summary, the numbers table,
incidents and work performed) as plain paragraphs and short lists that paste cleanly into an
email: no tables, no appendix, no ids, signed "<your MSP>".

### Evidence on request

When the user asks "why R1?" or questions a number, answer for that item only: the tool results
behind it (device, period, uptime, intervals with their start and duration, alert counts). Never
make a new number up; fetch it if needed.

### Visual report (shown by default)

If this skill's folder contains `report-template.html` **and** you can create an HTML artifact or
canvas in this chat, build the client-ready page **in the same reply, right after the markdown
report**, without asking. It is the part MSPs send to their client, so the report is not finished
without it. Skip it only if the user asked for text only.

1. Write the markdown report first, so it is there even if the page fails.
2. Read `report-template.html`. Copy it **unchanged** except for the JSON data block — the
   script element with `id="report"`, right after the opening comment. Replace only the JSON
   between that element's opening tag and its `</script>` with this report's data — the same
   facts and wording as the markdown report, nothing new. The field names are in the template's
   sample data; `verdict` is `healthy`, `issues` or `attention`. Leave out `alerts` when alert
   counts stay in the appendix, and use empty lists for empty sections. Keep the comment and
   every tag exactly as they are; if the page has lost its header or comes out blank, you edited
   the wrong part.
3. Publish it as an HTML artifact (or canvas). Don't restyle it or add sections.

If the file isn't there or you can't create an artifact, skip it silently; the markdown report is
the report.

## Next time

Suggest running the report again at the start of next month, and running the playbooks named in
the next steps before then, so the next report shows the improvement.
