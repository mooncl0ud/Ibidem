import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/local_database_provider.dart';
import '../../data/local/schema/reading_settings_schema.dart';
import '../authentication/auth_repository.dart';

part 'reading_settings_repository.g.dart';

class ReadingSettingsRepository {
  final Isar _isar;
  final FirebaseFirestore _firestore;
  final String? _userId;

  ReadingSettingsRepository(this._isar, this._firestore, this._userId);

  Future<ReadingSettings> getSettings() async {
    final settings = await _isar.readingSettings.get(1);
    if (settings == null) {
      // Create default settings
      final defaultSettings = ReadingSettings()
        ..fontFamily = 'Noto Sans KR'
        ..fontSize = 18.0
        ..lineHeight = 1.6
        ..letterSpacing = 0.0
        ..wordScale = 1.0
        ..theme = 'white'
        ..customBgColor = '#FFFFFF'
        ..customTextColor = '#121212'
        ..tapZoneMode = 'leftRight'
        ..touchZoneSize = 0.3
        ..pageTransition = 'slide'
        ..volumeKeyNavEnabled = false
        ..orientationLock = 'none'
        ..hideStatusBar = false
        ..brightness = 0.5
        ..showPageNumber = true
        ..showClock = true
        ..showProgressBar = true
        ..textAlign = 'left'
        ..autoIndent = false
        ..paragraphSpacing = false;

      await _isar.writeTxn(() async {
        await _isar.readingSettings.put(defaultSettings);
      });

      return defaultSettings;
    }
    return settings;
  }

  Stream<ReadingSettings> watchSettings() {
    return _isar.readingSettings.watchObject(1, fireImmediately: true).map((
      settings,
    ) {
      return settings ??
          ReadingSettings() // Fallback if null (shouldn't happen after init)
        ..fontFamily = 'Noto Sans KR'
        ..fontSize = 18.0
        ..lineHeight = 1.6
        ..letterSpacing = 0.0
        ..wordScale = 1.0
        ..theme = 'white'
        ..customBgColor = '#FFFFFF'
        ..customTextColor = '#121212'
        ..tapZoneMode = 'leftRight'
        ..touchZoneSize = 0.3
        ..pageTransition = 'slide'
        ..volumeKeyNavEnabled = false
        ..orientationLock = 'none'
        ..hideStatusBar = false
        ..brightness = 0.5
        ..showPageNumber = true
        ..showClock = true
        ..showProgressBar = true
        ..textAlign = 'left'
        ..autoIndent = false
        ..paragraphSpacing = false;
    });
  }

  Future<void> updateSettings(ReadingSettings settings) async {
    await _isar.writeTxn(() async {
      await _isar.readingSettings.put(settings);
    });
    // Trigger sync
    syncSettingsToFirestore();
  }

  Future<void> updateTypography({
    double? fontSize,
    double? lineHeight,
    double? letterSpacing,
    double? wordScale,
    String? fontFamily,
  }) async {
    final settings = await getSettings();
    if (fontSize != null) settings.fontSize = fontSize;
    if (lineHeight != null) settings.lineHeight = lineHeight;
    if (letterSpacing != null) settings.letterSpacing = letterSpacing;
    if (wordScale != null) settings.wordScale = wordScale;
    if (fontFamily != null) settings.fontFamily = fontFamily;

    await updateSettings(settings);
  }

  Future<void> updateTheme(
    String theme, {
    String? bgColor,
    String? textColor,
  }) async {
    final settings = await getSettings();
    settings.theme = theme;
    if (bgColor != null) settings.customBgColor = bgColor;
    if (textColor != null) settings.customTextColor = textColor;

    await updateSettings(settings);
  }

  Future<void> updateParagraph({
    String? textAlign,
    bool? autoIndent,
    bool? paragraphSpacing,
  }) async {
    final settings = await getSettings();
    if (textAlign != null) settings.textAlign = textAlign;
    if (autoIndent != null) settings.autoIndent = autoIndent;
    if (paragraphSpacing != null) settings.paragraphSpacing = paragraphSpacing;

    await updateSettings(settings);
  }

  Future<void> updateNavigation({
    String? tapZoneMode,
    String? pageTransition,
    bool? volumeKeyNavEnabled,
    double? touchZoneSize,
  }) async {
    final settings = await getSettings();
    if (tapZoneMode != null) settings.tapZoneMode = tapZoneMode;
    if (pageTransition != null) settings.pageTransition = pageTransition;
    if (volumeKeyNavEnabled != null)
      settings.volumeKeyNavEnabled = volumeKeyNavEnabled;
    if (touchZoneSize != null) settings.touchZoneSize = touchZoneSize;

    await updateSettings(settings);
  }

