import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class FloatingAudioPlayer {
  AudioPlayer? _audioPlayer;
  OverlayEntry? _overlayEntry;
  String? _currentAudioUrl;
  bool _isExpanded = true;
  bool _isLoading = false;

  void showFloatingWidget(BuildContext context, String audioUrl) async {
    // If the same audio is clicked again, do nothing
    if (_currentAudioUrl == audioUrl) return;

    // Stop and dispose the current player if necessary
    if (_audioPlayer != null) {
      if (_audioPlayer!.playing) {
        await _audioPlayer!.stop();
      }
      _audioPlayer?.dispose();
    }

    // Remove the existing overlay entry if it exists
    _overlayEntry?.remove();
    _overlayEntry = null;

    _audioPlayer = AudioPlayer();
    _currentAudioUrl = audioUrl;
    _isLoading = true;

    _audioPlayer!.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.ready) {
        _isLoading = false;
        _updateOverlay(context);
      }
    });

    await _audioPlayer!.setUrl(audioUrl);
    _audioPlayer!.play(); // Start playing the audio

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 0,
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded
                ? MediaQuery.of(context).size.height * 0.9
                : MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  spreadRadius: 5.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isExpanded ? Icons.expand_more : Icons.expand_less,
                      ),
                      onPressed: () {
                        _isExpanded = !_isExpanded;
                        _updateOverlay(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        _dispose();
                      },
                    ),
                  ],
                ),
                if (_isLoading) ...[
                  Center(child: CircularProgressIndicator()),
                ] else if (_isExpanded) ...[
                  Text('Playing: $audioUrl'),
                  SizedBox(height: 10),
                  StreamBuilder<Duration>(
                    stream: _audioPlayer!.positionStream,
                    builder: (context, snapshot) {
                      final duration = _audioPlayer?.duration ?? Duration.zero;
                      final position = snapshot.data ?? Duration.zero;

                      return Column(
                        children: [
                          Slider(
                            value: position.inSeconds.toDouble(),
                            min: 0.0,
                            max: duration.inSeconds.toDouble(),
                            onChanged: (value) {
                              _audioPlayer
                                  ?.seek(Duration(seconds: value.toInt()));
                            },
                          ),
                          Text(
                            '${_formatDuration(position)} / ${_formatDuration(duration)}',
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      _dispose();
                    },
                    child: Text('Close'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)!.insert(_overlayEntry!);
  }

  void _updateOverlay(BuildContext context) {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _dispose() {
    _audioPlayer?.dispose();
    _overlayEntry?.remove();
    _currentAudioUrl = null;
    _audioPlayer = null;
    _overlayEntry = null;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
