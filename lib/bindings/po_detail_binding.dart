import 'package:get/get.dart';
import '../controllers/po_detail_controller.dart';

class PoDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PoDetailController>(() => PoDetailController(Get.find()));
  }
}