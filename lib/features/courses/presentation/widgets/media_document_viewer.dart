import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/colors.dart';
import '../../../../core/utils/images.dart';
import '../../data/models/media.dart';

Widget buildMediaImage(BuildContext context,Media media) {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.66,
        width: double.infinity,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: media.documentUrl != null
              ? InteractiveViewer(
                  child: CachedNetworkImage(
                    imageUrl: media.documentUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.black)),
                    errorWidget: (context, url, error) =>
                        InteractiveViewer(child: Image.asset(AppImages.msleFkurWelda, fit: BoxFit.cover)),
                  ),
                )
              : InteractiveViewer(
                  child:
                      Image.asset(AppImages.msleFkurWelda, fit: BoxFit.cover)),
        ),
      ),
    ),
  );
}
