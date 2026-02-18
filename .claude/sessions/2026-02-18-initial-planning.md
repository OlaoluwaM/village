# Session: Initial Planning — 2026-02-18

## What Happened

This was the first planning session for Village. Started as a conversation about overcoming procrastination/inertia on side projects, then evolved into concrete product planning.

## Key Decisions Made

1. **Scoped v0 to three features**: resident verification (invite codes), postings (bulletin board), and comments with notifications. Nothing else until these ship.

2. **Broadened vision from "Village Square" to "Village"**: After talking to the property manager, reframed the project. Village Square (the bulletin board) is the first feature within Village (a local social network for apartment communities). Future features TBD.

3. **Stack choice**: Haskell + Postgres backend, React PWA frontend. Chose PWA over native mobile since there's React experience but no mobile dev experience. PWA gives mobile-app UX (home screen, push notifications) without app stores.

4. **Hosting plan**: Fly.io for backend (single Haskell binary + managed Postgres), Vercel or Cloudflare Pages for frontend.

5. **Invite codes as verification**: Low-tech, high-trust. Distribute physically via lobby flyers or property manager. Doubles as marketing. Stronger verification can come later.

6. **Building as top-level entity from day one**: Every user and posting scoped to a building. Even with one building at launch, avoids painful retrofit later.

7. **License**: Discussed options. AGPL-3.0 or BSL recommended since this is a product with commercial potential, not a library. Decision deferred — current BSD-3-Clause from scaffold is fine for now.

## Build Order

1. Data model + basic API (buildings, users, postings, comments)
2. Invite code flow
3. Posting creation + feed (one screen, reverse-chronological)
4. Comments + notification subscriptions

## Artifacts Created

- `README.md` — project README reflecting the Village vision
- `.claude/CLAUDE.md` — anonymized project context for Claude Code sessions
- Obsidian vault note: `Agent's Desk/Village Square — Project Plan.md`
- Agent context directory: `village-square/` in agent-context hub

## Context for Next Session

The project is scaffolded (stack template) but no application code has been written yet. The next step is to start on item 1 of the build order: define the data model and basic API. The Haskell source is at `src/Lib.hs` and `app/Main.hs` — both are scaffold defaults.

The property manager is receptive. First deployment target is the author's own apartment complex.
