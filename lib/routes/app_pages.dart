import 'package:get/get.dart';
import 'package:stockpilot/bindings/adjust_stock_binding.dart';
import 'package:stockpilot/bindings/po_detail_binding.dart';
import 'package:stockpilot/bindings/po_form_binding.dart';
import 'package:stockpilot/presentation/screens/auth/splash_screen.dart';
import 'package:stockpilot/presentation/screens/history/adjust_stock_screen.dart';
import 'package:stockpilot/presentation/screens/orders/po_detail_screen.dart';
import 'package:stockpilot/presentation/screens/orders/po_form_screen.dart';
import '../bindings/auth_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/product_form_binding.dart';
import '../bindings/splash_binding.dart';
import '../core/constants/app_routes.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/products/product_form_screen.dart';
import '../bindings/supplier_form_binding.dart';
import '../presentation/screens/suppliers/supplier_form_screen.dart';


class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterScreen(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.productForm,
      page: () => const ProductFormScreen(),
      binding: ProductFormBinding(),
    ),
    GetPage(
      name: AppRoutes.supplierForm,
      page: () => const SupplierFormScreen(),
      binding: SupplierFormBinding(),
    ),
    GetPage(
      name: AppRoutes.poForm,
      page: () => const PoFormScreen(),
      binding: PoFormBinding(),
    ),
    GetPage(
      name: AppRoutes.poDetail,
      page: () => const PoDetailScreen(),
      binding: PoDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.adjustStock,
      page: () => const AdjustStockScreen(),
      binding: AdjustStockBinding(),
    ),
  ];
}