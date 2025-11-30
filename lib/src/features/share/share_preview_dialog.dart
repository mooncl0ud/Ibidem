import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../data/local/schema/reading_settings_schema.dart';

class SharePreviewDialog extends StatefulWidget {
  final String text;
  final ReadingSettings settings;

  const SharePreviewDialog({
    super.key,
    required this.text,
    required this.settings,
  });

  @override
  State<SharePreviewDialog> createState() => _SharePreviewDialogState();
}

class _SharePreviewDialogState extends State<SharePreviewDialog> {
  final ScreenshotController _screenshotController = ScreenshotController();
  File? _backgroundImage;
  bool _isSharing = false;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _backgroundImage = File(result.files.single.path!);
      });
    }
  }

  Future<void> _shareImage() async {
    if (_isSharing) return;
    setState(() {
      _isSharing = true;
    });

    try {
      final imageBytes = await _screenshotController.capture();
      if (imageBytes == null) return;

      final tempDir = await getTemporaryDirectory();
      final file = await File(
        '${tempDir.path}/share_${DateTime.now().millisecondsSinceEpoch}.png',
      ).create();
      await file.writeAsBytes(imageBytes);

      if (mounted) {
        Navigator.pop(context); // Close dialog before sharing
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Check out this quote from Ibidem!',
        );
      }
    } catch (e) {
      debugPrint('Error sharing image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share image: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine default colors from settings if no background image
    Color bgColor;
    Color textColor;

    if (_backgroundImage != null) {
      // If background image is set, default to white text with shadow for visibility
      bgColor = Colors.black; // Placeholder behind image
      textColor = _getThemeTextColor(widget.settings);
    } else {
      bgColor = _getThemeBgColor(widget.settings);
      textColor = _getThemeTextColor(widget.settings);
    }

    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            title: const Text('Share Preview'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              TextButton(
                onPressed: _isSharing ? null : _shareImage,
                child: _isSharing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Share'),
              ),
            ],
          ),
          Flexible(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Screenshot(
                  controller: _screenshotController,
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 300),
                    decoration: BoxDecoration(
                      color: bgColor,
                      image: _backgroundImage != null
                          ? DecorationImage(
                              image: FileImage(_backgroundImage!),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black
                                    .withOpacity(0.3), // Darken for readability
                                BlendMode.darken,
                              ),
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.text,
                          style: TextStyle(
                            fontSize: widget.settings.fontSize,
                            height: widget.settings.lineHeight,
                            fontFamily: widget.settings.fontFamily,
                            letterSpacing: widget.settings.letterSpacing,
                            color: _backgroundImage != null
                                ? Colors.white
                                : textColor,
                            shadows: _backgroundImage != null
                                ? [
                                    const Shadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 3.0,
                                      color: Colors.black,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Shared via IBIDEM',
                            style: TextStyle(
                              fontSize: 12,
                              color: (_backgroundImage != null
                                      ? Colors.white
                                      : textColor)
                                  .withOpacity(0.7),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Add Background'),
                ),
                if (_backgroundImage != null)
                  TextButton(
                    onPressed: () => setState(() => _backgroundImage = null),
                    child: const Text('Remove Background'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getThemeBgColor(ReadingSettings settings) {
    if (settings.theme == 'white') return Colors.white;
    if (settings.theme == 'sepia') return const Color(0xFFF4ECD8);
    if (settings.theme == 'dark') return const Color(0xFF1E1E1E);
    if (settings.theme == 'black') return Colors.black;
    return Color(int.parse(settings.customBgColor.replaceFirst('#', '0xFF')));
  }

  Color _getThemeTextColor(ReadingSettings settings) {
    if (settings.theme == 'white') return Colors.black87;
    if (settings.theme == 'sepia') return const Color(0xFF5F4B32);
    if (settings.theme == 'dark') return const Color(0xFFE0E0E0);
    if (settings.theme == 'black') return Colors.grey;
    return Color(int.parse(settings.customTextColor.replaceFirst('#', '0xFF')));
  }
}
