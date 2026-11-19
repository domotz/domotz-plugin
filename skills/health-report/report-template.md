# Health report — client page template

The assistant copies the HTML in the code block below, unchanged except for the JSON in the
`<script id="report">` element, and publishes it as an HTML artifact. The JSON shown is sample
data. To preview the page, save the code block as an `.html` file and open it in a browser.

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>Network Health Report</title>
<!--
  Health report: client-ready page template.
  The assistant copies this file unchanged and replaces ONLY the JSON data block
  that follows this comment (the script element whose id is "report").
  The sample data in it is example data, not a real account.
-->
<script id="report" type="application/json">
{
  "client": "Brightwater Logistics",
  "sites": ["Brightwater Logistics - HQ", "Brightwater Logistics - Warehouse"],
  "period": "16 Sep – 16 Oct 2026",
  "comparison": "17 Aug – 16 Sep 2026",
  "devices": 61,
  "important": 22,
  "verdict": "issues",
  "headline": "Stable with issues",
  "summary": "Your network ran well this month: 20 of your 22 important devices were available 99.9% of the time or better. The warehouse lost its internet link twice on 3 October, for 47 minutes in total; we traced it to the provider and it has not happened since. Next month we will replace the warehouse access point that keeps dropping off.",
  "kpis": [
    {"label": "Important devices at 99.9% or better", "now": "20 of 22", "before": "—"},
    {"label": "Lowest device availability", "now": "WH-AP-02 98.71%", "before": "—"},
    {"label": "Monitoring connection", "now": "99.84%", "before": "99.97%"},
    {"label": "Outages of important devices (5 min or more)", "now": "4", "before": "—"},
    {"label": "Alerts raised", "now": "37", "before": "52"},
    {"label": "Remote support sessions", "now": "6", "before": "—"},
    {"label": "Changes made by your team", "now": "14", "before": "9"}
  ],
  "availability": [
    {"device": "WH-AP-02 (warehouse Wi-Fi)", "site": "Warehouse", "pct": "98.71", "outages": 3, "longest": "4 h 12 min"},
    {"device": "WH-GW (internet router)", "site": "Warehouse", "pct": "99.89", "outages": 2, "longest": "31 min"}
  ],
  "availability_rest": "20 other important devices at 99.9% or better",
  "offline_all_period": ["Old NVR (retired?)"],
  "incidents": [
    {"when": "3 Oct, 09:12", "what": "Warehouse internet link down twice (provider fault)", "duration": "47 min"},
    {"when": "11 Oct, 22:40", "what": "Warehouse Wi-Fi access point WH-AP-02 offline", "duration": "4 h 12 min"}
  ],
  "alerts": {
    "sentence": "37 alerts this month (2 critical, 11 warnings, 24 informational), 3 still open.",
    "rules": [
      {"rule": "Device Status", "count": 14, "meaning": "Devices going offline; mostly WH-AP-02"},
      {"rule": "High latency", "count": 12, "meaning": "Short spikes on cameras; most cleared within 5 minutes"},
      {"rule": "New device discovered", "count": 8, "meaning": "New devices joined the network; review them"}
    ]
  },
  "work": [
    {"area": "Remote support sessions", "count": 6, "examples": "Firewall and NAS maintenance"},
    {"area": "Alerting changes", "count": 5, "examples": "Down alerts added to both switches"},
    {"area": "Device work", "count": 3, "examples": "Rebooted WH-AP-02 twice; renamed a camera"}
  ],
  "next": [
    {"id": "R1", "text": "Replace or re-site WH-AP-02: 3 outages this month, the longest 4 h 12 min."},
    {"id": "R2", "text": "Run an alert tune-up: 9 of 12 latency alerts cleared within 5 minutes."},
    {"id": "R3", "text": "Confirm the old NVR was retired; it was offline all month."}
  ],
  "appendix": {
    "collectors": [
      {"name": "Brightwater Logistics - HQ [325688]", "status": "Online", "version": "9.6.0", "connectivity": "99.98%", "intervals": 2, "longest": "6 min", "notes": ""},
      {"name": "Brightwater Logistics - Warehouse [325701]", "status": "Online", "version": "9.6.0", "connectivity": "99.70%", "intervals": 5, "longest": "31 min", "notes": "Went offline with the internet link on 3 Oct"}
    ],
    "notes": [
      {"label": "Monitoring gaps", "text": "Old NVR [2843990] offline all period; collector reads SNMP with the platform default community"},
      {"label": "Alert coverage", "text": "Alert rules only; no classic alerts on important devices"},
      {"label": "Sources", "text": "Domotz app 12, API 0, AI assistant 2, Domotz support 0; failed actions 0"},
      {"label": "Not covered", "text": "Nothing"}
    ]
  }
}
</script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Archivo:wght@500;700;800&family=IBM+Plex+Sans:wght@400;500;600&family=IBM+Plex+Mono:wght@400;500&display=swap">
<style>
/* Layout: a monthly service report. Client part first (verdict, numbers, availability,
   incidents, alerts, work, next steps), then a quieter technician appendix. */
