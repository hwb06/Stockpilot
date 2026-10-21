import '../../core/constants/app_db.dart';
import '../../core/constants/app_enums.dart';

class StockMovementModel {
  const StockMovementModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.sku,
    this.imageUrl,
    required this.quantityChange,
    required this.stockAfter,
    required this.type,
    this.note,
    this.createdAt,
  });

  final String id;
  final String productId;
  final String productName;
  final String? sku;
  final String? imageUrl;
  final int quantityChange;
  final int stockAfter;
  final StockMovementType type;
  final String? note;
  final DateTime? createdAt;

  bool get isIncrease => quantityChange > 0;

  factory StockMovementModel.fromJson(Map<String, dynamic> json) {
    final product = json[AppDb.products] as Map<String, dynamic>?;
    return StockMovementModel(
      id: json[DbCol.id] as String,
      productId: json[DbCol.productId] as String,
      productName: (product?[DbCol.name] as String?) ?? '',
      sku: product?[DbCol.sku] as String?,
      imageUrl: product?[DbCol.imageUrl] as String?,
      quantityChange: json[DbCol.quantityChange] as int,
      stockAfter: json[DbCol.stockAfter] as int,
      type: StockMovementType.fromValue(json[DbCol.type] as String),
      note: json[DbCol.note] as String?,
      createdAt: DateTime.tryParse('${json[DbCol.createdAt]}'),
    );
  }
}