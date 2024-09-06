import 'package:flutter/material.dart';

import '../../../../core/utils/colors.dart';

class NavigationalButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const NavigationalButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.defaultGrey,
          borderRadius: BorderRadius.circular(8), 
          
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textBlack,
              ),
            ),
             Icon(
              Icons.chevron_right, 
              color: Colors.grey[400],
           
            ),
          ],
        ),
      ),
    );
  }
}
