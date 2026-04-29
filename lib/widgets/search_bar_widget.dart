// lib/widgets/search_bar_widget.dart

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class QCSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;
  final VoidCallback? onFilterTap;

  const QCSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.hint = 'Search recipes…',
    this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    final qc = context.qc;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: qc.input,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.isDark
                ? Colors.black.withOpacity(0.3)
                : AppColors.orange.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(Icons.search, color: AppColors.orange, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: TextStyle(
                color: qc.text1,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: qc.text3),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          if (onFilterTap != null)
            GestureDetector(
              onTap: onFilterTap,
              child: Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.only(right: 6),
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
