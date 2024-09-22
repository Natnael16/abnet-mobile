import 'package:flutter/material.dart';

import '../../../../core/utils/colors.dart';

Widget speedControlButton({void Function(double?)? onChanged, audioPlayer}) {
  return Container(
    decoration: BoxDecoration(
        color: AppColors.defaultGrey, borderRadius: BorderRadius.circular(16)),
    child: Tooltip(
      message: "ፍጥነት",
      child: Center(
        child: DropdownButton<double>(
            value: audioPlayer.speed,
            items: const [
              DropdownMenuItem(value: 0.25, child: Text("0.25x")),
              DropdownMenuItem(value: 0.5, child: Text("0.5x")),
              DropdownMenuItem(value: 1.0, child: Text("1x")),
              DropdownMenuItem(value: 1.5, child: Text("1.5x")),
              DropdownMenuItem(value: 2.0, child: Text("2x")),
            ],
            onChanged: onChanged,
            icon: null,
            iconSize: 0,
            alignment: AlignmentDirectional.center,
            dropdownColor: AppColors.defaultGrey,
            isDense: true,
            padding: const EdgeInsets.all(4),
            style: const TextStyle(fontSize: 14, color: AppColors.black),
            underline: const SizedBox.shrink(),
            borderRadius: BorderRadius.circular(16)),
      ),
    ),
  );
}
