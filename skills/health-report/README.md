# Health report

**What happened at this client last month, in a page they can read?**

Every month an MSP has to show a client that their network is looked after: what was up, what
broke, how fast it was fixed, and what the MSP did. Building that by hand means exporting uptime,
counting alerts and digging through the activity log for each site.

This playbook writes it for one client (all of an organization's collectors) or one site, over the
last 30 days, compared with the 30 days before:

- **Availability** of the client's important devices, the lowest first, and devices that were
  offline the whole month (probably retired).
- **Incidents**: the longest outages, internet-link drops and collector flapping, merged when they
  are one event.
- **Monitoring connection**: each collector's uptime, with flapping episodes called out.
- **Alerts**: how many, how severe, how many still open, and which rules produce them.
- **Work performed**: remote support sessions, alerting changes, reboots and other actions from
  the Domotz activity log, grouped, without people's names.
- **Next steps**, each backed by a number, pointing to the alert tune-up or site check-up where
  they fix it.

The first part is written for the client in plain language; a technician appendix underneath
carries collector details, monitoring gaps and what the report did not cover. Where your chat can
show HTML pages (such as Claude artifacts), it also builds a client-ready page from
[`report-template.md`](report-template.md). Say "text for the client" for a version to paste
into an email.

## What it changes

Nothing. The health report is read-only; fixes it recommends are made with the other playbooks,
after your approval there.

## What it needs

- The Domotz MCP server connected to your assistant ([how](../../connect/)).
- **A frontier model**: Claude Sonnet or Opus, or an equivalent model from another provider.
- About 25 tool calls for one site, 45 for a client with three.

## Limits

- **The last 30 days.** Domotz keeps per-device availability readable for periods that start at
  most 31 days ago. Run the report in the first days of a month to cover the calendar month just
  ended; later, it covers the last 30 days. The comparison period never has device availability.
- **Performance trends** (latency, CPU, bandwidth) are kept for 7 days only, so the report doesn't
  show monthly performance trends.
- **Alerts**: the report counts alert rules. On older accounts that still use classic alerts, the
  counts may be incomplete, so they stay in the technician appendix instead of the client part.
- **Work performed** comes from the Domotz activity log: work done outside Domotz (on site, in
  other tools) is not in it.
- Up to 12 collectors per report; from 7, device availability covers the 15 most important
  devices.

Starter prompts: [prompts.md](prompts.md).
