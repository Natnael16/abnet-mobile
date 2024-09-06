import 'package:flutter/material.dart';

import '../../../../core/utils/colors.dart';

class IntroText extends StatelessWidget {
  const IntroText({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
       width: MediaQuery.sizeOf(context).width - 50,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 2,color: AppColors.defaultGrey),
          ),
        ),
        child: Text(title,style: const TextStyle(fontWeight:FontWeight.bold)));
  }
}
