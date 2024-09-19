import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';

part 'media_event.dart';
part 'media_state.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  AudioPlayer? _audioPlayer;

  AudioBloc()
      : super(const AudioState(
          isPlaying: false,
          isLoading: false,
          currentDuration: Duration.zero,
          totalDuration: Duration.zero,
        )) {
    on<PlayAudio>((event, emit) async {
      // Dispose of any existing player
      _audioPlayer?.dispose();
      _audioPlayer = AudioPlayer();

      emit(state.copyWith(isLoading: true,
        currentAudioUrl: event.audioUrl,
      ));

      try {
        // Load the audio
        await _audioPlayer!.setUrl(event.audioUrl);

        // Play the audio
        await _audioPlayer!.play();
        emit(state.copyWith(
          isLoading: false,
          isPlaying: true,
          currentAudioUrl: event.audioUrl,
          totalDuration: _audioPlayer!.duration ?? Duration.zero,
        ));

        // Start listening for position updates and player state
        _audioPlayer!.positionStream.listen((position) {
          add(UpdatePosition(position)); // Trigger event for position updates
        });

        _audioPlayer!.playerStateStream.listen((playerState) {
          add(UpdatePlayerState(playerState.playing)); // Trigger event for player state updates
        });

      } catch (e) {
        // Handle error and update state
        emit(state.copyWith(isLoading: false));
      }
    });

    on<PauseAudio>((event, emit) async {
      await _audioPlayer?.pause();
      emit(state.copyWith(isPlaying: false));
    });

    on<ResumeAudio>((event, emit) async {
      await _audioPlayer?.play();
      emit(state.copyWith(isPlaying: true));
    });

    on<SeekAudio>((event, emit) async {
      await _audioPlayer?.seek(event.position);
    });

    on<StopAudio>((event, emit) async {
      await _audioPlayer?.stop();
      _audioPlayer?.dispose();
      emit(state.copyWith(isPlaying: false, currentAudioUrl: null));
    });

    // Handle position update event
    on<UpdatePosition>((event, emit) {
      emit(state.copyWith(currentDuration: event.position));
    });

    // Handle player state update event
    on<UpdatePlayerState>((event, emit) {
      emit(state.copyWith(isPlaying: event.isPlaying));
    });
    on<UpdateDownloadProgress>((event, emit) {
      emit(state.copyWith(downloadProgress: event.progress));
    });
    
    Future<String?> downloadAudio(String url) async {
      try {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/${url.split('/').last}';
        final file = File(filePath);

        if (await file.exists()) {
          return filePath; // Return if the file is already downloaded
        }

        Dio dio = Dio();
        await dio.download(
          url,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              final progress = received / total;
              add(UpdateDownloadProgress(progress)); // Emit progress event
            }
          },
        );

        return filePath;
      } catch (e) {
        print('Error downloading file: $e');
        return null;
      }
    }

  }

  @override
  Future<void> close() {
    _audioPlayer?.dispose();
    return super.close();
  }
}
