import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Structured, debug-only logging (see everstride-docs/plan/EVERSTRIDE_PLAN.md
/// section 13). Never logs in release builds; avoid passing raw/sensitive
/// health data — a summary or count is fine, a full data dump is not.
class AppLogger {
  const AppLogger._();

  static void debug(String area, String message) {
    if (!kDebugMode) return;
    developer.log(message, name: area);
  }

  static void error(String area, String message, [Object? error]) {
    if (!kDebugMode) return;
    developer.log(message, name: area, error: error, level: 1000);
  }
}
