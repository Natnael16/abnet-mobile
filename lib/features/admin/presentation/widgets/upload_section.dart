// Reusable upload section
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget uploadSection(String title, VoidCallback onPickFile, String? fileName,
    List<String> types) {
  final acceptedTypes = types.join(', ');
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 1.h),
      GestureDetector(
        onTap: onPickFile,
        child: Container(
          height: 25.h,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_circle_outline, size: 8.h, color: Colors.grey),
                SizedBox(height: 2.h),
                Text(
                  fileName ?? 'Drag and drop a $acceptedTypes file',
                  style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
