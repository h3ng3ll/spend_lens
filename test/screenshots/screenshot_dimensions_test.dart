import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

/// The single App-Store-accepted portrait size this pipeline targets:
/// App Store Connect's APP_IPHONE_65 (6.5") upload set.
///
/// See `.claude/rules/screenshots_device_rules.md` — the contract is the output
/// PIXEL SIZE, not the capture host. An Android emulator left at its native
/// resolution (e.g. 1080x2424) is rejected here.
const _kIphone14Plus = (width: 1284, height: 2778);

/// Reads a PNG's intrinsic size straight from its IHDR chunk.
///
/// Byte layout: an 8-byte signature, then the IHDR chunk whose 4-byte
/// big-endian width and height sit at offsets 16 and 20. This deliberately
/// avoids decoding the image — the gate only needs the header.
({int width, int height}) _readPngSize(File file) {
  final Uint8List bytes = file.readAsBytesSync();

  if (bytes.length < 24) {
    fail('${file.path}: too small to be a PNG (${bytes.length} bytes)');
  }

  const List<int> signature = <int>[137, 80, 78, 71, 13, 10, 26, 10];
  for (int i = 0; i < signature.length; i++) {
    if (bytes[i] != signature[i]) {
      fail('${file.path}: not a PNG (bad signature)');
    }
  }

  final ByteData data = ByteData.sublistView(bytes);
  return (
    width: data.getUint32(16, Endian.big),
    height: data.getUint32(20, Endian.big),
  );
}

void main() {
  final String dirPath =
      Platform.environment['SCREENSHOT_DIR'] ?? 'outputs/screenshots';
  final Directory dir = Directory(dirPath);

  test('the capture produced at least one PNG', () {
    expect(
      dir.existsSync(),
      isTrue,
      reason:
          'Screenshot directory $dirPath does not exist — the capture wrote '
          'nothing. `flutter drive` can exit 0 having produced no PNGs.',
    );

    final List<File> pngs = dir
        .listSync()
        .whereType<File>()
        .where((File f) => f.path.toLowerCase().endsWith('.png'))
        .toList();

    expect(
      pngs,
      isNotEmpty,
      reason:
          'No PNG files in $dirPath — the capture produced nothing to archive.',
    );
  });

  test('every screenshot is exactly ${_kIphone14Plus.width}x'
      '${_kIphone14Plus.height} portrait', () {
    final List<File> pngs =
        (dir.existsSync()
              ? dir
                    .listSync()
                    .whereType<File>()
                    .where((File f) => f.path.toLowerCase().endsWith('.png'))
                    .toList()
              : <File>[])
          ..sort((File a, File b) => a.path.compareTo(b.path));

    final List<String> offenders = <String>[];
    for (final File png in pngs) {
      final ({int width, int height}) size = _readPngSize(png);
      if (size.width != _kIphone14Plus.width ||
          size.height != _kIphone14Plus.height) {
        offenders.add(
          '${png.uri.pathSegments.last}: ${size.width}x${size.height}',
        );
      }
    }

    expect(
      offenders,
      isEmpty,
      reason:
          'These screenshots are not ${_kIphone14Plus.width}x'
          '${_kIphone14Plus.height}:\n  ${offenders.join('\n  ')}\n'
          'App Store Connect rejects any other size for the APP_IPHONE_65 set. '
          'On Android this means the `wm size` / `wm density` override did not '
          'hold for the whole run.',
    );
  });
}
