import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../courses/data/models/course.dart';
import '../../../courses/data/models/topic.dart';

Widget dropdownField(String label, dynamic selectedItem, List<dynamic> items,
    ValueChanged<dynamic> onChanged, VoidCallback onAddNew) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 1.h),
      Row(
        children: [
          Expanded(
            child: DropdownButton<dynamic>(
              value:  selectedItem,
              isExpanded: true,
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<dynamic>>((dynamic value) {
                return DropdownMenuItem<dynamic>(
                  value: value,
                  child: (value is Topic || value is Course)
                      ? Text(
                          value.title ?? '')
                      : Text(value?.name ?? ''),
                );
              }).toList(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, size: 24.sp),
            onPressed: onAddNew,
          ),
        ],
      ),
    ],
  );
}
