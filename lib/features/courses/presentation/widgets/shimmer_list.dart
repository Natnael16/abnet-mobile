import 'package:flutter/material.dart';
import '../../../../core/shared_widgets/shimmer.dart';
import '../../../../core/utils/colors.dart';

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 18, 
      itemBuilder: (context, index) {
        return  Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.defaultGrey, // Background color
            borderRadius: BorderRadius.circular(8), // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // Shadow color
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // Shadow position
              ),
            ],
          ),
          child: const ShimmerWidget(
              height: 60), 
        );
      },
    );
  }
}
