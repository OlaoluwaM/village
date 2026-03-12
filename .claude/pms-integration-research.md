# Why Direct PMS Integration and Unified API Aggregators Are Impractical for Village

*Researched 2026-03-03. Context: Village is a local social network for apartment communities, built by a single developer, launching first in their own building. No external funding, no existing enterprise customers.*

---

## The Core Problem

Every path to PMS resident data — direct integrations or unified API aggregators — is built exclusively for funded proptech companies with existing enterprise relationships. There is no free tier, no sandbox, no trial, and no accommodation for a solo developer building a social layer on top of resident data from a single building.

The industry is also actively moving in the wrong direction: providers like Entrata have begun introducing API access fees with minimal notice, further squeezing out smaller players.

---

## Direct PMS Providers

### Yardi

**Minimum cost:** $25,000/year *per interface*. Each distinct Yardi integration (e.g., Voyager resident data, RentCafe) requires its own annual license. Some interfaces add per-transaction fees on top.

**Partnership requirements:**
- Company must be at least **2 years old**
- Must have **3 existing Yardi Voyager clients** named as references in the application
- Must sign a **separate agreement for each interface**
- Must identify and use a **pilot client** for beta testing before approval
- Certain categories are **explicitly excluded**: rent payments, tenant screening, renters insurance

**Self-serve access:** None. No sandbox or trial without going through the full partnership program.

**Why it's a non-starter for Village:** A solo developer with no Voyager clients, no 2-year company history, and a single-building use case cannot satisfy any eligibility requirement — let alone justify $25,000/year per API interface.

