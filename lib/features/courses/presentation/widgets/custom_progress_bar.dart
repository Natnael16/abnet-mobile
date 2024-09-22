import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../../../../core/utils/colors.dart';
import '../../data/models/duration_state.dart';

class CustomProgressBar extends StatelessWidget {
  final Stream<DurationState> durationStateStream;
  final Function(Duration) onSeek;

  // Optional parameters with default values
  final Color progressBarColor;
  final Color baseBarColor;
  final Color? bufferedBarColor;
  final Color thumbColor;
  final double barHeight;
  final double thumbRadius;

  const CustomProgressBar({
    super.key,
    required this.durationStateStream,
    required this.onSeek,
    this.progressBarColor = AppColors.primaryColor, // Default color
    this.baseBarColor = const Color.fromARGB(255, 218, 218, 218), // Default base color
    this.bufferedBarColor, // Default buffered color
    this.thumbColor = AppColors.primaryColor, // Default thumb color
    this.barHeight = 6.0, // Default bar height
    this.thumbRadius = 8.0, // Default thumb radius
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DurationState>(
      stream: durationStateStream,
      builder: (context, snapshot) {
        final durationState = snapshot.data;
        final progress = durationState?.progress ?? Duration.zero;
        final buffered = durationState?.buffered ?? Duration.zero;
        final total = durationState?.total ?? Duration.zero;

        return ProgressBar(
          progress: progress,
          buffered: buffered,
          total: total,
          onSeek: onSeek,
          progressBarColor: progressBarColor,
          baseBarColor: baseBarColor,
          bufferedBarColor: bufferedBarColor ?? AppColors.primaryColor.withOpacity(0.3),
          thumbColor: thumbColor,
          barHeight: barHeight,
          thumbRadius: thumbRadius,
        );
      },
    );
  }
}
