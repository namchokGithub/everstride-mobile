import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';

import '../controllers/steps_controller.dart';

/// Debug-only: seeds Health Connect with test steps, since emulators can't
/// generate real pedometer data. Never shown outside `kDebugMode`.
class DebugStepsSeeder extends ConsumerWidget {
  const DebugStepsSeeder({super.key});

  // Tracks how many non-overlapping slots have been written this run, so
  // repeated presses don't write overlapping windows (Health Connect
  // de-duplicates/interpolates overlapping data instead of summing it).
  static int _slot = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) return const SizedBox.shrink();

    final selectedDate = ref.watch(selectedDateProvider);
    final dateLabel =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

    return ElevatedButton(
      onPressed: () async {
        final health = Health();
        await health.requestAuthorization(
          [HealthDataType.STEPS],
          permissions: [HealthDataAccess.READ_WRITE],
        );
        final midnight = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
        final start = midnight.add(Duration(minutes: _slot * 2));
        _slot++;
        await health.writeHealthData(
          value: 500,
          type: HealthDataType.STEPS,
          startTime: start,
          endTime: start.add(const Duration(minutes: 1)),
        );
        ref.invalidate(stepsForSelectedDateProvider);
      },
      child: Text('[Debug] Insert 500 test steps ($dateLabel)'),
    );
  }
}
