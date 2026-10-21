import 'package:get/get.dart';
import '../controllers/po_form_controller.dart';

class PoFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PoFormController>(
          () => PoFormController(Get.find(), Get.find(), Get.find()),
    );
  }
}