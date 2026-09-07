# Everstride

**Every step shapes your journey.**

Everstride is a health-powered RPG mobile game where real-world activity becomes in-game progress.

Walk in real life, earn energy, complete adventures, level up your character, collect equipment, and progress through a fantasy world.

## Core Concept

Real-world activity drives your in-game progression:

- Steps → Energy
- Energy → Adventures
- Adventures → EXP, Gold, and Items
- EXP → Character Progression

## Tech Stack

- Flutter
- Dart
- Riverpod
- GoRouter
- Health Connect
- Drift / SQLite
- Supabase
  - Auth
  - PostgreSQL
  - Storage
  - Realtime

Future integrations may include:

- Firebase Cloud Messaging
- Firebase Crashlytics
- Flame

## Getting Started

Prerequisites:

- Flutter SDK (see `flutter --version` for the version this repo was built against)
- Android Studio + Android SDK, with an emulator or physical device running Android 8.0 (API 26) or higher — required by Health Connect

Setup:

```sh
flutter pub get
cp .env.example .env
```

`.env` holds Supabase config (`SUPABASE_URL`, `SUPABASE_ANON_KEY`). It's gitignored — leave the values blank until a Supabase project exists (see Phase 6 in `everstride-docs/plan/EVERSTRIDE_PLAN.md`); the app runs fine locally without them for now.

Run:

```sh
flutter emulators --launch <emulator-id>   # or connect a physical device
flutter run
```

Check code health:

```sh
flutter format .
flutter analyze
```

Do not run `flutter test` unless explicitly asked — see `everstride-docs/AGENTS.md`.

For current build status and what to work on next, see `everstride-docs/PROGRESS.md`.

## Status

Early development / MVP.
