import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controllers/product_form_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_values.dart';
import '../../../core/extensions/string_extension.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/text_input_dialog.dart';

class ProductFormScreen extends StatefulWidget {
  const ProductFormScreen({super.key});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ProductFormController _c = Get.find<ProductFormController>();

  late final _name = TextEditingController(text: _c.editing?.name);
  late final _sku = TextEditingController(text: _c.editing?.sku);
  late final _description = TextEditingController(
    text: _c.editing?.description,
  );
  late final _price = TextEditingController(
    text: _c.editing == null ? '' : Formatters.plainNumber(_c.editing!.price),
  );
  late final _costPrice = TextEditingController(
    text:
        _c.editing == null ? '' : Formatters.plainNumber(_c.editing!.costPrice),
  );
  late final _stock = TextEditingController(
    text: _c.editing?.stockQty.toString(),
  );
  late final _minStock = TextEditingController(
    text: (_c.editing?.minStock ?? AppValues.defaultMinStock).toString(),
  );

  @override
  void dispose() {
    for (final c in [
      _name,
      _sku,
      _description,
      _price,
      _costPrice,
      _stock,
      _minStock,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;

    await _c.save(
      name: _name.text.trim(),
      sku: _sku.text.trim(),
      description: _description.text.nullIfBlank,
      price: double.parse(_price.text.trim()),
      costPrice: double.parse(_costPrice.text.trim()),
      stockQty:
          _c.isEdit ? _c.editing!.stockQty : int.parse(_stock.text.trim()),
      minStock: int.parse(_minStock.text.trim()),
    );
  }

  Future<void> _addCategory() async {
    final name = await TextInputDialog.show(
      title: AppStrings.newCategoryTitle,
      label: AppStrings.fieldCategoryName,
    );
    if (name != null) await _c.addCategory(name);
  }

  void _showImageSheet() {
    Get.bottomSheet(
      SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text(AppStrings.takePhoto),
              onTap: () {
                Get.back();
                _c.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text(AppStrings.chooseFromGallery),
              onTap: () {
                Get.back();
                _c.pickImage(ImageSource.gallery);
              },
            ),
            if (_c.hasImage)
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: AppColors.danger,
                ),
                title: const Text(
                  AppStrings.removePhoto,
                  style: TextStyle(color: AppColors.danger),
                ),
                onTap: () {
                  Get.back();
                  _c.removeImage();
                },
              ),
          ],
        ),
      ),
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusL),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_c.isEdit ? AppStrings.editProduct : AppStrings.newProduct),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.pagePadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppDimensions.formMaxWidth,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildImage(),
                    const SizedBox(height: AppDimensions.spaceXL),
                    AppTextField(
                      controller: _name,
                      label: AppStrings.fieldName,
                      icon: Icons.label_outline,
                      textCapitalization: TextCapitalization.words,
                      validator:
                          (v) => Validators.required(v, AppStrings.fieldName),
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                    AppTextField(
                      controller: _sku,
                      label: AppStrings.fieldSku,
                      icon: Icons.qr_code_2,
                      textCapitalization: TextCapitalization.characters,
                      validator:
                          (v) => Validators.required(v, AppStrings.fieldSku),
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                    _buildCategory(),
                    const SizedBox(height: AppDimensions.spaceL),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _price,
                            label: AppStrings.fieldPrice,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: InputFormatters.decimal,
                            validator:
                                (v) => Validators.nonNegativeNumber(
                                  v,
                                  AppStrings.fieldPrice,
                                ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceM),
                        Expanded(
                          child: AppTextField(
                            controller: _costPrice,
                            label: AppStrings.fieldCostPrice,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: InputFormatters.decimal,
                            validator:
                                (v) => Validators.nonNegativeNumber(
                                  v,
                                  AppStrings.fieldCostPrice,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _stock,
                            label:
                                _c.isEdit
                                    ? AppStrings.fieldCurrentStock
                                    : AppStrings.fieldStock,
                            enabled: !_c.isEdit,
                            keyboardType: TextInputType.number,
                            inputFormatters: InputFormatters.digitsOnly,
                            validator:
                                _c.isEdit
                                    ? null
                                    : (v) => Validators.nonNegativeInt(
                                      v,
                                      AppStrings.fieldStock,
                                    ),
                          ),
                        ),
                        const SizedBox(width: AppDimensions.spaceM),
                        Expanded(
                          child: AppTextField(
                            controller: _minStock,
                            label: AppStrings.fieldMinStock,
                            keyboardType: TextInputType.number,
                            inputFormatters: InputFormatters.digitsOnly,
                            validator:
                                (v) => Validators.nonNegativeInt(
                                  v,
                                  AppStrings.fieldMinStock,
                                ),
                          ),
                        ),
                      ],
                    ),
                    if (_c.isEdit)
                      const Padding(
                        padding: EdgeInsets.only(top: AppDimensions.spaceS),
                        child: Text(
                          AppStrings.stockEditHint,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: AppDimensions.fontCaption,
                          ),
                        ),
                      ),
                    const SizedBox(height: AppDimensions.spaceL),
                    AppTextField(
                      controller: _description,
                      label: AppStrings.fieldDescription,
                      icon: Icons.notes,
                      maxLines: 3,
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

  Widget _buildImage() {
    return Obx(() {
      final bytes = _c.pickedBytes.value;
      final existingUrl =
          _c.removeExistingImage.value ? null : _c.editing?.imageUrl;

      final Widget content;
      if (bytes != null) {
        content = Image.memory(bytes, fit: BoxFit.cover);
      } else if (existingUrl != null) {
        content = AppNetworkImage(
          url: existingUrl,
          size: AppDimensions.formImageSize,
        );
      } else {
        content = const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, color: AppColors.textSecondary),
            SizedBox(height: AppDimensions.spaceS),
            Text(
              AppStrings.addPhoto,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        );
      }

      return Center(
        child: GestureDetector(
          onTap: _showImageSheet,
          child: Container(
            width: AppDimensions.formImageSize,
            height: AppDimensions.formImageSize,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: AppColors.border),
            ),
            child: content,
          ),
        ),
      );
    });
  }

  Widget _buildCategory() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Obx(() {
            final selectedId = _c.selectedCategoryId.value;
            final exists = _c.categories.any((c) => c.id == selectedId);
            final safeValue = exists ? selectedId : null;

            return DropdownButtonFormField<String>(
              key: ValueKey(safeValue),
              value: safeValue,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: AppStrings.fieldCategory,
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text(AppStrings.noCategory),
                ),
                for (final category in _c.categories)
                  DropdownMenuItem<String>(
                    value: category.id,
                    child: Text(category.name),
                  ),
              ],
              onChanged: (value) => _c.selectedCategoryId.value = value,
            );
          }),
        ),
        const SizedBox(width: AppDimensions.spaceS),
        IconButton.filledTonal(
          tooltip: AppStrings.addCategoryTooltip,
          onPressed: _addCategory,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
