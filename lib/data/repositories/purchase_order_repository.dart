import '../../core/constants/app_db.dart';
import '../../core/constants/app_enums.dart';
import '../../core/errors/error_handler.dart';
import '../../core/extensions/string_extension.dart';
import '../../services/supabase_service.dart';
import '../models/po_line.dart';
import '../models/purchase_order_model.dart';

class PurchaseOrderRepository {
  PurchaseOrderRepository(this._supabase);

  final SupabaseService _supabase;

  Future<List<PurchaseOrderModel>> fetchOrders({
    required String search,
    required PoStatus? status,
    required PoSort sort,
    required int offset,
    required int limit,
  }) async {
    try {
      var query = _supabase.client
          .from(AppDb.purchaseOrders)
          .select(AppDb.poListSelect);

      final term = search.searchSafe;
      if (term.isNotEmpty) {
        query = query.ilike(DbCol.poNumber, '%$term%');
      }
      if (status != null) {
        query = query.eq(DbCol.status, status.value);
      }

      final data = await query
          .order(sort.column, ascending: sort.ascending)
          .order(DbCol.id)
          .range(offset, offset + limit - 1);

      return data.map(PurchaseOrderModel.fromJson).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<PurchaseOrderModel> fetchById(String id) async {
    try {
      final data = await _supabase.client
          .from(AppDb.purchaseOrders)
          .select(AppDb.poDetailSelect)
          .eq(DbCol.id, id)
          .single();
      return PurchaseOrderModel.fromJson(data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> create({
    required String supplierId,
    required List<PoLine> lines,
    required PoStatus status,
    String? notes,
  }) async {
    try {
      await _supabase.client.rpc(
        AppDb.rpcCreatePo,
        params: {
          DbParam.supplierId: supplierId,
          DbParam.items: [
            for (final line in lines)
              {
                DbCol.productId: line.product.id,
                DbCol.quantity: line.quantity,
                DbCol.unitCost: line.unitCost,
              },
          ],
          DbParam.notes: notes,
          DbParam.status: status.value,
        },
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> updateStatus(String id, PoStatus status) async {
    try {
      await _supabase.client
          .from(AppDb.purchaseOrders)
          .update({DbCol.status: status.value})
          .eq(DbCol.id, id);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> receive(String id) async {
    try {
      await _supabase.client.rpc(AppDb.rpcReceivePo, params: {DbParam.poId: id});
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}