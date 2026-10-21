import 'package:get/get.dart';
import '../core/constants/app_enums.dart';
import '../core/constants/app_strings.dart';
import '../core/errors/app_exception.dart';
import '../core/utils/app_snackbar.dart';
import '../data/models/product_model.dart';
import '../data/repositories/product_repository.dart';
import '../data/repositories/stock_movement_repository.dart';

class AdjustStockController extends GetxController {
  AdjustStockController(this._movements, this._products);

  final StockMovementRepository _movements;
  final ProductRepository _products;

  final product = Rxn<ProductModel>();
  final direction = AdjustDirection.add.obs;
  final quantity = 0.obs;
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ProductModel) product.value = args;
  }

  int? get newStock {
    final p = product.value;
    if (p == null || quantity.value <= 0) return null;
    return p.stockQty + direction.value.sign * quantity.value;
  }

  void setQuantity(String text) => quantity.value = int.tryParse(text.trim()) ?? 0;

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      return await _products.searchForPicker(query);
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
      return [];
    }
  }

  Future<void> save({String? note}) async {
    if (isSaving.value) return;

    final selected = product.value;
    if (selected == null) {
      AppSnackbar.error(AppStrings.errSelectProduct);
      return;
    }

    final qty = quantity.value;
    if (direction.value == AdjustDirection.remove && qty > selected.stockQty) {
      AppSnackbar.error(AppStrings.errRemoveTooMuch(selected.stockQty));
      return;
    }

    isSaving.value = true;
    try {
      await _movements.adjustStock(
        productId: selected.id,
        change: direction.value.sign * qty,
        note: note,
      );
      Get.back(result: true);
      AppSnackbar.success(AppStrings.adjustSaved);
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isSaving.value = false;
    }
  }
}