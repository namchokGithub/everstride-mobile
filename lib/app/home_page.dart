import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/errors/result.dart';
import '../features/health/data/repositories/health_repository_impl.dart';
import '../features/health/presentation/controllers/health_availability_controller.dart';
import '../features/health/presentation/controllers/health_permission_controller.dart';
import '../features/health/presentation/controllers/steps_controller.dart';
import '../features/health/presentation/widgets/debug_steps_seeder.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer(
              builder: (context, ref, _) {
                final availability = ref.watch(healthConnectAvailabilityProvider);
                return Text(
                  switch (availability) {
                    AsyncData(:final value) => switch (value) {
                      Ok(:final value) => value ? 'Health Connect: available' : 'Health Connect: not available',
                      Err(:final failure) => 'Health Connect: error (${failure.message})',
                    },
                    AsyncError() => 'Health Connect: error checking availability',
                    _ => 'Health Connect: checking...',
                  },
                );
              },
            ),
            const SizedBox(height: 24),
            Consumer(
              builder: (context, ref, _) {
                final availability = ref.watch(healthConnectAvailabilityProvider);
                final isAvailable = switch (availability) {
                  AsyncData(value: Ok(value: true)) => true,
                  _ => false,
                };

                if (!isAvailable) {
                  if (availability.isLoading) return const SizedBox.shrink();
                  return Column(
                    children: [
                      const Text(
                        "Health Connect isn't available on this device. Steps can't be read until it's installed and up to date.",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => ref.read(healthRepositoryProvider).promptInstallOrUpdate(),
                        child: const Text('Install / Update Health Connect'),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    Consumer(
                      builder: (context, ref, _) {
                        final permission = ref.watch(healthPermissionControllerProvider);
                        final denied = switch (permission) {
                          AsyncData(value: Ok(value: false)) => true,
                          _ => false,
                        };
                        return Column(
                          children: [
                            Text(
                              switch (permission) {
                                null => 'Permission: checking...',
                                AsyncData(:final value) => switch (value) {
                                  Ok(:final value) => value ? 'Permission: granted' : 'Permission: denied',
                                  Err(:final failure) => 'Permission: error (${failure.message})',
                                },
                                AsyncError() => 'Permission: error requesting',
                                _ => 'Permission: requesting...',
                              },
                            ),
                            if (denied)
                              const Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  "Steps can't be read without this permission. Tap below to try again.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ElevatedButton(
                              onPressed: () =>
                                  ref.read(healthPermissionControllerProvider.notifier).requestPermission(),
                              child: const Text('Request Health Permission'),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    Consumer(
                      builder: (context, ref, _) {
                        final selectedDate = ref.watch(selectedDateProvider);
                        final steps = ref.watch(stepsForSelectedDateProvider);
                        final dateLabel =
                            '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                        final lastResult = steps.value;
                        final stepsText = switch (lastResult) {
                          Ok(:final value) => '$value',
                          Err(:final failure) => 'Error (${failure.message})',
                          null => steps is AsyncError ? 'Error reading steps' : 'Loading...',
                        };
                        return Column(
                          children: [
                            Text('Steps on $dateLabel:'),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(stepsText, style: Theme.of(context).textTheme.headlineMedium),
                                if (steps.isLoading) ...[
                                  const SizedBox(width: 8),
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ],
                              ],
                            ),
                            ElevatedButton(
                              onPressed: steps.isLoading ? null : () => ref.invalidate(stepsForSelectedDateProvider),
                              child: const Text('Sync Now'),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: selectedDate,
                                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  ref.read(selectedDateProvider.notifier).set(picked);
                                }
                              },
                              child: const Text('Pick a date'),
                            ),
                            const SizedBox(height: 8),
                            const DebugStepsSeeder(),
                          ],
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
