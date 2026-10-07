# Alert tune-up

**Cut the noise. Keep the signal.**

Noisy alerts get muted. Laptops that "go down" every evening, rules that fire on every tiny
interface error, three rules alerting for the same outage: after enough of them, techs mute
the channel, and the alert that mattered is missed too.

This playbook reads a client's alert history and tells you, with evidence:

- **Safe to retire** — duplicate rules that alert several times for one event, conditions
  that can never clear, status alerts on devices that are switched off every day, such as staff laptops.
- **Worth re-tuning** — real metrics with the wrong threshold, with a proposed new value and
  how many of the window's alerts it would have removed.
- **Leave alone** — real signal: collector outages, infrastructure going down, and site-wide
  problems where the fix is the network, not the alert.

It ends with numbered batches of changes. Approve a batch and your assistant applies it
through the Domotz MCP server, checks that it took effect, and shows you how to undo it.

The report fits on one screen: how many alerts the changes would have saved, a table of changes
with the reason and key number for each, and what to leave alone
([example](example-report.md)). Where the playbook is installed as a skill and your chat can
show HTML pages (such as Claude artifacts), it also shows the report as a one-page review for
your team, built from [`report-template.html`](report-template.html). Say "text only" to skip it.

## What it changes

Only after you approve a batch by its number, and only reversible changes:

- unbind a rule from a device or collector (undo: bind it back);
- change a rule's threshold, condition or severity (undo: restore the recorded values).

It never deletes rules or devices, never changes notification channels, and never snoozes.
Resolving leftover open alerts is offered only as a separate, optional batch because it cannot
be undone.

## What it needs

- The Domotz MCP server connected to your assistant ([how](../../connect/)).
- **A frontier model**: Claude Sonnet or Opus, or an equivalent model from another provider.
  Small fast models (such as Claude Haiku) follow the steps but miscount and invent findings,
  so we don't recommend them for this playbook.
- About 25k tokens of context per 100 alerts read. One client over 14 days is usually well
  within that; for large scopes the playbook narrows the window or samples and says so.
- An audit of a few hundred alerts usually takes 4–7 minutes and 40–60 tool calls.

## Limits

- Domotz has no "only alert if it lasts N minutes" setting, so flapping is handled by
  thresholds, unbinding, or fixing the device.
- Domotz doesn't show which notification channel a rule uses, so the playbook asks you to check
  channels yourself before retiring a duplicate.
- Retiring a default rule doesn't stop Domotz attaching it to collectors you add later.

Starter prompts: [prompts.md](prompts.md).
