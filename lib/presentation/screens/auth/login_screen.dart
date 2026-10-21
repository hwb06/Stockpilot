import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpilot/presentation/widgets/app_button.dart';
import 'package:stockpilot/presentation/widgets/app_text_field.dart';
import '../../../controllers/login_controller.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/validators.dart';
import '../../../core/constants/app_dimensions.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  final LoginController _controller = Get.find<LoginController>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_formKey.currentState!.validate()) return;
    await _controller.login(_emailCtrl.text, _passwordCtrl.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    const Icon(
                      Icons.inventory_2_rounded,
                      size: AppDimensions.authLogoSize,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppDimensions.spaceL),
                    Text(
                      AppStrings.welcomeBack,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceS),
                    const Text(
                      AppStrings.loginSubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppDimensions.spaceXXL),
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
                      textInputAction: TextInputAction.done,
                      validator: Validators.password,
                      onSubmitted: _submit,
                    ),
                    const SizedBox(height: AppDimensions.spaceXL),
                    Obx(() => AppButton(
                      label: AppStrings.logIn,
                      isLoading: _controller.isLoading.value,
                      onPressed: _submit,
                    )),
                    const SizedBox(height: AppDimensions.spaceL),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(AppStrings.noAccountPrompt),
                        TextButton(
                          onPressed: () => Get.toNamed(AppRoutes.register),
                          child: const Text(AppStrings.register),
                        ),
                      ],
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