**Sources:**
- [Become an Interface Partner — Yardi](https://www.yardi.com/company/become-an-interface-partner/)
- [Yardi Interfaces Overview](https://www.yardi.com/company/interfaces/)
- [Yardi Voyager API Integration Guide — ND Consulting](https://ndconsultingllc.com/guide-to-yardi-voyager-api-integration/)

---

### Entrata

**Minimum cost:** $5,000–$50,000+/year. Fees introduced in 2024 with minimal notice to existing partners. Costs scale with usage; webhooks and sandbox access are separate paid tiers. Pricing is negotiated, not published.

**Partnership requirements:**
- Must register as a partner at developer.entrata.com
- Must sign a formal **API Developer Interface Agreement**
- OAuth 2.0 implementation required with data scope approval at submission time
- Credentials provisioned by Entrata — not self-served
- Sandbox and production access both require the paid partner agreement

**Self-serve access:** Partial — documentation and a limited "Try Yourself" environment are public, but production data and webhooks require a signed agreement.

**Why it's a non-starter for Village:** $5,000/year is the floor, priced for companies with an existing proptech product and customer base.

**Sources:**
- [Entrata API Documentation](https://docs.entrata.com/api/v1/documentation)
- [Entrata Enhanced API Program Press Release](https://www.entrata.com/press/entrata-introduces-enchanced-api-program-commitment-to-building-best-partner-ecosystem-in-the-industry)
- [The New Era of API Integration Fees — Transforming Cities](https://transformingcities.io/insights/the-new-era-of-api-integration-fees)
- [Entrata App Store Technical Details](https://docs.entrata.com/app-store/technical)

---

### RealPage

**Cost:** Undisclosed, enterprise custom pricing.

**Partnership requirements:**
- Mandatory **certification** (security, performance, compliance) before any data access
- Three outcomes: full AppPartner, Registered Vendor (single-client only), or Rejection
- All legacy integrations must go through the new RPX certification process

**Self-serve access:** None.

**Why it's a non-starter for Village:** A social network app has no viable reason to pursue or pass RealPage's enterprise certification.

**Sources:**
- [RealPage Exchange AppPartner Program](https://www.realpage.com/exchange/)
- [RealPage Exchange Overview](https://www.realpage.com/lp/realpage-exchange/)
- [RealPage Developer Portal](https://developer.realpage.com/)
- [RealPage Announces Evolution of RPX — BusinessWire](https://www.businesswire.com/news/home/20240115661517/en/RealPage-Announces-the-Evolution-of-RealPage-Exchange)

---

### AppFolio

**Cost:** Not published for the partner program. Platform itself: $1.40–$3.00/unit/month for property managers, with API access only on Plus tier (1,000+ units) and Max tier (enterprise).

**Partnership requirements:**
- Multi-stage application: Application → Security Review + ToS → Final Review
- Opaque criteria — AppFolio does not publish what qualifies an applicant

**Additional constraint:** Property managers whose data you'd integrate must be on Plus/Max tier. A small building almost certainly isn't.

**Self-serve access:** None — even API documentation requires partnership approval.

**Why it's a non-starter for Village:** Blocked on two fronts — developer-side requires multi-stage approval, and the property manager side requires enterprise-tier plans.

**Sources:**
- [AppFolio Stack Partner Program](https://www.appfolio.com/stack/become-a-partner)
- [AppFolio Stack API Documentation](https://www.appfolio.com/stack/partners/api)
- [AppFolio Pricing](https://www.appfolio.com/pricing)

---

### Rent Manager

**Cost:** Not publicly disclosed.

**Partnership requirements:** Application + vetting by Integrations team. No public criteria, no self-serve portal.

**Why it's a non-starter for Village:** Entirely relationship-driven and opaque. No free or low-cost tier documented.

**Sources:**
- [Rent Manager Integrations](https://www.rentmanager.com/integrations/)
- [Rent Manager Solutions Partners](https://www.rentmanager.com/solutions-partners/)

---

## Unified API Aggregators

### Propexo

**What it is:** YC-backed unified API layer across RealPage, Entrata, AppFolio, Yardi, and others.

**Pricing (publicly listed):**
- Starter: **$845/month** (1 system, 1M records/month)
- Growth: **$1,495/month** (unlimited systems, 40 production accounts)
- Professional: **$4,995/month**
- Enterprise: Custom

**Startup program:** 25–45% discounts, but requires having raised funding (up to $3M) and not yet at Series A. Not applicable to an unfunded indie developer.

**Why it's a non-starter for Village:** $845/month ($10,140/year) at the floor, for a product with zero paying customers and one building.

**Sources:**
- [Propexo Pricing](https://propexo.com/pricing)
- [Propexo AccessAPI](https://propexo.com/products/access-api)
- [Propexo for Startups](https://propexo.com/startups)
- [Propexo — Y Combinator](https://www.ycombinator.com/companies/propexo)

---

### Propify (getpropify.com, YC W23)

**What it is:** Unified API layer across Yardi, RealPage, Entrata, Propertyware, Buildium, Rent Manager, Rentvine. Raised $3.3M seed.

**Pricing:** Not publicly listed. Enterprise sales only.

**Important caveat:** Propify does not bypass upstream PMS access requirements — they pass those costs and requirements through to customers. No shortcut around PMS gatekeeping.

**Why it's a non-starter for Village:** No public pricing, no self-serve, enterprise B2B only.

**Sources:**
- [Launch HN: Propify (YC W23) — Hacker News](https://news.ycombinator.com/item?id=35170955)
- [Propify YC Launch Page](https://www.ycombinator.com/launches/IAQ-propify-plaid-for-real-estate)
- [Hidden Costs of PMS Integrations — Propify](https://getpropify.com/post/hidden-costs-of-building-a-property-management-software-integration)
- [RealPage API Integration Guide — Propify](https://getpropify.com/post/proptech-realpage-api-integration)

---

## Summary Table

| Provider | Min. Annual Cost | Partnership Required | Client/Unit Minimum | Self-Serve |
|---|---|---|---|---|
| Yardi | $25,000+/interface | Yes, per-interface | 3 existing Voyager clients; company 2+ yrs old | No |
| Entrata | $5,000–$50,000+ | Yes | Enterprise-oriented | Docs only |
| RealPage | Undisclosed | Yes, certification | None stated; certification can reject | No |
| AppFolio | Undisclosed | Yes, multi-stage | PM must be on Plus/Max (1,000+ units) | No |
| Rent Manager | Undisclosed | Yes, vetting | None stated | No |
| Propexo | $10,140+/year | No (but funding req. for discount) | None, but priced for B2B scale | Pricing only |
| Propify | Undisclosed | Not stated | Requires official PMS credentials per customer | No |

---

## Conclusion

At Village's current stage, none of these paths are accessible by cost, eligibility requirements, or both. The layered verification strategy — PM org-email anchor, per-unit invite codes, self-reported lease info, geofencing, and optional RentCafe scraping — is the right approach given these constraints. Revisit direct integration only after the product has proven traction and has a revenue basis to justify it.
