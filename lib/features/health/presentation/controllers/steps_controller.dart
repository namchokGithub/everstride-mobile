import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../data/repositories/health_repository_impl.dart';

class SelectedDate extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void set(DateTime date) => state = date;
}

final selectedDateProvider = NotifierProvider<SelectedDate, DateTime>(SelectedDate.new);

final stepsForSelectedDateProvider = FutureProvider<Result<int>>((ref) {
  final date = ref.watch(selectedDateProvider);
  return ref.watch(healthRepositoryProvider).getStepsForDate(date);
});
