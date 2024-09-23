import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/images.dart';
import 'custom_round_button.dart';

class NoDataReload extends StatelessWidget {
  final void Function()? onPressed;
  final double? height;
  final double? width;

  const NoDataReload(
      {super.key, required this.onPressed, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 3.h),
        SvgPicture.asset(
          AppImages.noDataImage,
          height: height ?? 25.h,
          width: width ?? 10.h,
        ),
        SizedBox(height: 3.h),
        Text('ምንም ማግኘት አልተቻለም ', style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(height: 3.h),
        CustomRoundButton(buttonText: "እንደገና ይሞክሩ", onPressed: onPressed)
      ],
    );
  }
}
