import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:equatable/equatable.dart';

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

      emit(state.copyWith(isLoading: true));

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
  }

  @override
  Future<void> close() {
    _audioPlayer?.dispose();
    return super.close();
  }
}
