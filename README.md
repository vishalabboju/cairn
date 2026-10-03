# Cairn

*Build your path, one stone at a time.*

Cairn helps university students explore careers, understand the skills they
need, and follow a personalized plan toward a goal. Information is shown
progressively, so beginners are never overwhelmed.

## What it does

- **Discover careers:** browse without logging in, with role details, required
  skills, what companies look for, and estimated salary ranges.
- **Skill-gap view:** compare your proven skills (tests, projects) with what
  your chosen career needs.
- **Roadmap:** a weekly and monthly plan that updates when your skills or
  interests change.
- **Passion block:** pathways beyond your goal, such as government jobs,
  startup ideas, and games or areas where you are already strong.
- **Alternative paths:** backup careers with smaller skill gaps.
- **AI mentor:** answers career questions and suggests next steps.
- **Progress tracking:** streaks, levels, achievements, and certificates.

## Status

Early development. Current focus: the core loop (goal, level, gap, plan, track)
and the passion block.

## Documentation

See [`docs/architecture.pdf`](docs/architecture.pdf) for the full architecture.

## Tech stack

React and TypeScript, a modular API service, PostgreSQL with pgvector, Redis,
and an LLM API for the AI mentor.

