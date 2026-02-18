# Village — Project Context

## What This Is

Village is a local social network for apartment communities. It helps residents connect with the people who live around them — closing the gap between high physical density and low social density in apartment living.

**Village Square** is the first release: a shared bulletin board scoped to individual buildings.

## Vision

"Village Square" is one feature within the broader "Village" platform. The full vision is a resident-only local social network for apartment complexes. Village Square is the town bulletin board; future features fill in the rest of the village:

- TBD

## Stack

- **Backend**: Haskell + Postgres
- **Frontend**: React PWA (progressive web app — mobile-friendly, push notifications, add-to-home-screen, no app store)
- **Hosting plan**: Fly.io for backend (single binary + managed Postgres), Vercel or Cloudflare Pages for frontend

## Architecture Decisions

### Building is the top-level entity

Every user belongs to a building. Every posting is scoped to a building. Even with one building at launch, this is baked in from day one to avoid a painful retrofit later.

### Resident verification via invite codes (v0)

Generate a code per building, distribute physically (lobby flyer, property manager handoff). Low-tech, high-trust, easy to build. Stronger verification methods (mail, ID) can come later if needed. Invite code distribution doubles as marketing.

### PWA over native mobile

The author has React experience but no mobile dev experience. A PWA gives mobile-app-like UX (home screen icon, push notifications, offline support) without app store friction. Existing React knowledge means course-correcting when vibe-coding the frontend is feasible.

## v0 Features (Village Square)

1. **Resident verification** — invite code flow (generate code → sign up with code → scoped to building)
2. **Postings** — residents create bulletin-board-style posts visible to their building
3. **Comments + notifications** — comment on postings, auto-subscribe on comment, notify on new activity

## Build Order

1. Data model + basic API (buildings, users, postings, comments)
2. Invite code flow
3. Posting creation + feed (one screen, reverse-chronological)
4. Comments + notification subscriptions

## Key Context

- The author lives in an apartment complex — they are their own first user
- The property manager has been consulted and is receptive
- The property manager relationship is both a distribution channel and a legitimacy signal

## Session History

Check `.claude/sessions/` for chronological session logs. Read the most recent one(s) to pick up context from prior conversations.
