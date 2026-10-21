import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpilot/controllers/splash_controller.dart';
import 'package:stockpilot/core/constants/app_colors.dart';
import 'package:stockpilot/core/constants/app_strings.dart';
import '../../../core/constants/app_dimensions.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.inventory_2_rounded,
              size: AppDimensions.splashLogoSize,
              color: AppColors.onPrimary,
            ),
            const SizedBox(height: AppDimensions.spaceL),
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spaceS),
            const Text(
              AppStrings.tagline,
              style: TextStyle(color: AppColors.onPrimarySoft),
            ),
            const SizedBox(height: AppDimensions.spaceXXL),
            const SizedBox(
              height: AppDimensions.splashLoaderSize,
              width: AppDimensions.splashLoaderSize,
              child: CircularProgressIndicator(
                strokeWidth: AppDimensions.loaderStroke,
                color: AppColors.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
