# Everstride

**Every step shapes your journey.**

Everstride is a health-powered RPG mobile game where real-world activity becomes in-game progress.

Walk in real life, earn Energy, complete Adventures and Daily Quests, level up your character, and progress through a fantasy world.

## Core Concept

Real-world activity drives your in-game progression:

- Steps → Energy
- Energy → Adventures
- Adventures and Quests → EXP and Gold
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

`.env` holds optional Supabase config:

```text
SUPABASE_URL=<Project URL>
SUPABASE_ANON_KEY=<Publishable key>
```

Copy the values from the Supabase project's Connect/API settings. Use the publishable key only; never put a secret or service-role key in the app. Without both values, the app remains fully playable locally and Cloud Backup is unavailable in Menu. With them, players can create an email/password account and back up Player, Health checkpoint, and Daily Quest state.

Cloud Backup is currently intended for one primary device. A new device with an existing backup asks whether to Restore or Replace it. Simultaneous play on multiple devices is not yet conflict-safe; see `everstride-docs/PROGRESS.md`.

Run:

```sh
flutter emulators --launch <emulator-id>   # or connect a physical device
flutter run
```

Check code health:

```sh
dart format .
flutter analyze
```

Do not run `flutter test` unless explicitly asked — see `everstride-docs/AGENTS.md`.

For current build status and what to work on next, see `everstride-docs/PROGRESS.md`.

## Testing Health Connect on an Emulator

An emulator has no pedometer, so it never generates real step data — Health Connect will read `0` steps even after granting permission. In debug builds, Menu → Debug Tools has a Test steps field (default `100`) and an insert button. It writes that amount into a past Health Connect time slot for the selected date, so the read path can be exercised without a real device. Sync afterward to convert newly rewardable Steps into Energy.

If the app's own permission requests stop showing a dialog and just silently fail (`SecurityException` in logcat, or a "No requestable permission in the request" log line), the permission is likely stuck with a `USER_FIXED` flag from earlier manual testing (e.g. mixing `adb shell pm revoke` with denying the real dialog). Clear it with:

```sh
adb shell pm reset-permissions <applicationId>
```

(`applicationId` is `com.namchok.everstride` — see `android/app/build.gradle.kts`.) This resets all of the app's permissions to "not yet decided," after which requesting them again from the app shows the dialog normally.

## Status

Early development / MVP.
