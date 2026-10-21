import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/stock_movement_model.dart';
import 'app_network_image.dart';
import 'label_chip.dart';

class MovementCard extends StatelessWidget {
  const MovementCard({super.key, required this.movement});

  final StockMovementModel movement;

  @override
  Widget build(BuildContext context) {
    final color = movement.isIncrease ? AppColors.success : AppColors.danger;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceM),
        child: Row(
          children: [
            AppNetworkImage(url: movement.imageUrl, size: AppDimensions.avatarSize),
            const SizedBox(width: AppDimensions.spaceM),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movement.productName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: AppDimensions.fontSubtitle,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXS),
                  Wrap(
                    spacing: AppDimensions.spaceS,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      LabelChip(label: movement.type.label, color: movement.type.color),
                      Text(
                        Formatters.dateTime(movement.createdAt),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppDimensions.fontCaption,
                        ),
                      ),
                    ],
                  ),
                  if (movement.note != null) ...[
                    const SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      movement.note!,
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
            const SizedBox(width: AppDimensions.spaceS),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppStrings.signedQuantity(movement.quantityChange),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: AppDimensions.fontHeading,
                  ),
                ),
                Text(
                  AppStrings.stockAfterLabel(movement.stockAfter),
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: AppDimensions.fontCaption),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}