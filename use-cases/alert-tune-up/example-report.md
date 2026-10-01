# Example report

> An illustrative report in the format the playbook produces. The clients, devices and numbers
> are made up, modelled on a typical MSP account.

## The first reply

**Approve 6 changes → 247 fewer alerts (−60%)**
412 → 165 alerts · whole account · 2026-09-01 → 2026-09-30 (UTC) · 412 of 412 read (complete) · 19 of 76 rules fired

### Proposed changes

| | Change | Alerts saved | Why |
|---|---|--:|---|
| **B1** | Unbind "errors > 0" rule from Lobby AP (Client A) | **118** | Fires on any interface error; 116 of 118 cleared in under 5 min |
| **B2** | Unbind Device Status from 6 staff laptops (Client B) | **64** | Laptops leave the network every evening; 58 of 64 fired between 17:30 and 19:30 |
| **B3** | Raise branch VPN latency rule 10 → 50 ms (Client C) | **29** *(est.)* | Fired 29× at only 11–24 ms, which is normal for that link |
| **B4** | Unbind Device Status from 2 printers (Client A) | **22** | The printers drop off when they go to sleep; 20 of 22 cleared in under 5 min |
| **B5** | Unbind "speed > 1000 b/s" from Core Switch (Client B) | **8** | Always true on a 1 Gb port; all 8 alerts still open |
| **B6** | Unbind 2 duplicate collector-status rules at Main Office (Client A) | **6** | 3 rules fired in the same second for all 3 outages; keeps the Critical one |

### Leave alone — fix the cause, not the alert

| | Problem | Alerts | What to fix |
|---|---|--:|---|
| **L1** | Cameras behind one Wi-Fi bridge at Warehouse (Client C) | 96 | Loss and latency rules fire at the same moments on 5 cameras; fix the bridge link |
| **L2** | Collector outages (all sites) | 9 | Real drops; the Branch 2 collector was offline for 6 hours on 18 Sep |
| **L3** | Firewall WAN failover at Head Office (Client B) | 7 | Real ISP drops; check the primary line with the provider |

### Also found
- Never-closing backlog: 6 driver failures, 4 WAN changes, 5 new devices discovered
- 18 rules are attached to nothing · every device that alerted is marked important

- **B1:** the rule is attached to 3 access points; this removes it from the Lobby AP only, where all 118 alerts came from.
- **B3:** a threshold belongs to the rule, so it also applies to the rule's other device, which fired nothing this month.
- **B6:** check in the app that the Critical rule notifies the right place.

Reply **"approve B1 B3"**, **"approve all"**, or **"why B2?"** for the evidence. Nothing changes until you approve.

Want this as a one-page review for your team?

## The one-page review

Where the chat can show an HTML page (such as Claude artifacts), the assistant fills
[`report-template.html`](report-template.html) with the same numbers. Open the file in a browser
to see it with this example's data.

## "why B2?"

**B2 · Unbind Device Status from 6 laptops (Client B, collector Head Office)**

| | |
|---|---|
| Rule | Device Status · went down · severity Warning · attached to 41 devices |
| Targets | SALES-LT-02 · SALES-LT-05 · SALES-LT-07 · ACCT-LT-01 · ACCT-LT-03 · HR-LT-02 |
| Alerts | 64 in the window · 58 fired between 17:30 and 19:30 on weekdays · 0 still open |
| Why | Staff laptops leave the network when people go home or close the lid. The alerts follow office hours, not faults: each one cleared when the laptop came back the next morning. |
| Undo | Bind Device Status back to each of the six laptops. |

The assistant adds a caveat: the case rests on device type, names and timing. If any of these
laptops is shared or meant to stay on, approve the others one by one and keep that one monitored.
