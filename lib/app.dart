import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/constants/app_routes.dart';
import 'core/constants/app_strings.dart';
import 'core/constants/app_styles.dart';
import 'injection_container.dart';
import 'routes/app_pages.dart';

class StockPilotApp extends StatelessWidget {
  const StockPilotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppStyles.lightTheme,
      initialBinding: InjectionContainer(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}