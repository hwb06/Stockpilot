import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/po_form_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/string_extension.dart';
import '../../../core/utils/formatters.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/line_item_tile.dart';
import '../../widgets/product_picker_sheet.dart';

class PoFormScreen extends StatefulWidget {
  const PoFormScreen({super.key});

  @override
  State<PoFormScreen> createState() => _PoFormScreenState();
}

class _PoFormScreenState extends State<PoFormScreen> {
  final PoFormController _c = Get.find<PoFormController>();
  final _notes = TextEditingController();

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _addItem() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final product = await ProductPickerSheet.show(_c.searchProducts);
    if (product != null) _c.addProduct(product);
  }

  Future<void> _submit(PoStatus status) {
    FocusManager.instance.primaryFocus?.unfocus();
    return _c.submit(status: status, notes: _notes.text.nullIfBlank);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.newPurchaseOrder)),
      bottomNavigationBar: _buildBottomBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.pagePadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppDimensions.formMaxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildSupplier(),
                  const SizedBox(height: AppDimensions.spaceXL),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          AppStrings.itemsTitle,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppDimensions.fontLarge),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _addItem,
                        icon: const Icon(Icons.add),
                        label: const Text(AppStrings.addItem),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spaceS),
                  _buildLines(),
                  const SizedBox(height: AppDimensions.spaceXL),
                  AppTextField(
                    controller: _notes,
                    label: AppStrings.fieldNotes,
                    icon: Icons.notes,
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupplier() {
    return Obx(() {
      if (!_c.isLoadingSuppliers.value && _c.suppliers.isEmpty) {
        return const Text(
          AppStrings.noSuppliersHint,
          style: TextStyle(color: AppColors.textSecondary),
        );
      }

      final selected = _c.selectedSupplierId.value;
      final exists = _c.suppliers.any((s) => s.id == selected);
      final safeValue = exists ? selected : null;

      return DropdownButtonFormField<String>(
        key: ValueKey(safeValue),
        value: safeValue,
        isExpanded: true,
        decoration: const InputDecoration(
          labelText: AppStrings.fieldSupplier,
          prefixIcon: Icon(Icons.local_shipping_outlined),
        ),
        items: [
          for (final supplier in _c.suppliers)
            DropdownMenuItem<String>(
              value: supplier.id,
              child: Text(supplier.name, overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: (value) => _c.selectedSupplierId.value = value,
      );
    });
  }

  Widget _buildLines() {
    return Obx(() {
      if (_c.lines.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(AppDimensions.spaceXL),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(color: AppColors.border),
          ),
          child: const Center(
            child: Text(
              AppStrings.noItemsYet,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        );
      }

      return Column(
        children: [
          for (var i = 0; i < _c.lines.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spaceM),
              child: LineItemTile(
                key: ValueKey(_c.lines[i].product.id),
                line: _c.lines[i],
                onQuantityChanged: (q) => _c.setQuantity(i, q),
                onCostChanged: (v) => _c.setUnitCost(i, v),
                onRemove: () => _c.removeLine(i),
              ),
            ),
        ],
      );
    });
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.pagePadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Obx(
                    () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      AppStrings.totalLabel,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: AppDimensions.fontTitle),
                    ),
                    Text(
                      Formatters.currency(_c.total),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppDimensions.fontLarge,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceM),
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      final saving = _c.savingAs.value;
                      return OutlinedButton(
                        onPressed: saving == null ? () => _submit(PoStatus.draft) : null,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(AppDimensions.buttonHeight),
                        ),
                        child: saving == PoStatus.draft
                            ? const SizedBox(
                          width: AppDimensions.loaderSize,
                          height: AppDimensions.loaderSize,
                          child: CircularProgressIndicator(strokeWidth: AppDimensions.loaderStroke),
                        )
                            : const Text(AppStrings.saveDraft),
                      );
                    }),
                  ),
                  const SizedBox(width: AppDimensions.spaceM),
                  Expanded(
                    child: Obx(() {
                      final saving = _c.savingAs.value;
                      return AppButton(
                        label: AppStrings.placeOrder,
                        isLoading: saving == PoStatus.ordered,
                        onPressed: () {
                          if (saving == null) _submit(PoStatus.ordered);
                        },
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}