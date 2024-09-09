import 'package:flutter/material.dart';

import '../utils/colors.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final double borderRadius;

  const SearchTextField({
    super.key,
    required this.controller,
    this.hintText = "ፈልግ ...",
    this.prefixIcon,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),

      decoration: BoxDecoration(
        color: AppColors.defaultGrey,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: prefixIcon ?? const Icon(Icons.search, color: AppColors.primaryColor),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
