import 'package:get/get.dart';
import 'auth_controller.dart';

class RegisterController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();

  RxBool get isLoading => _auth.isLoading;

  Future<void> register(String name, String email, String password) =>
      _auth.signUp(name, email, password);
}