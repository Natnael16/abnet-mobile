import 'package:flutter/material.dart';
import '../../../../core/utils/colors.dart';

class NavigationalButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final String searchQuery; // New parameter for the search query
  final Widget? suffix;

  NavigationalButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.searchQuery = '', // Default to empty string
    this.suffix,
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
            RichText(
              text: TextSpan(
                children: _getHighlightedText(title, searchQuery),
              ),
            ),
            suffix ??
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
          ],
        ),
      ),
    );
  }

  // Method to get the highlighted text as a list of TextSpan
  List<TextSpan> _getHighlightedText(String title, String query) {
    if (query.isEmpty) {
      return [
        TextSpan(
            text: title,
            style: const TextStyle(fontSize: 16, color: AppColors.textBlack))
      ];
    }

    final List<TextSpan> spans = [];
    final RegExp regExp = RegExp('($query)', caseSensitive: false);
    final Iterable<Match> matches = regExp.allMatches(title);

    int lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(TextSpan(
            text: title.substring(lastMatchEnd, match.start),
            style: const TextStyle(fontSize: 16, color: AppColors.textBlack)));
      }
      spans.add(TextSpan(
          text: match.group(0),
          style: const TextStyle(
              color: AppColors.primaryColor,fontSize:16, fontWeight: FontWeight.bold)));
      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < title.length) {
      spans.add(TextSpan(
          text: title.substring(lastMatchEnd),
          style: const TextStyle(fontSize: 16, color: AppColors.textBlack)));
    }

    return spans;
  }
}
