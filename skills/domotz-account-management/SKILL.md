---
name: domotz-account-management
description: "Domotz account know-how. Use when the user asks how to manage their Domotz account, such as adding or removing users, Access Sets and permissions, two-factor or SSO sign-in, invoices and payment method, changing or cancelling the subscription, account ownership, deleting the account, email preferences, API keys, or connecting an AI client through MCP."
---
# Manage a Domotz account

## What you can do

- Read the account basics with `get_account_info`: whether the signed-in user is the Account Owner, the billing state, the trial end, and whether RBAC is on. It does not say who the owner is, or the plan.
- You cannot change users, billing, the plan or the account itself. Give the exact steps below, or hand off with `domotz-contact-support`.
- Two setups exist: RBAC (Access Management) and the older Team Management. Call `get_account_info` yourself before you answer (never offer to): `is_rbac_enabled` says which steps apply.

## Users and permissions

With RBAC (Access Management):
- Account menu, then "Access Management", then "Users", then "+ Add User". Groups and Access Sets are in the "Groups" and "Access Sets" tabs.
- Default groups: Administrators (full access, cannot be edited or deleted), Team Members, Read-Only, Billing, Manager.
- Account Access Sets cover Access Management, API Keys, MCP Access, Billing, Branding, Alerts and Integrations. Resource Access Sets cover Collectors, devices and dashboards. They add up, and the highest permission wins. Access Sets can also be assigned directly to a user.
- To give someone full rights, the Account Owner adds them to the Administrators group.

With Team Management (no RBAC yet):
- The Account Owner creates users with "Create Team Member" (or "Add member"), as a Team Member or a Field Operator.
- Team Members cannot create users or see payment details. Field Operators see only the Collectors assigned to them. The Help Center does not say where Collectors are assigned to a Field Operator: if the user cannot find it, they email support@domotz.com.
- Extra administrators need support.
- To switch to RBAC, the Account Owner uses the "Enable functionality" banner on the Team page. Company Structure accounts and accounts with Collectors shared from other accounts cannot do it themselves: hand off. Team Management accounts are being moved to RBAC automatically, and no one's access changes.

Both:
- Someone cannot add users: read `get_account_info` first. Only the Account Owner, or on RBAC a user with the Access Management permission, can add users. If that does not explain it, hand off to support.
- An invited user gets an email with a link to set a password. If it does not arrive, check the spam folder.
- A removed user is signed out on their next action.

## Sign-in security

- Two-factor: Account Settings, then the "Two-Factor Authentication" tab. Turn it on, enter the password, scan the QR code with an authenticator app, then "Activate". New users get two-factor by default.
- Resetting a user's two-factor: "Manage", then "Reset 2FA" (Team Management), or by a user with user-management rights (RBAC).
- SAML single sign-on: portal.domotz.com, then Account, then "SAML/SSO". Supported identity providers: Okta, Azure, JumpCloud and Evo Security. Each user must exist in both Domotz and the identity provider with the same email, and removing a user from the identity provider does not remove them from Domotz. Each user's sign-in type is "2FA-Optional", "2FA-Mandatory" or "SAML/SSO".
- Signing in with SSO starts from the identity provider, not from a Domotz page: the user opens the Domotz app from their identity provider's portal (for example "Domotz Login" in Okta's My Apps, or its icon in Microsoft My Apps). Their email there must match their Domotz email.

## Billing and subscription

- Prices and plans: load `domotz-pricing-and-plans`.
- Who can: the Account Owner, or Administrators with the Billing permission. Other users are told who to ask.
- Invoices: account billing page, "Invoices History", with PDF downloads, and the "Estimated Upcoming Invoice". The payment card changes with the pencil icon on the Payment Method card. Invoice address and VAT number are under Account Info.
- Changing capacity: "Subscriptions", then "Manage Subscription", then "Update Subscription", choose the quantity, then "Continue" and "Confirm". On the per-device model, first remove devices from Managed. A lower quantity applies from the next billing cycle, and cannot go below the devices managed today. "Increase Managed Devices" adds capacity.
- Changing plan, or volume and annual terms: through sales (`domotz-contact-support`).
- Cancelling: "Subscriptions", then "Manage Subscription", then "Cancel Subscription". Legacy accounts: portal.domotz.com, then Account, then Info, then "Manage your Subscription".
  - Cancelling is not offered during the trial.
  - There is no pause: say so. Removing a Collector that is no longer needed stops its charge.
  - Billing is monthly, in advance; the billing day does not change. For refunds or what is still due after cancelling, the user emails support@domotz.com.
- Removing one Collector stops its charge: see `domotz-collector-setup`.
- An invoice unpaid for 7 days can lead to suspension, and 30 days to termination. After a license expires, the Collector stops scanning after 14 days.

## Ownership, username and deletion

- There is no self-service transfer of the Account Owner role and no self-service username change: hand off to support. If the owner has left, an Administrator can manage most of the account meanwhile (RBAC).
- Deleting the account and all its data: email privacy@domotz.com from the account's email address. It is done within one month.

## Emails

- Marketing and product emails: on RBAC accounts, an administrator ticks "No Marketing Communications" on the user in Access Management. Otherwise hand off to support.
- Alert emails and app notifications: see `domotz-alerting`.

## API keys and AI clients (MCP)

- API keys: Settings, then the "API Keys" tab, then "+ Create an API Key". The key is shown once.
- AI clients such as Claude, ChatGPT or Copilot Studio connect to the Domotz MCP server at https://mcp.domotz.com/mcp with "Sign in with Domotz" (OAuth). Clients that need a token use an MCP API key: Account, then "Domotz MCP API", then "Create MCP API Key". Keys can be revoked from the MCP API keys page.
- The MCP server acts with the signed-in user's permissions. The "MCP Access" permission controls who can connect, and destructive actions must be enabled explicitly. For read-only use, connect as a user whose Access Sets give read-only access, plus MCP Access.
- MCP is not available on the legacy Lite, Advanced and Residential plans.

## Other requests

- Accounts bought through a distributor or marketplace (for example Pax8 or Atera): transfers into or out of them go through support.
- Documentation: https://help.domotz.com, the Domotz Academy (https://www.domotz.com/domotz-academy.php) and the blog (https://blog.domotz.com). Logos and the brand book: https://www.domotz.com/about/media-kit.php.
