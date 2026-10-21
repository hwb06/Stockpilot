import '../../core/constants/app_db.dart';
import '../../core/errors/error_handler.dart';
import '../../services/supabase_service.dart';
import '../models/category_model.dart';

class CategoryRepository {
  CategoryRepository(this._supabase);

  final SupabaseService _supabase;

  Future<List<CategoryModel>> fetchAll() async {
    try {
      final data = await _supabase.client
          .from(AppDb.categories)
          .select()
          .order(DbCol.name);
      return data.map(CategoryModel.fromJson).toList();
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<CategoryModel> create(String name) async {
    try {
      final data =
          await _supabase.client
              .from(AppDb.categories)
              .insert({DbCol.name: name.trim()})
              .select()
              .single();
      return CategoryModel.fromJson(data);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
