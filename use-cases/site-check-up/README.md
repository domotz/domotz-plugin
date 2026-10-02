# Site check-up

**Is this site ready to hand over?**

A new collector discovers dozens of devices in minutes, and the site looks done. It usually isn't:
nothing alerts when the firewall goes down, the gateway isn't marked important, the switches'
configs aren't backed up, and half the devices are typed Generic. Those gaps show up weeks later,
in the middle of an outage.

This playbook checks one site (one collector) across eight areas and tells you, with evidence:

- **Alerting**: which key devices, and the collector itself, would never alert when they go down.
  It reads what is already bound (some accounts attach default rules, others nothing) and only
  fills the gaps.
- **Importance**: infrastructure not marked important, endpoints that shouldn't be.
- **Credentials and backups**: switches without config backup, cameras without ONVIF, the platform
  default SNMP community still in use.
- **Remote access**: hosts the collector can't reach, so remote connections would fail.
- **Identification**: key devices typed Generic or implausibly (a hypervisor typed Desktop).
- **Discovery scope**: subnets scanned, and whether others should be added.
- **Collector health** and **single points of failure** from the topology.

It ends with numbered changes to approve, actions only you can do in the Domotz app, and
questions only you can answer.

## Your standard, not ours

Which devices should alert and which are important is your call, so the check-up can use one of
your established sites as the standard: *"Check the new Brightwater site against our Pisa
office."* It reads the reference site (never changes it), works out which device types you alert
on and mark important, and applies the same rules to the new site. Without a reference site, for
example on your very first collector, it uses general practice and says so on the report.

## What it changes

Only after you approve a batch by its number, and only reversible changes:

- bind an existing "went down" alert rule to key devices or the collector (undo: unbind);
- set a device's importance (undo: set it back);
- turn the TCP open-port scanner on or off (undo: set it back).

It never creates rules, never touches device types, discovery settings, routed networks or
external hosts, never changes what is monitored, and never deletes devices. Those are listed as
actions for you. It never sees a credential: for SNMP it can open the Domotz credentials form,
which you fill in yourself.

## What it needs

- The Domotz MCP server connected to your assistant ([how](../../connect/)).
- **A frontier model**: Claude Sonnet or Opus, or an equivalent model from another provider.
- About 15–35 tool calls and a few minutes for a site of up to 100 devices.

## Limits

- In the first hour after install, device types and topology are still settling; the check-up
  says so and treats identification as a preview.
- Device types can't be changed through the Domotz MCP today, so wrong types are actions for you
  in the app. SSH, ONVIF and other non-SNMP credentials are added in the app too.
- With a reference site, claude.ai may show "Continue" after the report (its per-turn tool
  limit); the report is complete, and replying continues as normal.
- Stale devices: on per-device monitoring the check-up lists those you could stop monitoring to
  free device slots (you do it in the app); on per-location monitoring it only reports them.

Starter prompts: [prompts.md](prompts.md).
