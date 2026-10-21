import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_strings.dart';
import '../constants/app_values.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(String message) =>
      _show(AppStrings.snackSuccessTitle, message, AppColors.success);

  static void error(String message) =>
      _show(AppStrings.snackErrorTitle, message, AppColors.danger);

  static void _show(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: AppColors.onPrimary,
      margin: const EdgeInsets.all(AppDimensions.spaceL),
      borderRadius: AppDimensions.radiusM,
      duration: AppValues.snackbarDuration,
    );
  }
}
