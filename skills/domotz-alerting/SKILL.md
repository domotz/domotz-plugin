---
name: domotz-alerting
description: "Domotz alerting know-how. Use before any other tool when the user wants to be alerted (including when the internet or ISP goes down), change who gets notified, snooze or quiet alerts, or asks why an alert, push or PSA ticket did not arrive. Covers Alert Rules and Shared Alerts, contact channels (email, push, Teams, Slack, webhooks), Collector alerts, PSA ticketing (ConnectWise, Autotask, HaloPSA and others) and IT Glue sync."
---
# Alerts and notifications

## Two alerting systems

- **Alert Rules (Beta)**, also called Unified Alerts, is the current system. It works at account, Collector and device level. New accounts have only this one.
- Older accounts may not have Alert Rules yet. The account can ask support to turn it on (`domotz-contact-support`). It is being turned on for every account as accounts move to RBAC. Company Structure accounts must ask support.
- The older systems still run next to it:
  - **Personal Alerts** go only to that user, by email or mobile push.
  - **Shared Alerts** are profiles that send to contact channels. Creating a profile applies it nowhere: it must be attached to each Collector or device.
  - **Metric alert profiles** are on SNMP, OS monitoring and driver values.
  When both systems are on, check for duplicate notifications.
- Which devices can alert depends on the Collector's `monitoring_mode` (`search_collectors` with `view: "detailed"`). "Location Mode": every discovered device is managed and can alert. "Custom Selection Mode" (per-device pricing): only Managed Devices alert; an unmanaged device never alerts. An account can mix both: answer per Collector.
- If the alert rule tools fail because the feature is not enabled, the account uses the older system. Give the steps for Shared Alerts, and say that support can enable Alert Rules.

## Your tools

- Every change waits for the user's approval of that exact change: say what will change and how to undo it.
- Rules: `list_alert_rules`, `list_metric_functions` (call it before `create_alert_rule`), `create_alert_rule`, `update_alert_rule`, `bind_alert_rule_to_device`, `bind_alert_rule_to_collector`, the matching `unbind_*` tools, and `get_device_alert_rule_bindings` / `get_collector_alert_rule_bindings`. For metric rules use `list_variable_alert_rule_candidates`.
- A rule needs a severity and at least one channel: without a channel it notifies no one.
- A rule's metric cannot be changed after it is created: create a new rule instead.
- Before asking the user for a channel, a rule or a device, look them up yourself (`list_communication_channels`, `list_alert_rules`, `search_devices`), then ask only which of the ones you found.
- Channels: `list_communication_channels`. Reuse an existing channel. Teams, Slack, webhook and PSA connections are set up by the user in the app. Mapping a Collector to a PSA customer can be done with `manage_ticketing_link` (with approval) when the user gives you the board id (`board_uid`) from the PSA or the app: no tool lists PSA boards or companies, so never guess one.
- History: `search_alerts`, and `resolve_alert` to close an open alert. Resolving cannot be undone: say so, and resolve only the alerts the user names.
- Quiet a Collector: `snooze_collector_alerts` (up to 30 days, the whole Collector) and `unsnooze_collector_alerts`.
- Before binding a rule to many devices, say how many and which, so the approval covers exactly that.

## Setting it up in the app

- Account level: "Alerts" in the left menu, then the "Alert Rules" tab, then "Add Alert Rule". The other tabs are "Alert Activity" (the alert history), "Contact Channels & Ticketing Systems" and "Alert Dependency". Set "Target", "Trigger Definition", the severity, and "Notification Channels" (via "Add Channels"). "Send Test" checks it.
- On a device: the "Alerts" tab, then "Alert Rules (Beta)". Groups: Connectivity (Device Status, Heartbeat Lost, IP Address, Ping RTD Median Latency, Ping RTD Packet Loss), SNMP Sensors, TCP Ports, Monitoring Service Health.
- On a Collector: "Alerts", then the "Network" and "Devices" tabs.
- Many devices at once:
  - Inventory, then "Managed Devices", filter "Alert Rules", then the "Alert Rules List" on the right.
  - Collectors in bulk from the Inventory Collector tab.
  - A Device Profile's "Alerts" tab, with "Include the Alerts Module in the Profile". A manual apply is a one-time copy; a scheduled profile reapplies itself.
- An Alert Rule cannot target a device type or tag. To leave a type out (desktops, for example), bind the rule only to the devices you want: filter the Inventory by type and use the bulk "Alert Rules List", or a Device Profile.
- Recovery: with Shared Alerts, a device coming back is the separate "Device Goes Up" event ("Connection Recovered" for a Collector): include it in the profile. For Alert Rules the Help Center does not say whether a recovery notice is sent: do not promise one.
- Metric alerts: hover a metric value and click the bell, or click the bell under a Monitoring Table column. A filtered table applies the alert only to the rows shown.
- When a Collector goes down: the rule "Collector Status went down" (Target Collector, Trigger "Is Down"). While a Collector is down, its devices' alerts do not fire. The older "Connection Lost" alert fires after 8 minutes without contact.
- The internet or ISP going down: the Collector loses its connection to Domotz Cloud, so "Collector Status went down" is the alert for it. First check whether the account has that rule and whether it is bound to the Collector. A rule on the gateway or on an External Host cannot fire while the Collector is offline: it only helps for a second internet link while the first still works.
- New devices on the network: Security, then "New Device Discovery".
- IP conflicts: part of the Collector alerts. Older path: the Network Troubleshooting table, then "View Details", "Edit", "IP Conflict Detection", "+ add contact channels".
- Severities: Critical, High, Warning and Info.

