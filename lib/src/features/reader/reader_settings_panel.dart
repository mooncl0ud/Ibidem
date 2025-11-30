import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../shared/theme/app_colors.dart';
import '../../shared/theme/app_typography.dart';
import 'models/reading_settings_model.dart';
import '../settings/font_repository.dart';
import 'reading_settings_repository.dart';

part 'reader_settings_panel.g.dart';

class ReaderSettingsPanel extends ConsumerWidget {
  const ReaderSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(readingSettingsProvider);

    return Container(
      height: 600,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppColors.brandOrange,
              tabs: [
                Tab(text: '일반'),
                Tab(text: '폰트'),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                children: [
                  // General Settings
                  settingsAsync.when(
                    data: (settings) => ListView(
                      children: [
                        Text('화면 설정', style: AppTypography.h2),
                        const SizedBox(height: 16),
                        // Brightness
                        Row(
                          children: [
                            const Icon(Icons.brightness_low, size: 20),
                            Expanded(
                              child: Slider(
                                value: settings.brightness,
                                onChanged: (value) {
                                  ref
                                      .read(readingSettingsRepositoryProvider)
                                      .updateDisplay(brightness: value);
                                  ScreenBrightness().setScreenBrightness(value);
                                },
                              ),
                            ),
                            const Icon(Icons.brightness_high, size: 20),
                          ],
                        ),
                        const Divider(),
                        // Theme
                        Text(
                          '테마',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _ThemeButton(
                              label: '시스템',
                              color: Colors.grey.shade300,
                              textColor: Colors.black,
                              isSelected: settings.theme == 'system',
                              onTap: () => ref
                                  .read(readingSettingsRepositoryProvider)
                                  .updateTheme('system'),
                            ),
                            _ThemeButton(
                              label: '화이트',
                              color: Colors.white,
                              textColor: Colors.black,
                              isSelected: settings.theme == 'white',
                              onTap: () => ref
                                  .read(readingSettingsRepositoryProvider)
                                  .updateTheme(
                                    'white',
                                    bgColor: '#FFFFFF',
                                    textColor: '#121212',
                                  ),
                            ),
                            _ThemeButton(
                              label: '세피아',
                              color: const Color(0xFFF4ECD8),
                              textColor: const Color(0xFF5F4B32),
                              isSelected: settings.theme == 'sepia',
                              onTap: () => ref
                                  .read(readingSettingsRepositoryProvider)
                                  .updateTheme(
                                    'sepia',
                                    bgColor: '#F4ECD8',
                                    textColor: '#5F4B32',
                                  ),
                            ),
                            _ThemeButton(
                              label: '다크',
                              color: const Color(0xFF1E1E1E),
                              textColor: const Color(0xFFE0E0E0),
                              isSelected: settings.theme == 'dark',
                              onTap: () => ref
                                  .read(readingSettingsRepositoryProvider)
                                  .updateTheme(
                                    'dark',
                                    bgColor: '#1E1E1E',
                                    textColor: '#E0E0E0',
                                  ),
                            ),
                            _ThemeButton(
                              label: '블랙',
                              color: Colors.black,
                              textColor: Colors.grey,
                              isSelected: settings.theme == 'black',
                              onTap: () => ref
                                  .read(readingSettingsRepositoryProvider)
                                  .updateTheme(
                                    'black',
                                    bgColor: '#000000',
                                    textColor: '#808080',
                                  ),
                            ),
                          ],
                        ),
                        const Divider(),
                        // Typography
                        Text(
                          '글자 크기',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text('A-', style: AppTypography.body),
                            Expanded(
                              child: Slider(
                                value: settings.fontSize,
                                min: 12.0,
                                max: 32.0,
                                divisions: 10,
                                onChanged: (value) {
                                  ref
                                      .read(readingSettingsRepositoryProvider)
                                      .updateTypography(fontSize: value);
                                },
                              ),
                            ),
                            Text('A+', style: AppTypography.h2),
                          ],
                        ),
                        Text(
                          '줄 간격',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.format_line_spacing, size: 20),
                            Expanded(
                              child: Slider(
                                value: settings.lineHeight,
                                min: 1.0,
                                max: 2.5,
                                divisions: 6,
                                onChanged: (value) {
                                  ref
                                      .read(readingSettingsRepositoryProvider)
                                      .updateTypography(lineHeight: value);
                                },
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        // Paragraph
                        Text(
                          '문단 정렬',
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SegmentedButton<String>(
                                segments: const [
                                  ButtonSegment(
                                    value: 'left',
                                    label: Text('왼쪽 정렬'),
                                    icon: Icon(Icons.format_align_left),
                                  ),
                                  ButtonSegment(
                                    value: 'justify',
                                    label: Text('양쪽 정렬'),
                                    icon: Icon(Icons.format_align_justify),
                                  ),
                                ],
                                selected: {settings.textAlign},
                                onSelectionChanged: (Set<String> newSelection) {
                                  ref
                                      .read(readingSettingsRepositoryProvider)
                                      .updateParagraph(
                                        textAlign: newSelection.first,
                                      );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        SwitchListTile(
                          title: const Text('문단 첫 줄 들여쓰기'),
                          value: settings.autoIndent,
                          onChanged: (value) {
                            ref
                                .read(readingSettingsRepositoryProvider)
                                .updateParagraph(autoIndent: value);
                          },
                        ),

                        const Divider(),
                        // Navigation
                        SwitchListTile(
                          title: const Text('볼륨키로 페이지 이동'),
                          value: settings.volumeKeyNavEnabled,
                          onChanged: (value) {
                            ref
                                .read(readingSettingsRepositoryProvider)
                                .updateNavigation(volumeKeyNavEnabled: value);
                          },
                        ),
                        // 2-Page View (only show on wide screens)
                        if (MediaQuery.of(context).size.width > 600)
                          SwitchListTile(
                            title: const Text('2단 보기 (태블릿)'),
                            subtitle: const Text('큰 화면에서 2페이지씩 표시'),
                            value: settings.twoPageView,
                            onChanged: (value) {
                              ref
                                  .read(readingSettingsRepositoryProvider)
                                  .updateDisplay(twoPageView: value);
                            },
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '터치 영역 크기 (${(settings.touchZoneSize * 100).toInt()}%)',
                                style: AppTypography.body,
                              ),
                              Slider(
                                value: settings.touchZoneSize,
                                min: 0.1,
                                max: 0.5,
                                divisions: 4,
                                onChanged: (value) {
                                  ref
                                      .read(readingSettingsRepositoryProvider)
                                      .updateNavigation(touchZoneSize: value);
                                },
                              ),
                            ],
                          ),
                        ),
                        ListTile(
                          title: const Text('페이지 넘김 효과'),
                          trailing: DropdownButton<String>(
                            value: settings.pageTransition,
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(
                                value: 'slide',
                                child: Text('슬라이드'),
                              ),
                              DropdownMenuItem(
                                value: 'fade',
                                child: Text('페이드'),
                              ),
                              DropdownMenuItem(
                                value: 'none',
                                child: Text('없음'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                ref
                                    .read(readingSettingsRepositoryProvider)
                                    .updateNavigation(pageTransition: value);
                              }
                            },
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) =>
                        Center(child: Text('설정을 불러올 수 없습니다: $err')),
                  ),

                  // Font Settings
                  settingsAsync.when(
                    data: (settings) => _FontSettingsTab(settings: settings),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) =>
                        Center(child: Text('설정을 불러올 수 없습니다: $err')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

@riverpod
Future<List<String>> availableFonts(AvailableFontsRef ref) async {
  final customFonts =
      await ref.watch(fontRepositoryProvider).getAvailableFonts();
  final customFontNames =
      customFonts.map((f) => path.basenameWithoutExtension(f.path)).toList();

  // Default system fonts + custom fonts
  return [
    'Noto Sans KR',
    ...customFontNames,
  ];
}

class _FontSettingsTab extends ConsumerWidget {
  final ReadingSettingsModel settings;
  const _FontSettingsTab({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontsAsync = ref.watch(availableFontsProvider);

    return Column(
      children: [
        Expanded(
          child: fontsAsync.when(
            data: (fonts) {
              return ListView.builder(
                itemCount: fonts.length,
                itemBuilder: (context, index) {
                  final font = fonts[index];
                  final isSelected = settings.fontFamily == font;
                  return ListTile(
                    title: Text(font, style: TextStyle(fontFamily: font)),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: AppColors.brandOrange)
                        : null,
                    onTap: () {
                      ref
                          .read(readingSettingsRepositoryProvider)
                          .updateTypography(fontFamily: font);
                    },
                    onLongPress: () {
                      // Only allow deleting custom fonts
                      // We assume default fonts are hardcoded above and won't be in the custom list
                      // But for simplicity, let's just try to delete. Repository handles existence check.
                      if ([
                        'Noto Sans KR',
                      ].contains(font)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('기본 폰트는 삭제할 수 없습니다.')),
                        );
                        return;
                      }

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('$font 삭제'),
                          content: const Text('이 폰트를 삭제하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                                // We need the filename. Assuming filename matches font name for now.
                                // In reality, we should map name to filename.
                                // But our repository uses basename as name.
                                // So we need to find the file extension.
                                // Let's just try both .ttf and .otf
                                await ref
                                    .read(fontRepositoryProvider)
                                    .deleteFont('$font.ttf');
                                await ref
                                    .read(fontRepositoryProvider)
                                    .deleteFont('$font.otf');
                                ref.invalidate(availableFontsProvider);
                              },
                              child: const Text('삭제'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            onPressed: () async {
              debugPrint('Font Import Button Pressed');
              try {
                // Changed to FileType.any because custom type with extensions
                // sometimes fails to open picker on certain Android versions/emulators
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.any,
                );

                if (result != null && result.files.single.path != null) {
                  final path = result.files.single.path!;
                  if (!path.toLowerCase().endsWith('.ttf') &&
                      !path.toLowerCase().endsWith('.otf')) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('TTF 또는 OTF 파일만 지원합니다.')),
                      );
                    }
                    return;
                  }

                  await ref.read(fontRepositoryProvider).importFont(path);
                  ref.invalidate(availableFontsProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('폰트가 추가되었습니다.')),
                    );
                  }
                }
              } catch (e) {
                debugPrint('Font Import Error: $e');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('폰트 추가 실패: $e')),
                  );
                }
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('폰트 가져오기 (TTF, OTF)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandOrange,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ),
      ],
    );
  }
}

class _ThemeButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                    ? AppColors.brandOrange
                    : Colors.grey.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppColors.brandOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            child: Center(
              child: Text(
                'Aa',
                style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.brandOrange : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
