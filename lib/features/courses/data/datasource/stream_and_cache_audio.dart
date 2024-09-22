import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/media.dart';

Future<void> streamAndCacheAudio(Media media) async {
  if (media.audioUrl == null) return;
  String url = media.audioUrl!;

  final Directory tempDir = await getTemporaryDirectory();
  final File cacheFile = File('${tempDir.path}/${media.id}.mp3');
  final IOSink cacheSink = cacheFile.openWrite();

  var cacheBox = Hive.box('audioCache');
  String cacheKey = url;

  try {
    // Initialize Dio
    Dio dio = Dio();

    // Start downloading the audio
    await dio.download(
      url,
      cacheFile.path,
      onReceiveProgress: (received, total) {
        // You can use this to show progress to the user if needed
        print('Received: $received, Total: $total');
      },
      options: Options(
        responseType: ResponseType.stream, // Stream response for streaming
      ),
    );

    // Once downloaded, save the file path to Hive
    cacheBox.put(cacheKey, cacheFile.path);
  } catch (e) {
    print("Error caching audio stream: $e");
  } finally {
    await cacheSink.flush();
    await cacheSink.close();
  }
}
