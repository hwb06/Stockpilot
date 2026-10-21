import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/purchase_order_model.dart';
import 'status_chip.dart';
import '../../core/constants/app_values.dart';

class PoCard extends StatelessWidget {
  const PoCard({super.key, required this.order, required this.onTap});

  final PurchaseOrderModel order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final meta = [
      Formatters.date(order.orderDate),
      AppStrings.itemsCount(order.itemCount),
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
              Container(
                width: AppDimensions.statusIconSize,
                height: AppDimensions.statusIconSize,
                decoration: BoxDecoration(
                  color: order.status.color.withValues(alpha: AppValues.softAlpha),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(Icons.receipt_long, color: order.status.color),
              ),
              const SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.poNumber,
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
                      order.supplierName ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: AppDimensions.fontLabel),
                    ),
                    const SizedBox(height: AppDimensions.spaceXS),
                    Text(
                      meta,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: AppDimensions.fontCaption),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.spaceS),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    Formatters.currency(order.totalAmount),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceS),
                  StatusChip(status: order.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}