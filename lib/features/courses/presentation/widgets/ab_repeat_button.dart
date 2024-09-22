import 'package:flutter/material.dart';

import '../../../../core/utils/colors.dart';

String _formatDuration(Duration? duration) {
  if (duration == null) return '00:00';
  final minutes = duration.inMinutes.toString().padLeft(2, '0');
  final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

// Individual A/B point buttons
Widget abPointButton(String label, Duration? point, VoidCallback onPressed) {
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
        style:  TextStyle(
          color: point != null ?Colors.white :Colors.black,
          fontSize: 14,
        ),
      ),
    ),
  );
}
