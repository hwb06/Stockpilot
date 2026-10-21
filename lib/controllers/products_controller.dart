import 'package:get/get.dart';
import '../core/constants/app_db.dart';
import '../core/constants/app_enums.dart';
import '../core/constants/app_routes.dart';
import '../core/constants/app_strings.dart';
import '../core/errors/app_exception.dart';
import '../core/utils/app_snackbar.dart';
import '../data/models/category_model.dart';
import '../data/models/product_model.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/product_repository.dart';
import '../presentation/widgets/confirm_dialog.dart';
import '../services/supabase_service.dart';
import 'base/paginated_list_controller.dart';

class ProductsController extends PaginatedListController<ProductModel> {
  ProductsController(this._products, this._categories, SupabaseService supabase)
      : super(supabase);

  final ProductRepository _products;
  final CategoryRepository _categories;

  // Filters
  final categories = <CategoryModel>[].obs;
  final selectedCategoryId = RxnString();
  final stockFilter = StockFilter.all.obs;
  final sort = ProductSort.newest.obs;

  @override
  String get tableName => AppDb.products;

  @override
  String get channelName => AppDb.productsChannel;

  @override
  String idOf(ProductModel item) => item.id;

  @override
  bool get hasActiveFilters =>
      super.hasActiveFilters ||
          selectedCategoryId.value != null ||
          stockFilter.value != StockFilter.all;

  @override
  Future<List<ProductModel>> fetchPage({required int offset, required int limit}) {
    return _products.fetchProducts(
      search: query.value,
      categoryId: selectedCategoryId.value,
      stock: stockFilter.value,
      sort: sort.value,
      offset: offset,
      limit: limit,
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  @override
  Future<void> onPullToRefresh() async {
    await Future.wait([loadCategories(), super.onPullToRefresh()]);
  }

  Future<void> loadCategories() async {
    try {
      categories.assignAll(await _categories.fetchAll());
    } on AppException {
    }
  }

  // ---------- Filters ----------

  void selectCategory(String? id) {
    if (selectedCategoryId.value == id) return;
    selectedCategoryId.value = id;
    load();
  }

  void selectStockFilter(StockFilter filter) {
    if (stockFilter.value == filter) return;
    stockFilter.value = filter;
    load();
  }

  void selectSort(ProductSort value) {
    if (sort.value == value) return;
    sort.value = value;
    load();
  }

  // ---------- Actions ----------

  Future<void> openForm([ProductModel? product]) async {
    final saved = await Get.toNamed(AppRoutes.productForm, arguments: product);
    if (saved == true) await load(showLoader: false);
  }

  Future<void> deleteProduct(ProductModel product) async {
    final confirmed = await ConfirmDialog.show(
      title: AppStrings.deleteProductTitle,
      message: AppStrings.deleteProductMessage(product.name),
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
    );
    if (!confirmed) return;

    try {
      await _products.delete(product);
      removeLocally(product.id);
      AppSnackbar.success(AppStrings.productDeleted);
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    }
  }
}