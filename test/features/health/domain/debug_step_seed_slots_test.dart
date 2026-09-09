import 'package:everstride/core/errors/result.dart';
import 'package:everstride/features/health/domain/debug_step_seed_slots.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final date = DateTime(2026, 9, 10);

  test('today uses a slot whose record ended before the device clock', () {
    final now = DateTime(2026, 9, 10, 17, 20, 29);

    final result = DebugStepSeedSlots.latestAvailableSlot(date: date, now: now);
    final slot = (result as Ok<int>).value;
    final start = DebugStepSeedSlots.startForSlot(date, slot);

    expect(start, DateTime(2026, 9, 10, 17, 18));
    expect(start.add(const Duration(minutes: 1)).isAfter(now), isFalse);
  });

  test('a previous day begins at its latest completed slot', () {
    final result = DebugStepSeedSlots.latestAvailableSlot(
      date: DateTime(2026, 9, 9),
      now: DateTime(2026, 9, 10, 0, 0),
    );

    expect((result as Ok<int>).value, DebugStepSeedSlots.maxSlots - 1);
  });

  test('a future date is rejected before a Health Connect write', () {
    final result = DebugStepSeedSlots.latestAvailableSlot(
      date: DateTime(2026, 9, 11),
      now: DateTime(2026, 9, 10, 17, 20),
    );

    expect(result, isA<Err<int>>());
    expect((result as Err<int>).failure.message, contains('future date'));
  });
}
