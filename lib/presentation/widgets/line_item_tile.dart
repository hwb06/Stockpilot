import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/po_line.dart';
import 'app_network_image.dart';

class LineItemTile extends StatefulWidget {
  const LineItemTile({
    super.key,
    required this.line,
    required this.onQuantityChanged,
    required this.onCostChanged,
    required this.onRemove,
  });

  final PoLine line;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<double> onCostChanged;
  final VoidCallback onRemove;

  @override
  State<LineItemTile> createState() => _LineItemTileState();
}

class _LineItemTileState extends State<LineItemTile> {
  late final _cost = TextEditingController(
    text: Formatters.plainNumber(widget.line.unitCost),
  );

  @override
  void dispose() {
    _cost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final line = widget.line;

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
        child: Column(
          children: [
            Row(
              children: [
                AppNetworkImage(url: line.product.imageUrl, size: AppDimensions.avatarSize),
                const SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        line.product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        AppStrings.skuLabel(line.product.sku),
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: AppDimensions.fontCaption,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete_outline, color: AppColors.danger),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceM),
            Row(
              children: [
                _QuantityStepper(
                  quantity: line.quantity,
                  onChanged: widget.onQuantityChanged,
                ),
                const SizedBox(width: AppDimensions.spaceM),
                Expanded(
                  child: TextField(
                    controller: _cost,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: InputFormatters.decimal,
                    decoration: const InputDecoration(
                      labelText: AppStrings.unitCostLabel,
                      isDense: true,
                    ),
                    onChanged: (v) => widget.onCostChanged(double.tryParse(v) ?? 0),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spaceS),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${AppStrings.lineTotalLabel}: ${Formatters.currency(line.total)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  const _QuantityStepper({required this.quantity, required this.onChanged});

  final int quantity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: quantity > 1 ? () => onChanged(quantity - 1) : null,
            icon: const Icon(Icons.remove),
          ),
          Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w600)),
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () => onChanged(quantity + 1),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}