---
name: domotz-pricing-and-plans
description: "Domotz pricing and plans. Use for any question about price or cost, plans (per-location or per-device), the free trial, billing terms, discounts, the Domotz Box, distributors and marketplaces such as Pax8, or what Domotz would cost for an account. States only the published starting price and sends quotes to sales."
---
# Domotz pricing and plans

## First, find the account's pricing model

- When the answer depends on the account's model (a price, what is billed, how to add or remove capacity), first call `search_collectors` with `view: "detailed"` and read each Collector's `monitoring_mode`:
  - "Location Mode": the **per-location** model. Every device the Collector discovers is monitored and managed.
  - "Custom Selection Mode": the **per-device** model. The user chooses which devices are Managed Devices.
- No Collector yet, or someone evaluating Domotz: the per-location model, the default for every new self-service account.
- Collectors in both modes, or the tool fails: ask which model they mean, only when the answer differs between the two.
- Answer for the user's model only. On the per-device model, do not give the per-location price or describe that model unless the user asks about changing model.

## Rules

- The one price you may state: the per-location model starts at $35, £35 or €35 per Collector per month. The current price list is on https://www.domotz.com/pricing.php.
- Never state any other price, tier, band or discount amount, including the per-device price, and never take one from an older document, a help article or a tool result. Volume discounts are available through sales; never promise any other discount. For a quote, volume pricing or the per-device price, send the user to sales and give the contact: "Contact Sales" on https://www.domotz.com/contact-us.php, or sales@domotz.com. Never offer to look anything up to give a per-device figure.
- Never compute a total for the user. Give the starting price, point to the pricing page, and offer sales for a quote.
- Never write "unlimited devices": say "no per-device charges" (fair usage applies).
- Never say there is a free plan, a free version or free discovery: the only free offer is the 14-day free trial.
- Never promise every feature on every plan.
- Current plans include the MCP server, with no AI tier or AI markup. The legacy Lite, Advanced and Residential plans do not include it.

## The two models

- **Per-location** (Collectors in "Location Mode"; the default for new accounts):
  - Priced per Collector, starting at 35 a month. Every device that Collector discovers is included: no per-device charge, no device bundle, no sensor counting.
  - A Collector can monitor several networks: subnets up to /16, VLANs, routed networks and External Hosts. An account can have as many Collectors as it needs.
- **Per-device** (Collectors in "Custom Selection Mode"):
  - Priced per Managed Device. The user chooses which devices are managed, and Collectors are not charged separately.
  - No longer the self-service default. Existing customers keep it; a new customer can ask sales for it.
- **Legacy plans**, discontinued for new customers: Location Packaging, Lite, Advanced, Residential, Premium, Basic, Standard, Enterprise, Collector Basic, Collector + and Collector XL.
  - An existing customer can stay on a legacy plan and keep adding Collectors on it. Their price can differ from the current price list: their invoices show what they pay.
  - Moving to a current plan converts every Collector of the account at once, through support (support@domotz.com). It is not meant to raise what the customer pays for the same use.

## Free trial

- 14 days, all features, no credit card, sign-up with a business email. New trials use the per-location model.
- On the per-device model, every discovered device is managed during the trial.
- More time for a proof of concept: hand off to sales or support (`domotz-contact-support`). Never promise the extension yourself.

## Billing terms

- Billed monthly, in advance, by credit card, renewing automatically. The billing day does not change.
- Removing capacity applies from the next billing cycle, with no refund for the current one.
- Collectors can be prepaid, for up to 5 years. Annual and volume terms are agreed with sales.
- An invoice unpaid for 7 days can lead to suspension, and 30 days to termination.
- How to change capacity, see invoices or cancel: `domotz-account-management`.

## Discounts and programs

- Volume and annual discounts exist, through sales.
- Domotz has no MSP or partner program, no NFR licenses, and no price per end customer.

## Domotz Box

- Optional hardware with the Collector preinstalled, for convenient deployment. It includes no subscription. It has the same features as the Collector installed on the customer's own hardware.
- Sold on Amazon in the US, and by local distributors elsewhere. Orders of 25 or more, shipped to the US, Europe or the UK, come from Domotz through sales: ask for the quantity, the destination and a contact.
- Models, limits and alternatives such as Protectli: `domotz-collector-setup`.

## Distributors and marketplaces

- Domotz is also sold through several distributors and marketplaces, for example Pax8, Atera and Elovade. They offer the per-location model.
- Moving an account to or from a distributor: sales or support.
