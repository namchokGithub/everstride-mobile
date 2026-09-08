import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../player/presentation/controllers/player_controller.dart';

enum _AdventureDifficulty { easy, normal, hard }

class AdventureScreen extends ConsumerStatefulWidget {
  const AdventureScreen({super.key});

  @override
  ConsumerState<AdventureScreen> createState() => _AdventureScreenState();
}

class _AdventureScreenState extends ConsumerState<AdventureScreen> {
  var _selectedDifficulty = _AdventureDifficulty.easy;

  Future<void> _startAdventure() async {
    final result = await ref
        .read(playerControllerProvider.notifier)
        .spendOnAdventure();
    if (!mounted) return;

    final message = switch (result) {
      Ok() => 'Adventure complete! +25 EXP, +10 Gold',
      Err(:final failure) => failure.message,
    };
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adventure')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Greenwood Trail',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'A peaceful path through the forest.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'lib/assets/bg.png',
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Difficulty',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _AdventureDifficulty.values
                  .map(
                    (difficulty) => ChoiceChip(
                      label: Text(_labelFor(difficulty)),
                      selected: _selectedDifficulty == difficulty,
                      onSelected: (_) =>
                          setState(() => _selectedDifficulty = difficulty),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            Text(
              'Difficulty effects arrive in Phase 4.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),
            const Text(
              'Possible Rewards',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(
                  child: _RewardCard(icon: Icons.auto_graph, label: '+25 EXP'),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _RewardCard(
                    icon: Icons.monetization_on,
                    label: '+10 Gold',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _startAdventure,
              icon: const Icon(Icons.bolt),
              label: const Text('Start Adventure · 10 Energy'),
            ),
          ],
        ),
      ),
    );
  }

  String _labelFor(_AdventureDifficulty difficulty) {
    return switch (difficulty) {
      _AdventureDifficulty.easy => 'Easy',
      _AdventureDifficulty.normal => 'Normal',
      _AdventureDifficulty.hard => 'Hard',
    };
  }
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }
}
