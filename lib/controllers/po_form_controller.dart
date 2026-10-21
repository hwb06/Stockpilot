import 'package:get/get.dart';
import '../core/constants/app_enums.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_values.dart';
import '../core/errors/app_exception.dart';
import '../core/utils/app_snackbar.dart';
import '../data/models/po_line.dart';
import '../data/models/product_model.dart';
import '../data/models/supplier_model.dart';
import '../data/repositories/product_repository.dart';
import '../data/repositories/purchase_order_repository.dart';
import '../data/repositories/supplier_repository.dart';

class PoFormController extends GetxController {
  PoFormController(this._orders, this._suppliers, this._products);

  final PurchaseOrderRepository _orders;
  final SupplierRepository _suppliers;
  final ProductRepository _products;

  final suppliers = <SupplierModel>[].obs;
  final isLoadingSuppliers = true.obs;
  final selectedSupplierId = RxnString();
  final lines = <PoLine>[].obs;

  final savingAs = Rxn<PoStatus>();

  double get total {
    var sum = 0.0;
    for (var i = 0; i < lines.length; i++) {
      sum += lines[i].total;
    }
    return sum;
  }

  @override
  void onInit() {
    super.onInit();
    _loadSuppliers();
  }

  Future<void> _loadSuppliers() async {
    try {
      suppliers.assignAll(await _suppliers.fetchSuppliers(
        search: '',
        sort: SupplierSort.nameAsc,
        offset: 0,
        limit: AppValues.pickerLimit,
      ));
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isLoadingSuppliers.value = false;
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      return await _products.searchForPicker(query);
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
      return [];
    }
  }

  // ---------- Lines ----------

  void addProduct(ProductModel product) {
    final index = lines.indexWhere((l) => l.product.id == product.id);
    if (index >= 0) {
      lines[index].quantity += 1;
      lines.refresh();
    } else {
      lines.add(PoLine(product: product));
    }
  }

  void setQuantity(int index, int quantity) {
    if (quantity < 1) return;
    lines[index].quantity = quantity;
    lines.refresh();
  }

  void setUnitCost(int index, double cost) {
    lines[index].unitCost = cost;
    lines.refresh();
  }

  void removeLine(int index) => lines.removeAt(index);

  // ---------- Save ----------

  Future<void> submit({required PoStatus status, String? notes}) async {
    if (savingAs.value != null) return;

    final supplierId = selectedSupplierId.value;
    if (supplierId == null) {
      AppSnackbar.error(AppStrings.errSelectSupplier);
      return;
    }
    if (lines.isEmpty) {
      AppSnackbar.error(AppStrings.errAddItems);
      return;
    }

    savingAs.value = status;
    try {
      await _orders.create(
        supplierId: supplierId,
        lines: lines.toList(),
        status: status,
        notes: notes,
      );
      Get.back(result: true);
      AppSnackbar.success(
        status == PoStatus.draft ? AppStrings.draftSaved : AppStrings.orderPlaced,
      );
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      savingAs.value = null;
    }
  }
}