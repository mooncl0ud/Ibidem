import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'font_repository.g.dart';

@Riverpod(keepAlive: true)
FontRepository fontRepository(FontRepositoryRef ref) {
  return FontRepository();
}

class FontRepository {
  static const String _fontDirName = 'custom_fonts';

  Future<Directory> get _fontDirectory async {
    final appDir = await getApplicationDocumentsDirectory();
    final fontDir = Directory(path.join(appDir.path, _fontDirName));
    if (!await fontDir.exists()) {
      await fontDir.create(recursive: true);
    }
    return fontDir;
  }

  Future<List<File>> getAvailableFonts() async {
    final dir = await _fontDirectory;
    final entities = dir.listSync();
    return entities
        .whereType<File>()
        .where((file) =>
            file.path.toLowerCase().endsWith('.ttf') ||
            file.path.toLowerCase().endsWith('.otf'))
        .toList();
  }

  Future<void> importFont(String sourcePath) async {
    final file = File(sourcePath);
    if (!await file.exists()) return;

    final dir = await _fontDirectory;
    final fileName = path.basename(sourcePath);
    final destination = path.join(dir.path, fileName);

    await file.copy(destination);
  }

  Future<void> deleteFont(String fileName) async {
    final dir = await _fontDirectory;
    final file = File(path.join(dir.path, fileName));
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> loadCustomFonts() async {
    final fonts = await getAvailableFonts();
    for (final fontFile in fonts) {
      final fontName = path.basenameWithoutExtension(fontFile.path);
      try {
        final fontLoader = FontLoader(fontName);
        fontLoader.addFont(Future.value(ByteData.view(
          await fontFile.readAsBytes().then((bytes) => bytes.buffer),
        )));
        await fontLoader.load();
      } catch (e) {
        print('Error loading font $fontName: $e');
      }
    }
  }
}
