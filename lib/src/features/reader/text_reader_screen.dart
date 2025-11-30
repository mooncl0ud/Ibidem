import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:ui'; // For PointerDeviceKind
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/local/schema/reading_settings_schema.dart';
import '../../data/local/schema/text_book_schema.dart';
import '../../data/local/schema/highlight_schema.dart';
import '../library/text_book_repository.dart';
import '../authentication/auth_repository.dart';
import 'reader_settings_panel.dart';
import 'reading_settings_repository.dart';
import 'text_parser.dart';
import 'bookmark_repository.dart';
import 'highlight_repository.dart';
import 'sticky_note_repository.dart';
import 'sticky_note_widget.dart';

import '../settings/font_repository.dart';

class TextReaderScreen extends ConsumerStatefulWidget {
  final String bookId;

  const TextReaderScreen({super.key, required this.bookId});

  @override
  ConsumerState<TextReaderScreen> createState() => _TextReaderScreenState();
}

class _TextReaderScreenState extends ConsumerState<TextReaderScreen>
    with WidgetsBindingObserver {
  TextBook? _book;
  bool _isLoading = true;
  List<ReaderPage> _pages = [];
  int _currentPageIndex = 0;
  bool _showMenu = false;

  // Chunking
  int _currentChunkIndex = 0;
  bool _isPaginationInProgress = false;
  Timer? _debounceTimer;

  // Sticky Notes
  bool _isAddingNote = false;
  Offset? _notePosition;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadBook();
    WakelockPlus.enable();
    // Load custom fonts
    ref.read(fontRepositoryProvider).loadCustomFonts();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    _syncData(); // Sync on exit
    WakelockPlus.disable();
    ScreenBrightness().resetScreenBrightness();
    SystemChrome.setPreferredOrientations([]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _syncData();
    }
  }

  Future<void> _syncData() async {
    if (_book == null) return;
    final bookId = _book!.id;

    // Fire and forget syncs
    ref.read(textBookRepositoryProvider).syncPositionToFirestore(bookId);
    ref.read(bookmarkRepositoryProvider).syncBookmarks(bookId);
    ref.read(highlightRepositoryProvider).syncHighlights(bookId);
  }

  Future<void> _loadBook() async {
    final bookId = int.tryParse(widget.bookId);
    if (bookId == null) return;

    // Sync from Firestore before loading
    await ref
        .read(textBookRepositoryProvider)
        .syncPositionFromFirestore(bookId);
    await ref.read(bookmarkRepositoryProvider).syncBookmarks(bookId);
    await ref.read(highlightRepositoryProvider).syncHighlights(bookId);
    await ref
        .read(readingSettingsRepositoryProvider)
        .syncSettingsFromFirestore();

    final books = await ref.read(textBookRepositoryProvider).getBooks();
    try {
      _book = books.firstWhere((b) => b.id == bookId);
    } catch (e) {
      debugPrint('Error loading book: $e');
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _paginateChunk(ReadingSettings settings) async {
    if (_book == null) return;
    if (_isPaginationInProgress) return;
    _isPaginationInProgress = true;

    try {
      final file = File(_book!.filePath);
      if (!file.existsSync()) return;

      final parser = TextParser();
      String content;

      // Always ensure we have chunks. If not, analyze now.
      if (_book!.chunkOffsets == null || _book!.chunkOffsets!.isEmpty) {
        final parser = TextParser();
        final encodingName = await parser.detectEncodingName(file);
        final (totalChars, byteOffsets, charOffsets) =
            await parser.analyzeFile(file, encodingName: encodingName);

        _book!.chunkOffsets = byteOffsets;
        _book!.chunkCharOffsets = charOffsets;
        _book!.totalCharacters = totalChars;
        _book!.encoding = encodingName;

        // Save updated metadata
        await ref.read(textBookRepositoryProvider).updateBookMetadata(_book!);
      }

      // Read the current chunk
      final startByte = _book!.chunkOffsets![_currentChunkIndex];
      final endByte = (_currentChunkIndex < _book!.chunkOffsets!.length - 1)
          ? _book!.chunkOffsets![_currentChunkIndex + 1]
          : _book!.fileSizeBytes;

      content = await parser.readChunk(file, startByte, endByte,
          encodingName: _book!.encoding);

      // Hybrid Fallback for Large Chunks
      const int kReflowThreshold = 300 * 1024; // 300KB

      if (content.length > kReflowThreshold) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Large section detected. Optimization disabled for performance.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }

      if (!mounted) return;

      final mediaQuery = MediaQuery.of(context);
      final size = mediaQuery.size;
      final safePadding = mediaQuery.padding;

      // Fix Bottom Cut-off: Subtract SafeArea vertical padding + safety buffer
      final availableHeight =
          size.height - safePadding.top - safePadding.bottom - 20;

      // Use full screen width (minus padding handled by parser)
      final paginateSize = Size(size.width, availableHeight);

      // Standard visual padding
      // Increased bottom padding to 60 to avoid overlap with footer (Page Number/Clock)
      final padding = const EdgeInsets.fromLTRB(24, 20, 24, 60);

      _pages = parser.paginate(
        content: content,
        size: paginateSize,
        style: TextStyle(
          fontSize: settings.fontSize,
          height: settings.lineHeight,
          fontFamily: settings.fontFamily,
          letterSpacing: settings.letterSpacing,
        ),
        padding: padding,
      );

      // Restore position within chunk
      int relativeCharPos = 0;
      if (_book!.chunkCharOffsets != null &&
          _book!.chunkCharOffsets!.isNotEmpty) {
        relativeCharPos = _book!.currentCharPosition -
            _book!.chunkCharOffsets![_currentChunkIndex];
      } else {
        relativeCharPos = _book!.currentCharPosition;
      }

      // Map original relativeCharPos to reflowed index
      final reflowedPos = relativeCharPos;

      // Find page containing reflowedPos
      int targetPage = 0;
      for (int i = 0; i < _pages.length; i++) {
        if (_pages[i].startIndex <= reflowedPos &&
            _pages[i].endIndex > reflowedPos) {
          targetPage = i;
          break;
        }
      }

      _currentPageIndex = targetPage;

      setState(() {});
    } finally {
      _isPaginationInProgress = false;
    }
  }

  Future<void> _loadChunk(int chunkIndex) async {
    if (_book == null) return;
    if (chunkIndex < 0) return;
    if (_book!.chunkOffsets != null &&
        chunkIndex >= _book!.chunkOffsets!.length) return;

    // Debounce rapid calls
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      _currentChunkIndex = chunkIndex;

      // Memory Cleanup: Clear previous pages before loading new ones
      setState(() {
        _pages = [];
      });

      final settings = ref.read(readingSettingsProvider).value;
      if (settings != null) {
        try {
          await _paginateChunk(settings);
        } catch (e) {
          debugPrint('Error loading chunk: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error loading content: $e')),
            );
          }
        }
      }
    });
  }

  void _onPageChanged(int index) async {
    if (_book == null) return;

    // Handle Chunk Crossing
    if (index < 0) {
      // Previous Chunk
      if (_currentChunkIndex > 0) {
        await _loadChunk(_currentChunkIndex - 1);
        // Go to last page of new chunk
        if (_pages.isNotEmpty) {
          _onPageChanged(_pages.length - 1);
        }
      }
      return;
    } else if (index >= _pages.length) {
      // Next Chunk
      if (_book!.chunkOffsets != null &&
          _currentChunkIndex < _book!.chunkOffsets!.length - 1) {
        await _loadChunk(_currentChunkIndex + 1);
        // Go to first page of new chunk
        if (_pages.isNotEmpty) {
          _onPageChanged(0);
        }
      }
      return;
    }

    setState(() {
      _currentPageIndex = index;
    });
    HapticFeedback.lightImpact();

    // Save progress
    // Calculate global char position
    int globalCharPos = _pages[index].startIndex;
    if (_book!.chunkCharOffsets != null &&
        _book!.chunkCharOffsets!.isNotEmpty) {
      globalCharPos += _book!.chunkCharOffsets![_currentChunkIndex];
    }

    ref.read(textBookRepositoryProvider).updateProgress(
          _book!.id,
          globalCharPos,
          0, // Global page number is unknown
          0, // Total pages unknown
        );
  }

  void _toggleBookmark() async {
    if (_book == null) return;

    final bookmarks =
        await ref.read(bookmarkRepositoryProvider).getBookmarks(_book!.id);
    final isBookmarked = bookmarks.any(
      (b) => b.pageNumber == _currentPageIndex,
    );

    if (isBookmarked) {
      await ref
          .read(bookmarkRepositoryProvider)
          .removeBookmarkByPosition(_book!.id, _currentPageIndex);
    } else {
      final text = _pages[_currentPageIndex].text;
      final label =
          text.substring(0, min(20, text.length)).replaceAll('\n', ' ').trim() +
              "...";

      await ref.read(bookmarkRepositoryProvider).addBookmark(
            bookId: _book!.id,
            charPosition: _pages[_currentPageIndex].startIndex,
            pageNumber: _currentPageIndex,
            label: label,
          );
    }
    HapticFeedback.mediumImpact();
  }

  void _toggleMenu() {
    setState(() => _showMenu = !_showMenu);
  }

  void _sharePage() {
    if (_pages.isEmpty || _currentPageIndex >= _pages.length) return;
    final text = _pages[_currentPageIndex].text;
    Share.share(text, subject: _book?.title);
  }

  void _showContents() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: DefaultTabController(
            length: 2,
            child: Column(
              children: [
                const TabBar(
                  tabs: [
                    Tab(text: 'Bookmarks'),
                    Tab(text: 'Highlights'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // Bookmarks Tab
                      Consumer(
                        builder: (context, ref, child) {
                          final bookmarksAsync = ref.watch(
                            bookmarksStreamProvider(_book!.id),
                          );
                          return bookmarksAsync.when(
                            data: (bookmarks) {
                              if (bookmarks.isEmpty) {
                                return const Center(
                                  child: Text('No bookmarks yet'),
                                );
                              }
                              return ListView.builder(
                                controller: scrollController,
                                itemCount: bookmarks.length,
                                itemBuilder: (context, index) {
                                  final bookmark = bookmarks[index];
                                  return ListTile(
                                    title: Text(
                                      bookmark.label ??
                                          'Page ${bookmark.pageNumber + 1}',
                                    ),
                                    subtitle: Text(
                                      DateFormat.yMMMd().add_jm().format(
                                            bookmark.createdAt,
                                          ),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      _onPageChanged(bookmark.pageNumber);
                                    },
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        ref
                                            .read(bookmarkRepositoryProvider)
                                            .removeBookmark(bookmark.id);
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                            loading: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            error: (err, stack) =>
                                Center(child: Text('Error: $err')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageContent(
    BuildContext context,
    ReadingSettings settings,
    Color bgColor,
    Color textColor,
  ) {
    if (settings.pageTransition == 'scroll') {
      return LayoutBuilder(
        builder: (context, constraints) {
          // Sync scroll controller if page changed externally
          if (_scrollController.hasClients) {
            final targetOffset = _currentPageIndex * constraints.maxHeight;
            if ((_scrollController.offset - targetOffset).abs() > 10) {
              _scrollController.jumpTo(targetOffset);
            }
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                final page =
                    (_scrollController.offset / constraints.maxHeight).round();
                if (page != _currentPageIndex &&
                    page >= 0 &&
                    page < _pages.length) {
                  _onPageChanged(page);
                }
              }
              return false;
            },
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _pages.length,
              itemExtent: constraints.maxHeight,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return _buildSinglePage(
                  context,
                  settings,
                  bgColor,
                  textColor,
                  index,
                );
              },
            ),
          );
        },
      );
    } else if (settings.pageTransition == 'flip') {
      return GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swipe Right -> Previous
            if (_currentPageIndex > 0) _onPageChanged(_currentPageIndex - 1);
          } else if (details.primaryVelocity! < 0) {
            // Swipe Left -> Next
            if (_currentPageIndex < _pages.length - 1)
              _onPageChanged(_currentPageIndex + 1);
          }
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: _buildFlipTransition,
          layoutBuilder: (currentChild, previousChildren) {
            return Stack(
              children: <Widget>[
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          child: _buildSinglePage(
            context,
            settings,
            bgColor,
            textColor,
            _currentPageIndex,
          ),
        ),
      );
    } else {
      // Animated Switcher (Slide / Fade / None)
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200), // Faster
        switchInCurve: Curves.easeOutCubic, // Smoother
        switchOutCurve: Curves.easeOutCubic,
        transitionBuilder: (child, animation) {
          if (settings.pageTransition == 'fade') {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          } else if (settings.pageTransition == 'slide') {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          }
          return child; // none
        },
        child: _buildSinglePage(
          context,
          settings,
          bgColor,
          textColor,
          _currentPageIndex,
        ),
      );
    }
  }

  Widget _buildFlipTransition(Widget child, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (context, child) {
        final isUnder = (ValueKey(_currentPageIndex) != child!.key);
        double value;
        if (isUnder) {
          // Exiting: 0 -> pi/2
          value = (1 - animation.value) * (pi / 2);
        } else {
          // Entering: -pi/2 -> 0
          value = (animation.value - 1) * (pi / 2);
        }
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            ..rotateY(value),
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }

  Widget _buildSinglePage(
    BuildContext context,
    ReadingSettings settings,
    Color bgColor,
    Color textColor,
    int pageIndex, {
    Key? key,
  }) {
    return Container(
      key: key ?? ValueKey(pageIndex),
      color: bgColor,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 60),
      child: Consumer(
        builder: (context, ref, child) {
          final highlightsAsync = _book != null
              ? ref.watch(highlightsStreamProvider(_book!.id))
              : const AsyncValue.data(<Highlight>[]);

          return Stack(
            children: [
              SelectionArea(
                child: RichText(
                  textAlign: settings.textAlign == 'justify'
                      ? TextAlign.justify
                      : TextAlign.left,
                  text: highlightsAsync.when(
                    data: (highlights) {
                      final chunkGlobalOffset =
                          (_book!.chunkCharOffsets != null &&
                                  _book!.chunkCharOffsets!.isNotEmpty)
                              ? _book!.chunkCharOffsets![_currentChunkIndex]
                              : 0;

                      return _buildRichText(
                        _pages[pageIndex].text,
                        _pages[pageIndex].startIndex,
                        highlights,
                        TextStyle(
                          fontSize: settings.fontSize,
                          height: settings.lineHeight,
                          fontFamily: settings.fontFamily,
                          letterSpacing: settings.letterSpacing,
                          color: textColor,
                        ),
                        chunkGlobalOffset,
                      );
                    },
                    loading: () => TextSpan(
                      text: _pages[pageIndex].text,
                      style: TextStyle(
                        fontSize: settings.fontSize,
                        height: settings.lineHeight,
                        fontFamily: settings.fontFamily,
                        letterSpacing: settings.letterSpacing,
                        color: textColor,
                      ),
                    ),
                    error: (_, __) => TextSpan(
                      text: _pages[pageIndex].text,
                      style: TextStyle(
                        fontSize: settings.fontSize,
                        height: settings.lineHeight,
                        fontFamily: settings.fontFamily,
                        letterSpacing: settings.letterSpacing,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  TextSpan _buildRichText(
    String text,
    int pageStartIndex,
    List<Highlight> highlights,
    TextStyle baseStyle,
    int chunkGlobalOffset,
  ) {
    if (highlights.isEmpty) {
      return TextSpan(text: text, style: baseStyle);
    }

    // Filter and map highlights
    final pageEndIndex = pageStartIndex + text.length;
    final relevantHighlights = <_MappedHighlight>[];

    for (final highlight in highlights) {
      // 1. Global Original -> Chunk Relative Original
      int chunkRelativeStart = highlight.startPosition - chunkGlobalOffset;
      int chunkRelativeEnd = highlight.endPosition - chunkGlobalOffset;

      // Skip if completely outside chunk (optimization)
      // Note: This is rough because we don't know chunk length easily here without looking it up
      // But mapToReflowed handles out of bounds by clamping, so it's safe.

      // 2. Chunk Relative Original -> Reflowed
      int reflowedStart = chunkRelativeStart;
      int reflowedEnd = chunkRelativeEnd;

      // 3. Check intersection with page
      if (reflowedStart < pageEndIndex && reflowedEnd > pageStartIndex) {
        relevantHighlights.add(_MappedHighlight(
          start: reflowedStart,
          end: reflowedEnd,
          color: highlight.color,
        ));
      }
    }

    if (relevantHighlights.isEmpty) {
      return TextSpan(text: text, style: baseStyle);
    }

    // Sort by start position
    relevantHighlights.sort((a, b) => a.start.compareTo(b.start));

    List<TextSpan> spans = [];
    int currentLocalIndex = 0;

    for (final highlight in relevantHighlights) {
      // Calculate local start/end relative to the page text
      int localStart = max(0, highlight.start - pageStartIndex);
      int localEnd = min(text.length, highlight.end - pageStartIndex);

      if (localStart > currentLocalIndex) {
        // Add non-highlighted text before this highlight
        spans.add(TextSpan(
          text: text.substring(currentLocalIndex, localStart),
        ));
      }

      // Add highlighted text
      if (localEnd > localStart) {
        spans.add(TextSpan(
          text: text.substring(localStart, localEnd),
          style: baseStyle.copyWith(
            backgroundColor: Color(
              int.parse(highlight.color.replaceFirst('#', '0xFF')),
            ).withOpacity(0.5),
          ),
        ));
      }

      currentLocalIndex = max(currentLocalIndex, localEnd);
    }

    // Add remaining text
    if (currentLocalIndex < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentLocalIndex),
      ));
    }

    return TextSpan(style: baseStyle, children: spans);
  }

  void _showSettingsPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const ReaderSettingsPanel(),
    );
  }

  void _addStickyNote(TapUpDetails details) {
    setState(() {
      _isAddingNote = true;
      // Calculate relative position (0.0 - 1.0)
      final RenderBox box = context.findRenderObject() as RenderBox;
      final localPos = box.globalToLocal(details.globalPosition);
      _notePosition = Offset(
        localPos.dx / box.size.width,
        localPos.dy / box.size.height,
      );
    });
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder: (context) => StickyNoteDialog(
        isEditable: true,
        onSave: (content, color) {
          if (_book != null &&
              _book!.ownerId != null &&
              _book!.sourceId != null) {
            ref.read(stickyNoteRepositoryProvider).addNote(
                  ownerId: _book!.ownerId!,
                  bookId: _book!.sourceId!,
                  pageIndex: _currentPageIndex,
                  x: _notePosition!.dx,
                  y: _notePosition!.dy,
                  content: content,
                  color: color,
                );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('공유된 책에서만 포스트잇을 사용할 수 있습니다.')),
            );
          }
        },
      ),
    ).then((_) {
      if (_isAddingNote) setState(() => _isAddingNote = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(readingSettingsProvider);

    // Listen for settings changes to re-paginate
    ref.listen(readingSettingsProvider, (previous, next) {
      next.whenData((settings) {
        previous?.whenData((prevSettings) {
          if (settings.fontSize != prevSettings.fontSize ||
              settings.lineHeight != prevSettings.lineHeight ||
              settings.fontFamily != prevSettings.fontFamily ||
              settings.letterSpacing != prevSettings.letterSpacing ||
              settings.textAlign != prevSettings.textAlign ||
              settings.autoIndent != prevSettings.autoIndent) {
            _paginateChunk(settings);
          }
        });
      });
    });

    return settingsAsync.when(
      data: (settings) {
        // Apply brightness
        try {
          ScreenBrightness().setScreenBrightness(settings.brightness);
        } catch (e) {
          // Ignore brightness error
        }

        // Apply Orientation
        if (settings.orientationLock == 'portrait') {
          SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        } else if (settings.orientationLock == 'landscape') {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight
          ]);
        } else {
          SystemChrome.setPreferredOrientations([]);
        }

        // Apply Fullscreen
        if (settings.hideStatusBar) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
        } else {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        }

        // Check if we need to paginate (e.g. first load or settings changed)
        if (_pages.isEmpty && !_isLoading && _book != null) {
          // Determine initial chunk based on currentCharPosition
          if (_book!.chunkCharOffsets != null &&
              _book!.chunkCharOffsets!.isNotEmpty) {
            // Find chunk
            for (int i = 0; i < _book!.chunkCharOffsets!.length; i++) {
              int start = _book!.chunkCharOffsets![i];
              int end = (i < _book!.chunkCharOffsets!.length - 1)
                  ? _book!.chunkCharOffsets![i + 1]
                  : _book!.totalCharacters;

              if (_book!.currentCharPosition >= start &&
                  _book!.currentCharPosition < end) {
                _currentChunkIndex = i;
                break;
              }
            }
          }
          _paginateChunk(settings);
        }

        // Determine colors based on theme
        Color bgColor;
        Color textColor;

        switch (settings.theme) {
          case 'white':
            bgColor = Colors.white;
            textColor = Colors.black87;
            break;
          case 'sepia':
            bgColor = const Color(0xFFF4ECD8);
            textColor = const Color(0xFF5F4B32);
            break;
          case 'dark':
            bgColor = const Color(0xFF1E1E1E);
            textColor = const Color(0xFFE0E0E0);
            break;
          case 'black':
            bgColor = Colors.black;
            textColor = Colors.grey;
            break;
          default:
            // Custom
            try {
              bgColor = Color(
                int.parse(settings.customBgColor.replaceFirst('#', '0xFF')),
              );
              textColor = Color(
                int.parse(settings.customTextColor.replaceFirst('#', '0xFF')),
              );
            } catch (e) {
              bgColor = Colors.white;
              textColor = Colors.black87;
            }
        }

        if (_isLoading) {
          return Scaffold(
            backgroundColor: bgColor,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (_book == null) {
          return Scaffold(
            backgroundColor: bgColor,
            body: Center(
              child: Text('Book not found', style: TextStyle(color: textColor)),
            ),
          );
        }

        if (_pages.isEmpty) {
          return Scaffold(
            backgroundColor: bgColor,
            body: Center(child: CircularProgressIndicator(color: textColor)),
          );
        }

        return Scaffold(
          backgroundColor: bgColor,
          body: RawKeyboardListener(
            focusNode: FocusNode(),
            autofocus: true,
            onKey: (event) {
              if (!settings.volumeKeyNavEnabled) return;
              if (event is RawKeyDownEvent) {
                if (event.logicalKey == LogicalKeyboardKey.audioVolumeUp) {
                  if (_currentPageIndex > 0)
                    _onPageChanged(_currentPageIndex - 1);
                } else if (event.logicalKey ==
                    LogicalKeyboardKey.audioVolumeDown) {
                  if (_currentPageIndex < _pages.length - 1)
                    _onPageChanged(_currentPageIndex + 1);
                }
              }
            },
            child: SafeArea(
              child: Stack(
                children: [
                  GestureDetector(
                    onTapUp: (details) {
                      final width = MediaQuery.of(context).size.width;
                      final touchZone = width * settings.touchZoneSize;
                      if (details.globalPosition.dx < touchZone) {
                        if (_currentPageIndex > 0)
                          _onPageChanged(_currentPageIndex - 1);
                      } else if (details.globalPosition.dx >
                          width - touchZone) {
                        if (_currentPageIndex < _pages.length - 1)
                          _onPageChanged(_currentPageIndex + 1);
                      } else {
                        _toggleMenu();
                      }
                    },
                    onLongPressStart: (details) {
                      // Long press to add sticky note
                      _addStickyNote(
                        TapUpDetails(
                          kind: PointerDeviceKind.touch,
                          globalPosition: details.globalPosition,
                          localPosition: details.localPosition,
                        ),
                      );
                    },
                    child: _buildPageContent(
                        context, settings, bgColor, textColor),
                  ),

                  // Sticky Notes Overlay (Only for non-scroll/flip modes or handle separately)
                  // For Scroll/Flip, we might need to integrate notes into the page builder
                  // But for now, let's keep it simple.
                  if (settings.pageTransition != 'scroll' &&
                      settings.pageTransition != 'flip' &&
                      _book != null &&
                      _book!.ownerId != null &&
                      _book!.sourceId != null)
                    Consumer(
                      builder: (context, ref, child) {
                        final notesAsync = ref.watch(
                          stickyNotesStreamProvider(
                            ownerId: _book!.ownerId!,
                            bookId: _book!.sourceId!,
                          ),
                        );

                        return notesAsync.when(
                          data: (notes) {
                            final pageNotes = notes
                                .where((n) => n.pageIndex == _currentPageIndex)
                                .toList();
                            return Stack(
                              children: pageNotes.map((note) {
                                return Positioned(
                                  left: note.x *
                                      MediaQuery.of(context).size.width,
                                  top: note.y *
                                      MediaQuery.of(context).size.height,
                                  child: StickyNoteWidget(
                                    note: note,
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => StickyNoteDialog(
                                          note: note,
                                          isEditable: note.authorId ==
                                              ref
                                                  .read(authRepositoryProvider)
                                                  .currentUser
                                                  ?.uid,
                                          onSave: (content, color) {
                                            ref
                                                .read(
                                                  stickyNoteRepositoryProvider,
                                                )
                                                .updateNote(
                                                  ownerId: _book!.ownerId!,
                                                  bookId: _book!.sourceId!,
                                                  noteId: note.id,
                                                  content: content,
                                                  color: color,
                                                );
                                          },
                                          onDelete: () {
                                            ref
                                                .read(
                                                  stickyNoteRepositoryProvider,
                                                )
                                                .deleteNote(
                                                  ownerId: _book!.ownerId!,
                                                  bookId: _book!.sourceId!,
                                                  noteId: note.id,
                                                );
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            );
                          },
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        );
                      },
                    ),

                  // Page Number
                  if (settings.showPageNumber)
                    Positioned(
                      bottom: 10,
                      left: 20,
                      child: Text(
                        '${_currentPageIndex + 1} / ${_pages.length}',
                        style: TextStyle(
                          color: textColor.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ),

                  // Clock
                  if (settings.showClock)
                    Positioned(
                      bottom: 10,
                      right: 20,
                      child: StreamBuilder(
                        stream: Stream.periodic(const Duration(minutes: 1)),
                        builder: (context, snapshot) {
                          final now = DateTime.now();
                          final timeString =
                              '${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
                          return Text(
                            timeString,
                            style: TextStyle(
                              color: textColor.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),

                  // Progress Bar
                  if (settings.showProgressBar)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: LinearProgressIndicator(
                        value: _pages.isEmpty
                            ? 0
                            : (_currentPageIndex + 1) / _pages.length,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          textColor.withOpacity(0.3),
                        ),
                        minHeight: 3,
                      ),
                    ),

                  // Menu Overlay
                  if (_showMenu)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AppBar(
                        backgroundColor: bgColor.withOpacity(0.9),
                        elevation: 0,
                        iconTheme: IconThemeData(color: textColor),
                        title: Text(
                          _book!.title,
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                        actions: [
                          if (_book != null)
                            Consumer(
                              builder: (context, ref, child) {
                                final bookmarksAsync = ref.watch(
                                  bookmarksStreamProvider(_book!.id),
                                );
                                return bookmarksAsync.when(
                                  data: (bookmarks) {
                                    final isBookmarked = bookmarks.any(
                                      (b) => b.pageNumber == _currentPageIndex,
                                    );
                                    return IconButton(
                                      icon: Icon(
                                        isBookmarked
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                      ),
                                      onPressed: _toggleBookmark,
                                    );
                                  },
                                  loading: () => const SizedBox.shrink(),
                                  error: (_, __) => const SizedBox.shrink(),
                                );
                              },
                            ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: _sharePage,
                          ),
                          IconButton(
                            icon: const Icon(Icons.list),
                            onPressed: _showContents,
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings),
                            onPressed: _showSettingsPanel,
                          ),
                        ],
                      ),
                    ),

                  if (_showMenu)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        color: bgColor.withOpacity(0.9),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Slider(
                              value: _book != null
                                  ? _book!.currentCharPosition.toDouble()
                                  : 0,
                              min: 0,
                              max: _book != null
                                  ? _book!.totalCharacters.toDouble()
                                  : 1,
                              onChanged: (value) {
                                // Seek to global char position
                                int targetChar = value.toInt();

                                // Find chunk
                                int targetChunk = 0;
                                if (_book!.chunkCharOffsets != null) {
                                  for (int i = 0;
                                      i < _book!.chunkCharOffsets!.length;
                                      i++) {
                                    if (_book!.chunkCharOffsets![i] <=
                                        targetChar) {
                                      targetChunk = i;
                                    } else {
                                      break;
                                    }
                                  }
                                }

                                // Update book position temporarily so pagination picks it up
                                _book!.currentCharPosition = targetChar;

                                if (targetChunk != _currentChunkIndex) {
                                  _loadChunk(targetChunk);
                                } else {
                                  // Same chunk, just find page
                                  int relativeChar = targetChar;
                                  if (_book!.chunkCharOffsets != null) {
                                    relativeChar -= _book!
                                        .chunkCharOffsets![_currentChunkIndex];
                                  }

                                  int targetPage = 0;
                                  for (int i = 0; i < _pages.length; i++) {
                                    if (_pages[i].startIndex <= relativeChar &&
                                        _pages[i].endIndex > relativeChar) {
                                      targetPage = i;
                                      break;
                                    }
                                  }
                                  _onPageChanged(targetPage);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}

class _MappedHighlight {
  final int start;
  final int end;
  final String color;

  _MappedHighlight(
      {required this.start, required this.end, required this.color});
}
