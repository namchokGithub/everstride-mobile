import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        body: const Center(child: Text('Loading...')),
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
                Text(instance.status.name),
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
                      if (result case Err(:final failure)) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(failure.message)),
                          );
                        }
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
