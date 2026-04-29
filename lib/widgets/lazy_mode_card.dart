// lib/widgets/lazy_mode_card.dart

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class LazyModeCard extends StatelessWidget {
  final bool isOn;
  final ValueChanged<bool> onToggle;

  const LazyModeCard({super.key, required this.isOn, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final qc = context.qc;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        gradient: isOn
            ? LinearGradient(
                colors: [
                  AppColors.noCookTeal.withOpacity(0.25),
                  AppColors.noCookTeal.withOpacity(0.08),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: isOn ? null : qc.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isOn
              ? AppColors.noCookTeal.withOpacity(0.5)
              : qc.divider,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.isDark
                ? Colors.black.withOpacity(0.25)
                : AppColors.orange.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '😴',
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lazy Mode',
                  style: TextStyle(
                    color: isOn ? AppColors.noCookTeal : qc.text1,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isOn
                      ? 'Showing quick and easy meals under 15 mins'
                      : "Fast, simple meals with minimal effort",
                  style: TextStyle(
                    color: isOn
                        ? AppColors.noCookTeal.withOpacity(0.8)
                        : qc.text3,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: isOn, onChanged: onToggle),
        ],
      ),
    );
  }
}
