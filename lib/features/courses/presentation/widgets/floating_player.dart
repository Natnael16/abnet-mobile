import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/media/media_bloc.dart';

class FloatingAudioPlayer extends StatefulWidget {
  const FloatingAudioPlayer({super.key});

  @override
  FloatingAudioPlayerState createState() => FloatingAudioPlayerState();
}

class FloatingAudioPlayerState extends State<FloatingAudioPlayer> {
  bool _isExpanded = true;
  bool _isClosing = false; // To prevent re-renders during close

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioBloc, AudioState>(
      builder: (context, audioState) {
        if (audioState.currentAudioUrl == null || _isClosing) {
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
                : MediaQuery.of(context).size.height * 0.25,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black26, blurRadius: 10, spreadRadius: 3),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isExpanded ? Icons.expand_less : Icons.expand_more,
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
                        setState(() {
                          _isClosing = true; // Mark the widget as closing
                        });
                        context.read<AudioBloc>().add(StopAudio());
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: _isExpanded
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.center,
                    children: [
                      if (_isExpanded)
                        const Center(
                          child: Placeholder(
                            fallbackHeight: 150,
                            fallbackWidth: 150,
                          ), // Image placeholder when expanded
                        ),
                      if (audioState.isLoading)
                        const CircularProgressIndicator(),
                      const SizedBox(height: 10),
                      // Slider and controls (always visible)
                      Slider(
                        value: audioState.currentDuration.inSeconds.toDouble(),
                        min: 0,
                        max: audioState.totalDuration.inSeconds.toDouble(),
                        onChanged: audioState.isLoading
                            ? null
                            : (value) {
                                context.read<AudioBloc>().add(
                                      SeekAudio(
                                        Duration(seconds: value.toInt()),
                                      ),
                                    );
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
