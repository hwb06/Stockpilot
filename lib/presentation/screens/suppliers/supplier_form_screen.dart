import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/supplier_form_controller.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/string_extension.dart';
import '../../../core/utils/validators.dart';
import '../../../data/models/supplier_model.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class SupplierFormScreen extends StatefulWidget {
  const SupplierFormScreen({super.key});

  @override
  State<SupplierFormScreen> createState() => _SupplierFormScreenState();
}

class _SupplierFormScreenState extends State<SupplierFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final SupplierFormController _c = Get.find<SupplierFormController>();

  late final _name = TextEditingController(text: _c.editing?.name);
  late final _phone = TextEditingController(text: _c.editing?.phone);
  late final _email = TextEditingController(text: _c.editing?.email);
  late final _address = TextEditingController(text: _c.editing?.address);

  @override
  void dispose() {
    for (final c in [_name, _phone, _email, _address]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;

    await _c.save(
      SupplierModel(
        id: _c.editing?.id ?? '',
        name: _name.text.trim(),
        phone: _phone.text.nullIfBlank,
        email: _email.text.nullIfBlank,
        address: _address.text.nullIfBlank,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_c.isEdit ? AppStrings.editSupplier : AppStrings.newSupplier),
      ),
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
                    AppTextField(
                      controller: _name,
                      label: AppStrings.fieldSupplierName,
                      icon: Icons.business_outlined,
                      textCapitalization: TextCapitalization.words,
                      validator: (v) =>
                          Validators.required(v, AppStrings.fieldSupplierName),
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                    AppTextField(
                      controller: _phone,
                      label: AppStrings.fieldPhone,
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: Validators.optionalPhone,
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                    AppTextField(
                      controller: _email,
                      label: AppStrings.fieldEmail,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.optionalEmail,
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                    AppTextField(
                      controller: _address,
                      label: AppStrings.fieldAddress,
                      icon: Icons.location_on_outlined,
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
}