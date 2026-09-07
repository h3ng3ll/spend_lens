import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot:
        (
          String screenshotName,
          List<int> screenshotBytes, [
          Map<String, Object?>? args,
        ]) async {
          final dir =
              Platform.environment['SCREENSHOT_DIR'] ?? 'outputs/screenshots';
          final outDir = Directory(dir);
          if (!outDir.existsSync()) {
            outDir.createSync(recursive: true);
          }
          final file = File('${outDir.path}/$screenshotName.png');
          await file.writeAsBytes(screenshotBytes);
          return true;
        },
  );
}