## Channels

- Email, mobile push, webhook, Slack, Microsoft Teams, Telegram, and the PSA or ticketing systems below. The channels are in the "Contact Channels & Ticketing Systems" tab of the Alerts page.
- Microsoft Teams: in Teams, open the Workflows app and use the template "Send webhook alerts to a channel", then copy the URL. In Domotz: Integrations, then "Software Integrations", then Microsoft Teams. Paste the URL into "Microsoft Teams Incoming Webhook", then "Add".
- Slack: create an incoming webhook in Slack and add it in Domotz as a Slack channel.
- Push or email not arriving: check in this order.
  1. The device has a rule (`get_device_alert_rule_bindings`), and in "Custom Selection Mode" it is a Managed Device.
  2. The rule has a channel that reaches this user.
  3. The alert fired (`search_alerts`).
  4. The outage lasted longer than the device's offline time window (2 minutes by default).
  5. For push: the user is signed in to the Domotz mobile app, with notifications allowed.
  6. The channel's "Test" button works.
  If all of that passes, hand off to support.
- The source IP addresses of email, push and webhook notifications are not published; only the PSA allow-list addresses below are. For anything else, the user asks support@domotz.com.

## Quieting alerts

- Snooze a Collector's alerts from now until a date and time, or for up to 30 days: use `snooze_collector_alerts`, or in the app "Collector Alert Control", then "Snooze".
- A snooze always starts at once; it cannot be scheduled. For a planned outage, offer to snooze when it starts, or tell the user to do it then.
- Alerting only during business hours: an Alert Rule has no time-of-day schedule. Scheduled suppression comes with maintenance windows (next point).
- Not available yet: snoozing one device, and maintenance windows (announced as coming soon). Workarounds: snooze the Collector, or unbind the rule from the device for the period and bind it again afterwards (record the bindings first with `get_device_alert_rule_bindings`, so you can restore them exactly). No tool disables a rule, and never delete one for this. Offer to do it, with approval.
- Fewer false offline alerts: a device counts as offline after 2 minutes by default (10 for mobile devices). Per device, "Use custom time window" raises it to up to 24 hours.
- Alert Dependency groups parent and child tickets in ConnectWise, Halo PSA and Autotask. It does not stop notifications. Its "Device DOWN notification delay" defaults to 5 minutes.
- There is no flapping or hysteresis setting.

## PSA tickets

- Systems: Autotask PSA, ConnectWise PSA, Freshdesk, Freshservice, HaloPSA, Kaseya BMS, Q360, RepairShopr, ServiceNow, Syncro and Zendesk. Each works with Alert Rules and with Shared Alerts. The legacy Lite, Advanced and Residential plans do not include ticketing.
- Setup:
  1. Connect the PSA account once: Alerts, then "Contact Channels & Ticketing Systems", then "Connect Account" next to the system.
  2. Map each Collector to its customer: "Manage Collectors" on the system's row, or the "Ticketing System" card in the Collector's settings. You can do it with `manage_ticketing_link` (with approval) when the user gives you the board id; `get_ticketing_integration` reads the mapping.
  3. Add the system as a channel to an Alert Rule (or a Shared Alert) and apply it to the Collectors and devices.
- What a Collector maps to: an Autotask account (tickets go to the queue chosen when connecting), a ConnectWise company and site (one board), a Kaseya BMS account and location, a Q360 site, a ServiceNow assignment group (it opens Incidents), a Freshservice department, a Zendesk organization, or a customer or company in the others.
- Without a mapping, Autotask, ConnectWise, Kaseya BMS, Q360, RepairShopr, ServiceNow and Syncro create nothing. HaloPSA files the ticket under "Client Unknown"; Freshdesk, Freshservice and Zendesk file it with no company, department or organization.
- A new event on a device with an open ticket updates that ticket. After it is closed, the next event opens a new ticket.
- Auto-close: tick "Automatically close tickets, if possible" in the connection. Available for Autotask, ConnectWise, Freshdesk, Freshservice, HaloPSA, Kaseya BMS, Syncro and Zendesk; not for Q360, RepairShopr or ServiceNow. With an Alert Rule, the ticket closes when the condition clears. With a Shared Alert, include "Device Goes Up", "Connection Recovered" or the TCP events.
- When tickets stop:
  - "Authentication Error" on the system's row: reconnect the account.
  - The Collector is not mapped: check with `get_ticketing_integration`. It shows the mapping only, not the connection's status or errors.
  - ConnectWise and Syncro: the IP allow list must include 52.71.132.221 (North America) and 52.48.78.120 (rest of the world). ConnectWise's API member needs the "Domotz API" security role.
  - Autotask: the queue's required Ticket Category must be set.
  - HaloPSA: the URL must have no trailing "/", and the permissions read:tickets, edit:tickets and read:customers are needed.
  - Freshdesk and Freshservice: default values are needed for their mandatory fields.

## Documentation sync

- IT Glue, Syncro, ConnectWise PSA or Autotask PSA documentation is separate from ticketing: Integrations, then "Software Integrations", then "Documentation and Data Aggregation Platforms".
- One documentation system per account. Each Collector links to one organization in it.
- In "Custom Selection Mode", only Managed Devices sync. Sync runs every 12 hours once auto-sync is on, or at once with "Sync now".
- Tools: `get_documentation_integration`, `list_documentation_organizations`, `list_documentation_assets`, and `manage_documentation_link` (with approval). `create_if_missing` creates the assets in the other system, and unlinking does not delete them: that cannot be undone from here, so say so before the user approves.
