import 'package:stockpilot/core/constants/app_values.dart';

import '../../core/constants/app_db.dart';
import '../../core/constants/app_enums.dart';
import '../../core/errors/error_handler.dart';
import '../../services/storage_service.dart';
import '../../services/supabase_service.dart';
import '../models/product_model.dart';
import '../../core/extensions/string_extension.dart';

class ProductRepository {
  ProductRepository(this._supabase, this._storage);

  final SupabaseService _supabase;
  final StorageService _storage;


  Future<List<ProductModel>> fetchProducts({
    required String search,
    required String? categoryId,
    required StockFilter stock,
    required ProductSort sort,
    required int offset,
    required int limit,
  }) async {
    try {
      var query = _supabase.client
          .from(AppDb.products)
          .select(AppDb.productSelect);

      final term = search.searchSafe;
      if (term.isNotEmpty) {
        query = query.or(
          '${DbCol.name}.ilike.%$term%,${DbCol.sku}.ilike.%$term%',
        );
      }
      if (categoryId != null) {
        query = query.eq(DbCol.categoryId, categoryId);
      }
      switch (stock) {
        case StockFilter.all:
          break;
        case StockFilter.low:
          query = query.eq(DbCol.isLowStock, true);
        case StockFilter.out:
          query = query.eq(DbCol.stockQty, 0);
      }

      final data = await query
          .order(sort.column, ascending: sort.ascending)
          .order(DbCol.id)
          .range(offset, offset + limit - 1);

      return data.map(ProductModel.fromJson).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> create(ProductModel product) async {
    try {
      await _supabase.client
          .from(AppDb.products)
          .insert(product.toInsertJson());
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> update(ProductModel product) async {
    try {
      await _supabase.client
          .from(AppDb.products)
          .update(product.toUpdateJson())
          .eq(DbCol.id, product.id);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> delete(ProductModel product) async {
    try {
      await _supabase.client
          .from(AppDb.products)
          .delete()
          .eq(DbCol.id, product.id);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
    final url = product.imageUrl;
    if (url != null) await _storage.deleteByUrl(url);
  }

  Future<List<ProductModel>> searchForPicker(String query) {
    return fetchProducts(
      search: query,
      categoryId: null,
      stock: StockFilter.all,
      sort: ProductSort.nameAsc,
      offset: 0,
      limit: AppValues.pickerLimit,
    );
  }

}
