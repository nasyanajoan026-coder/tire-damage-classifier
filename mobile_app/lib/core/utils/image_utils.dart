import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  /// Compress dan resize gambar sebelum upload ke backend.
  /// Target: di bawah 500KB, resize ke 512x512 max.
  static Future<File> compressImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final decoded = img.decodeImage(bytes);

    if (decoded == null) return imageFile;

    // Resize jika lebih besar dari 512
    final resized = img.copyResize(
      decoded,
      width: decoded.width > 512 ? 512 : decoded.width,
    );

    final compressed = img.encodeJpg(resized, quality: 85);

    final tempDir = await getTemporaryDirectory();
    final tempFile = File(
      '${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    await tempFile.writeAsBytes(compressed);
    return tempFile;
  }
}