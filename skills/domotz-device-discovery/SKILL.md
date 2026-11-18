---
name: domotz-device-discovery
description: "Domotz discovery and identification know-how. Use before any other tool when devices are missing (another VLAN, subnet, VPN or External Host), a device has a generic or wrong type, or the user asks about the network map, a switch with no ports or links, which ports to open, SNMP, WinRM, SSH, ONVIF or iDRAC credentials, the switch port of a device, adding or excluding devices, or configuration backups."
---
# Get every device discovered and fully identified

## Your tools

- Read: `collector_discovery_status`, `get_network_configuration`, `get_collector_credential_coverage`, `network_topology`, `get_config_backup_status`, `list_config_backup_history`, `compare_config_backup`.
- Change, only after the user approves that exact change, and only changes that can be undone:
  - `manage_routed_networks` to add one (private subnets, /24 or narrower). Never remove one yourself: removing it deletes every device found in it, with its history, so the user does it in the app;
  - `manage_external_hosts` to add one (each one uses the account's allowance). Never remove one yourself: removing it deletes the device and its history, so the user does it in the app;
  - `manage_ip_scan_policy` (forced IP addresses and ranges, IPv4, on plans that allow it; `set` replaces the whole list, so read it with `get_network_configuration` first);
  - `set_interfaces_policy` (which of the Collector's own interfaces are scanned; it replaces the policy, so read it first);
  - `update_collector_settings` (`broadcast_discovery` is the "Auto Discovery" switch);
  - `update_device_metadata` (name, importance, tags, and the type with `type_id` from `list_device_types`; read the current `type.id` with `device_inventory` first: setting it back is the undo, and 0 restores the detected type), `update_device_monitoring_state`.
- Credentials never go through the chat, and never as a tool argument: a password, community or key written here reaches your AI provider. Open the credentials form instead (`get_snmp_credentials_form`; `get_device_credentials_form`, after `get_device_credentials` for the device's `devicePurposes`; or `get_driver_credentials_form` for a driver): the user types them into the form and you never see them. If the form doesn't appear in this chat, `get_credentials_link` gives a one-time page (15 minutes) for a device or driver login; for SNMP, give the path in the Domotz app. The Collector's default SNMP credentials are set only in the app.
- When the user asks you to make a change, use the tool, with approval. When they ask where to click, give the path in the Domotz app.

## Why devices are missing: decide first

Start by reading `get_network_configuration` and `collector_discovery_status` for that Collector, then pick the case below.

1. **Same network as the Collector, but not listed?**
   - The host interface's subnet mask may be smaller than the real network: scanning covers the interface's subnet, up to a /16 on current plans (/22 on the legacy Lite, Advanced and Residential plans; a /8 is not supported). For a /16, set the interface mask to /16 and restart the Collector.
   - A Wi-Fi extender in bridge mode may not pass ARP.
   - A virtual machine must use a bridged adapter, not NAT.
   - Docker must use host networking.
2. **On another VLAN?**
   - Give the host one virtual interface per VLAN on a trunk port, then restart the Collector. Never add a VLAN as a routed network: Domotz then gets no MAC addresses, so it cannot identify brand, model or type, and the map breaks.
   - Per platform: Windows (a Hyper-V virtual switch with one vNIC per VLAN, then restart the Domotz service), Hyper-V (one network adapter per VLAN), ESXi (one port group per VLAN ID), Debian (8021q).
   - Domotz Box: Setup Review, then the pen next to "VLANs", then "Add a VLAN" with the "ID" and an unused "IP Address/CIDR Notation", then "Apply Configuration". The Box's untagged network must be the one with internet access.
   - "VLANs Auto Discovery" lists VLANs seen in the switches' SNMP data that are not configured yet. It needs SNMP on the network devices.
3. **A remote subnet reached through a router or a site-to-site VPN?**
   - Add it as a routed network: Devices, then Network Configuration, then Routed Networks, then "Add a Routed Network", with a name, the subnet address and mask. Or use `manage_routed_networks`.
   - "Advanced Scan via TCP" is optional; without it only ICMP is used. If a firewall answers for every IP (fake devices appear), remove the routed network, delete those devices and add it again without the TCP scan.
   - There are no MAC addresses at Layer 3, so static IPs on those devices are recommended.
   - Do not add a FortiLink subnet: it is mapped from the FortiGate's SNMP data.
   - A remote site with its own LAN is better served by its own Collector: full Layer-2 identification and the network map. A routed network suits a few devices across a VPN. On the per-location model each Collector is a billed location: for cost, load `domotz-pricing-and-plans`.
4. **A single host outside the networks (a website, a cloud server, the far end of a VPN)?**
   - Add it as an External Host: "Add External Hostname/IP" with the IP or hostname, or `manage_external_hosts`. It is monitored by ping, SNMP and remote connections, without a MAC address.
5. **On Azure, and only about 2 devices found?** Support must turn on the Azure network scan (`domotz-contact-support`).
6. **A Windows Collector finds nothing?** Check a supported Windows version, reinstall Npcap (uninstall it, reinstall the Collector, reboot), and the Visual C++ x86 redistributable.

## Choosing what is scanned

- To exclude a device: Device List, then "Monitoring Settings", then "Devices Excluded from Discovery", then "Exclude from Discovery". Deleting an online device while auto-discovery is on only brings it back, so exclude it instead.
- For devices that never answer a discovery scan, add a forced IP list or range with `manage_ip_scan_policy`. The Collector probes them on top of its own discovery.
- To scan only chosen addresses, also turn "Auto Discovery" off (Collector, then Discovery, or `update_collector_settings`). New devices and IP conflicts are then no longer detected. The list must include the Collector's own IP, and the Collector needs a static IP. Devices found before stay until deleted.
- To stop scanning one of the Collector's own interfaces (a container bridge, a VPN tunnel), use `set_interfaces_policy` with `deny`; the user then restarts the Collector service.
- How many routed networks and External Hosts a Collector handles depends on its hardware (see `domotz-collector-setup`). As a guide, suggest up to about 8 routed networks and 20 External Hosts per Collector. These are not hard limits: never refuse to add more because of them, but mention that more may need a stronger Collector.

## Missing or wrong devices in the list

- There is no button to add one LAN device by IP. Use the IP Address List, an External Host, or a Logical device (a placeholder that is not monitored).
- A Collector in "Location Mode" (per-location pricing) manages every device it discovers. In "Custom Selection Mode" (per-device pricing), only Managed Devices get alerts, sensors and drivers: use "Add to Managed Devices" (or `update_device_monitoring_state`). The mode is in `search_collectors` with `view: "detailed"`.
- Wrong type: change it with `update_device_metadata` `type_id` (with approval, see "Your tools"), or give the user the steps: the Edit icon next to the device name opens the type picker. Type, make and model can be set in bulk with a Device Profile's Info module. SNMP data, once readable, overrides a wrong guess. Devices seen only at Layer 3 are often misidentified because there is no MAC address.
- One host with several network cards: select them, then "Group Network Interface Cards", pick the primary one, then "Group". The group is online if any card is.

## Credentials

- **Ports**: nothing is opened from the internet. The Collector reaches each device across the LAN on the protocol's port: SNMP UDP 161, SSH TCP 22, WinRM TCP 5985 (HTTP) or 5986 (HTTPS), and the device's web port (HTTP or HTTPS) for ONVIF and iDRAC. A firewall on the device or between VLANs must allow the Collector's IP.
- The lock icon and the Inventory "Insights" column (SNMP Management, OS Monitoring, ONVIF Monitoring, Configuration Management) show what credentials would unlock.
- **SNMP**:
  - Domotz first tries v2c with public and private.
  - Credentials go in four places: the Collector's Default Credentials (with the box to apply them to existing devices), a device's Access Manager, the Inventory in bulk, or a Device Profile.
  - SNMPv3 supports MD5 and SHA up to SHA-512, and DES, AES, AES-256B or AES-256R.
  - The SNMP tab shows the status:
    - "READ": working.
    - "Service not found": UDP 161 is closed.
    - "Unable to read from SNMP service": wrong credentials or version, or the Collector's IP is not allowed on the device.
    "Retry now" checks again.
- **OS monitoring (WinRM or SSH)**: no admin rights needed, and SSH wins if both are open. The unlock option can take up to 3 hours to appear.
- **WinRM failures**:
  - Run `enable_winrm_os_monitoring.ps1` in a normal administrator PowerShell window, not ISE.
  - Enter a local user as `COMPUTERNAME\user` and a domain user as `DOMAIN\user`.
  - The port depends on the transport the user chose: TCP 5985 for WinRM over HTTP, TCP 5986 for WinRM over HTTPS. Open the one in use, or both if both are used.
  - Group Policy can roll it out.
- **iDRAC**: SNMP templates, or the SSH drivers (recommended), or OS monitoring over SSH with root for IPMI sensors.
- **ONVIF cameras**: a Camera tab appears by itself (reboot, snapshot, a 1-minute stream). Credentials can also come from a Device Profile.

## The network map

- In a Collector's view, the "Topology" button in the top menu bar opens it.
- It needs managed switches that support RFC 4188 or Q-BRIDGE-MIB, SNMP readable (status "READ") with the right community, LLDP (or CDP) on, and every switch a Managed Device. Meraki, UniFi, UISP and FortiLink are mapped through their integrations.
- Wrong links: put the right device on a port, use "Create Unmanaged Switch or Hub", or "Add Manual Link" ("Manual Mapping Configuration"). Manual links override the automatic ones.
- "Export Map" saves PNG, SVG or Excel; only the app exports its map. From `network_topology` you can describe the links or draw a simple diagram, if this chat can show one.

## Configuration backups

- The Config tab appears only on supported network devices, after SNMP is readable (so Domotz can identify the device) and the device credentials are unlocked: SSH for most vendors, HTTPS for SonicWall. The supported list is at https://help.domotz.com/monitoring-management/officially-supported-hw-for-configuration-management/.
- Backups run automatically every 6 hours and keep a version only when something changed. "Backup Now" always saves one. "Configuration Misalignment" means the running and startup configurations differ.
- Requirements by vendor:
  - Cisco IOS: SSH, SNMP, SCP and a privilege 15 user, with no login banner.
  - Cisco SG and CBS, Luxul, Dell N: privilege 15 (TFTP needed to restore).
  - HP Aruba: the user needs admin privilege (never mention privilege level 15 for Aruba), plus SNMP, SSH and TFTP. Access points are read-only.
  - FortiGate: super_admin or admin, no banner, TFTP on UDP 69 both ways, no VDOMs. Across a VPN, the tunnel interface needs an IP.
  - Juniper: super-admin.
  - WatchGuard: Device Monitor can back up, Device Administrator can also restore.
  - SonicWall: read-only. On SonicOS 7.3.2+ and 8.2.0+, use an API account without 2FA.
  - MikroTik: a user who can run `/export verbose`.
