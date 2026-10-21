import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/products_controller.dart';
import '../controllers/purchase_orders_controller.dart';
import '../controllers/stock_movements_controller.dart';
import '../controllers/suppliers_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<DashboardController>(
          () => DashboardController(Get.find(), Get.find(), Get.find(), Get.find()),
    );
    Get.lazyPut<ProductsController>(
          () => ProductsController(Get.find(), Get.find(), Get.find()),
    );
    Get.lazyPut<SuppliersController>(
          () => SuppliersController(Get.find(), Get.find()),
    );
    Get.lazyPut<PurchaseOrdersController>(
          () => PurchaseOrdersController(Get.find(), Get.find()),
    );
    Get.lazyPut<StockMovementsController>(
          () => StockMovementsController(Get.find(), Get.find()),
    );
  }
}
