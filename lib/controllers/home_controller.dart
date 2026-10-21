import 'package:get/get.dart';
import '../core/constants/app_enums.dart';
import 'products_controller.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) => currentIndex.value = index;

  void openTab(HomeTab tab) => changeTab(tab.index);

  void showLowStock() {
    Get.find<ProductsController>().selectStockFilter(StockFilter.low);
    openTab(HomeTab.products);
  }
}
