import 'package:flutter/material.dart' show Color;
import 'app_colors.dart';
import 'app_db.dart';
import 'app_strings.dart';

enum ViewState { loading, success, empty, error }

enum StockFilter {
  all(AppStrings.filterAll),
  low(AppStrings.filterLowStock),
  out(AppStrings.filterOutOfStock);

  const StockFilter(this.label);
  final String label;
}

enum ProductSort {
  newest(AppStrings.sortNewest, DbCol.createdAt, false),
  nameAsc(AppStrings.sortNameAsc, DbCol.name, true),
  nameDesc(AppStrings.sortNameDesc, DbCol.name, false),
  priceLow(AppStrings.sortPriceLow, DbCol.price, true),
  priceHigh(AppStrings.sortPriceHigh, DbCol.price, false),
  stockLow(AppStrings.sortStockLow, DbCol.stockQty, true),
  stockHigh(AppStrings.sortStockHigh, DbCol.stockQty, false);

  const ProductSort(this.label, this.column, this.ascending);
  final String label;
  final String column;
  final bool ascending;
}

enum SupplierSort {
  newest(AppStrings.sortNewest, DbCol.createdAt, false),
  nameAsc(AppStrings.sortNameAsc, DbCol.name, true),
  nameDesc(AppStrings.sortNameDesc, DbCol.name, false);

  const SupplierSort(this.label, this.column, this.ascending);
  final String label;
  final String column;
  final bool ascending;
}

enum PoSort {
  newest(AppStrings.sortNewest, DbCol.orderDate, false),
  oldest(AppStrings.sortOldest, DbCol.orderDate, true),
  amountHigh(AppStrings.sortAmountHigh, DbCol.totalAmount, false),
  amountLow(AppStrings.sortAmountLow, DbCol.totalAmount, true);

  const PoSort(this.label, this.column, this.ascending);
  final String label;
  final String column;
  final bool ascending;
}

enum PoStatus {
  draft('draft', AppStrings.poDraft, AppColors.textSecondary),
  ordered('ordered', AppStrings.poOrdered, AppColors.primary),
  received('received', AppStrings.poReceived, AppColors.success),
  cancelled('cancelled', AppStrings.poCancelled, AppColors.danger);

  const PoStatus(this.value, this.label, this.color);
  final String value;
  final String label;
  final Color color;

  static PoStatus fromValue(String value) =>
      values.firstWhere((s) => s.value == value, orElse: () => draft);
}

enum RowAction { edit, delete }

enum StockMovementType {
  initial('initial', AppStrings.movementInitial, AppColors.primary),
  purchase('purchase', AppStrings.movementPurchase, AppColors.success),
  adjustment('adjustment', AppStrings.movementAdjustment, AppColors.warning);

  const StockMovementType(this.value, this.label, this.color);
  final String value;
  final String label;
  final Color color;

  static StockMovementType fromValue(String value) =>
      values.firstWhere((t) => t.value == value, orElse: () => adjustment);
}

enum MovementSort {
  newest(AppStrings.sortNewest, DbCol.createdAt, false),
  oldest(AppStrings.sortOldest, DbCol.createdAt, true);

  const MovementSort(this.label, this.column, this.ascending);
  final String label;
  final String column;
  final bool ascending;
}

enum AdjustDirection {
  add(AppStrings.addStock, 1),
  remove(AppStrings.removeStock, -1);

  const AdjustDirection(this.label, this.sign);
  final String label;
  final int sign;
}

enum HomeTab { dashboard, products, suppliers, orders, history }
