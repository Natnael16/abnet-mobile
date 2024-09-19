import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/colors.dart';
import '../../data/models/media.dart';
import 'package:abnet_mobile/core/utils/images.dart';
import 'package:rxdart/rxdart.dart';

class MediaPlayerPage extends StatefulWidget {
  final Media media;

  const MediaPlayerPage({super.key, required this.media});

  @override
  MediaPlayerPageState createState() => MediaPlayerPageState();
}

class MediaPlayerPageState extends State<MediaPlayerPage> {
  late AudioPlayer _audioPlayer;
  late Stream<DurationState> _durationState;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Load audio and configure background audio handling
    _audioPlayer.setAudioSource(
        AudioSource.uri(Uri.parse(widget.media.audioUrl ?? '')));

    // Initialize streams for duration, position, and buffered position
    _durationState =
        Rx.combineLatest3<Duration, Duration, Duration?, DurationState>(
      _audioPlayer.positionStream,
      _audioPlayer.bufferedPositionStream,
      _audioPlayer.durationStream,
      (position, bufferedPosition, duration) => DurationState(
        progress: position,
        buffered: bufferedPosition,
        total: duration ?? Duration.zero,
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.media.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Display documentUrl if available or Lottie animation otherwise
            widget.media.documentUrl != null
                ? Image.network(widget.media.documentUrl!)
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SvgPicture.asset(
                      AppImages.diskImage,
                    ),
                  ), // Add Lottie file to assets

            const SizedBox(height: 60),

            // Progress bar
            StreamBuilder<DurationState>(
              stream: _durationState,
              builder: (context, snapshot) {
                final durationState = snapshot.data;
                final progress = durationState?.progress ?? Duration.zero;
                final buffered = durationState?.buffered ?? Duration.zero;
                final total = durationState?.total ?? Duration.zero;

                return ProgressBar(
                  progress: progress,
                  buffered: buffered,
                  total: total,
                  onSeek: _audioPlayer.seek,
                  progressBarColor: AppColors.primaryColor,
                  baseBarColor: Colors.grey[300],
                  bufferedBarColor: AppColors.primaryColor.withOpacity(0.3),
                  thumbColor: AppColors.primaryColor,
                  barHeight: 6.0,
                  thumbRadius: 8.0,
                );
              },
            ),

            const SizedBox(height: 20),

            // Audio control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                _seekButton(-10),
                _seekButton(-5),
                _playPauseButton(),
                _seekButton(5),
                _seekButton(10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Play/Pause Button
  Widget _playPauseButton() {
    return StreamBuilder<PlayerState>(
      stream: _audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final isPlaying = playerState?.playing ?? false;
        return IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
          iconSize: 50,
          onPressed: () =>
              isPlaying ? _audioPlayer.pause() : _audioPlayer.play(),
        );
      },
    );
  }

  // Seek buttons for fast forward and rewind
  Widget _seekButton(int seconds) {
    return IconButton(
      icon: Icon(
        seconds.isNegative ? seconds.abs() == 5 ?  Icons.replay_5_rounded : Icons.replay_10_rounded :  seconds.abs() == 5 ? Icons.forward_5_rounded : Icons.forward_10_rounded,
        size: 40,
      ),
      onPressed: () => _audioPlayer.seek(
        _audioPlayer.position + Duration(seconds: seconds),
      ),
    );
  }
}

// Custom class for managing progress bar duration states
class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    required this.total,
  });

  final Duration progress;
  final Duration buffered;
  final Duration total;
}
