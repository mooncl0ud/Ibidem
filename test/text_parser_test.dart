import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:ibidem/src/features/reader/text_parser.dart';

void main() {
  test('TextParser analyzes and reads chunks correctly', () async {
    // 1. Generate a test file (~200KB)
    final file = File('test_large_file.txt');
    final sb = StringBuffer();
    for (int i = 0; i < 3000; i++) {
      sb.writeln(
          'Line $i: This is a test line to fill up space and test chunking. ' *
              2);
    }
    await file.writeAsString(sb.toString());

    try {
      final parser = TextParser();

      // 2. Detect Encoding
      final encoding = await parser.detectEncodingName(file);
      expect(encoding, isNotNull);

      // 3. Analyze File
      final (totalChars, byteOffsets, charOffsets) =
          await parser.analyzeFile(file, encodingName: encoding);

      print('Total Chars: $totalChars');
      print('Byte Offsets: $byteOffsets');
      print('Char Offsets: $charOffsets');

      expect(byteOffsets.length,
          greaterThan(1)); // Should have multiple chunks (50KB chunk size)
      expect(byteOffsets.length, equals(charOffsets.length));
      expect(byteOffsets.first, 0);
      expect(charOffsets.first, 0);

      // 4. Read Chunks
      for (int i = 0; i < byteOffsets.length; i++) {
        final start = byteOffsets[i];
        final end = (i < byteOffsets.length - 1)
            ? byteOffsets[i + 1]
            : await file.length();

        final chunkContent =
            await parser.readChunk(file, start, end, encodingName: encoding);
        expect(chunkContent, isNotEmpty);

        // Verify char count matches
        final expectedCharCount = (i < charOffsets.length - 1)
            ? charOffsets[i + 1] - charOffsets[i]
            : totalChars - charOffsets[i];

        expect(chunkContent.length, equals(expectedCharCount));
      }
    } finally {
      // Cleanup
      if (await file.exists()) {
        await file.delete();
      }
    }
  });

  test('TextParser handles split multi-byte characters correctly', () async {
    final file = File('test_split_char.txt');
    // Create a string with Korean characters (3 bytes each in UTF-8)
    // We want to force a split at the buffer boundary (64KB = 65536 bytes)
    // '가' is 3 bytes: EAB080

    final sb = StringBuffer();
    // Fill up to close to 65536
    // 65536 / 3 = 21845.33
    // 21845 * 3 = 65535.
    // So if we write 21845 Korean chars, we have 65535 bytes.
    // Then next char will be split: 1 byte in first chunk, 2 bytes in next.

    for (int i = 0; i < 21845; i++) {
      sb.write('가');
    }
    sb.write('나'); // This '나' should be split (starts at 65535, ends at 65538)
    sb.write('다' * 100);

    await file.writeAsString(sb.toString());

    try {
      final parser = TextParser();
      final (totalChars, byteOffsets, charOffsets) =
          await parser.analyzeFile(file);

      // 21845 + 1 + 100 = 21946 chars
      expect(totalChars, equals(21946));

      // Verify content integrity
      final content = await parser.readChunk(file, 0, await file.length());
      expect(content, equals(sb.toString()));
    } finally {
      if (await file.exists()) {
        await file.delete();
      }
    }
  });
}
