import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/colors.dart';

class ShimmerWidget extends StatelessWidget {
  final double? height;
  final double? width;

  const ShimmerWidget({super.key, this.height, this.width});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        color: AppColors.defaultGrey,
      ),
    );
  }
}
