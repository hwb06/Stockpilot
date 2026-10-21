import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_enums.dart';
import '../../core/constants/app_strings.dart';

class RowActionsMenu extends StatelessWidget {
  const RowActionsMenu({super.key, required this.onEdit, required this.onDelete});

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<RowAction>(
      padding: EdgeInsets.zero,
      iconSize: AppDimensions.popupIconSize,
      onSelected: (action) {
        switch (action) {
          case RowAction.edit:
            onEdit();
          case RowAction.delete:
            onDelete();
        }
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: RowAction.edit, child: Text(AppStrings.edit)),
        PopupMenuItem(
          value: RowAction.delete,
          child: Text(AppStrings.delete, style: TextStyle(color: AppColors.danger)),
        ),
      ],
    );
  }
}