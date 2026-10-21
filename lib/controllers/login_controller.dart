import 'package:get/get.dart';
import 'auth_controller.dart';

class LoginController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();

  RxBool get isLoading => _auth.isLoading;

  Future<void> login(String email, String password) => _auth.signIn(email, password);
}