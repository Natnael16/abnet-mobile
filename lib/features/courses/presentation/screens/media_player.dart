import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../core/utils/colors.dart';
import '../../data/models/media.dart';
import 'package:abnet_mobile/core/utils/images.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MediaPlayerPage extends StatefulWidget {
  final Media media;

  const MediaPlayerPage({super.key, required this.media});

  @override
  MediaPlayerPageState createState() => MediaPlayerPageState();
}

class MediaPlayerPageState extends State<MediaPlayerPage> {
  late AudioPlayer _audioPlayer;
  late Stream<DurationState> _durationState;
  bool _isLooping = false; // Default to not looping
  bool _isABRepeat = false; // Default to not A-B repeating
  Duration? _aPoint;
  Duration? _bPoint;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _init();

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

    _audioPlayer.positionStream.listen((position) {
      if (_isABRepeat && _aPoint != null && _bPoint != null) {
        if (position >= _bPoint!) {
          _audioPlayer.seek(_aPoint!); // Loop back to A
        }
      }
    });
  }

  Future<void> _init() async {
    final artUri = await getArtUri(); // Get the file URI for the asset

    await _audioPlayer.setAudioSource(AudioSource.uri(
      Uri.parse(widget.media.audioUrl ?? ''),
      tag: MediaItem(
        title: widget.media.title,
        id: widget.media.id.toString(),
        artUri: widget.media.documentUrl != null &&
                widget.media.documentUrl!.isNotEmpty
            ? Uri.parse(widget.media.documentUrl!)
            : artUri,
      ),
    ));
  }

  Future<Uri> getArtUri() async {
    final ByteData data =
        await rootBundle.load('assets/images/msle_fkur_welda.jpg');
    final Directory tempDir = await getTemporaryDirectory();
    final File file = File('${tempDir.path}/msle_fkur_welda.jpg');
    await file.writeAsBytes(data.buffer.asUint8List());
    return Uri.file(file.path);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) return '00:00';
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMediaImage(),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _loopToggleButton(),
                          const SizedBox(
                            width: 20,
                          ),
                          _speedControlButton(),
                        ],
                      ),
                      _aBControls(), // A and B point controls
                    ],
                  ),
                ),
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
                      onSeek: (duration) {
                        _audioPlayer.seek(duration);
                      },
                      progressBarColor: AppColors.primaryColor,
                      baseBarColor: Colors.grey[300],
                      bufferedBarColor: AppColors.primaryColor.withOpacity(0.3),
                      thumbColor: AppColors.primaryColor,
                      barHeight: 6.0,
                      thumbRadius: 8.0,
                    );
                  },
                ),

                // Audio control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _seekButton(-5),
                    _playPauseButton(),
                    _seekButton(5),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Media Image Display
  Widget _buildMediaImage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.62,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: widget.media.documentUrl != null
                ? InteractiveViewer(
                    child: CachedNetworkImage(
                      imageUrl: widget.media.documentUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                              color: AppColors.black)),
                      errorWidget: (context, url, error) => Image.asset(
                          AppImages.msleFkurWelda,
                          fit: BoxFit.cover),
                    ),
                  )
                : InteractiveViewer(
                    child: Image.asset(AppImages.msleFkurWelda,
                        fit: BoxFit.cover)),
          ),
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
          icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              size: 40),
          color: AppColors.black,
          onPressed: () =>
              isPlaying ? _audioPlayer.pause() : _audioPlayer.play(),
        );
      },
    );
  }

  Widget _seekButton(int seconds) {
    return IconButton(
      icon: Icon(
          seconds.isNegative ? Icons.replay_5_rounded : Icons.forward_5_rounded,
          size: 30,
          color: Colors.black),
      onPressed: () {
        final duration = _audioPlayer.duration;
        if (duration != null) {
          final newPosition =
              _audioPlayer.position + Duration(seconds: seconds);
          if (newPosition >= Duration.zero && newPosition <= duration) {
            _audioPlayer.seek(newPosition);
          }
        }
      },
    );
  }

  // Toggle Loop Button
  Widget _loopToggleButton() {
    return Tooltip(
      message: "Loop Mode",
      child: GestureDetector(
        child: Icon(
          Icons.repeat_rounded,
          color: (_isLooping ? AppColors.primaryColor : Colors.grey),
        ),
        onTap: () {
          setState(() {
            _isLooping = !_isLooping;
            if (_isLooping) {
              _isABRepeat = false; // Disable A-B repeat when loop is on
              _aPoint = null;
              _bPoint = null;
            }
            _audioPlayer.setLoopMode(_isLooping ? LoopMode.all : LoopMode.off);
          });
        },
      ),
    );
  }

  // A-B Repeat Controls with clear labels
  Widget _aBControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _abPointButton("ጀምር", _aPoint, () {
          setState(() {
            _setA();
          });
        }),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("--"),
        ),
        _abPointButton("ጨርስ", _bPoint, () {
          setState(() {
            _setB();
          });
        }),
      ],
    );
  }

  // Individual A/B point buttons
  Widget _abPointButton(String label, Duration? point, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: point != null ? AppColors.primaryColor : AppColors.defaultGrey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          point != null ? _formatDuration(point) : label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  // Speed Control Dropdown
  Widget _speedControlButton() {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.defaultGrey,
          borderRadius: BorderRadius.circular(16)),
      child: Tooltip(
        message: "ፍጥነት",
        child: Center(
          child: DropdownButton<double>(
              value: _audioPlayer.speed,
              items: const [
                DropdownMenuItem(value: 0.25, child: Text("0.25x")),
                DropdownMenuItem(value: 0.5, child: Text("0.5x")),
                DropdownMenuItem(value: 1.0, child: Text("1x")),
                DropdownMenuItem(value: 1.5, child: Text("1.5x")),
                DropdownMenuItem(value: 2.0, child: Text("2x")),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _audioPlayer.setSpeed(value);
                  });
                }
              },
              icon: null,
              iconSize: 0,
              alignment: AlignmentDirectional.center,
              dropdownColor: AppColors.defaultGrey,
              isDense: true,
              padding: const EdgeInsets.all(4),
              style: const TextStyle(fontSize: 16, color: AppColors.black),
              underline: const SizedBox.shrink(),
              borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  // Set Point A for A-B repeat
  void _setA() {
    _aPoint = _audioPlayer.position;
    if (_bPoint != null && _aPoint!.compareTo(_bPoint!) >= 0) {
      _aPoint = null; // Reset A if it is greater than B
    } else {
      _isABRepeat = true;
    }
  }

  // Set Point B for A-B repeat
  void _setB() {
    _bPoint = _audioPlayer.position;
    if (_aPoint != null && _bPoint!.compareTo(_aPoint!) <= 0) {
      _bPoint = null; // Reset B if it is less than A
    } else {
      _isABRepeat = true;
    }
  }
}

class DurationState {
  final Duration progress;
  final Duration buffered;
  final Duration total;

  DurationState({
    required this.progress,
    required this.buffered,
    required this.total,
  });
}
