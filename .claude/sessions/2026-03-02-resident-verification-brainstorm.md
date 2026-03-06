# Session: Resident Verification Brainstorm — 2026-03-02

## Scope Update (2026-03-03)

Scope reduced to a single building — Olaolu's own apartment complex. The strategy below was designed for multi-building scaling; much of its complexity was shaped by that requirement. For the current scope, the minimal viable approach is: (1) PM distributes codes directly to residents via a personal channel, (2) mandatory registration geofencing. Everything else is preserved for if/when scope expands.

## What Happened

Brainstorming session on resident verification — the core trust mechanism that makes Village work. Explored the problem space, ruled out several approaches, and arrived at a layered strategy that optimizes for cost and autonomy while accepting some accuracy tradeoffs.

## Problem Framing

There are three parameters to optimize for: **cost**, **accuracy**, and **autonomy** (how automatic it is). Realistically, you can only optimize two of three:

- Most accurate + most automatic = most expensive (unified PMS APIs like Propexo/Propify, or direct Yardi integration)
- Cheapest + most automatic = least accurate (no real validation)
- Cheapest + most accurate = least autonomous (manual, human-in-the-loop)

Some false positives are acceptable — this is a local social network, not a bank. The goal is non-trivial to fool, not cryptographic certainty.

## Approaches Ruled Out

- **Direct PMS integration** (Yardi, Entara, etc.) — too expensive, too time-costly per provider
- **Unified PMS APIs** (Propexo, Propify) — still too expensive for a solo founder at launch
- **Plaid / rent payments** — accuracy problem: rent transactions list the payment processor, not the apartment complex. Association between transaction and building isn't reliably inferable. Also, transaction data doesn't contain lease start/end dates at all — Plaid could at best signal ongoing residency via recurring payments, but can't tie those payments to a specific building reliably. Not a substitute for RentCafe scraping for the lease date verification use case.
- **Property manager as ongoing gatekeeper** — creates a bottleneck, and PM turnover is a real operational fragility. Every new PM would need to be onboarded to their role in the verification flow.
- **Physical mail verification** — postal delays make it slow, per-verification cost adds up at scale, and it bottlenecks on the postal service

## The Strategy

A layered approach where each layer covers the failure modes of the others:

### 1. Property Manager Anchor (Building Registration)
The PM signs up first, using the **official property management email** (not a personal one). The account is tied to the organization, not the individual — so it survives PM turnover. Public email domains (Gmail, Outlook, iCloud, Yahoo, ProtonMail, etc.) are blocked as a proxy for "unofficial." It's best-effort; there's only so much you can do without an external API. But it raises the bar.

### 2. Invite Codes (Resident Onboarding)
The PM generates invite codes that residents use to register. The PM's only responsibility is generating and distributing the codes — no further validation burden on them. We assume a resident is valid upon registering with a valid code.

*Original addition: time-limit a single building-wide code to ~2 weeks. Reduces the lobby-flyer attack surface.*

*Refined: **per-unit codes** are meaningfully stronger. PM generates a batch — one code per unit — when onboarding the building. One-time work, not ongoing. Residents receive their unit's code directly (email, slip under the door, etc.) rather than from a public flyer. A bad actor would need to intercept a specific resident's communication rather than photograph one flyer. Per-unit codes also pair naturally with the unit number collected at registration — a code issued for unit 4B should only be valid for someone registering as unit 4B, closing a small but real gap.*

### 3. Self-Reported Lease Info
At registration, residents provide their lease start and end dates, plus their **unit number**. The unit number doesn't verify anything on its own, but it ties a user to a specific unit — and combined with geofencing becomes a meaningful consistency check. Access is limited based on the lease end date.

*Addition: unit number was not in the original plan — adds specificity cheaply.*

### 4. Grace Period + Lease Renewal
As a lease approaches expiry, users get a grace period to update their lease info. We could have the PM verify renewals, but that adds friction and delays. Self-reported is acceptable given the other layers.

### 5. Periodic Geofencing (Failsafe)
A Netflix-household-style periodic geofencing check prevents someone from entering a bogus lease end date and retaining access indefinitely after moving out. Exact policy TBD, but something like "user must be within X meters of the complex at least once in the last Y days."

*Addition: lean toward **recency** over frequency for the policy. "Within X meters in the last 30 days" handles vacationers and infrequent users better than a count-based threshold. Someone on a 3-week trip is fine; someone who moved out 6 months ago will never trigger it. Also, when a lease expires and a user renews during the grace period, require them to re-verify location — closes the gap between self-reported renewal and actual presence.*

### 6. Geofencing at Registration (Strongest Layer)
Residents can only register from within the apartment complex. This is the hardest layer to fake — you have to physically be there. Strongly considering making this **mandatory**, not optional.

*Addition: this should be mandatory. It's the only check that genuinely requires physical presence. It also sets a baseline location anchor for the user that later geofencing checks can reference.*

## Optional Enhancement: RentCafe Portal Scraping

For buildings on Yardi/RentCafe, there's an optional stronger signal: log into the resident's RentCafe account on their behalf, read lease start/end dates, immediately discard the credentials. Replaces self-reported lease info with data pulled directly from the PMS.

This is an enhancement, not a foundation — it only works for RentCafe buildings, carries a ToS violation risk, and adds scraping infrastructure. The layered strategy works without it.

**Security for a one-time read:**
- HTTPS in transit
- Credentials in memory only — never written to disk, DB, or logs
- Log sanitization is the main gotcha — must explicitly exclude credentials from request logging
- Discard immediately after the portal read completes

**Implementation considerations:**
- RentCafe is JS-heavy — needs a headless browser (Playwright)
- Verify lease dates actually appear in the portal UI before building around it — check your own RentCafe account first
- Portal UI changes can silently break scrapers
- 2FA on a resident's account breaks the flow entirely

**Long-term:** if Yardi opens a public OAuth program, this becomes a clean delegated auth flow. Worth revisiting at scale.

## Open Questions

- Exact geofencing policy parameters (radius, recency window, grace on expiry)
- Whether registration geofencing is mandatory or optional
- How to handle legitimate edge cases: subletters, multi-resident units, accessibility situations where someone can't easily be near the building
- Whether to implement RentCafe scraping as an optional stronger signal at launch

## Artifacts

- Session log: `.claude/sessions/2026-03-02-resident-verification-brainstorm.md` (this file)
- Agent context: `village-square/resident-verification.md` in agent-context hub
