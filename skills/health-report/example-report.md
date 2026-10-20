# Example report

> Produced by this playbook in claude.ai on a real two-site client (two collectors, 74 devices,
> 26 marked important). Client, site and device names are changed; the numbers and the structure
> are as the playbook wrote them.

## The report

**Lakeside Dental · 16 Sep – 16 Oct 2026 · Needs attention**
Main clinic, Annex · 16 Sep – 16 Oct 2026 compared with 17 Aug – 16 Sep 2026 · 74 devices, 26 important · times in UTC

### Summary
Most of your equipment ran without interruption: 19 of your 25 active important devices were
available 99.9% of the time or better, and monitoring at both sites was far steadier than the
month before. The main problem is at the Annex, where a Wi-Fi router and the security recorder
behind it went offline together on 9 October and have not come back. A camera at the Annex and
the terrace access point at the Main clinic also dropped off several times. Our priority before
next month is to restore the Annex equipment and look into the repeated drops.

| | 16 Sep – 16 Oct | 17 Aug – 16 Sep |
|---|--:|--:|
| Important devices at 99.9% or better | 19 of 25 | — |
| Lowest device availability | Annex recorder 79.07% | — |
| Monitoring connection | Main clinic 99.97% · Annex 99.93% | Main clinic 99.76% · Annex 78.68% |
| Outages of important devices (5 min or more) | 26 | — |
| Remote support sessions | 0 | — |
| Changes made by your team | 1 | no comparison |

### Availability
| Device | Site | Availability | Outages | Longest |
|---|---|--:|--:|--:|
| Annex recorder (NVR) | Annex | 79.07% | 1 | 6 d 6 h, still offline |
| Annex Wi-Fi router | Annex | 79.07% | 1 | 6 d 6 h, still offline |
| Smart-home hub | Annex | 99.78% | 7 | 22 min |
| Kitchen camera | Annex | 99.88% | 4 | 18 min |
| Terrace access point | Main clinic | 99.89% | 4 | 27 min |
| Network controller | Main clinic | 99.81% | 5 | 23 min |
| 19 other important devices | | 99.9% or better | | |

One important device, a Wi-Fi range extender at the Annex, was offline the whole period
(probably retired or unplugged) and is left out of the figures.

### Incidents
| When | What happened | How long |
|---|---|--:|
| 9 Oct, 16:35 | Annex: Wi-Fi router and security recorder went offline together | 6 d 6 h (ongoing) |
| 29 Sep | Main clinic: network controller unreachable | 23 min |
| 7 Oct, 18:36 | Main clinic: terrace access point offline | 27 min |
| 13 Oct, 15:13 | Annex: smart-home hub dropped 5 times during the afternoon | 22 min (longest) |

### Work performed
| Area | Actions | Examples |
|---|--:|---|
| Device work | 1 | Power-cycled the network controller at the Main clinic on 16 Sep |

### Next steps
- **R1** Investigate the Annex Wi-Fi router and recorder: both offline since 9 Oct 16:35, together,
  which points to the router feeding that part of the network losing power or its link.
- **R2** Check the Wi-Fi signal of the Annex cameras: the four busiest alert rules, all latency and
  packet loss on those cameras, raised 231 alerts. Then run an alert tune-up for Lakeside Dental.
- **R3** Raise the Main clinic's internet speed with the provider: the last speed test measured
  25.99 Mbps download against a 42.4 Mbps threshold.
- **R4** Confirm the Annex range extender was retired and unmark it, then run a site check-up on
  both sites: both still read SNMP with the platform default community.

---

### Technician appendix

| Collector | Status | Version | Connectivity | Intervals | Longest | Notes |
|---|---|---|--:|--:|--:|---|
| Main clinic | Online | 9.6.0 | 99.97% (prev. 99.76%) | 14 (prev. 23) | 1 min 50 s | Flapping on 21 Sep (7 intervals) |
| Annex | Online | 9.6.0 | 99.93% (prev. 78.68%) | 3 (prev. 2) | 14 min 49 s | Previous period had a 6-day outage, 19–25 Aug |

- **Monitoring gaps:** the Annex range extender was offline all period; both collectors use the
  platform default SNMP community; the Main clinic speed test is below its download threshold.
- **Alert coverage:** three access points have classic shared alerts and both collectors predate
  May 2026, so alert counts stay here. 318 alerts this period, all Info, 4 open; most rules were
  migrated on 14 Sep, so there is no comparison. Top rules, all on the Annex cameras: packet loss
  over 15% (128), latency over 50 ms (45 and 40). They last hours rather than minutes: a real Wi-Fi
  problem, not alert noise.
- **Sources:** 1 change from the Domotz app, none from the API, an AI assistant or Domotz support;
  no failed actions.
- **Not covered:** nothing skipped after "continue" (the first turn reached claude.ai's tool limit
  and checked 19 of 25 devices; later versions of the playbook fit in one turn).

*The client-ready page followed in the same reply, as an artifact.*
