import '../../core/constants/app_db.dart';
import '../../core/constants/app_enums.dart';
import '../../core/constants/app_strings.dart';
import '../../core/errors/error_handler.dart';
import '../../core/extensions/string_extension.dart';
import '../../services/supabase_service.dart';
import '../models/supplier_model.dart';

class SupplierRepository {
  SupplierRepository(this._supabase);

  final SupabaseService _supabase;


  Future<List<SupplierModel>> fetchSuppliers({
    required String search,
    required SupplierSort sort,
    required int offset,
    required int limit,
  }) async {
    try {
      var query = _supabase.client.from(AppDb.suppliers).select();

      final term = search.searchSafe;
      if (term.isNotEmpty) {
        query = query.or(
          '${DbCol.name}.ilike.%$term%,'
              '${DbCol.phone}.ilike.%$term%,'
              '${DbCol.email}.ilike.%$term%',
        );
      }

      final data = await query
          .order(sort.column, ascending: sort.ascending)
          .order(DbCol.id)
          .range(offset, offset + limit - 1);

      return data.map(SupplierModel.fromJson).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> create(SupplierModel supplier) async {
    try {
      await _supabase.client.from(AppDb.suppliers).insert(supplier.toJson());
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> update(SupplierModel supplier) async {
    try {
      await _supabase.client
          .from(AppDb.suppliers)
          .update(supplier.toJson())
          .eq(DbCol.id, supplier.id);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> delete(String id) async {
    try {
      await _supabase.client.from(AppDb.suppliers).delete().eq(DbCol.id, id);
    } catch (e) {
      throw ErrorHandler.handle(e, inUseMessage: AppStrings.errSupplierInUse);
    }
  }
}