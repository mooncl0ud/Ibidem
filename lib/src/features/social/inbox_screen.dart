import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('받은 노트')),
      body: ListView.builder(
        itemCount: 0, // TODO: Replace with actual shared notes
        itemBuilder: (context, index) {
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
