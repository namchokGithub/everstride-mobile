import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../player/domain/repositories/player_repository.dart';
import '../models/adventure_result.dart';

class AdventureResultScreen extends StatelessWidget {
  const AdventureResultScreen({super.key, required this.result});

  final AdventureResult result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle, size: 64),
              const SizedBox(height: 16),
              const Text(
                'Adventure Complete!',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text('${result.adventureName} — ${result.difficultyLabel}'),
              const SizedBox(height: 24),
              if (result.leveledUp) ...[
                Text(
                  'Level Up! ${result.levelBefore} → ${result.playerAfter.level}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
              ],
              _ResultRow(
                label: 'Energy spent',
                value: '-${result.energySpent}',
              ),
              _ResultRow(label: 'EXP gained', value: '+${result.expGained}'),
              _ResultRow(label: 'Gold gained', value: '+${result.goldGained}'),
              if (result.usedTrailSupplies)
                _ResultRow(
                  label: 'Trail Supplies',
                  value: '-${result.goldSpentOnSupplies}',
                ),
              const SizedBox(height: 8),
              Text(
                'Lv. ${result.playerAfter.level} — EXP ${result.playerAfter.exp}/${PlayerState.expToNextLevel(result.playerAfter.level)}',
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
