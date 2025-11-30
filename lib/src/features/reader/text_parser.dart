import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ReaderPage {
  final String text;
  final int startIndex;
  final int endIndex;

  ReaderPage({
    required this.text,
    required this.startIndex,
    required this.endIndex,
  });
}

class TextParser {
  static const int _sampleSize = 4096;

  /// Detects the encoding of the file and returns the decoded string.
  /// If encoding cannot be detected, defaults to UTF-8.
  ///
  /// [Deprecated] This method reads the entire file into memory.
  /// Use [readChunk] or [analyzeFile] for large files.
  @Deprecated('Use readChunk for better memory management')
  Future<String> readFile(File file, {String? encodingName}) async {
    final bytes = await file.readAsBytes();
    return compute((message) {
      final bytes = message.bytes;
      final name = message.encodingName;
      Encoding? encoding;

      if (name != null) {
        encoding = Encoding.getByName(name);
      }

      encoding ??= _detectEncoding(bytes);
      return encoding.decode(bytes);
    }, (bytes: bytes, encodingName: encodingName));
  }

  /// Returns the name of the detected encoding
  Future<String> detectEncodingName(File file) async {
    // Read only a sample for detection
    final length = await file.length();
    final sampleSize = length > _sampleSize ? _sampleSize : length;
    final bytes = await file.openRead(0, sampleSize).first;
    // We need a Uint8List
    final uint8Bytes = Uint8List.fromList(bytes);

    final encoding = await compute(_detectEncoding, uint8Bytes);
    return encoding.name;
  }

  /// Analyzes the file to generate chunk offsets and count characters.
  /// Returns (totalCharacters, byteOffsets, charOffsets)
  Future<(int, List<int>, List<int>)> analyzeFile(File file,
      {String? encodingName}) async {
    return compute((message) async {
      final file = message.file;
      final encodingName = message.encodingName;

      final encoding = encodingName != null
          ? Encoding.getByName(encodingName) ?? utf8
          : utf8;

      final raf = file.openSync();
      final length = raf.lengthSync();

      List<int> byteOffsets = [0];
      List<int> charOffsets = [0];
      int totalChars = 0;
      int currentByteOffset = 0;
      const int targetChunkSize = 50 * 1024; // 50KB

      const int bufferSize = 64 * 1024;
      final buffer = Uint8List(bufferSize);

      try {
        while (currentByteOffset < length) {
          final bytesRead = raf.readIntoSync(buffer);
          if (bytesRead == 0) break;

          int validLength = bytesRead;
          String content = '';
          bool decoded = false;

          // Backtracking loop to handle split multi-byte characters
          while (!decoded && validLength > 0) {
            try {
              if (encoding.name == 'utf-8') {
                content = const Utf8Decoder(allowMalformed: false)
                    .convert(buffer, 0, validLength);
              } else {
                content = encoding.decode(buffer.sublist(0, validLength));
              }
              decoded = true;
            } catch (e) {
              validLength--;
            }
          }

          if (!decoded) {
            content = encoding.decode(buffer.sublist(0, bytesRead));
            validLength = bytesRead;
          }

          if (validLength < bytesRead) {
            raf.setPositionSync(raf.positionSync() - (bytesRead - validLength));
          }

          final contentLen = content.length;
          currentByteOffset += validLength;
          totalChars += contentLen;

          if (currentByteOffset - byteOffsets.last > targetChunkSize) {
            int splitIndex = -1;

            // Priority 1: Double Newline (Strong Paragraph Break)
            for (int i = validLength - 1; i >= 1; i--) {
              if (buffer[i] == 10 && buffer[i - 1] == 10) {
                splitIndex = i;
                break;
              }
            }

            // Priority 2: Sentence End (Period + Newline)
            if (splitIndex == -1) {
              for (int i = validLength - 1; i >= 1; i--) {
                if (buffer[i] == 10 && buffer[i - 1] == 46) {
                  // . = 46
                  splitIndex = i;
                  break;
                }
              }
            }

            // Priority 3: Any Newline (Fallback)
            if (splitIndex == -1) {
              for (int i = validLength - 1; i >= 0; i--) {
                if (buffer[i] == 10) {
                  splitIndex = i;
                  break;
                }
              }
            }

            if (splitIndex != -1) {
              final newlineFileOffset =
                  (currentByteOffset - validLength) + splitIndex + 1;

              if (newlineFileOffset > byteOffsets.last) {
                byteOffsets.add(newlineFileOffset);

                final preSplitBytes = buffer.sublist(0, splitIndex + 1);
                final preSplitContent = encoding.decode(preSplitBytes);
                charOffsets
                    .add((totalChars - contentLen) + preSplitContent.length);
              }
            } else {
              byteOffsets.add(currentByteOffset);
              charOffsets.add(totalChars);
            }
          }
        }
      } finally {
        raf.closeSync();
      }

      return (totalChars, byteOffsets, charOffsets);
    }, (file: file, encodingName: encodingName));
  }

