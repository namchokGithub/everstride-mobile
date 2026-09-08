import 'package:flutter/material.dart';

class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined, size: 48),
            SizedBox(height: 12),
            Text('Coming soon'),
            SizedBox(height: 4),
            Text('Your activity and reward history will show up here.'),
          ],
        ),
      ),
    );
  }
}
