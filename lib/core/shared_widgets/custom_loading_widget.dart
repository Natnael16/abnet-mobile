import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/colors.dart';

class CustomLoadingWidget extends StatelessWidget {
  final double size;
  final Color color;
  final double strokeWidth;
  final Duration duration;

  const CustomLoadingWidget({
    super.key,
    this.size = 50.0,
    this.color = AppColors.primaryColor,
    this.strokeWidth = 3.0,
    this.duration = const Duration(seconds: 2),
  });

  @override
  Widget build(BuildContext context) {
    return SpinKitWaveSpinner(
      color: color,
      size: size,
      duration: duration,
    );
  }
}
