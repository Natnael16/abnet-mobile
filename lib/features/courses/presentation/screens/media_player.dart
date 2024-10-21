import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../core/shared_widgets/custom_back_button.dart';
import '../../../../core/utils/colors.dart';
import '../../data/datasource/stream_and_cache_audio.dart';
import '../../data/models/duration_state.dart';
import '../../data/models/media.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import '../widgets/ab_repeat_button.dart';
import '../widgets/custom_progress_bar.dart';
import '../widgets/media_document_viewer.dart';
import '../widgets/speed_dropdown.dart';

class MediaPlayerPage extends StatefulWidget {
  final Media media;

  const MediaPlayerPage({super.key, required this.media});

  @override
  MediaPlayerPageState createState() => MediaPlayerPageState();
}

class MediaPlayerPageState extends State<MediaPlayerPage> {
  late AudioPlayer _audioPlayer;
  late Stream<DurationState> _durationState;
  bool _isLooping = true;
  bool _isABRepeat = false; // Default to not A-B repeating
  Duration? _aPoint;
  Duration? _bPoint;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setLoopMode(LoopMode.all);
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
    final artUri = await getArtUri();
    var cacheBox = Hive.box('audioCache');
    String cacheKey = widget.media.audioUrl ?? '';
    String? cachedFilePath = cacheBox.get(cacheKey);

    if (cachedFilePath != null && await File(cachedFilePath).exists()) {
      await _audioPlayer.setAudioSource(AudioSource.uri(
        Uri.file(cachedFilePath),
        tag: MediaItem(
          title: widget.media.title,
          id: widget.media.id.toString(),
          artUri: widget.media.documentUrl != null &&
                  widget.media.documentUrl!.isNotEmpty
              ? Uri.parse(widget.media.documentUrl!)
              : artUri,
        ),
      ));
    } else {
      // Play from the network
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
      // Save streamed data in the background
      streamAndCacheAudio(widget.media);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.media.title, style: const TextStyle(fontSize: 20)),
        leading: const CustomBackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildMediaImage(context, widget.media),
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
                          speedControlButton(
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    _audioPlayer.setSpeed(value);
                                  });
                                }
                              },
                              audioPlayer: _audioPlayer),
                        ],
                      ),
                      _aBControls(), // A and B point controls
                    ],
                  ),
                ),
                CustomProgressBar(
                  durationStateStream: _durationState,
                  onSeek: (duration) {
                    _audioPlayer.seek(duration);
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
                const SizedBox(height: 10),
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
        return CircleAvatar(
          maxRadius: 24,
          backgroundColor: AppColors.black,
          child: GestureDetector(
            onTap: () => isPlaying ? _audioPlayer.pause() : _audioPlayer.play(),
            child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: AppColors.white,
                size: 40),
          ),
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
        abPointButton("ጀምር", _aPoint, () {
          setState(() {
            _setA();
          });
        }),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("--"),
        ),
        abPointButton("ጨርስ", _bPoint, () {
          setState(() {
            _setB();
          });
        }),
      ],
    );
  }

  // Set Point A for A-B repeat
  void _setA() {
    _aPoint = _audioPlayer.position;
    if (_bPoint != null && _aPoint!.compareTo(_bPoint!) >= 0) {
      _aPoint = null;
    } else {
      _isABRepeat = true;
    }
  }

  void _setB() {
    _bPoint = _audioPlayer.position;
    if (_aPoint != null && _bPoint!.compareTo(_aPoint!) <= 0) {
      _bPoint = null;
    } else {
      _isABRepeat = true;
    }
  }
}