:root {
  --bg: #f4f6f8;
  --paper: #ffffff;
  --ink: #1d2733;
  --muted: #5c6a79;
  --line: #dfe5eb;
  --brand: #22303f;
  --accent: #1f8ff0;
  --accent-soft: #dcecfc;
  --good: #19865a;
  --good-soft: #dcf2e7;
  --warn: #b36d08;
  --warn-soft: #fbedd6;
  --bad: #c2392f;
  --bad-soft: #f9dfdc;
  --display: "Archivo", "Helvetica Neue", Arial, sans-serif;
  --body: "IBM Plex Sans", -apple-system, "Segoe UI", Roboto, sans-serif;
  --mono: "IBM Plex Mono", ui-monospace, "SF Mono", Menlo, monospace;
  color-scheme: light;
}
@media (prefers-color-scheme: dark) {
  :root:not([data-theme="light"]) {
    --bg: #141b23; --paper: #1b242e; --ink: #e5ecf3; --muted: #9aa8b6; --line: #2c3845;
    --brand: #0e141a; --accent: #57b3ff; --accent-soft: #1c3953; --good: #43d394; --good-soft: #163829;
    --warn: #f0aa45; --warn-soft: #3a2c16; --bad: #ff7d72; --bad-soft: #42201d; color-scheme: dark;
  }
}
:root[data-theme="dark"] {
  --bg: #141b23; --paper: #1b242e; --ink: #e5ecf3; --muted: #9aa8b6; --line: #2c3845;
  --brand: #0e141a; --accent: #57b3ff; --accent-soft: #1c3953; --good: #43d394; --good-soft: #163829;
  --warn: #f0aa45; --warn-soft: #3a2c16; --bad: #ff7d72; --bad-soft: #42201d; color-scheme: dark;
}
* { box-sizing: border-box; }
html, body { margin: 0; }
body { background: var(--bg); color: var(--ink); font: 15px/1.55 var(--body); }
.wrap { max-width: 880px; margin: 0 auto; padding-inline: 16px; }
header.top { background: var(--brand); color: #fff; }
header.top .wrap { padding-block: 16px; display: flex; flex-wrap: wrap; gap: 6px 20px; align-items: baseline; justify-content: space-between; }
.eyebrow { font: 600 12px/1 var(--body); letter-spacing: .12em; text-transform: uppercase; color: #8fc9ff; }
.period { font: 400 13px/1.4 var(--mono); color: #c9d4df; }
main.wrap { padding-block: 0 48px; }
h1, h2, h3 { font-family: var(--display); text-wrap: balance; margin: 0; }
.hero { padding-block: 30px 6px; display: grid; gap: 14px; }
.client { font: 600 13px/1 var(--body); letter-spacing: .08em; text-transform: uppercase; color: var(--muted); }
.hero h1 { font-size: clamp(30px, 6vw, 44px); font-weight: 800; line-height: 1.05; letter-spacing: -.01em; display: flex; flex-wrap: wrap; gap: 10px 14px; align-items: center; }
.dot { width: 14px; height: 14px; border-radius: 50%; flex: none; }
.v-healthy .dot { background: var(--good); }
.v-issues .dot { background: var(--warn); }
.v-attention .dot { background: var(--bad); }
.sites { color: var(--muted); font-size: 14px; }
.summary { font-size: 17px; line-height: 1.6; max-width: 68ch; margin: 0; }
section { margin-top: 34px; }
.sec-head { display: flex; justify-content: space-between; align-items: baseline; gap: 12px; border-bottom: 2px solid var(--ink); padding-bottom: 8px; }
.sec-head h2 { font-size: 20px; font-weight: 700; }
.sec-head span { font: 600 12px/1 var(--body); letter-spacing: .08em; text-transform: uppercase; color: var(--muted); }
.scroll { overflow-x: auto; }
table { width: 100%; border-collapse: collapse; font-variant-numeric: tabular-nums; }
th { font: 600 12px/1.2 var(--body); letter-spacing: .06em; text-transform: uppercase; color: var(--muted); text-align: left; padding: 12px 10px 8px 0; }
td { padding: 11px 10px 11px 0; border-bottom: 1px solid var(--line); vertical-align: top; }
td.num, th.num { text-align: right; white-space: nowrap; }
td.num + td, th.num + th { padding-left: 16px; }
td.num { font-family: var(--mono); font-size: 14px; }
.kpis td:first-child { color: var(--ink); }
.kpis td.prev { color: var(--muted); }
.kpis td.num { font-family: var(--body); font-size: 15px; white-space: normal; min-width: 7em; }
.kpis td.now { font-weight: 600; }
.pct { font: 700 17px/1 var(--display); }
.pct.low { color: var(--bad); }
.pct.mid { color: var(--warn); }
.dev small { display: block; color: var(--muted); font-size: 13px; }
.rest { color: var(--muted); font-size: 14px; padding-top: 10px; }
.rest b { color: var(--good); font-weight: 600; }
.empty { color: var(--muted); padding-top: 12px; margin: 0; }
.incident td:first-child { white-space: nowrap; font-family: var(--mono); font-size: 13px; color: var(--muted); }
.alert-line { margin: 12px 0 0; }
.next { list-style: none; margin: 14px 0 0; padding: 0; display: grid; gap: 10px; }
.next li { display: grid; grid-template-columns: 44px minmax(0, 1fr); gap: 12px; align-items: start; background: var(--paper); border: 1px solid var(--line); border-radius: 6px; padding: 12px; }
.next .id { font: 500 13px/1 var(--mono); padding: 5px 0; text-align: center; border-radius: 3px; background: var(--accent-soft); }
.appendix { margin-top: 48px; padding-top: 4px; border-top: 1px dashed var(--line); }
.appendix .sec-head { border-bottom-width: 1px; border-color: var(--muted); }
.appendix .sec-head h2 { font-size: 17px; color: var(--muted); }
.appendix table { font-size: 13px; }
.appendix td.num { font-size: 13px; }
.appendix dl { margin: 14px 0 0; display: grid; grid-template-columns: 150px minmax(0, 1fr); gap: 8px 14px; font-size: 14px; }
.appendix dt { font-weight: 600; }
.appendix dd { margin: 0; color: var(--muted); min-width: 0; }
footer { margin-top: 28px; font: 400 12px/1.5 var(--mono); color: var(--muted); }
@media (max-width: 600px) {
  .appendix dl { grid-template-columns: minmax(0, 1fr); }
  .appendix dd { margin-bottom: 6px; }
  .hide-sm { display: none; }
}
</style>
</head>
<body>
<header class="top"><div class="wrap">
  <span class="eyebrow">Network health report</span>
  <span class="period" id="period"></span>
</div></header>
<main class="wrap">
  <div class="hero" id="hero">
    <span class="client" id="client"></span>
    <h1><span class="dot" aria-hidden="true"></span><span id="headline"></span></h1>
    <span class="sites" id="sites"></span>
    <p class="summary" id="summary"></p>
  </div>

  <section>
    <div class="sec-head"><h2>This month at a glance</h2></div>
    <div class="scroll"><table class="kpis">
      <thead><tr><th></th><th class="num" id="h-now"></th><th class="num" id="h-before"></th></tr></thead>
      <tbody id="kpis"></tbody>
    </table></div>
  </section>

  <section>
    <div class="sec-head"><h2>Availability of important devices</h2><span id="avail-count"></span></div>
    <div class="scroll" id="avail-table"><table>
      <thead><tr><th>Device</th><th class="num">Availability</th><th class="num">Outages</th><th class="num hide-sm">Longest</th></tr></thead>
      <tbody id="avail"></tbody>
    </table></div>
    <div class="rest" id="avail-rest"></div>
  </section>

  <section>
    <div class="sec-head"><h2>Incidents</h2></div>
    <div class="scroll" id="inc-table"><table>
      <thead><tr><th>When</th><th>What happened</th><th class="num">How long</th></tr></thead>
      <tbody id="incidents"></tbody>
    </table></div>
  </section>

  <section id="alerts-sec">
    <div class="sec-head"><h2>Alerts</h2></div>
    <p class="alert-line" id="alert-line"></p>
    <div class="scroll"><table>
      <thead><tr><th>Rule</th><th class="num">Alerts</th><th>What it means</th></tr></thead>
      <tbody id="rules"></tbody>
    </table></div>
  </section>

  <section>
    <div class="sec-head"><h2>Work performed</h2><span id="work-total"></span></div>
    <div class="scroll" id="work-table"><table>
      <thead><tr><th>Area</th><th class="num">Actions</th><th>Examples</th></tr></thead>
      <tbody id="work"></tbody>
    </table></div>
  </section>

  <section id="next-sec">
    <div class="sec-head"><h2>Next steps</h2></div>
    <ul class="next" id="next"></ul>
  </section>

  <section class="appendix">
    <div class="sec-head"><h2>Technician appendix</h2><span>For the MSP</span></div>
    <div class="scroll"><table>
      <thead><tr><th>Collector</th><th>Status</th><th class="hide-sm">Version</th><th class="num">Connectivity</th><th class="num">Intervals</th><th class="num hide-sm">Longest</th><th class="hide-sm">Notes</th></tr></thead>
      <tbody id="collectors"></tbody>
    </table></div>
    <dl id="app-notes"></dl>
  </section>

  <footer id="foot"></footer>
</main>
<script>
(function () {
  var d = JSON.parse(document.getElementById("report").textContent);
  var $ = function (id) { return document.getElementById(id); };
  var el = function (tag, cls, text) { var e = document.createElement(tag); if (cls) e.className = cls; if (text != null) e.textContent = String(text); return e; };
  var td = function (text, cls) { return el("td", cls, text); };
  function empty(tableId, text) { var t = $(tableId); t.replaceWith(el("p", "empty", text)); }

  $("period").textContent = d.period + (d.comparison ? " · compared with " + d.comparison : "");
  $("client").textContent = d.client;
  $("hero").classList.add("v-" + (d.verdict || "issues"));
  $("headline").textContent = d.headline;
  $("sites").textContent = (d.sites || []).join(" · ") + " · " + d.devices + " devices, " + d.important + " important";
  $("summary").textContent = d.summary;

  $("h-now").textContent = "This period";
  $("h-before").textContent = "Previous";
  (d.kpis || []).forEach(function (k) {
    var r = el("tr"); r.append(td(k.label), td(k.now, "num now"), td(k.before, "num prev")); $("kpis").append(r);
  });

  var av = d.availability || [];
  av.forEach(function (a) {
    var p = parseFloat(a.pct), r = el("tr");
    var dev = td(null, "dev"); dev.append(document.createTextNode(a.device)); if (a.site) dev.append(el("small", null, a.site));
    var pc = td(null, "num"); pc.append(el("span", "pct" + (p < 99 ? " low" : p < 99.9 ? " mid" : ""), a.pct + "%"));
    r.append(dev, pc, td(a.outages, "num"), td(a.longest, "num hide-sm")); $("avail").append(r);
  });
  if (!av.length) $("avail-table").hidden = true;
  var rest = $("avail-rest");
  if (d.availability_rest) { var b = el("b", null, "✓ "); rest.append(b, document.createTextNode(d.availability_rest)); }
  if ((d.offline_all_period || []).length) rest.append(el("div", null, "Offline the whole period (left out of the figures): " + d.offline_all_period.join(", ")));
  if (!av.length && !d.availability_rest) rest.textContent = "Device availability was not readable for this period.";

  var inc = d.incidents || [];
  inc.forEach(function (i) { var r = el("tr", "incident"); r.append(td(i.when), td(i.what), td(i.duration, "num")); $("incidents").append(r); });
  if (!inc.length) empty("inc-table", "No incidents this period.");

  if (d.alerts && d.alerts.sentence) {
    $("alert-line").textContent = d.alerts.sentence;
    (d.alerts.rules || []).forEach(function (a) { var r = el("tr"); r.append(td(a.rule), td(a.count, "num"), td(a.meaning)); $("rules").append(r); });
    if (!(d.alerts.rules || []).length) $("rules").closest(".scroll").hidden = true;
  } else { $("alerts-sec").hidden = true; }

  var work = d.work || [], total = 0;
  work.forEach(function (w) { total += Number(w.count) || 0; var r = el("tr"); r.append(td(w.area), td(w.count, "num"), td(w.examples)); $("work").append(r); });
  if (!work.length) empty("work-table", "No configuration changes this period.");
  else $("work-total").textContent = total + " actions";

  var next = d.next || [];
  next.forEach(function (n) { var li = el("li"); li.append(el("span", "id", n.id), el("div", null, n.text)); $("next").append(li); });
  if (!next.length) $("next-sec").hidden = true;

  var ap = d.appendix || {};
  (ap.collectors || []).forEach(function (c) {
    var r = el("tr");
    r.append(td(c.name), td(c.status), td(c.version, "hide-sm"), td(c.connectivity, "num"), td(c.intervals, "num"), td(c.longest, "num hide-sm"), td(c.notes, "hide-sm"));
    $("collectors").append(r);
  });
  (ap.notes || []).forEach(function (n) { $("app-notes").append(el("dt", null, n.label), el("dd", null, n.text)); });

  $("avail-count").textContent = av.length ? av.length + " below 99.9%" : "";
  $("foot").textContent = "Read from Domotz through the Domotz MCP server · " + d.client + " · " + d.period;
})();
</script>
</body>
</html>
```
