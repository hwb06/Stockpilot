import 'package:flutter/material.dart' show DateTimeRange;
import '../../core/constants/app_db.dart';
import '../../core/constants/app_enums.dart';
import '../../core/errors/error_handler.dart';
import '../../core/extensions/string_extension.dart';
import '../../services/supabase_service.dart';
import '../models/stock_movement_model.dart';

class StockMovementRepository {
  StockMovementRepository(this._supabase);

  final SupabaseService _supabase;

  Future<List<StockMovementModel>> fetchMovements({
    required String search,
    required StockMovementType? type,
    required DateTimeRange? range,
    required MovementSort sort,
    required int offset,
    required int limit,
  }) async {
    try {
      var query = _supabase.client
          .from(AppDb.stockMovements)
          .select(AppDb.movementSelect);

      final term = search.searchSafe;
      if (term.isNotEmpty) {
        query = query.ilike(AppDb.movementProductName, '%$term%');
      }
      if (type != null) {
        query = query.eq(DbCol.type, type.value);
      }
      if (range != null) {
        final start = DateTime(range.start.year, range.start.month, range.start.day);
        final endExclusive =
        DateTime(range.end.year, range.end.month, range.end.day + 1);
        query = query
            .gte(DbCol.createdAt, start.toUtc().toIso8601String())
            .lt(DbCol.createdAt, endExclusive.toUtc().toIso8601String());
      }

      final data = await query
          .order(sort.column, ascending: sort.ascending)
          .order(DbCol.id)
          .range(offset, offset + limit - 1);

      return data.map(StockMovementModel.fromJson).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> adjustStock({
    required String productId,
    required int change,
    String? note,
  }) async {
    try {
      await _supabase.client.rpc(
        AppDb.rpcAdjustStock,
        params: {
          DbParam.adjustProductId: productId,
          DbParam.adjustChange: change,
          DbParam.adjustNote: note,
        },
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}