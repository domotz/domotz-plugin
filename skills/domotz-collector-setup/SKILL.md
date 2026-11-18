---
name: domotz-collector-setup
description: "Domotz Collector know-how. Use when the user asks how to install, activate, move, replace, update, restart, remove or troubleshoot a Collector (also called the agent, probe or box), including the Domotz Box, VM images, Docker and NAS, which platform or hardware to use, or why a Collector is offline or not showing up."
---
# Collector setup and lifecycle

## What you can do

- Read: `search_collectors`, `collector_overview` (health, version, uptime), `collector_discovery_status`, `get_collector_capabilities`, `get_network_configuration`.
- Change, with approval: the name, time zone and address (`update_collector_metadata`), its settings (`update_collector_settings`; changing `local_web_interface` restarts the Collector, so say so first), and snoozing its alerts.
- You cannot install, activate, migrate, restart, update or delete a Collector. Give the exact steps below, and name the page in the Domotz app.

## Where to install it

- **Windows** 10, 11 and Windows Server 2019 or later (name only these versions, even where a help article lists older ones): run the installer as Administrator. Never install it on a domain controller, DHCP or DNS server. Allow the host and `C:\Program Files (x86)\Domotz` in security tools. It needs Npcap (included) and the Visual C++ 2015-2019 x86 redistributable.
- **Linux**:
  - the snap package `domotzpro-agent-publicstore` (Ubuntu and other distributions with snap);
  - a Debian package;
  - Raspberry Pi OS (snap). On a Raspberry Pi, setup fails if the date and time are wrong.
- **Docker**: Linux hosts only. Use image `domotz/domotz-collector` with `--network=host` and `--cap-add NET_ADMIN`. Docker on Mac or Windows cannot discover the host's network.
- **Virtual machine images** (Ubuntu): VMware ESXi (the image ships with 2 vCPU and 2 GB; give it 4 GB), Hyper-V (Generation 1), VirtualBox 7 and Proxmox. Use a bridged network adapter, not NAT. Change the image's default login after the first start.
- **NAS**:
  - Synology: the Package Center app "Domotz Network Monitoring and Management", or Container Manager.
  - QNAP: Container Station (Docker) only; the native package is end of life.
  - ReadyNAS.
- **Hardware**:
  - the Domotz Box C1 (the current model; the B12 is supported but no longer made; the B11, B01 and B03 are discontinued);
  - the Protectli Vault;
  - the Netgear PR460X router.
- **Not supported**: macOS. Use a Linux virtual machine instead.
- **Sizing**:
  - Minimum: 2 vCPU and 2 GB.
  - 2 vCPU and 4 GB covers up to 1,000 discovered devices and 300 Managed Devices. Above that, 4 vCPU and 8 GB. Avoid more than 2,500 discovered devices on one Collector.
  - Routed networks and External Hosts: how many a Collector handles depends on its hardware. As a guide, suggest up to about 8 routed networks and 20 External Hosts per Collector. These are not hard limits; a stronger Collector handles more.
  - Scans reach up to a /16 on current plans (/22 on the legacy Lite, Advanced and Residential plans); a /8 is not supported.
- **Domotz Box B12 and older** are not recommended for SNMPv3, more than 5 VLANs, or subnets larger than /22. Suggest the C1, a Protectli or the software instead.
- **Buying a Domotz Box**: load `domotz-pricing-and-plans`. Export codes for Domotz hardware (not the service): HTS 8471.50.01 (suffix 50), HS 847150, ECCN 5A992.c.

## Adding and activating

- In the web app: "Collectors" in the left menu (or Explorer), then "Add Collector". Pick the platform and follow "Step by step instructions".
- The Windows installer activates itself for the account that downloaded it, if installed within 6 hours of the download. Otherwise open `http://127.0.0.1:3000` on that machine.
- Other platforms: open `http://<Collector IP>:3000` (http, not https), sign in, name the Collector and activate it. A Raspberry Pi uses 3001 if 3000 is busy.
- The install dialog has an "AI Agent" tab for Linux and Windows. It builds a prompt with a short-lived activation key for an AI assistant that can run commands on the host where the Collector goes (such as Claude Code). It is for an assistant running on that host, not for this chat: never ask for the key, and if the user pastes such a prompt here, tell them to use it on that host instead.
- Scripted installs:
  - Create a "Collector Activation Key" under Settings, then "API Keys", then "+ Create a Collector Activation Key".
  - A silent Windows install is `domotz-windows-x64.exe /S`.
