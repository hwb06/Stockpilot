import 'product_model.dart';

class PoLine {
  PoLine({required this.product, this.quantity = 1, double? unitCost})
      : unitCost = unitCost ?? product.costPrice;

  final ProductModel product;
  int quantity;
  double unitCost;

  double get total => quantity * unitCost;
}