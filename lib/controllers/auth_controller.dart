import 'dart:async';
import 'package:get/get.dart';
import '../core/constants/app_routes.dart';
import '../core/errors/app_exception.dart';
import '../core/utils/app_snackbar.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';
import '../presentation/widgets/confirm_dialog.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_values.dart';

class AuthController extends GetxController {
  AuthController(this._repo);

  final AuthRepository _repo;

  final Rxn<UserModel> user = Rxn<UserModel>();
  final isLoading = false.obs;

  StreamSubscription<UserModel?>? _sub;
  bool _suppressRedirect = false;

  @override
  void onInit() {
    super.onInit();
    user.value = _repo.currentUser;

    _sub = _repo.userChanges.listen((u) {
      final wasLoggedIn = user.value != null;
      user.value = u;
      if (wasLoggedIn && u == null && !_suppressRedirect) {
        Get.offAllNamed(AppRoutes.login);
      }
    });
  }

  bool get isLoggedIn => _repo.hasSession;

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    try {
      await _repo.signIn(email: email.trim(), password: password);
      Get.offAllNamed(AppRoutes.home);
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String fullName, String email, String password) async {
    isLoading.value = true;
    _suppressRedirect = true;
    try {
      await _repo.signUp(
        fullName: fullName.trim(),
        email: email.trim(),
        password: password,
      );
      Get.offAllNamed(AppRoutes.login);
      AppSnackbar.success(AppStrings.accountCreated);
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isLoading.value = false;
      Future.delayed(AppValues.signupRedirectGuard, () {
        _suppressRedirect = false;
      });
    }
  }

  Future<void> confirmSignOut() async {
    final confirmed = await ConfirmDialog.show(
      title: AppStrings.logoutTitle,
      message: AppStrings.logoutMessage,
      confirmText: AppStrings.yes,
      cancelText: AppStrings.no,
    );
    if (!confirmed) return;

    try {
      await _repo.signOut();
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    }
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }
}
