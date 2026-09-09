import '../../../../core/errors/result.dart';
import '../entities/quest_instance.dart';

abstract class QuestRepository {
  Future<Result<List<QuestInstance>>> getInstancesForDate(DateTime date);
  Future<Result<QuestInstance?>> getInstanceById(String id);
  Future<Result<List<QuestInstance>>> getActiveInstancesBeforeDate(
    DateTime date,
  );
  Future<Result<bool>> saveInstance(QuestInstance instance);
}
