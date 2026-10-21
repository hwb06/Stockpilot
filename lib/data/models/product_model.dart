import '../../core/constants/app_db.dart';

class ProductModel {
  const ProductModel({
    this.id = '',
    required this.name,
    required this.sku,
    this.description,
    required this.price,
    required this.costPrice,
    required this.stockQty,
    required this.minStock,
    this.imageUrl,
    this.categoryId,
    this.categoryName,
    this.createdAt,
  });

  final String id;
  final String name;
  final String sku;
  final String? description;
  final double price;
  final double costPrice;
  final int stockQty;
  final int minStock;
  final String? imageUrl;
  final String? categoryId;
  final String? categoryName;
  final DateTime? createdAt;

  bool get isOutOfStock => stockQty <= 0;

  bool get isLowStock => stockQty <= minStock;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final category = json[AppDb.categories] as Map<String, dynamic>?;
    return ProductModel(
      id: json[DbCol.id] as String,
      name: json[DbCol.name] as String,
      sku: json[DbCol.sku] as String,
      description: json[DbCol.description] as String?,
      price: (json[DbCol.price] as num).toDouble(),
      costPrice: (json[DbCol.costPrice] as num).toDouble(),
      stockQty: json[DbCol.stockQty] as int,
      minStock: json[DbCol.minStock] as int,
      imageUrl: json[DbCol.imageUrl] as String?,
      categoryId: json[DbCol.categoryId] as String?,
      categoryName: category?[DbCol.name] as String?,
      createdAt: DateTime.tryParse('${json[DbCol.createdAt]}'),
    );
  }

  Map<String, dynamic> toInsertJson() => {
    ..._editableFields(),
    DbCol.stockQty: stockQty,
  };

  Map<String, dynamic> toUpdateJson() => _editableFields();

  Map<String, dynamic> _editableFields() => {
    DbCol.name: name,
    DbCol.sku: sku,
    DbCol.description: description,
    DbCol.price: price,
    DbCol.costPrice: costPrice,
    DbCol.minStock: minStock,
    DbCol.imageUrl: imageUrl,
    DbCol.categoryId: categoryId,
  };
}
