import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child:
          isLoading
              ? const SizedBox(
                height: AppDimensions.loaderSize,
                width: AppDimensions.loaderSize,
                child: CircularProgressIndicator(
                  strokeWidth: AppDimensions.loaderStroke,
                  color: AppColors.onPrimary,
                ),
              )
              : Text(
                label,
                style: const TextStyle(
                  fontSize: AppDimensions.fontTitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
    );
  }
}
