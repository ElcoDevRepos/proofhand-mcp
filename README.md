# Proofhand MCP server

**Human QA on real devices, as a tool your coding agent can call.**

Your agent (Claude Code, Cursor, Codex, VS Code, anything that speaks MCP or HTTP) posts a *check*: a URL or a TestFlight / Google Play testing link, the steps, and the devices. A vetted human tester runs it on a real iPhone, Android phone or desktop browser and reports **pass / fail / blocked per step, with screenshots or recordings**. Your agent reads the result and keeps going.

- Hosted remote server: `https://proofhand.dev/api/mcp` (streamable HTTP, bearer API key)
- Registry name: `dev.proofhand/proofhand` in the [official MCP Registry](https://registry.modelcontextprotocol.io)
- Pricing: you set the reward per device (default $5, betas from $8) plus a 20% platform fee, reserved up front and refunded if nobody claims the run
- **Launch offer: $5 of checks on us** for the first 25 developers who verify a domain (added to your balance automatically)
- Try it without signing up: **https://demo.proofhand.dev**
- Docs: https://proofhand.dev/docs

This repository holds configuration examples and the registry manifest. The service itself is hosted; there's nothing to run locally.

## Setup

1. Create an account at https://proofhand.dev/signup and verify a domain you own: add a TXT record named `_proofhand.<your domain>` with the value shown in Settings. Many DNS dashboards add your domain to the name for you; in those, type just `_proofhand` (or `_proofhand.staging` for `staging.example.com`). Verifying a domain covers its subdomains, and while launch spots last it adds $5 of checks to your balance. Checks can only target your verified domains and the app betas they list.
2. Add funds and create an API key in **Settings**.
3. Connect your agent:

**Claude Code**

```bash
claude mcp add --transport http proofhand https://proofhand.dev/api/mcp \
  --header "Authorization: Bearer $PROOFHAND_KEY"
```

**Cursor**: [`examples/cursor-mcp.json`](examples/cursor-mcp.json) → `.cursor/mcp.json`

**VS Code**: [`examples/vscode-mcp.json`](examples/vscode-mcp.json) → `.vscode/mcp.json`

**Codex CLI**: [`examples/codex-config.toml`](examples/codex-config.toml) → `~/.codex/config.toml`

**Any HTTP client**: [`examples/create-check.sh`](examples/create-check.sh)

## Tools

| Tool | What it does |
|---|---|
| `create_check` | Post a check: `title`, `target_url`, `steps` [{`instruction`, `expected`}], `devices`, optional `reward_cents`, `testers_per_device` (different people per device; up to 50 runs per check), `test_credentials`, `expires_in_minutes`, `idempotency_key`. Reserves the cost immediately. |
| `wait_for_check` | Long-polls up to 120 s; returns when a run needs review or the check finishes. |
| `get_check` | Current state and every submitted human report. |
| `list_checks` | Recent checks, optionally by status. |
| `approve_run` | Accept a run and pay the tester (approve honest attempts, including ones that found bugs). |
| `reject_run` | Only for low-effort or fabricated work, with a reason that references steps. Testers can dispute. |
| `cancel_check` | Refund every run nobody has claimed. |
| `get_balance` | Available and reserved funds, in cents. |

Devices: `ios-safari`, `android-chrome`, `desktop-chrome`, `desktop-safari`, `desktop-firefox`, `desktop-edge`.

## Example prompt

> I just changed the checkout flow. Use Proofhand to have someone try it on an iPhone and an Android phone at https://staging.example.com/cart: add any item, check out with test card 4242 4242 4242 4242, and confirm the order page appears. Wait for the results and fix anything that fails.

## Native app betas

List your TestFlight public link or Play testing link in `https://<your verified domain>/.well-known/proofhand.json`:

```json
{ "apps": ["https://testflight.apple.com/join/AbCdEf12", "https://play.google.com/apps/testing/com.yourapp"] }
```

## Acceptable use

Only your own sites and apps, staging test accounts and test cards, no CAPTCHAs, verification codes, reviews or third-party account creation. Full policy: https://proofhand.dev/docs#acceptable-use

## Testers

Want to get paid to test apps on your own phone or computer? https://proofhand.dev/testers (US, 18+).

---

Proofhand is run by Elco Dev, LLC. [Terms](https://proofhand.dev/terms) · [Privacy](https://proofhand.dev/privacy). The examples in this repository are MIT-licensed.
