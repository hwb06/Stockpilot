import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/product_model.dart';
import 'app_network_image.dart';
import 'label_chip.dart';
import 'section_card.dart';

class LowStockTile extends StatelessWidget {
  const LowStockTile({super.key, required this.product, required this.onTap});

  final ProductModel product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final out = product.isOutOfStock;
    final color = out ? AppColors.danger : AppColors.warning;
    final label = out ? AppStrings.outOfStock : AppStrings.lowStock(product.stockQty);

    return SectionCard(
      onTap: onTap,
      child: Row(
        children: [
          AppNetworkImage(url: product.imageUrl, size: AppDimensions.avatarSize),
          const SizedBox(width: AppDimensions.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
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
                  '${AppStrings.skuLabel(product.sku)}${AppStrings.separator}'
                  '${AppStrings.minStockLabel(product.minStock)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: AppDimensions.fontCaption,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spaceS),
          LabelChip(label: label, color: color),
        ],
      ),
    );
  }
}
