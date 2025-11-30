import 'package:flutter/foundation.dart';
import '../../../data/local/schema/reading_settings_schema.dart';

@immutable
class ReadingSettingsModel {
  // Typography
  final String fontFamily;
  final double fontSize;
  final double lineHeight;
  final double letterSpacing;
  final double wordScale;

  // Theme
  final String theme;
  final String customBgColor;
  final String customTextColor;

  // Navigation
  final String tapZoneMode;
  final double touchZoneSize;
  final String pageTransition;
  final bool volumeKeyNavEnabled;

  // Screen
  final String orientationLock;
  final bool hideStatusBar;
  final double brightness;

  // Reading UI
  final bool showPageNumber;
  final bool showClock;
  final bool showProgressBar;

  // Paragraph Organization
  final String textAlign;
  final bool autoIndent;
  final bool paragraphSpacing;
  final bool twoPageView;

  const ReadingSettingsModel({
    required this.fontFamily,
    required this.fontSize,
    required this.lineHeight,
    required this.letterSpacing,
    required this.wordScale,
    required this.theme,
    required this.customBgColor,
    required this.customTextColor,
    required this.tapZoneMode,
    required this.touchZoneSize,
    required this.pageTransition,
    required this.volumeKeyNavEnabled,
    required this.orientationLock,
    required this.hideStatusBar,
    required this.brightness,
    required this.showPageNumber,
    required this.showClock,
    required this.showProgressBar,
    required this.textAlign,
    required this.autoIndent,
    required this.paragraphSpacing,
    required this.twoPageView,
  });

  factory ReadingSettingsModel.fromSchema(ReadingSettings schema) {
    return ReadingSettingsModel(
      fontFamily: schema.fontFamily,
      fontSize: schema.fontSize,
      lineHeight: schema.lineHeight,
      letterSpacing: schema.letterSpacing,
      wordScale: schema.wordScale,
      theme: schema.theme,
      customBgColor: schema.customBgColor,
      customTextColor: schema.customTextColor,
      tapZoneMode: schema.tapZoneMode,
      touchZoneSize: schema.touchZoneSize,
      pageTransition: schema.pageTransition,
      volumeKeyNavEnabled: schema.volumeKeyNavEnabled,
      orientationLock: schema.orientationLock,
      hideStatusBar: schema.hideStatusBar,
      brightness: schema.brightness,
      showPageNumber: schema.showPageNumber,
      showClock: schema.showClock,
      showProgressBar: schema.showProgressBar,
      textAlign: schema.textAlign,
      autoIndent: schema.autoIndent,
      paragraphSpacing: schema.paragraphSpacing,
      twoPageView: schema.twoPageView,
    );
  }

  factory ReadingSettingsModel.defaultSettings() {
    return const ReadingSettingsModel(
      fontFamily: 'Noto Sans KR',
      fontSize: 18.0,
      lineHeight: 1.6,
      letterSpacing: 0.0,
      wordScale: 1.0,
      theme: 'white',
      customBgColor: '#FFFFFF',
      customTextColor: '#121212',
      tapZoneMode: 'leftRight',
      touchZoneSize: 0.3,
      pageTransition: 'slide',
      volumeKeyNavEnabled: false,
      orientationLock: 'none',
      hideStatusBar: false,
      brightness: 0.5,
      showPageNumber: true,
      showClock: true,
      showProgressBar: true,
      textAlign: 'left',
      autoIndent: false,
      paragraphSpacing: false,
      twoPageView: false,
    );
  }

  ReadingSettingsModel copyWith({
    String? fontFamily,
    double? fontSize,
    double? lineHeight,
    double? letterSpacing,
    double? wordScale,
    String? theme,
    String? customBgColor,
    String? customTextColor,
    String? tapZoneMode,
    double? touchZoneSize,
    String? pageTransition,
    bool? volumeKeyNavEnabled,
    String? orientationLock,
    bool? hideStatusBar,
    double? brightness,
    bool? showPageNumber,
    bool? showClock,
    bool? showProgressBar,
    String? textAlign,
    bool? autoIndent,
    bool? paragraphSpacing,
    bool? twoPageView,
  }) {
    return ReadingSettingsModel(
      fontFamily: fontFamily ?? this.fontFamily,
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      letterSpacing: letterSpacing ?? this.letterSpacing,
      wordScale: wordScale ?? this.wordScale,
      theme: theme ?? this.theme,
      customBgColor: customBgColor ?? this.customBgColor,
      customTextColor: customTextColor ?? this.customTextColor,
      tapZoneMode: tapZoneMode ?? this.tapZoneMode,
      touchZoneSize: touchZoneSize ?? this.touchZoneSize,
      pageTransition: pageTransition ?? this.pageTransition,
      volumeKeyNavEnabled: volumeKeyNavEnabled ?? this.volumeKeyNavEnabled,
      orientationLock: orientationLock ?? this.orientationLock,
      hideStatusBar: hideStatusBar ?? this.hideStatusBar,
      brightness: brightness ?? this.brightness,
      showPageNumber: showPageNumber ?? this.showPageNumber,
      showClock: showClock ?? this.showClock,
      showProgressBar: showProgressBar ?? this.showProgressBar,
      textAlign: textAlign ?? this.textAlign,
      autoIndent: autoIndent ?? this.autoIndent,
      paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
      twoPageView: twoPageView ?? this.twoPageView,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ReadingSettingsModel &&
        other.fontFamily == fontFamily &&
        other.fontSize == fontSize &&
        other.lineHeight == lineHeight &&
        other.letterSpacing == letterSpacing &&
        other.wordScale == wordScale &&
        other.theme == theme &&
        other.customBgColor == customBgColor &&
        other.customTextColor == customTextColor &&
        other.tapZoneMode == tapZoneMode &&
        other.touchZoneSize == touchZoneSize &&
        other.pageTransition == pageTransition &&
        other.volumeKeyNavEnabled == volumeKeyNavEnabled &&
        other.orientationLock == orientationLock &&
        other.hideStatusBar == hideStatusBar &&
        other.brightness == brightness &&
        other.showPageNumber == showPageNumber &&
        other.showClock == showClock &&
        other.showProgressBar == showProgressBar &&
        other.textAlign == textAlign &&
        other.autoIndent == autoIndent &&
        other.paragraphSpacing == paragraphSpacing &&
        other.twoPageView == twoPageView;
  }

  @override
  int get hashCode {
    return fontFamily.hashCode ^
        fontSize.hashCode ^
        lineHeight.hashCode ^
        letterSpacing.hashCode ^
        wordScale.hashCode ^
        theme.hashCode ^
        customBgColor.hashCode ^
        customTextColor.hashCode ^
        tapZoneMode.hashCode ^
        touchZoneSize.hashCode ^
        pageTransition.hashCode ^
        volumeKeyNavEnabled.hashCode ^
        orientationLock.hashCode ^
        hideStatusBar.hashCode ^
        brightness.hashCode ^
        showPageNumber.hashCode ^
        showClock.hashCode ^
        showProgressBar.hashCode ^
        textAlign.hashCode ^
        autoIndent.hashCode ^
        paragraphSpacing.hashCode ^
        twoPageView.hashCode;
  }
}
