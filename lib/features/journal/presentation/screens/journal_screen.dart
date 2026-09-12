import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../core/errors/result.dart';
import '../../../quest/domain/entities/quest_instance.dart';
import '../../../quest/domain/quest_catalog.dart';
import '../../../quest/presentation/controllers/quest_controller.dart';

class JournalScreen extends ConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(questControllerProvider);
    final instances = switch (state?.value) {
      Ok(:final value) => value,
      _ => null,
    };
    if (instances == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Journal')),
        body: const Center(child: Text("Gathering today's Quests…")),
      );
    }
    final sorted = [...instances]
      ..sort(
        (a, b) => dailyQuestCatalog
            .firstWhere((q) => q.id == a.questId)
            .sortOrder
            .compareTo(
              dailyQuestCatalog.firstWhere((q) => q.id == b.questId).sortOrder,
            ),
      );
    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("Today's Quests", style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          for (final instance in sorted) _QuestCard(instance: instance),
        ],
      ),
    );
  }
}

class _QuestCard extends ConsumerWidget {
  const _QuestCard({required this.instance});
  final QuestInstance instance;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final definition = dailyQuestCatalog.firstWhere(
      (q) => q.id == instance.questId,
    );
    final ratio = (instance.progress / instance.target).clamp(0, 1).toDouble();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  definition.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                _QuestStatusLabel(status: instance.status),
              ],
            ),
            const SizedBox(height: 4),
            Text(definition.description),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: ratio),
            const SizedBox(height: 4),
            Text(
              '${instance.progress.clamp(0, instance.target)} / ${instance.target}',
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '+${instance.expReward} EXP, +${instance.goldReward} Gold',
                ),
                if (instance.status == QuestStatus.claimable)
                  ElevatedButton(
                    onPressed: () async {
                      final result = await ref
                          .read(questControllerProvider.notifier)
                          .claim(instance);
                      if (!context.mounted) return;
                      switch (result) {
                        case Ok():
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Claimed! +${instance.expReward} EXP, +${instance.goldReward} Gold',
                              ),
                            ),
                          );
                        case Err(:final failure):
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(failure.message)),
                          );
                      }
                    },
                    child: const Text('Claim'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestStatusLabel extends StatelessWidget {
  const _QuestStatusLabel({required this.status});

  final QuestStatus status;

  @override
  Widget build(BuildContext context) {
    final label = switch (status) {
      QuestStatus.inProgress => 'In Progress',
      QuestStatus.claimable => 'Ready to claim',
      QuestStatus.claimed => 'Claimed',
      QuestStatus.expired => 'Expired',
    };
    if (status != QuestStatus.claimable) {
      return Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppTheme.textSecondaryColor,
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.mint,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          color: AppTheme.deepNavy,
        ),
      ),
    );
  }
}
