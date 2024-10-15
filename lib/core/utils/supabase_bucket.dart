import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../main.dart'; // For kIsWeb

Future<String?> supabaseUpload(
  dynamic file, // Can be either File or a Uint8List
  String fileName,
  String bucket,
) async {
  final String filePath =
      'uploads/$fileName';
  String? publicURL;

  try {
    if (kIsWeb) {
      // For web, expect a Uint8List
      if (file is Uint8List) {
        publicURL = await supabase.storage.from(bucket).uploadBinary(
              filePath,
              file,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: false),
            );
      } else {
        throw Exception("Invalid file type for web. Expected Uint8List.");
      }
    } else {
      // For mobile, expect a File
      if (file is File) {
        final fileBytes = await file.readAsBytes();
        publicURL = await supabase.storage.from(bucket).uploadBinary(
              filePath,
              fileBytes,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: false),
            );
      } else {
        throw Exception("Invalid file type for mobile. Expected File.");
      }
    }
  } on Exception catch (e) {
    throw Exception("Upload failed: $e");
  }

  // Get the public URL of the uploaded file
  return supabase.storage.from(bucket).getPublicUrl(filePath);
}