  /// Reads a specific chunk of the file
  Future<String> readChunk(File file, int start, int end,
      {String? encodingName}) async {
    return compute((message) {
      final file = message.file;
      final start = message.start;
      final end = message.end;
      final encodingName = message.encodingName;

      final raf = file.openSync();
      raf.setPositionSync(start);

      final length = end - start;
      final buffer = Uint8List(length);
      raf.readIntoSync(buffer);
      raf.closeSync();

      final encoding = encodingName != null
          ? Encoding.getByName(encodingName) ?? utf8
          : utf8;

      return encoding.decode(buffer);
    }, (file: file, start: start, end: end, encodingName: encodingName));
  }

  static Encoding _detectEncoding(Uint8List bytes) {
    // 1. Try UTF-8
    try {
      const Utf8Decoder(allowMalformed: false).convert(bytes);
      return utf8;
    } catch (_) {}

    // 2. Try EUC-KR (Korean)
    final eucKr = Encoding.getByName('euc-kr');
    if (eucKr != null) {
      try {
        // Simple heuristic: if it decodes without error, assume it's correct
        // For strict check, we might need more logic, but this is a good start
        eucKr.decode(bytes);
        return eucKr;
      } catch (_) {}
    }

    // 3. Try CP949 (Extended Korean)
    final cp949 = Encoding.getByName('cp949');
    if (cp949 != null) {
      try {
        cp949.decode(bytes);
        return cp949;
      } catch (_) {}
    }

    // 4. Fallback to Latin1 (which usually doesn't fail but might show garbage)
    return latin1;
  }

  /// Paginates the text based on the given constraints and style.
  /// Returns a list of ReaderPage objects.
  /// Paginates the text based on the given constraints and style.
  /// Uses TextPainter to measure actual rendering height and splits at ZWSP boundaries.
  List<ReaderPage> paginate({
    required String content,
    required Size size,
    required TextStyle style,
    required EdgeInsets padding,
  }) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final double maxWidth = size.width - padding.left - padding.right;
    final double maxHeight = size.height - padding.top - padding.bottom;

    List<ReaderPage> pages = [];
    int start = 0;

    while (start < content.length) {
      // 1. Layout the remaining text to see if it fits
      String remaining = content.substring(start);
      textPainter.text = TextSpan(text: remaining, style: style);
      textPainter.layout(maxWidth: maxWidth);

      // If it fits entirely, we are done
      if (textPainter.height <= maxHeight) {
        pages.add(ReaderPage(
          text: remaining,
          startIndex: start,
          endIndex: content.length,
        ));
        break;
      }

      // 2. If it doesn't fit, find the split point
      // Get the position at the bottom-right corner of the available space
      final endPosition =
          textPainter.getPositionForOffset(Offset(maxWidth, maxHeight));
      int end = start + endPosition.offset;

      // 3. Adjust split point to avoid breaking words (ZWSP awareness)
      // We search backwards from the split point for a ZWSP (\u200B) or Space
      // The KTextReflow engine injects ZWSP after spaces, so we look for that.
      // If we can't find one reasonably close, we might have to force break.

      if (end < content.length) {
        int searchLimit = 50; // Look back up to 50 chars
        int foundSplit = -1;

        for (int i = 0; i < searchLimit && (end - i) > start; i++) {
          final char = content[end - i];
          // Check for ZWSP, Space, or Newline
          if (char == '\u200B' || char == ' ' || char == '\n') {
            foundSplit = end - i;
            break;
          }
        }

        if (foundSplit != -1) {
          end = foundSplit + 1; // Include the break char in the current page
        }
      }

      // Safety check: ensure progress
      if (end <= start) {
        end = start + 1;
      }

      pages.add(ReaderPage(
        text: content.substring(start, end),
        startIndex: start,
        endIndex: end,
      ));

      start = end;
    }

    return pages;
  }
}
