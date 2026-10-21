import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/supplier_model.dart';
import 'row_actions_menu.dart';

class SupplierCard extends StatelessWidget {
  const SupplierCard({
    super.key,
    required this.supplier,
    required this.onTap,
    required this.onDelete,
  });

  final SupplierModel supplier;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final contact = [
      if (supplier.phone != null) supplier.phone!,
      if (supplier.email != null) supplier.email!,
    ].join(AppStrings.separator);

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceM),
          child: Row(
            children: [
              CircleAvatar(
                radius: AppDimensions.avatarSize / 2,
                backgroundColor: AppColors.primarySoft,
                child: Text(
                  supplier.initial,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.fontLarge,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: AppDimensions.fontTitle,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      contact.isEmpty ? AppStrings.noContactDetails : contact,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: AppDimensions.fontLabel),
                    ),
                    if (supplier.address != null) ...[
                      const SizedBox(height: AppDimensions.spaceXS),
                      Text(
                        supplier.address!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppDimensions.fontCaption,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              RowActionsMenu(onEdit: onTap, onDelete: onDelete),
            ],
          ),
        ),
      ),
    );
  }
}