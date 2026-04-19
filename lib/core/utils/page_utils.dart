import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

Widget _buildAppBar(BuildContext context, String title) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8, 12, 20, 8),
    child: Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 18,
          ),
        ),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    ),
  );
}
