import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../library/book_repository.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final String bookId;
  final String bookTitle;
  final String filePath;

  const ReaderScreen({
    super.key,
    required this.bookId,
    required this.bookTitle,
    required this.filePath,
  });

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  InAppWebViewController? webViewController;
  String currentCFI = '';
  bool isLoading = true;

  // Typography settings
  double fontSize = 16.0;
  double lineHeight = 1.6;
  String fontFamily = 'Georgia';
  String theme = 'light'; // light, dark, sepia

  @override
  void initState() {
    super.initState();
    _loadSavedPosition();
  }

  Future<void> _loadSavedPosition() async {
    final books = await ref.read(bookRepositoryProvider).getBooks();
    final book = books.firstWhere(
      (b) => b.id.toString() == widget.bookId,
      orElse: () => books.first,
    );
    setState(() {
      currentCFI = book.currentPosition;
    });
  }

  Future<void> _savePosition(String cfi) async {
    final books = await ref.read(bookRepositoryProvider).getBooks();
    final book = books.firstWhere((b) => b.id.toString() == widget.bookId);
    book.currentPosition = cfi;
    book.lastReadAt = DateTime.now();
    await ref.read(bookRepositoryProvider).addBook(book);
  }

  void _updateTypography() {
    if (webViewController == null) return;

    final themeColors = _getThemeColors();

    webViewController!.evaluateJavascript(
      source:
          '''
      if (window.rendition) {
        window.rendition.themes.override('font-size', '${fontSize}px');
        window.rendition.themes.override('line-height', '$lineHeight');
        window.rendition.themes.override('font-family', '$fontFamily, serif');
        window.rendition.themes.override('color', '${themeColors['text']}');
        window.rendition.themes.override('background-color', '${themeColors['background']}');
      }
    ''',
    );
  }

  Map<String, String> _getThemeColors() {
    switch (theme) {
      case 'dark':
        return {'text': '#E0E0E0', 'background': '#1A1A1A'};
      case 'sepia':
        return {'text': '#5B4636', 'background': '#F4ECD8'};
      default: // light
        return {'text': '#000000', 'background': '#FFFFFF'};
    }
  }

  Widget _themeButton(String label, String value, StateSetter setModalState) {
    final isSelected = theme == value;
    return ElevatedButton(
      onPressed: () {
        setModalState(() => theme = value);
        setState(() => theme = value);
        _updateTypography();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.orange : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.bookTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.note_add),
            onPressed: _showAddNoteDialog,
          ),
          IconButton(
            icon: const Icon(Icons.format_size),
            onPressed: _showTypographyControls,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              // TODO: Add bookmark
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialData: InAppWebViewInitialData(data: _getEpubViewerHTML()),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              useOnDownloadStart: false,
            ),
            onWebViewCreated: (controller) {
              webViewController = controller;

              controller.addJavaScriptHandler(
                handlerName: 'cfiChanged',
                callback: (args) {
                  if (args.isNotEmpty) {
                    final cfi = args[0].toString();
                    setState(() {
                      currentCFI = cfi;
                    });
                    _savePosition(cfi);
                  }
                },
              );
            },
            onLoadStop: (controller, url) {
              setState(() {
                isLoading = false;
              });
              Future.delayed(const Duration(milliseconds: 500), () {
                _updateTypography();
              });
            },
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  void _showAddNoteDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('노트 추가'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: '노트 내용을 입력하세요...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(context);
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('노트가 추가되었습니다')));
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  void _showTypographyControls() {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '타이포그래피 설정',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  const Text('글자 크기'),
                  const SizedBox(width: 8),
                  Text(
                    '${fontSize.toInt()}px',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Expanded(
                    child: Slider(
                      value: fontSize,
                      min: 12,
                      max: 32,
                      onChanged: (val) {
                        setModalState(() => fontSize = val);
                        setState(() => fontSize = val);
                        _updateTypography();
                      },
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  const Text('줄 간격'),
                  const SizedBox(width: 8),
                  Text(
                    lineHeight.toStringAsFixed(1),
                    style: const TextStyle(color: Colors.grey),
                  ),
                  Expanded(
                    child: Slider(
                      value: lineHeight,
                      min: 1.0,
                      max: 2.5,
                      onChanged: (val) {
                        setModalState(() => lineHeight = val);
                        setState(() => lineHeight = val);
                        _updateTypography();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              DropdownButton<String>(
                value: fontFamily,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'Georgia', child: Text('Georgia')),
                  DropdownMenuItem(
                    value: 'Times New Roman',
                    child: Text('Times New Roman'),
                  ),
                  DropdownMenuItem(value: 'Arial', child: Text('Arial')),
                  DropdownMenuItem(
                    value: 'Noto Serif KR',
                    child: Text('Noto Serif KR'),
                  ),
                ],
                onChanged: (val) {
                  if (val != null) {
                    setModalState(() => fontFamily = val);
                    setState(() => fontFamily = val);
                    _updateTypography();
                  }
                },
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _themeButton('밝게', 'light', setModalState),
                  _themeButton('어둡게', 'dark', setModalState),
                  _themeButton('세피아', 'sepia', setModalState),
                ],
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('닫기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getEpubViewerHTML() {
    return '''
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.jsdelivr.net/npm/epubjs/dist/epub.min.js"></script>
    <style>
        body {
            margin: 0;
            padding: 0;
            overflow: hidden;
        }
        #viewer {
            width: 100vw;
            height: 100vh;
        }
        #area {
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body>
    <div id="viewer">
        <div id="area"></div>
    </div>
    
    <script>
        var book = ePub("${widget.filePath}");
        var rendition = book.renderTo("area", {
            width: "100%",
            height: "100%",
            spread: "none"
        });
        
        var displayed = rendition.display("${currentCFI.isEmpty ? 'epubcfi(/6/2)' : currentCFI}");
        
        rendition.on("relocated", function(location){
            var cfi = location.start.cfi;
            window.flutter_inappwebview.callHandler('cfiChanged', cfi);
        });
        
        document.addEventListener('keyup', function(e) {
            if (e.key === 'ArrowRight') {
                rendition.next();
            } else if (e.key === 'ArrowLeft') {
                rendition.prev();
            }
        });
        
        var startX = 0;
        document.addEventListener('touchstart', function(e) {
            startX = e.touches[0].pageX;
        });
        
        document.addEventListener('touchend', function(e) {
            var endX = e.changedTouches[0].pageX;
            if (startX - endX > 50) {
                rendition.next();
            } else if (endX - startX > 50) {
                rendition.prev();
            }
        });
    </script>
</body>
</html>
    ''';
  }
}
