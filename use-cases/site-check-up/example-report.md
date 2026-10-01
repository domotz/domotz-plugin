# Example report

> Produced by this playbook in claude.ai on a freshly installed collector watching a simulated
> customer network (33 devices: firewall, three PoE switches, access points, servers, ESXi, UPS,
> cameras, phones, printers and POS terminals). Names are from the simulation.

## The first reply

**Brightwater Logistics - HQ · 2 of 8 areas ready · approve 3 changes → 14 key devices alert when down, up from 0, plus a collector-down alert**
Brightwater Logistics · collector [325688] · installed 1 Oct 2026, 22:51 UTC · 33 devices · settled (initial discovery complete)

### Readiness

| Area | Status | What we found |
|---|---|---|
| Alerting | Needs work | 0 of 14 key infrastructure devices alert when down; 0 of 8 critical endpoints; no collector-down alert |
| Importance | Needs work | Gateway router, warehouse AP and DNS server not marked important |
| Credentials & backups | Your action | 3 switches can back up config but have no SSH credentials; 4 cameras lack ONVIF; platform-default SNMP |
| Remote access | Your action | Collector cannot reach sshg.domotz.co, so remote connections will fail |
| Identification | Your action | Hypervisor typed Desktop, UPS typed Smart Power Plug, gateway and door controller typed Generic |
| Discovery scope | Your action | Only 172.30.0.0/24 scanned, no routed networks |
| Collector health | Ready | Online since install; open-port scanner off |
| Single points of failure | Ready | BWL-CORE-SW01 carries all 21 other key devices |

### Proposed changes

| | Change | Devices | Why |
|---|---|--:|---|
| **B1** | Bind "Collector Status" [52798] to the collector | 1 | No collector-down alert; this is the account's Critical agent_status rule |
| **B2** | Bind "Device Status" [54034] to key infrastructure | 14 | 0 of 14 alert when down; rule already used on 22 devices |
| **B3** | Mark 3 infrastructure devices important | 3 | Gateway, warehouse AP and DNS server are key but not important |
| **B4** | Optional: bind "Device Status" [54034] to endpoints | 8 | 4 cameras, door controller and 3 POS terminals have no down alert |
| **B5** | Optional: mark door controller and POS important | 4 | Business-critical endpoints; your call |
| **B6** | Optional: turn on the TCP open-port scanner | 1 | Scans the site's public IP for exposed ports; currently off |

### To do in the Domotz app

| | Action | Devices | Why |
|---|---|--:|---|
| **T1** | Add SSH credentials to the 3 HPE ProCurve switches | 3 | Config backup is available but disabled until they authenticate |
| **T2** | Add ONVIF credentials to the 4 Axis cameras | 4 | ONVIF integration is locked |
| **T3** | Enable SNMP on gateway, warehouse AP and DNS server | 3 | Key devices with no working SNMP |
| **T4** | Set the client's own SNMP credentials (prefer v3) | 1 | Collector reads SNMP with the platform default community |
| **T5** | Allow collector outbound access to sshg.domotz.co | 1 | Required for Remote Connection |
| **T6** | Correct device types | 6 | ESXi as Desktop, UPS as Smart Power Plug, router/door controller Generic, 2 workstations as Mobile |

### Questions
- **Q1** Does HQ have other VLANs or subnets (servers, cameras, VoIP, guest) that should be added as routed networks?

- "Device Status" [54034] is severity Warning; check in the app that it notifies the right people before approving B2.
- The 3 POS terminals appear behind the warehouse AP, so they likely depend on it.

Reply **"approve B1 B2"**, **"approve all"**, or **"why B1?"** for the evidence. Nothing changes until you approve.

Want this as a one-page review for your team?

## After "approve B1 B2 B3"

All 18 targets were applied and read back: the collector now carries "Collector Status", the
"Device Status" rule went from 22 to 36 attached devices, and the three devices read as important
in the device inventory. The reply listed the undo batch; "undo B1 B2 B3" reverted all 18 and the
site was back to its install state.