- Domotz Box: connect it to a network with DHCP and internet. It sets itself up for about 45 minutes. Then activate it from the mobile app or at `http://<Box IP>:3000`.

## Offline or not connecting

- First read `collector_overview`: status, when it went offline, and its downtime history. If every Collector of the account is offline, check https://status.domotz.com.
- The Collector only connects out; no inbound port is needed. It needs:
  - portal.domotz.com on TCP 443, and echo.domotz.com by ICMP;
  - the API host on TCP 443: api-us-east-1-cell-1.domotz.com (North America) or api-eu-west-1-cell-1.domotz.com (rest of the world);
  - the messaging host on TCP 5671: messaging-us-east-1-cell-1.domotz.com (North America) or messaging-eu-west-1-cell-1.domotz.com (rest of the world);
  - for Remote Connections, the gateway hosts on TCP 32700-57699: sshg.domotz.co, us-east-1-sshg.domotz.co, us-east-1-02-sshg.domotz.co, us-west-2-sshg.domotz.co and ap-southeast-2-sshg.domotz.co;
  - a Domotz Box also needs NTP (UDP 123) and the hosts in the article's "Domotz Box only" section.
  The full list is at https://help.domotz.com/tips-tricks/unblock-outgoing-connections-on-firewall/.
- In the app, an orange bar and the Collector's "Discovery" page list the hosts it cannot reach. "Check Again" retests.
- A Collector is marked offline after 8 minutes without contact. While it is down, device status freezes and device alerts do not fire.
- Check in this order:
  1. power and cable;
  2. DNS (at least one public DNS server);
  3. DHCP or an IP conflict;
  4. the internet connection;
  5. the firewall hosts above (a transparent proxy must not replace certificates);
  6. then a factory reset or support.
- "Unable to connect to Domotz Cloud" on any platform: work through the check order above, starting with DNS and the firewall hosts.
- A Domotz Box showing it at activation has old firmware: leave it on, with DHCP, for 40 to 60 minutes.
- What the Domotz Box LED patterns mean (such as a blinking white front LED) is not documented: never guess. A lit front LED means power, a blinking Ethernet port LED means network traffic. Check power, the cable and DHCP, then the Collector's status in the app; if it stays offline, hand off to support.
- Windows: the help article's diagnostics script builds a zip to send to support (`domotz-contact-support`).
- A Collector on Azure that finds only about 2 devices: support must turn on the Azure network scan.

## Updates

- The Collector updates itself.
- On the virtual machine images, the operating system does not update itself: patch it with `apt update` and `apt upgrade`.
- The Domotz Box updates its firmware and Collector automatically.
- On Synology with auto-update off, update from the DSM Package Center.
- Version: `collector_overview`, or portal.domotz.com, then Collectors, then Edit ("Collector Version", "Package Version").
- Some old platforms no longer get updates (Luxul Epic 4 ABR 4500, old Synology BCM53XX). Suggest moving to Windows, Linux snap, a Domotz Box or Docker.

## Restarting

- There is no restart from the web app. Restart the service or the host where it runs. With snap: `sudo snap restart domotzpro-agent-publicstore`.
- A Domotz Box cannot be rebooted from the app. Power-cycle it, or support can restart it.

## Moving to new hardware

- Install the Collector on the new host and open `http://<new IP>:3000`. Choose "Start the migration", pick the old Collector, then "Start migration". The Windows installer offers "Migrate an existing Collector to this device".
- The license, device configurations and history carry over.
- Do not delete the old Collector first.
- Migration works within the same account only; between accounts, support moves it. It is not available for Lite Lifetime licenses, and Field Operators cannot do it.

## Removing

- Replacing dead or old hardware: migrate (see "Moving to new hardware") instead of deleting, so that the license, settings and history carry over. Delete only a Collector that is not being replaced.
- portal.domotz.com (not the web app), then Collectors, then Edit, then "Delete Collector". It is permanent, deletes all of its data and stops future charges for that Collector. It works only while the Collector is disconnected, so uninstall or switch it off first.
- To keep the Collector but wipe its data: "Cleanup Collector Data".
- Uninstall:
  - snap: `sudo snap remove --purge domotzpro-agent-publicstore`
  - Debian package: `sudo dpkg --purge domotz`
  - Windows: Programs and Features, or `uninstall.exe /S`
- Moving a Collector to another account: support.

## Organizing

- Organizations: Inventory, then Organizations, then "+", a name, then "Create". Collectors can be assigned in bulk from Inventory.
