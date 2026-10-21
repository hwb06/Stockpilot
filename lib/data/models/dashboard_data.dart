import 'dashboard_stats_model.dart';
import 'product_model.dart';
import 'stock_movement_model.dart';

class DashboardData {
  const DashboardData({
    required this.stats,
    required this.lowStock,
    required this.recentMovements,
  });

  final DashboardStatsModel stats;
  final List<ProductModel> lowStock;
  final List<StockMovementModel> recentMovements;

  bool get isEmpty =>
      stats.totalProducts == 0 &&
      stats.totalSuppliers == 0 &&
      stats.pendingPos == 0;
}
