import 'package:get/get.dart';
import '../controllers/adjust_stock_controller.dart';

class AdjustStockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdjustStockController>(
          () => AdjustStockController(Get.find(), Get.find()),
    );
  }
}