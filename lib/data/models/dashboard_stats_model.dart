import '../../core/constants/app_db.dart';

class DailyPurchaseModel {
  const DailyPurchaseModel({required this.day, required this.total});

  final DateTime day;
  final double total;

  factory DailyPurchaseModel.fromJson(Map<String, dynamic> json) {
    return DailyPurchaseModel(
      day: DateTime.parse(json[DashboardKey.day] as String),
      total: (json[DashboardKey.total] as num).toDouble(),
    );
  }
}

class DashboardStatsModel {
  const DashboardStatsModel({
    required this.totalProducts,
    required this.totalSuppliers,
    required this.stockValue,
    required this.lowStockCount,
    required this.pendingPos,
    required this.purchasesLast7Days,
  });

  final int totalProducts;
  final int totalSuppliers;
  final double stockValue;
  final int lowStockCount;
  final int pendingPos;
  final List<DailyPurchaseModel> purchasesLast7Days;

  double get weekTotal =>
      purchasesLast7Days.fold(0.0, (sum, day) => sum + day.total);

  bool get hasPurchases => weekTotal > 0;

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    final days = (json[DashboardKey.purchasesLast7Days] as List?) ?? const [];
    return DashboardStatsModel(
      totalProducts: (json[DashboardKey.totalProducts] as num).toInt(),
      totalSuppliers: (json[DashboardKey.totalSuppliers] as num).toInt(),
      stockValue: (json[DashboardKey.stockValue] as num).toDouble(),
      lowStockCount: (json[DashboardKey.lowStockCount] as num).toInt(),
      pendingPos: (json[DashboardKey.pendingPos] as num).toInt(),
      purchasesLast7Days: [
        for (final day in days)
          DailyPurchaseModel.fromJson(Map<String, dynamic>.from(day as Map)),
      ],
    );
  }
}
