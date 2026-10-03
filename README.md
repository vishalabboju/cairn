# Cairn

**Tell us where you are and where you want to go. We'll show you what it takes to get there and what to do next.**

Personalized career-exploration and navigation for students, postgrads, recent graduates and early-career professionals. Explore → Assess → Gap → Roadmap → Learn → Project → Prove → Opportunities → Reassess → Pivot (without losing progress).

## Quickstart

```bash
npm install
npm run db:setup   # prisma db push + seed
npm run dev        # http://localhost:3000
```

Demo account (seeded, ~40% roadmap, 2 projects, 7-day streak): **demo@cairn.app / Demo@1234** — or click **Try Demo** on the landing page.

## Env
See `.env.example`. Required: `DATABASE_URL`, `JWT_SECRET`, `JWT_REFRESH_SECRET`. Optional: `ANTHROPIC_API_KEY`, `MENTOR_MODEL` (mentor falls back to rule-based using roadmap data when absent).

## Scripts
`dev | build | start | lint | typecheck | db:push | db:seed | db:setup | test (vitest) | test:e2e (playwright)`

## Architecture / folders
Next.js 14 App Router + Route Handlers; Prisma + SQLite (PostgreSQL-compatible); JWT httpOnly cookies; Zod; TanStack Query; Recharts; Tailwind. See `docs/architecture.md`, `docs/database.md`, `docs/api.md`, `docs/algorithms.md`.

`/app` (pages + `/api`) `/components` `/lib/auth|db|engine|validation|utils` `/prisma` `/tests` `/docs` `/public`

## API table
See `docs/api.md` (auth, profile, careers, assessment, goals, gap, roadmap, resources, projects, portfolio, dashboard, opportunities, mentor, feedback, health).

## Algorithms
- Skill: `current = 0.7*assessed + 0.3*selfMapped (+evidence ≤0.6)`; `gap = max(0, required-current)`; severity none/small/medium/large; priority `gap*weight`; match `Σmin(cur,req)*w / Σreq*w *100`. Details in `docs/algorithms.md`.

## Auth
Email/password, bcrypt(10), access 30m + refresh 30d, httpOnly + SameSite=Lax + Secure-in-prod, middleware guards dashboard/roadmap/assessment/onboarding/projects/opportunities/learn/pathways/profile/mentor. All user queries scoped by server user id (IDOR-safe).

## AI mentor
POST /api/mentor grounds replies in profile/goal/gaps/roadmap/projects; returns `{reply, suggestedPlan}`; UI supports Apply-to-roadmap (reassess). Without key: deterministic fallback + banner.

## Testing
`npm test` (Vitest unit: levels/gaps/match/edge cases) · `npm run test:e2e` (Playwright 1280 + 360 journey: landing→explore→compare→register→onboarding→assessment→detail→gap→roadmap→dashboard→project→opportunity→pathway→pivot→logout/login). `smoke.ps1` runs the same journey against a live server via raw API calls.

## Screenshots
`public/screenshots/landing.png`, `explore.png`, `dashboard.png` (demo Arjun, 39% roadmap, 7-day streak), `roadmap.png`, `gap.png`.

## PostgreSQL migration
Change `provider` to `postgresql`, set `DATABASE_URL`, `npx prisma db push && npm run db:seed`. Schema uses portable types only.

## Known limitations
- Screenshot upload captured as URL fields (2MB PNG/JPG/WEBP guidance) rather than binary store
- Salary data omitted by design (no promises); opportunities are labelled demo/seed with source/asOfDate fields ready for live feeds
- Mentor AI requires key for full mode; fallback is rule-based

## Future (P2, not built)
Resume autofill, LinkedIn/GitHub optimizers, feeds, notifications, employer/university integrations, paid courses.
