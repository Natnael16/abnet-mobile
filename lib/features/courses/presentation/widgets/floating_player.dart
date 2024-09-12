import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/media/media_bloc.dart';

class FloatingAudioPlayer extends StatefulWidget {
  @override
  _FloatingAudioPlayerState createState() => _FloatingAudioPlayerState();
}

class _FloatingAudioPlayerState extends State<FloatingAudioPlayer> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, audioState) {
        if (audioState.currentAudioUrl == null) {
          return const SizedBox.shrink();
        }

        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: _isExpanded
                ? MediaQuery.of(context).size.height * 0.9
                : MediaQuery.of(context).size.height *
                    0.25, // Collapsed height with just the player controls
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10, spreadRadius: 3),
              ],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Expand/Collapse control row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isExpanded ? Icons.expand_more : Icons.expand_less,
                      ),
                      onPressed: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        context.read<AudioBloc>().add(StopAudio());
                      },
                    ),
                  ],
                ),
                  Column(
                    mainAxisAlignment: _isExpanded
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.center,
                    children: [
                      if (_isExpanded)
                        Center(
                          child: Placeholder(
                            fallbackHeight: 150,
                            fallbackWidth: 150,
                          ), // Image placeholder when expanded
                        ),
                      // Text(
                      //   audioState.isPlaying
                      //       ? 'Playing: ${audioState.currentAudioUrl}'
                      //       : 'Paused: ${audioState.currentAudioUrl}',
                      // ),
                      const SizedBox(height: 10),
                      // Slider and controls (always visible)
                      Slider(
                        value:
                            audioState.currentDuration.inSeconds.toDouble(),
                        min: 0,
                        max: audioState.totalDuration.inSeconds.toDouble(),
                        onChanged: (value) {
                          context.read<AudioBloc>().add(
                              SeekAudio(Duration(seconds: value.toInt())));
                        },
                      ),
                      Text(
                        '${_formatDuration(audioState.currentDuration)} / ${_formatDuration(audioState.totalDuration)}',
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              audioState.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 30,
                            ),
                            onPressed: () {
                              if (audioState.isPlaying) {
                                context.read<AudioBloc>().add(PauseAudio());
                              } else {
                                context.read<AudioBloc>().add(ResumeAudio());
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
