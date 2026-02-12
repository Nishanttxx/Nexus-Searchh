import 'package:flutter/material.dart';
import 'package:perplexity_clone/theme/colors.dart';

class SearchBarWidgets extends StatelessWidget {
  final IconData icon;
  final String text;

  const SearchBarWidgets({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.textGrey,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
