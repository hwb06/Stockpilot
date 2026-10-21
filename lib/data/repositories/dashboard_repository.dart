import '../../core/constants/app_db.dart';
import '../../core/constants/app_enums.dart';
import '../../core/constants/app_values.dart';
import '../../core/errors/error_handler.dart';
import '../../services/supabase_service.dart';
import '../models/dashboard_data.dart';
import '../models/dashboard_stats_model.dart';
import '../models/product_model.dart';
import '../models/stock_movement_model.dart';
import 'product_repository.dart';
import 'stock_movement_repository.dart';

/// Composes the dashboard: one RPC for the numbers (computed in Postgres),
/// plus the existing repositories for the two short lists (no duplicated queries).
class DashboardRepository {
  DashboardRepository(this._supabase, this._products, this._movements);

  final SupabaseService _supabase;
  final ProductRepository _products;
  final StockMovementRepository _movements;

  Future<DashboardData> fetchDashboard() async {
    // Three independent requests run in parallel. Future.wait rethrows the
    // ORIGINAL AppException (unlike the record `.wait`, which wraps errors).
    final results = await Future.wait<Object>([
      _fetchStats(),
      _fetchLowStock(),
      _fetchRecentMovements(),
    ]);

    return DashboardData(
      stats: results[0] as DashboardStatsModel,
      lowStock: results[1] as List<ProductModel>,
      recentMovements: results[2] as List<StockMovementModel>,
    );
  }

  Future<DashboardStatsModel> _fetchStats() async {
    try {
      final result = await _supabase.client.rpc(AppDb.rpcDashboardStats);
      return DashboardStatsModel.fromJson(
        Map<String, dynamic>.from(result as Map),
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<List<ProductModel>> _fetchLowStock() {
    return _products.fetchProducts(
      search: '',
      categoryId: null,
      stock: StockFilter.low,
      sort: ProductSort.stockLow, // emptiest shelves first
      offset: 0,
      limit: AppValues.dashboardListLimit,
    );
  }

  Future<List<StockMovementModel>> _fetchRecentMovements() {
    return _movements.fetchMovements(
      search: '',
      type: null,
      range: null,
      sort: MovementSort.newest,
      offset: 0,
      limit: AppValues.dashboardListLimit,
    );
  }
}
