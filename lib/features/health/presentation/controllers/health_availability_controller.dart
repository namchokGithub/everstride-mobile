import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../data/repositories/health_repository_impl.dart';

final healthConnectAvailabilityProvider = FutureProvider<Result<bool>>((ref) {
  return ref.watch(healthRepositoryProvider).isAvailable();
});
