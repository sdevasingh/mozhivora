# MOZHIVORA

**One workspace. Every task. Smarter with AI.**  
An AI workspace for writing, reading, studying, planning, and meetings on Android and Web — built with a warm editorial design, multilingual depth (11+ Tier 1 Indian & world languages + Urdu/Arabic RTL), and transparent regional pricing.

## Architecture Overview

- **App (`lib/`)**: Flutter (Material 3, Riverpod, `go_router`) — single codebase for Android and Web.
- **Marketing & SEO Site (`web_marketing/`)**: Astro static HTML site sharing MOZHIVORA's design tokens.
- **Backend (`supabase/`)**: Supabase Auth, Postgres + `pgvector`, Storage, and Edge Functions (`ai-gateway`, `embed-document`, `payments-webhook`, `play-billing-verify`, `credits-reset`).
- **CI (`.github/workflows/ci.yml`)**: Runs `flutter analyze`, `flutter test`, `flutter build web`, and builds `web_marketing/`.

## Repository Layout

- `lib/app/` — App root, `go_router` configuration, Material 3 theme & design tokens
- `lib/core/` — Config, errors, network, localization helpers
- `lib/shared/` — Reusable UI components (Responsive Shell, Unified Command Bar, Credits Ring, Empty State)
- `lib/features/` — Clean architecture (`data/`, `domain/`, `presentation/`) per feature:
  - `auth`, `onboarding`, `dashboard`, `ask`, `ai_writer`, `documents`, `document_chat`, `email`, `notes_study`, `translator`, `voice`, `task_planner`, `templates`, `workspace`, `subscription`, `settings`
- `lib/l10n/` — ARB localization files (`app_en.arb`, `app_hi.arb`, `app_ur.arb`)
- `web_marketing/` — Astro SEO marketing site
- `test/`, `integration_test/` — Unit, widget, and integration tests

## Running Locally

### Prerequisites
- Flutter SDK (stable) with `flutter_gen` / `gen-l10n`
- Node.js 20+ (for `web_marketing/`)

### Run Flutter App (Web)
```bash
flutter pub get
flutter gen-l10n
flutter run -d chrome
```

### Run Flutter App (Android)
```bash
flutter pub get
flutter gen-l10n
flutter run
```

### Run Tests & Static Analysis
```bash
flutter analyze --fatal-infos
flutter test
```

### Build SEO Marketing Site
```bash
cd web_marketing
npm install
npm run build
```

## Build Phases
1. **Foundation** (Current): Design tokens, branding, 3-screen onboarding, responsive navigation, dashboard shell, EN/HI/UR (RTL) localization, SEO marketing site, CI.
2. **Accounts & Data**: Supabase Auth (email, Google, phone OTP), Postgres + pgvector migrations, RLS policies, profiles & preferences.
3. **Core AI**: `ai-gateway` edge function (Gemini Flash/Pro router, SSE streaming < 1.5s, atomic credit reservation & moderation), Ask, Writer, Email, Notes, Translator, Templates.
4. **Documents**: Upload, OCR, Summarizer, pgvector embeddings, Document Chat with page-level citations.
5. **Productivity**: Task Planner, Workspace, version history, read-only share links, Voice & Meetings.
6. **Monetisation**: Credit ledger, Google Play Billing, Razorpay (UPI), Stripe/Paddle webhooks, referrals.
7. **Android Extras**: Share-sheet, home widget, offline-first sync, FCM push, biometric lock.
8. **Launch**: Security audit, performance tuning, Play Store release, analytics.
