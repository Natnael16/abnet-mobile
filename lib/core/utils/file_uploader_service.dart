import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'dart:io' as io; // Only for non-web platforms

class FilePickerService {
  static Future<dynamic> getFile({List<String>? allowedExtensions}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: allowedExtensions != null ? FileType.custom : FileType.any,
      allowedExtensions: allowedExtensions,
    );

    if (result != null) {
      PlatformFile platformFile = result.files.first;

      if (kIsWeb) {
        // Web: return bytes (Uint8List)
        Uint8List? fileBytes = platformFile.bytes;
        if (fileBytes != null) {
          return {
            "file": fileBytes,
            "name": platformFile.name
          }; // Return the file content as bytes for web
        } else {
          debugPrint("No file bytes available.");
        }
      } else {
        // Mobile/Desktop: return a File object from file path
        String? filePath = platformFile.path;
        if (filePath != null) {
          io.File file = io.File(filePath); // Return File object for non-web
          return {"file": file, "name": platformFile.name};
        } else {
          debugPrint("No file path available.");
        }
      }
    } else {
      debugPrint("No file selected.");
    }
  }
}
