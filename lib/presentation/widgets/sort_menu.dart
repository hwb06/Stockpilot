import 'package:flutter/material.dart';
import '../../core/constants/app_strings.dart';

class SortMenu<T> extends StatelessWidget {
  const SortMenu({
    super.key,
    required this.options,
    required this.selected,
    required this.labelOf,
    required this.onSelected,
  });

  final List<T> options;
  final T Function() selected;
  final String Function(T option) labelOf;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      tooltip: AppStrings.sortTooltip,
      icon: const Icon(Icons.sort),
      onSelected: onSelected,
      itemBuilder: (_) => [
        for (final option in options)
          CheckedPopupMenuItem<T>(
            value: option,
            checked: selected() == option,
            child: Text(labelOf(option)),
          ),
      ],
    );
  }
}