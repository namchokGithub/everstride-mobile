import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';

import '../../../../core/errors/result.dart';
import '../../data/repositories/debug_step_seed_repository_impl.dart';
import '../controllers/steps_controller.dart';

/// Debug-only: seeds Health Connect with test steps, since emulators can't
/// generate real pedometer data. Never shown outside `kDebugMode`.
class DebugStepsSeeder extends ConsumerStatefulWidget {
  const DebugStepsSeeder({super.key});

  @override
  ConsumerState<DebugStepsSeeder> createState() => _DebugStepsSeederState();
}

class _DebugStepsSeederState extends ConsumerState<DebugStepsSeeder> {
  static const _minutesPerSlot = 2;
  static const _maxSlots = 24 * 60 ~/ _minutesPerSlot;

  final _stepsController = TextEditingController(text: '500');
  var _isSeeding = false;

  @override
  void dispose() {
    _stepsController.dispose();
    super.dispose();
  }

  Future<void> _seedSteps(DateTime selectedDate) async {
    final steps = int.tryParse(_stepsController.text.trim());
    if (steps == null || steps <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a positive number of steps.')),
      );
      return;
    }

    setState(() => _isSeeding = true);
    try {
      final initialSlot = _initialSlotFor(DateTime.now());
      final slotResult = await ref
          .read(debugStepSeedRepositoryProvider)
          .claimNextSlot(date: selectedDate, initialSlot: initialSlot);
      final slot = switch (slotResult) {
        Ok(value: final value) => value,
        Err(:final failure) => throw failure,
      };
      if (slot >= _maxSlots) {
        throw StateError('No debug step time slots remain for this date.');
      }

      final health = Health();
      await health.requestAuthorization(
        [HealthDataType.STEPS],
        permissions: [HealthDataAccess.READ_WRITE],
      );
      final midnight = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
      );
      final start = midnight.add(Duration(minutes: slot * _minutesPerSlot));
      final wrote = await health.writeHealthData(
        value: steps.toDouble(),
        type: HealthDataType.STEPS,
        startTime: start,
        endTime: start.add(const Duration(minutes: 1)),
      );
      if (!wrote) {
        throw StateError('Health Connect did not save the test steps.');
      }
      ref.invalidate(stepsForSelectedDateProvider);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not insert test steps: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSeeding = false);
    }
  }

  int _initialSlotFor(DateTime now) {
    // Start new installs near the current clock time rather than midnight,
    // avoiding legacy debug records written by previous app versions.
    final minute = now.hour * 60 + now.minute;
    return minute ~/ _minutesPerSlot;
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();

    final selectedDate = ref.watch(selectedDateProvider);
    final dateLabel =
        '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _stepsController,
          enabled: !_isSeeding,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Test steps',
            hintText: '500',
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _isSeeding ? null : () => _seedSteps(selectedDate),
          child: _isSeeding
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('[Debug] Insert test steps ($dateLabel)'),
        ),
      ],
    );
  }
}
