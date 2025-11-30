import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_typography.dart';

class InboxScreen extends ConsumerWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('받은 노트')),
      body: ListView.builder(
        itemCount: 5, // TODO: Replace with actual shared notes
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.brandOrange,
                child: Text(
                  'U${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                '사용자 ${index + 1}',
                style: AppTypography.h2.copyWith(fontSize: 16),
              ),
              subtitle: const Text('공유된 노트 내용...'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // TODO: Navigate to shared note detail
              },
            ),
          );
        },
      ),
    );
  }
}
