import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/local/schema/reading_settings_schema.dart';

class ImageShareService {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future<void> shareTextAsImage(
    BuildContext context,
    String text,
    ReadingSettings settings,
  ) async {
    try {
      // Determine colors based on settings (similar logic to TextReaderScreen)
      Color bgColor;
      Color textColor;
      if (settings.theme == 'white') {
        bgColor = Colors.white;
        textColor = Colors.black87;
      } else if (settings.theme == 'sepia') {
        bgColor = const Color(0xFFF4ECD8);
        textColor = const Color(0xFF5F4B32);
      } else if (settings.theme == 'dark') {
        bgColor = const Color(0xFF1E1E1E);
        textColor = const Color(0xFFE0E0E0);
      } else if (settings.theme == 'black') {
        bgColor = Colors.black;
        textColor = Colors.grey;
      } else {
        bgColor = Color(
          int.parse(settings.customBgColor.replaceFirst('#', '0xFF')),
        );
        textColor = Color(
          int.parse(settings.customTextColor.replaceFirst('#', '0xFF')),
        );
      }

      final imageBytes = await _screenshotController.captureFromWidget(
        Container(
          padding: const EdgeInsets.all(32),
          color: bgColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: settings.fontSize,
                  height: settings.lineHeight,
                  fontFamily: settings.fontFamily,
                  letterSpacing: settings.letterSpacing,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 32),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Shared via IBIDEM',
                  style: TextStyle(
                    fontSize: 12,
                    color: textColor.withOpacity(0.5),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
        delay: const Duration(milliseconds: 10),
        context: context,
      );

      final tempDir = await getTemporaryDirectory();
      final file = await File(
        '${tempDir.path}/share_${DateTime.now().millisecondsSinceEpoch}.png',
      ).create();
      await file.writeAsBytes(imageBytes);

      await Share.shareXFiles([
        XFile(file.path),
      ], text: 'Check out this quote!');
    } catch (e) {
      debugPrint('Error sharing image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('이미지 공유 실패: $e')));
      }
    }
  }
}