  Future<void> updateDisplay({
    String? orientationLock,
    bool? hideStatusBar,
    double? brightness,
  }) async {
    final settings = await getSettings();
    if (orientationLock != null) settings.orientationLock = orientationLock;
    if (hideStatusBar != null) settings.hideStatusBar = hideStatusBar;
    if (brightness != null) settings.brightness = brightness;

    await updateSettings(settings);
  }

  Future<void> syncSettingsToFirestore() async {
    if (_userId == null) return;

    try {
      final settings = await getSettings();
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('settings')
          .doc('reading')
          .set({
        'fontFamily': settings.fontFamily,
        'fontSize': settings.fontSize,
        'lineHeight': settings.lineHeight,
        'letterSpacing': settings.letterSpacing,
        'wordScale': settings.wordScale,
        'theme': settings.theme,
        'customBgColor': settings.customBgColor,
        'customTextColor': settings.customTextColor,
        'tapZoneMode': settings.tapZoneMode,
        'touchZoneSize': settings.touchZoneSize,
        'pageTransition': settings.pageTransition,
        'volumeKeyNavEnabled': settings.volumeKeyNavEnabled,
        'orientationLock': settings.orientationLock,
        'hideStatusBar': settings.hideStatusBar,
        'showPageNumber': settings.showPageNumber,
        'showClock': settings.showClock,
        'showProgressBar': settings.showProgressBar,
        'textAlign': settings.textAlign,
        'autoIndent': settings.autoIndent,
        'paragraphSpacing': settings.paragraphSpacing,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Failed to sync settings to Firestore: $e');
    }
  }

  Future<void> syncSettingsFromFirestore() async {
    if (_userId == null) return;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('settings')
          .doc('reading')
          .get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final settings = await getSettings();

        // Update local settings
        settings.fontFamily = data['fontFamily'] ?? settings.fontFamily;
        settings.fontSize =
            (data['fontSize'] as num?)?.toDouble() ?? settings.fontSize;
        settings.lineHeight =
            (data['lineHeight'] as num?)?.toDouble() ?? settings.lineHeight;
        settings.letterSpacing = (data['letterSpacing'] as num?)?.toDouble() ??
            settings.letterSpacing;
        settings.wordScale =
            (data['wordScale'] as num?)?.toDouble() ?? settings.wordScale;
        settings.theme = data['theme'] ?? settings.theme;
        settings.customBgColor =
            data['customBgColor'] ?? settings.customBgColor;
        settings.customTextColor =
            data['customTextColor'] ?? settings.customTextColor;
        settings.tapZoneMode = data['tapZoneMode'] ?? settings.tapZoneMode;
        settings.touchZoneSize = (data['touchZoneSize'] as num?)?.toDouble() ??
            settings.touchZoneSize;
        settings.pageTransition =
            data['pageTransition'] ?? settings.pageTransition;
        settings.volumeKeyNavEnabled =
            data['volumeKeyNavEnabled'] ?? settings.volumeKeyNavEnabled;
        settings.orientationLock =
            data['orientationLock'] ?? settings.orientationLock;
        settings.hideStatusBar =
            data['hideStatusBar'] ?? settings.hideStatusBar;
        settings.showPageNumber =
            data['showPageNumber'] ?? settings.showPageNumber;
        settings.showClock = data['showClock'] ?? settings.showClock;
        settings.showProgressBar =
            data['showProgressBar'] ?? settings.showProgressBar;
        settings.textAlign = data['textAlign'] ?? settings.textAlign;
        settings.autoIndent = data['autoIndent'] ?? settings.autoIndent;
        settings.paragraphSpacing =
            data['paragraphSpacing'] ?? settings.paragraphSpacing;

        await _isar.writeTxn(() async {
          await _isar.readingSettings.put(settings);
        });
      }
    } catch (e) {
      debugPrint('Failed to sync settings from Firestore: $e');
    }
  }
}

@Riverpod(keepAlive: true)
ReadingSettingsRepository readingSettingsRepository(
  ReadingSettingsRepositoryRef ref,
) {
  final localDb = ref.watch(localDatabaseProvider);
  final user = ref.watch(authRepositoryProvider).currentUser;
  return ReadingSettingsRepository(
    localDb.isar,
    FirebaseFirestore.instance,
    user?.uid,
  );
}

@riverpod
Stream<ReadingSettings> readingSettings(ReadingSettingsRef ref) {
  return ref.watch(readingSettingsRepositoryProvider).watchSettings();
}
