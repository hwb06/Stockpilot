import '../../core/constants/app_db.dart';
import '../../core/constants/app_enums.dart';

class PurchaseOrderItemModel {
  const PurchaseOrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.sku,
    this.imageUrl,
    required this.quantity,
    required this.unitCost,
  });

  final String id;
  final String productId;
  final String productName;
  final String? sku;
  final String? imageUrl;
  final int quantity;
  final double unitCost;

  double get lineTotal => quantity * unitCost;

  factory PurchaseOrderItemModel.fromJson(Map<String, dynamic> json) {
    final product = json[AppDb.products] as Map<String, dynamic>?;
    return PurchaseOrderItemModel(
      id: json[DbCol.id] as String,
      productId: json[DbCol.productId] as String,
      productName: (product?[DbCol.name] as String?) ?? '',
      sku: product?[DbCol.sku] as String?,
      imageUrl: product?[DbCol.imageUrl] as String?,
      quantity: json[DbCol.quantity] as int,
      unitCost: (json[DbCol.unitCost] as num).toDouble(),
    );
  }
}

class PurchaseOrderModel {
  const PurchaseOrderModel({
    required this.id,
    required this.poNumber,
    required this.supplierId,
    this.supplierName,
    this.supplierPhone,
    required this.status,
    required this.totalAmount,
    this.notes,
    this.orderDate,
    this.receivedAt,
    this.itemCount = 0,
    this.items = const [],
  });

  final String id;
  final String poNumber;
  final String supplierId;
  final String? supplierName;
  final String? supplierPhone;
  final PoStatus status;
  final double totalAmount;
  final String? notes;
  final DateTime? orderDate;
  final DateTime? receivedAt;
  final int itemCount;
  final List<PurchaseOrderItemModel> items;

  bool get canMarkOrdered => status == PoStatus.draft;
  bool get canReceive => status == PoStatus.ordered;
  bool get canCancel => status == PoStatus.draft || status == PoStatus.ordered;
  bool get hasActions => canMarkOrdered || canReceive || canCancel;

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    final supplier = json[AppDb.suppliers] as Map<String, dynamic>?;

    final rawItems = json[AppDb.purchaseOrderItems] as List<dynamic>?;
    final items = (rawItems ?? const [])
        .map((e) => PurchaseOrderItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final countList = json[DbCol.itemCountAlias] as List<dynamic>?;
    final itemCount = (countList != null && countList.isNotEmpty)
        ? (countList.first as Map<String, dynamic>)[DbCol.count] as int
        : items.length;

    return PurchaseOrderModel(
      id: json[DbCol.id] as String,
      poNumber: json[DbCol.poNumber] as String,
      supplierId: json[DbCol.supplierId] as String,
      supplierName: supplier?[DbCol.name] as String?,
      supplierPhone: supplier?[DbCol.phone] as String?,
      status: PoStatus.fromValue(json[DbCol.status] as String),
      totalAmount: (json[DbCol.totalAmount] as num).toDouble(),
      notes: json[DbCol.notes] as String?,
      orderDate: DateTime.tryParse('${json[DbCol.orderDate]}'),
      receivedAt: DateTime.tryParse('${json[DbCol.receivedAt]}'),
      itemCount: itemCount,
      items: items,
    );
  }
}