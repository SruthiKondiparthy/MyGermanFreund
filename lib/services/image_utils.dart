import 'dart:io';
import 'package:image/image.dart' as img;

class ImageUtils {
  /// Auto-rotates image based on EXIF data
  /// Fixes sideways/upside-down photos from camera
  static Future<File> fixOrientation(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return imageFile;

      // This automatically reads EXIF and fixes rotation!!
      final fixed = img.bakeOrientation(image);

      // Save corrected image to temp file
      final tempPath = imageFile.path.replaceAll('.jpg', '_fixed.jpg');
      final fixedFile = File(tempPath);
      await fixedFile.writeAsBytes(img.encodeJpg(fixed, quality: 85));

      return fixedFile;
    } catch (e) {
      // If anything fails return original
      return imageFile;
    }
  }
}