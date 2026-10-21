import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/category_repository.dart';
import 'data/repositories/dashboard_repository.dart';
import 'data/repositories/product_repository.dart';
import 'data/repositories/purchase_order_repository.dart';
import 'data/repositories/stock_movement_repository.dart';
import 'data/repositories/supplier_repository.dart';
import 'services/storage_service.dart';
import 'services/supabase_service.dart';

class InjectionContainer extends Bindings {
  @override
  void dependencies() {
    // Services
    Get.put<SupabaseService>(SupabaseService(), permanent: true);
    Get.put<StorageService>(StorageService(Get.find()), permanent: true);

    // Repositories
    Get.put<AuthRepository>(AuthRepository(Get.find()), permanent: true);
    Get.put<CategoryRepository>(CategoryRepository(Get.find()), permanent: true);
    Get.put<ProductRepository>(
      ProductRepository(Get.find(), Get.find()),
      permanent: true,
    );
    Get.put<SupplierRepository>(SupplierRepository(Get.find()), permanent: true);
    Get.put<PurchaseOrderRepository>(
      PurchaseOrderRepository(Get.find()),
      permanent: true,
    );
    Get.put<StockMovementRepository>(
      StockMovementRepository(Get.find()),
      permanent: true,
    );
    // Depends on Product + StockMovement repositories, so it comes after them.
    Get.put<DashboardRepository>(
      DashboardRepository(Get.find(), Get.find(), Get.find()),
      permanent: true,
    );

    // Global controllers
    Get.put<AuthController>(AuthController(Get.find()), permanent: true);
  }
}
