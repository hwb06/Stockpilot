import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_values.dart';
import '../core/errors/app_exception.dart';
import '../core/utils/app_snackbar.dart';
import '../data/models/category_model.dart';
import '../data/models/product_model.dart';
import '../data/repositories/category_repository.dart';
import '../data/repositories/product_repository.dart';
import '../services/storage_service.dart';

class ProductFormController extends GetxController {
  ProductFormController(this._products, this._categories, this._storage);

  final ProductRepository _products;
  final CategoryRepository _categories;
  final StorageService _storage;
  final _picker = ImagePicker();

  late final ProductModel? editing;

  bool get isEdit => editing != null;

  final categories = <CategoryModel>[].obs;
  final selectedCategoryId = RxnString();
  final pickedBytes = Rxn<Uint8List>();
  final removeExistingImage = false.obs;
  final isSaving = false.obs;

  String? _pickedFileName;

  bool get hasImage =>
      pickedBytes.value != null ||
      (!removeExistingImage.value && editing?.imageUrl != null);

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    editing = args is ProductModel ? args : null;
    selectedCategoryId.value = editing?.categoryId;

    final product = editing;
    if (product?.categoryId != null && product?.categoryName != null) {
      categories.add(
        CategoryModel(id: product!.categoryId!, name: product.categoryName!),
      );
    }

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      categories.assignAll(await _categories.fetchAll());
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    }
  }

  Future<void> addCategory(String name) async {
    try {
      final category = await _categories.create(name);
      categories
        ..add(category)
        ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      selectedCategoryId.value = category.id;
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(
        source: source,
        maxWidth: AppValues.imageMaxWidth,
        imageQuality: AppValues.imageQuality,
      );
      if (file == null) return;
      pickedBytes.value = await file.readAsBytes();
      _pickedFileName = file.name;
      removeExistingImage.value = false;
    } catch (_) {
      AppSnackbar.error(AppStrings.errImagePick);
    }
  }

  void removeImage() {
    pickedBytes.value = null;
    _pickedFileName = null;
    if (editing?.imageUrl != null) removeExistingImage.value = true;
  }

  Future<void> save({
    required String name,
    required String sku,
    required String? description,
    required double price,
    required double costPrice,
    required int stockQty,
    required int minStock,
  }) async {
    isSaving.value = true;
    String? uploadedUrl;
    try {
      var imageUrl = editing?.imageUrl;
      String? staleUrl;

      final bytes = pickedBytes.value;
      if (bytes != null) {
        uploadedUrl = await _storage.uploadProductImage(
          bytes: bytes,
          fileName: _pickedFileName ?? '',
        );
        staleUrl = imageUrl;
        imageUrl = uploadedUrl;
      } else if (removeExistingImage.value) {
        staleUrl = imageUrl;
        imageUrl = null;
      }

      final product = ProductModel(
        id: editing?.id ?? '',
        name: name,
        sku: sku,
        description: description,
        price: price,
        costPrice: costPrice,
        stockQty: stockQty,
        minStock: minStock,
        imageUrl: imageUrl,
        categoryId: selectedCategoryId.value,
      );

      if (isEdit) {
        await _products.update(product);
      } else {
        await _products.create(product);
      }

      if (staleUrl != null) await _storage.deleteByUrl(staleUrl);

      Get.back(result: true);
      AppSnackbar.success(
        isEdit ? AppStrings.productUpdated : AppStrings.productCreated,
      );
    } on AppException catch (e) {
      if (uploadedUrl != null) await _storage.deleteByUrl(uploadedUrl);
      AppSnackbar.error(e.message);
    } finally {
      isSaving.value = false;
    }
  }
}
