// lib/widgets/ingredient_chips.dart
// ─────────────────────────────────────────────────────────────────────────────
// Allows user to type ingredients and adds them as removable chips.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class IngredientChipsInput extends StatefulWidget {
  final List<String> chips;
  final ValueChanged<List<String>> onChanged;

  const IngredientChipsInput({
    super.key,
    required this.chips,
    required this.onChanged,
  });

  @override
  State<IngredientChipsInput> createState() => _IngredientChipsInputState();
}

class _IngredientChipsInputState extends State<IngredientChipsInput> {
  final _ctrl = TextEditingController();

  void _add(String value) {
    final trimmed = value.trim().toLowerCase();
    if (trimmed.isEmpty || widget.chips.contains(trimmed)) {
      _ctrl.clear();
      return;
    }
    final updated = [...widget.chips, trimmed];
    widget.onChanged(updated);
    _ctrl.clear();
  }

  void _remove(String chip) {
    widget.onChanged(widget.chips.where((c) => c != chip).toList());
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final qc = context.qc;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Input row
        Row(
          children: [
            Expanded(
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: qc.input,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: _ctrl,
                  style: TextStyle(color: qc.text1, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Add ingredient (e.g. rice)',
                    hintStyle: TextStyle(color: qc.text3, fontSize: 13),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12,
                    ),
                    isDense: true,
                  ),
                  onSubmitted: _add,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _add(_ctrl.text),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.orange,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
        // Chips
        if (widget.chips.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: widget.chips
                .map((chip) => _IngChip(
                      label: chip,
                      onRemove: () => _remove(chip),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _IngChip extends StatelessWidget {
  final String label;
  final VoidCallback onRemove;

  const _IngChip({required this.label, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.orange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.orange.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.orange,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(Icons.close, size: 14, color: AppColors.orange),
          ),
        ],
      ),
    );
  }
}
