import 'package:isar/isar.dart';

part 'reading_settings_schema.g.dart';

@collection
class ReadingSettings {
  Id id = 1; // Singleton - only one settings instance

  // Typography
  late String fontFamily; // e.g., "Noto Sans KR", "Ridibatang"
  late double fontSize; // Default: 16.0
  late double lineHeight; // Default: 1.5
  late double letterSpacing; // Default: 0.0
  late double wordScale; // Default: 1.0

  // Theme
  late String theme; // "white", "sepia", "dark", "black"
  late String customBgColor; // Hex color
  late String customTextColor; // Hex color

  // Navigation
  late String tapZoneMode; // "leftRight" or "topBottom"
  late double touchZoneSize; // Default: 0.3
  late String pageTransition; // "slide", "fade", "none"
  late bool volumeKeyNavEnabled; // Default: false

  // Screen
  late String orientationLock; // "none", "portrait", "landscape"
  late bool hideStatusBar; // Default: false
  late double brightness; // 0.0 to 1.0

  // Reading UI
  late bool showPageNumber; // Default: true
  late bool showClock; // Default: true
  late bool showProgressBar; // Default: true

  // Paragraph Organization
  late String textAlign; // "left", "justify"
  late bool autoIndent; // Default: false
  late bool paragraphSpacing; // Default: false
}
