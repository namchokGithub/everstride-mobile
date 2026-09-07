import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/errors/result.dart';
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
                final permission = ref.watch(healthPermissionControllerProvider);
                final denied = switch (permission) {
                  AsyncData(value: Ok(value: false)) => true,
                  _ => false,
                };
                return Column(
                  children: [
                    Text(
                      switch (permission) {
                        null => 'Permission: not requested',
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
                      onPressed: () => ref.read(healthPermissionControllerProvider.notifier).requestPermission(),
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
                return Column(
                  children: [
                    Text('Steps on $dateLabel:'),
                    Text(
                      switch (steps) {
                        AsyncData(:final value) => switch (value) {
                          Ok(:final value) => '$value',
                          Err(:final failure) => 'Error (${failure.message})',
                        },
                        AsyncError() => 'Error reading steps',
                        _ => 'Loading...',
                      },
                      style: Theme.of(context).textTheme.headlineMedium,
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
