import 'package:get/get.dart';
import '../core/constants/app_strings.dart';
import '../core/errors/app_exception.dart';
import '../core/utils/app_snackbar.dart';
import '../data/models/supplier_model.dart';
import '../data/repositories/supplier_repository.dart';

class SupplierFormController extends GetxController {
  SupplierFormController(this._repo);

  final SupplierRepository _repo;

  late final SupplierModel? editing;
  bool get isEdit => editing != null;

  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    editing = args is SupplierModel ? args : null;
  }

  Future<void> save(SupplierModel supplier) async {
    isSaving.value = true;
    try {
      if (isEdit) {
        await _repo.update(supplier);
      } else {
        await _repo.create(supplier);
      }
      Get.back(result: true);
      AppSnackbar.success(
        isEdit ? AppStrings.supplierUpdated : AppStrings.supplierCreated,
      );
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    } finally {
      isSaving.value = false;
    }
  }
}