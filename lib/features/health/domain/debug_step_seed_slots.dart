import '../../../core/errors/result.dart';

/// Chooses completed, non-overlapping time windows for debug Health Connect
/// records. A record for today must never end after the device clock.
class DebugStepSeedSlots {
  static const minutesPerSlot = 2;
  static const maxSlots = 24 * 60 ~/ minutesPerSlot;

  static Result<int> latestAvailableSlot({
    required DateTime date,
    required DateTime now,
  }) {
    final selectedDay = DateTime(date.year, date.month, date.day);
    final currentDay = DateTime(now.year, now.month, now.day);

    if (selectedDay.isAfter(currentDay)) {
      return const Err(Failure('Cannot insert test steps for a future date.'));
    }
    if (selectedDay.isBefore(currentDay)) {
      return const Ok(maxSlots - 1);
    }

    // A slot lasts one minute inside a two-minute window. Select only a slot
    // whose one-minute record has completed before the current clock minute.
    final completedMinute = now.hour * 60 + now.minute - 1;
    if (completedMinute < 0) {
      return const Err(
        Failure('No completed debug step time slot is available yet.'),
      );
    }
    return Ok(completedMinute ~/ minutesPerSlot);
  }

  static DateTime startForSlot(DateTime date, int slot) {
    final midnight = DateTime(date.year, date.month, date.day);
    return midnight.add(Duration(minutes: slot * minutesPerSlot));
  }
}
