import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/adjust_stock_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_enums.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/string_extension.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/product_picker_sheet.dart';

class AdjustStockScreen extends StatefulWidget {
  const AdjustStockScreen({super.key});

  @override
  State<AdjustStockScreen> createState() => _AdjustStockScreenState();
}

class _AdjustStockScreenState extends State<AdjustStockScreen> {
  final _formKey = GlobalKey<FormState>();
  final AdjustStockController _c = Get.find<AdjustStockController>();
  final _quantity = TextEditingController();
  final _reason = TextEditingController();

  @override
  void dispose() {
    _quantity.dispose();
    _reason.dispose();
    super.dispose();
  }

  Future<void> _pickProduct() async {
    FocusManager.instance.primaryFocus?.unfocus();
    final picked = await ProductPickerSheet.show(_c.searchProducts);
    if (picked != null) _c.product.value = picked;
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;
    await _c.save(note: _reason.text.nullIfBlank);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.adjustStockTitle)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.pagePadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppDimensions.formMaxWidth),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildProductCard(),
                    const SizedBox(height: AppDimensions.spaceXL),
                    Obx(
                          () => SegmentedButton<AdjustDirection>(
                        segments: [
                          for (final d in AdjustDirection.values)
                            ButtonSegment(value: d, label: Text(d.label)),
                        ],
                        selected: {_c.direction.value},
                        onSelectionChanged: (s) => _c.direction.value = s.first,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                    AppTextField(
                      controller: _quantity,
                      label: AppStrings.fieldAdjustQty,
                      icon: Icons.numbers,
                      keyboardType: TextInputType.number,
                      inputFormatters: InputFormatters.digitsOnly,
                      validator: (v) =>
                          Validators.positiveInt(v, AppStrings.fieldAdjustQty),
                      onChanged: _c.setQuantity,
                    ),
                    Obx(() {
                      final preview = _c.newStock;
                      if (preview == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: AppDimensions.spaceS),
                        child: Text(
                          AppStrings.newStockLabel(preview),
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: preview < 0 ? AppColors.danger : AppColors.primary,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: AppDimensions.spaceL),
                    AppTextField(
                      controller: _reason,
                      label: AppStrings.fieldReason,
                      icon: Icons.notes,
                      maxLines: 2,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: AppDimensions.spaceXL),
                    Obx(
                          () => AppButton(
                        label: AppStrings.save,
                        isLoading: _c.isSaving.value,
                        onPressed: _submit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard() {
    return Obx(() {
      final product = _c.product.value;

      return InkWell(
        onTap: _pickProduct,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spaceM),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            border: Border.all(color: AppColors.border),
          ),
          child: product == null
              ? const Row(
            children: [
              Icon(Icons.inventory_2_outlined, color: AppColors.textSecondary),
              SizedBox(width: AppDimensions.spaceM),
              Expanded(
                child: Text(
                  AppStrings.selectProduct,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          )
              : Row(
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
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      AppStrings.currentStockLabel(product.stockQty),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: AppDimensions.fontLabel,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: _pickProduct,
                child: const Text(AppStrings.changeProduct),
              ),
            ],
          ),
        ),
      );
    });
  }
}