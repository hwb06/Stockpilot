import 'package:get/get.dart';
import '../core/constants/app_db.dart';
import '../core/constants/app_enums.dart';
import '../core/constants/app_routes.dart';
import '../data/models/purchase_order_model.dart';
import '../data/repositories/purchase_order_repository.dart';
import '../services/supabase_service.dart';
import 'base/paginated_list_controller.dart';

class PurchaseOrdersController extends PaginatedListController<PurchaseOrderModel> {
  PurchaseOrdersController(this._repo, SupabaseService supabase) : super(supabase);

  final PurchaseOrderRepository _repo;

  final statusFilter = Rxn<PoStatus>();
  final sort = PoSort.newest.obs;

  @override
  String get tableName => AppDb.purchaseOrders;

  @override
  String get channelName => AppDb.purchaseOrdersChannel;

  @override
  String idOf(PurchaseOrderModel item) => item.id;

  @override
  bool get hasActiveFilters => super.hasActiveFilters || statusFilter.value != null;

  @override
  Future<List<PurchaseOrderModel>> fetchPage({required int offset, required int limit}) {
    return _repo.fetchOrders(
      search: query.value,
      status: statusFilter.value,
      sort: sort.value,
      offset: offset,
      limit: limit,
    );
  }

  void selectStatus(PoStatus? status) {
    if (statusFilter.value == status) return;
    statusFilter.value = status;
    load();
  }

  void selectSort(PoSort value) {
    if (sort.value == value) return;
    sort.value = value;
    load();
  }

  Future<void> openCreate() async {
    final saved = await Get.toNamed(AppRoutes.poForm);
    if (saved == true) await load(showLoader: false);
  }

  Future<void> openDetail(PurchaseOrderModel order) async {
    await Get.toNamed(AppRoutes.poDetail, arguments: order.id);
    await load(showLoader: false);
  }
}