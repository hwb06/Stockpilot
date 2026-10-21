import 'package:get/get.dart';
import '../core/constants/app_db.dart';
import '../core/constants/app_enums.dart';
import '../core/constants/app_routes.dart';
import '../core/constants/app_strings.dart';
import '../core/errors/app_exception.dart';
import '../core/utils/app_snackbar.dart';
import '../data/models/supplier_model.dart';
import '../data/repositories/supplier_repository.dart';
import '../presentation/widgets/confirm_dialog.dart';
import '../services/supabase_service.dart';
import 'base/paginated_list_controller.dart';

class SuppliersController extends PaginatedListController<SupplierModel> {
  SuppliersController(this._repo, SupabaseService supabase) : super(supabase);

  final SupplierRepository _repo;

  final sort = SupplierSort.newest.obs;

  @override
  String get tableName => AppDb.suppliers;

  @override
  String get channelName => AppDb.suppliersChannel;

  @override
  String idOf(SupplierModel item) => item.id;

  @override
  Future<List<SupplierModel>> fetchPage({required int offset, required int limit}) {
    return _repo.fetchSuppliers(
      search: query.value,
      sort: sort.value,
      offset: offset,
      limit: limit,
    );
  }

  void selectSort(SupplierSort value) {
    if (sort.value == value) return;
    sort.value = value;
    load();
  }

  Future<void> openForm([SupplierModel? supplier]) async {
    final saved = await Get.toNamed(AppRoutes.supplierForm, arguments: supplier);
    if (saved == true) await load(showLoader: false);
  }

  Future<void> deleteSupplier(SupplierModel supplier) async {
    final confirmed = await ConfirmDialog.show(
      title: AppStrings.deleteSupplierTitle,
      message: AppStrings.deleteSupplierMessage(supplier.name),
      confirmText: AppStrings.delete,
      cancelText: AppStrings.cancel,
    );
    if (!confirmed) return;

    try {
      await _repo.delete(supplier.id);
      removeLocally(supplier.id);
      AppSnackbar.success(AppStrings.supplierDeleted);
    } on AppException catch (e) {
      AppSnackbar.error(e.message);
    }
  }
}