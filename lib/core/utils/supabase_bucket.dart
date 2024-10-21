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
  final String filePath = 'uploads/$fileName';
  String? publicURL;

  try {
    if (kIsWeb) {
      //! Here upser should be false and be handled other ways
      if (file is Uint8List) {
        publicURL = await supabase.storage.from(bucket).uploadBinary(
              filePath,
              file,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: true),
            );
      } else {
        debugPrint("Invalid file type for web. Expected Uint8List.");
        return null;
      }
    } else {
      if (file is File) {
        //! Here upser should be false and be handled other ways
        final fileBytes = await file.readAsBytes();
        publicURL = await supabase.storage.from(bucket).uploadBinary(
              filePath,
              fileBytes,
              fileOptions:
                  const FileOptions(cacheControl: '3600', upsert: true),
            );
      } else {
        debugPrint("Invalid file type for mobile. Expected File.");
        return null;
      }
    }
  } on StorageException catch (e) {
    debugPrint("Storage Exception : $e");
    return null;
  } on Exception catch (e) {
    debugPrint("Unknown Exception : $e");
    return null;
  }

  // Get the public URL of the uploaded file
  return supabase.storage.from(bucket).getPublicUrl(filePath);
}
