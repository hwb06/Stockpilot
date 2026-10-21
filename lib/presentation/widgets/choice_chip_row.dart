import 'package:flutter/material.dart';
import '../../core/constants/app_dimensions.dart';

class ChipOption {
  const ChipOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
}
class ChoiceChipRow extends StatelessWidget {
  const ChoiceChipRow({super.key, required this.options});

  final List<ChipOption> options;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.pagePadding,
          vertical: AppDimensions.spaceS,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < options.length; i++) ...[
              if (i > 0) const SizedBox(width: AppDimensions.spaceS),
              ChoiceChip(
                label: Text(options[i].label),
                selected: options[i].selected,
                onSelected: (_) => options[i].onTap(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
