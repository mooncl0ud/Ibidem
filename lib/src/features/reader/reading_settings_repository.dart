import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/local/local_database_provider.dart';
import '../../data/local/schema/reading_settings_schema.dart';
import '../authentication/auth_repository.dart';
import 'models/reading_settings_model.dart';

part 'reading_settings_repository.g.dart';

class ReadingSettingsRepository {
  final Isar _isar;
  final FirebaseFirestore _firestore;
  final String? _userId;

  ReadingSettingsRepository(this._isar, this._firestore, this._userId);

  Future<ReadingSettingsModel> getSettings() async {
    final settings = await _isar.readingSettings.get(1);
    if (settings == null) {
      // Create default settings
      final defaultSettings = ReadingSettingsModel.defaultSettings();
      await _saveToIsar(defaultSettings);
      return defaultSettings;
    }
    return ReadingSettingsModel.fromSchema(settings);
  }

  Stream<ReadingSettingsModel> watchSettings() {
    return _isar.readingSettings.watchObject(1, fireImmediately: true).map((
      settings,
    ) {
      if (settings == null) {
        return ReadingSettingsModel.defaultSettings();
      }
      return ReadingSettingsModel.fromSchema(settings);
    });
  }

  Future<void> saveSettings(ReadingSettingsModel model) async {
    debugPrint(
        'saveSettings called: theme=${model.theme}, fontSize=${model.fontSize}, brightness=${model.brightness}');
    await _saveToIsar(model);
    debugPrint('Settings saved to Isar successfully');
    // Trigger sync
    syncSettingsToFirestore();
  }

  Future<void> _saveToIsar(ReadingSettingsModel model) async {
    await _isar.writeTxn(() async {
      final settings = await _isar.readingSettings.get(1) ?? ReadingSettings();
      settings.fontFamily = model.fontFamily;
      settings.fontSize = model.fontSize;
      settings.lineHeight = model.lineHeight;
      settings.letterSpacing = model.letterSpacing;
      settings.wordScale = model.wordScale;
      settings.theme = model.theme;
      settings.customBgColor = model.customBgColor;
      settings.customTextColor = model.customTextColor;
      settings.tapZoneMode = model.tapZoneMode;
      settings.touchZoneSize = model.touchZoneSize;
      settings.pageTransition = model.pageTransition;
      settings.volumeKeyNavEnabled = model.volumeKeyNavEnabled;
      settings.orientationLock = model.orientationLock;
      settings.hideStatusBar = model.hideStatusBar;
      settings.brightness = model.brightness;
      settings.showPageNumber = model.showPageNumber;
      settings.showClock = model.showClock;
      settings.showProgressBar = model.showProgressBar;
      settings.textAlign = model.textAlign;
      settings.autoIndent = model.autoIndent;
      settings.paragraphSpacing = model.paragraphSpacing;
      settings.twoPageView = model.twoPageView;

      await _isar.readingSettings.put(settings);
    });
  }

  Future<void> updateTypography({
    double? fontSize,
    double? lineHeight,
    double? letterSpacing,
    double? wordScale,
    String? fontFamily,
  }) async {
    debugPrint(
        'updateTypography: fontSize=$fontSize, lineHeight=$lineHeight, fontFamily=$fontFamily');
    final current = await getSettings();
    final updated = current.copyWith(
      fontSize: fontSize,
      lineHeight: lineHeight,
      letterSpacing: letterSpacing,
      wordScale: wordScale,
      fontFamily: fontFamily,
    );
    await saveSettings(updated);
  }

  Future<void> updateTheme(
    String theme, {
    String? bgColor,
    String? textColor,
  }) async {
    debugPrint(
        'updateTheme: theme=$theme, bgColor=$bgColor, textColor=$textColor');
    final current = await getSettings();
    final updated = current.copyWith(
      theme: theme,
      customBgColor: bgColor,
      customTextColor: textColor,
    );
    await saveSettings(updated);
  }

  Future<void> updateParagraph({
    String? textAlign,
    bool? autoIndent,
    bool? paragraphSpacing,
  }) async {
    debugPrint('updateParagraph: textAlign=$textAlign, autoIndent=$autoIndent');
    final current = await getSettings();
    final updated = current.copyWith(
      textAlign: textAlign,
      autoIndent: autoIndent,
      paragraphSpacing: paragraphSpacing,
    );
    await saveSettings(updated);
  }

  Future<void> updateNavigation({
    String? tapZoneMode,
    String? pageTransition,
    bool? volumeKeyNavEnabled,
    double? touchZoneSize,
  }) async {
    debugPrint(
        'updateNavigation: pageTransition=$pageTransition, volumeKey=$volumeKeyNavEnabled, touchZoneSize=$touchZoneSize');
    final current = await getSettings();
    final updated = current.copyWith(
      tapZoneMode: tapZoneMode,
      pageTransition: pageTransition,
      volumeKeyNavEnabled: volumeKeyNavEnabled,
      touchZoneSize: touchZoneSize,
    );
    await saveSettings(updated);
  }

  Future<void> updateDisplay({
    String? orientationLock,
    bool? hideStatusBar,
    double? brightness,
    bool? twoPageView,
  }) async {
    debugPrint(
        'updateDisplay: brightness=$brightness, orientationLock=$orientationLock, hideStatusBar=$hideStatusBar, twoPageView=$twoPageView');
    final current = await getSettings();
    final updated = current.copyWith(
      orientationLock: orientationLock,
      hideStatusBar: hideStatusBar,
      brightness: brightness,
      twoPageView: twoPageView,
    );
    await saveSettings(updated);
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
        'twoPageView': settings.twoPageView,
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
        final current = await getSettings();

        // Update local settings
        final updated = current.copyWith(
          fontFamily: data['fontFamily'],
          fontSize: (data['fontSize'] as num?)?.toDouble(),
          lineHeight: (data['lineHeight'] as num?)?.toDouble(),
          letterSpacing: (data['letterSpacing'] as num?)?.toDouble(),
          wordScale: (data['wordScale'] as num?)?.toDouble(),
          theme: data['theme'],
          customBgColor: data['customBgColor'],
          customTextColor: data['customTextColor'],
          tapZoneMode: data['tapZoneMode'],
          touchZoneSize: (data['touchZoneSize'] as num?)?.toDouble(),
          pageTransition: data['pageTransition'],
          volumeKeyNavEnabled: data['volumeKeyNavEnabled'],
          orientationLock: data['orientationLock'],
          hideStatusBar: data['hideStatusBar'],
          showPageNumber: data['showPageNumber'],
          showClock: data['showClock'],
          showProgressBar: data['showProgressBar'],
          textAlign: data['textAlign'],
          autoIndent: data['autoIndent'],
          paragraphSpacing: data['paragraphSpacing'],
          twoPageView: data['twoPageView'],
        );

        await saveSettings(updated);
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
Stream<ReadingSettingsModel> readingSettings(ReadingSettingsRef ref) {
  return ref.watch(readingSettingsRepositoryProvider).watchSettings();
}
