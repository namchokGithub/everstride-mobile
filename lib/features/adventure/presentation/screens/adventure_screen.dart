import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/metrics/metrics_recorder.dart';
import '../../../player/domain/repositories/player_repository.dart';
import '../../../player/presentation/controllers/player_controller.dart';
import '../../../quest/presentation/controllers/quest_controller.dart';
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
  static const _trailSuppliesCost = 30;
  static const _trailSuppliesMultiplier = 1.5;
  String _selectedDifficultyId = greenwoodTrail.defaultDifficultyId;
  var _isStarting = false;
  var _useTrailSupplies = false;

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

    final requestedExp = _useTrailSupplies
        ? (difficulty.expReward * _trailSuppliesMultiplier).floor()
        : difficulty.expReward;
    final requestedGold = _useTrailSupplies
        ? (difficulty.goldReward * _trailSuppliesMultiplier).floor()
        : difficulty.goldReward;
    final requestedGoldCost = _useTrailSupplies ? _trailSuppliesCost : 0;
    if (playerBefore.energy < difficulty.energyCost) {
      _recordPreflightRejection(
        difficulty: difficulty,
        playerBefore: playerBefore,
        expReward: requestedExp,
        goldReward: requestedGold,
        additionalGoldCost: requestedGoldCost,
        outcome: 'insufficient_energy',
      );
      setState(() => _isStarting = true);
      await _showInsufficientEnergyDialog(difficulty, playerBefore.energy);
      if (mounted) setState(() => _isStarting = false);
      return;
    }

    final applySupplies =
        _useTrailSupplies && playerBefore.gold >= _trailSuppliesCost;
    if (_useTrailSupplies && !applySupplies) {
      _recordPreflightRejection(
        difficulty: difficulty,
        playerBefore: playerBefore,
        expReward: requestedExp,
        goldReward: requestedGold,
        additionalGoldCost: requestedGoldCost,
        outcome: 'insufficient_gold',
      );
      setState(() => _isStarting = true);
      await _showInsufficientGoldDialog(playerBefore.gold);
      if (mounted) setState(() => _isStarting = false);
      return;
    }
    final expReward = applySupplies
        ? (difficulty.expReward * _trailSuppliesMultiplier).floor()
        : difficulty.expReward;
    final goldReward = applySupplies
        ? (difficulty.goldReward * _trailSuppliesMultiplier).floor()
        : difficulty.goldReward;
    final goldCost = applySupplies ? _trailSuppliesCost : 0;

    setState(() => _isStarting = true);
    final result = await ref
        .read(playerControllerProvider.notifier)
        .spendOnAdventure(
          adventureId: _adventure.id,
          difficultyId: difficulty.id,
          suppliesSelected: _useTrailSupplies,
          energyCost: difficulty.energyCost,
          expReward: expReward,
          goldReward: goldReward,
          additionalGoldCost: goldCost,
        );
    if (!mounted) return;
    setState(() => _isStarting = false);

    switch (result) {
      case Ok(:final value):
        setState(() => _useTrailSupplies = false);
        unawaited(
          ref
              .read(questControllerProvider.notifier)
              .recordAdventureCompletion(),
        );
        context.push(
          '/adventure-result',
          extra: AdventureResult(
            adventureName: _adventure.name,
            difficultyLabel: difficulty.label,
            energySpent: difficulty.energyCost,
            expGained: expReward,
            goldGained: goldReward,
            levelBefore: playerBefore.level,
            playerAfter: value,
            goldSpentOnSupplies: goldCost,
          ),
        );
      case Err(:final failure):
        if (failure.message == 'Not enough energy') {
          await _showInsufficientEnergyDialog(difficulty, playerBefore.energy);
        } else if (failure.message == 'Not enough Gold') {
          await _showInsufficientGoldDialog(playerBefore.gold);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(failure.message)));
        }
    }
  }

  void _recordPreflightRejection({
    required AdventureDifficulty difficulty,
    required PlayerState playerBefore,
    required int expReward,
    required int goldReward,
    required int additionalGoldCost,
    required String outcome,
  }) {
    ref
        .read(metricsRecorderProvider)
        .record(
          eventType: 'adventure_attempt',
          buildPayload: () => {
            'adventureId': _adventure.id,
            'difficultyId': difficulty.id,
            'suppliesSelected': _useTrailSupplies,
            'outcome': outcome,
            'energyCost': difficulty.energyCost,
            'expReward': expReward,
            'goldReward': goldReward,
            'additionalGoldCost': additionalGoldCost,
            'energyBeforeObserved': playerBefore.energy,
            'energyAfter': null,
            'energySpent': 0,
            'expGranted': 0,
            'goldGranted': 0,
            'goldSpent': 0,
          },
        );
  }

  Future<void> _showInsufficientGoldDialog(int currentGold) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Not enough Gold'),
      content: Text(
        'Trail Supplies cost $_trailSuppliesCost Gold. You have $currentGold.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Got it'),
        ),
      ],
    ),
  );

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
    final player = switch (ref.watch(playerControllerProvider)?.value) {
      Ok(:final value) => value,
      _ => null,
    };
    final currentGold = player?.gold ?? 0;
    final canAffordSupplies = currentGold >= _trailSuppliesCost;
    final applySupplies = _useTrailSupplies && canAffordSupplies;
    final displayedExp = applySupplies
        ? (difficulty.expReward * _trailSuppliesMultiplier).floor()
        : difficulty.expReward;
    final displayedGold = applySupplies
        ? (difficulty.goldReward * _trailSuppliesMultiplier).floor()
        : difficulty.goldReward;
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
                    label: '+$displayedExp EXP',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _RewardCard(
                    icon: Icons.monetization_on,
                    label: '+$displayedGold Gold',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: applySupplies,
              onChanged: canAffordSupplies
                  ? (value) =>
                        setState(() => _useTrailSupplies = value ?? false)
                  : null,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Use Trail Supplies (-30 Gold): +50% EXP & Gold this run',
              ),
              subtitle: Text(
                canAffordSupplies
                    ? 'You have $currentGold Gold'
                    : 'Need $_trailSuppliesCost Gold — you have $currentGold',
              ),
            ),
            const SizedBox(height: 16),
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
