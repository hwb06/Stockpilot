import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpilot/presentation/widgets/app_button.dart';
import 'package:stockpilot/presentation/widgets/app_text_field.dart';
import '../../../controllers/register_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  final RegisterController _controller = Get.find<RegisterController>();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;
    await _controller.register(_nameCtrl.text, _emailCtrl.text, _passwordCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spaceXL),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: AppDimensions.authMaxWidth),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      AppStrings.createAccountTitle,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceS),
                    const Text(
                      AppStrings.registerSubtitle,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppDimensions.spaceXXL),
                    AppTextField(
                      controller: _nameCtrl,
                      label: AppStrings.authFullName,
                      icon: Icons.person_outline,
                      validator: (v) => Validators.required(v, AppStrings.authFullName),
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                    AppTextField(
                      controller: _emailCtrl,
                      label: AppStrings.authEmail,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.email,
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                    AppTextField(
                      controller: _passwordCtrl,
                      label: AppStrings.authPassword,
                      icon: Icons.lock_outline,
                      isPassword: true,
                      validator: Validators.password,
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                    AppTextField(
                      controller: _confirmCtrl,
                      label: AppStrings.authConfirmPassword,
                      icon: Icons.lock_outline,
                      isPassword: true,
                      textInputAction: TextInputAction.done,
                      validator: Validators.confirmPassword(_passwordCtrl),
                      onSubmitted: _submit,
                    ),
                    const SizedBox(height: AppDimensions.spaceXL),
                    Obx(() => AppButton(
                      label: AppStrings.createAccountButton,
                      isLoading: _controller.isLoading.value,
                      onPressed: _submit,
                    )),
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