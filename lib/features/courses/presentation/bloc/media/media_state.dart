part of 'media_bloc.dart';

class AudioState extends Equatable {
  final bool isPlaying;
  final bool isLoading;
  final String? currentAudioUrl;
  final Duration currentDuration;
  final Duration totalDuration;
  final double downloadProgress;

  const AudioState({
    required this.isPlaying,
    required this.isLoading,
    this.currentAudioUrl,
    required this.currentDuration,
    required this.totalDuration,
    this.downloadProgress = 0.0,
  });

  AudioState copyWith({
    bool? isPlaying,
    bool? isLoading,
    String? currentAudioUrl,
    Duration? currentDuration,
    Duration? totalDuration,
    double? downloadProgress,
  }) {
    return AudioState(
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      currentAudioUrl: currentAudioUrl ?? this.currentAudioUrl,
      currentDuration: currentDuration ?? this.currentDuration,
      totalDuration: totalDuration ?? this.totalDuration,
      downloadProgress: downloadProgress ?? this.downloadProgress,
    );
  }

  @override
  List<Object?> get props => [
        isPlaying,
        isLoading,
        currentAudioUrl,
        currentDuration,
        totalDuration,
        downloadProgress,
      ];
}
