import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';

import '../../../../core/errors/result.dart';
import '../../data/repositories/debug_step_seed_repository_impl.dart';
import '../../domain/debug_step_seed_slots.dart';
import '../controllers/steps_controller.dart';

/// Debug-only: seeds Health Connect with test steps, since emulators can't
/// generate real pedometer data. Never shown outside `kDebugMode`.
class DebugStepsSeeder extends ConsumerStatefulWidget {
  const DebugStepsSeeder({super.key});

  @override
  ConsumerState<DebugStepsSeeder> createState() => _DebugStepsSeederState();
}

class _DebugStepsSeederState extends ConsumerState<DebugStepsSeeder> {
  final _stepsController = TextEditingController(text: '100');
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

    final latestSlotResult = DebugStepSeedSlots.latestAvailableSlot(
      date: selectedDate,
      now: DateTime.now(),
    );
    if (latestSlotResult case Err(:final failure)) {
      _showNotification(failure.message);
      return;
    }
    final latestSlot = (latestSlotResult as Ok<int>).value;

    setState(() => _isSeeding = true);
    try {
      final slotResult = await ref
          .read(debugStepSeedRepositoryProvider)
          .claimLatestPastSlot(
            date: selectedDate,
            latestAvailableSlot: latestSlot,
          );
      final slot = switch (slotResult) {
        Ok(value: final value) => value,
        Err(:final failure) => throw failure,
      };
      if (slot < 0) {
        throw StateError('No debug step time slots remain for this date.');
      }

      final health = Health();
      await health.requestAuthorization(
        [HealthDataType.STEPS],
        permissions: [HealthDataAccess.READ_WRITE],
      );
      final start = DebugStepSeedSlots.startForSlot(selectedDate, slot);
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
        _showNotification(_errorMessageFor(error));
      }
    } finally {
      if (mounted) setState(() => _isSeeding = false);
    }
  }

  void _showNotification(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(behavior: SnackBarBehavior.floating, content: Text(message)),
    );
  }

  String _errorMessageFor(Object error) {
    final message = error.toString().toLowerCase();
    if (message.contains('must not be in the future')) {
      return 'That debug time slot is not ready yet. Wait a few minutes and try again.';
    }
    if (message.contains('no debug step time slots remain')) {
      return 'No debug step time slots remain for this date.';
    }
    if (message.contains('future date')) {
      return 'Cannot insert test steps for a future date.';
    }
    if (message.contains('did not save the test steps')) {
      return 'Health Connect could not save the test steps. Try again.';
    }
    return 'Could not insert test steps. Please try again.';
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
            hintText: '100',
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
