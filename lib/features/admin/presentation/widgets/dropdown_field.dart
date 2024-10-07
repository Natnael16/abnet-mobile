import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Widget dropdownField(String label, String selectedItem, List<String> items,
    ValueChanged<String?> onChanged, VoidCallback onAddNew) {
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
            child: DropdownButton<String>(
              value: selectedItem,
              isExpanded: true,
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
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
