import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../player/presentation/controllers/player_controller.dart';

class AdventureScreen extends ConsumerWidget {
  const AdventureScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adventure')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'lib/assets/bg.png',
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Temporary — full Adventure system arrives in Phase 4.',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final result = await ref
                    .read(playerControllerProvider.notifier)
                    .spendOnAdventure();
                if (result case Err(:final failure)) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(failure.message)));
                  }
                }
              },
              child: const Text(
                'Adventure (temporary) — 10 Energy → +25 EXP, +10 Gold',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
