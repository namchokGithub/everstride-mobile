import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/result.dart';
import '../../../player/presentation/controllers/player_controller.dart';
import '../../domain/adventure_catalog.dart';
import '../../domain/entities/adventure.dart';
import '../models/adventure_result.dart';

class AdventureScreen extends ConsumerStatefulWidget {
  const AdventureScreen({super.key});

  @override
  ConsumerState<AdventureScreen> createState() => _AdventureScreenState();
}

class _AdventureScreenState extends ConsumerState<AdventureScreen> {
  static const _adventure = greenwoodTrail;
  String _selectedDifficultyId = greenwoodTrail.defaultDifficultyId;
  var _isStarting = false;

  AdventureDifficulty get _selectedDifficulty =>
      _adventure.difficultyById(_selectedDifficultyId);

  Future<void> _startAdventure() async {
    if (_isStarting) return;

    final difficulty = _selectedDifficulty;
    final playerBefore = switch (ref.read(playerControllerProvider)?.value) {
      Ok(:final value) => value,
      _ => null,
    };
    if (playerBefore == null) return;

    if (playerBefore.energy < difficulty.energyCost) {
      await _showInsufficientEnergyDialog(difficulty, playerBefore.energy);
      return;
    }

    setState(() => _isStarting = true);
    final result = await ref
        .read(playerControllerProvider.notifier)
        .spendOnAdventure(
          energyCost: difficulty.energyCost,
          expReward: difficulty.expReward,
          goldReward: difficulty.goldReward,
        );
    if (!mounted) return;
    setState(() => _isStarting = false);

    switch (result) {
      case Ok(:final value):
        context.push(
          '/adventure-result',
          extra: AdventureResult(
            adventureName: _adventure.name,
            difficultyLabel: difficulty.label,
            energySpent: difficulty.energyCost,
            expGained: difficulty.expReward,
            goldGained: difficulty.goldReward,
            levelBefore: playerBefore.level,
            playerAfter: value,
          ),
        );
      case Err(:final failure):
        if (failure.message == 'Not enough energy') {
          await _showInsufficientEnergyDialog(difficulty, playerBefore.energy);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(failure.message)));
        }
    }
  }

  Future<void> _showInsufficientEnergyDialog(
    AdventureDifficulty difficulty,
    int currentEnergy,
  ) {
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Not enough Energy'),
        content: Text(
          '${_adventure.name} (${difficulty.label}) costs ${difficulty.energyCost} Energy. '
          'You have $currentEnergy. Walk more to earn Energy, or pick an easier difficulty.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final difficulty = _selectedDifficulty;
    return Scaffold(
      appBar: AppBar(title: const Text('Adventure')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _adventure.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              _adventure.description,
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
              children: _adventure.difficultyOptions
                  .map(
                    (option) => ChoiceChip(
                      label: Text(option.label),
                      selected: _selectedDifficultyId == option.id,
                      onSelected: (_) =>
                          setState(() => _selectedDifficultyId = option.id),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Possible Rewards',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _RewardCard(
                    icon: Icons.auto_graph,
                    label: '+${difficulty.expReward} EXP',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _RewardCard(
                    icon: Icons.monetization_on,
                    label: '+${difficulty.goldReward} Gold',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isStarting ? null : _startAdventure,
              icon: _isStarting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.bolt),
              label: Text('Start Adventure · ${difficulty.energyCost} Energy'),
            ),
          ],
        ),
      ),
    );
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
