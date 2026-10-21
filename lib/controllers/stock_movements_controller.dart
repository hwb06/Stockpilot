import 'package:flutter/material.dart' show DateTimeRange;
import 'package:get/get.dart';
import '../core/constants/app_db.dart';
import '../core/constants/app_enums.dart';
import '../core/constants/app_routes.dart';
import '../data/models/stock_movement_model.dart';
import '../data/repositories/stock_movement_repository.dart';
import '../services/supabase_service.dart';
import 'base/paginated_list_controller.dart';

class StockMovementsController extends PaginatedListController<StockMovementModel> {
  StockMovementsController(this._repo, SupabaseService supabase) : super(supabase);

  final StockMovementRepository _repo;

  final typeFilter = Rxn<StockMovementType>();
  final dateRange = Rxn<DateTimeRange>();
  final sort = MovementSort.newest.obs;

  @override
  String get tableName => AppDb.stockMovements;

  @override
  String get channelName => AppDb.stockMovementsChannel;

  @override
  String idOf(StockMovementModel item) => item.id;

  @override
  bool get hasActiveFilters =>
      super.hasActiveFilters || typeFilter.value != null || dateRange.value != null;

  @override
  Future<List<StockMovementModel>> fetchPage({required int offset, required int limit}) {
    return _repo.fetchMovements(
      search: query.value,
      type: typeFilter.value,
      range: dateRange.value,
      sort: sort.value,
      offset: offset,
      limit: limit,
    );
  }

  void selectType(StockMovementType? type) {
    if (typeFilter.value == type) return;
    typeFilter.value = type;
    load();
  }

  void setDateRange(DateTimeRange? range) {
    dateRange.value = range;
    load();
  }

  void selectSort(MovementSort value) {
    if (sort.value == value) return;
    sort.value = value;
    load();
  }

  Future<void> openAdjust() async {
    final saved = await Get.toNamed(AppRoutes.adjustStock);
    if (saved == true) await load(showLoader: false);
  }
}