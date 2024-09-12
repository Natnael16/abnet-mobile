part of 'media_bloc.dart';

abstract class AudioEvent extends Equatable {
  const AudioEvent();

  @override
  List<Object?> get props => [];
}

class PlayAudio extends AudioEvent {
  final String audioUrl;

  const PlayAudio(this.audioUrl);

  @override
  List<Object?> get props => [audioUrl];
}

class PauseAudio extends AudioEvent {}

class ResumeAudio extends AudioEvent {}

class SeekAudio extends AudioEvent {
  final Duration position;

  const SeekAudio(this.position);

  @override
  List<Object?> get props => [position];
}

class StopAudio extends AudioEvent {}

class UpdatePosition extends AudioEvent {
  final Duration position;

  const UpdatePosition(this.position);

  @override
  List<Object?> get props => [position];
}

class UpdatePlayerState extends AudioEvent {
  final bool isPlaying;

  const UpdatePlayerState(this.isPlaying);

  @override
  List<Object?> get props => [isPlaying];
}
