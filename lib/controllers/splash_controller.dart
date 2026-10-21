import 'package:get/get.dart';
import 'package:stockpilot/controllers/auth_controller.dart';
import 'package:stockpilot/core/constants/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _decideRoute();
  }

  Future<void> _decideRoute() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    final auth = Get.find<AuthController>();
    Get.offAllNamed(auth.isLoggedIn ? AppRoutes.home : AppRoutes.login);
  }
}
