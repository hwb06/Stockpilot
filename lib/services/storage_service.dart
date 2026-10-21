import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../core/constants/app_db.dart';
import '../core/constants/app_strings.dart';
import '../core/constants/app_values.dart';
import '../core/errors/app_exception.dart';
import '../core/errors/error_handler.dart';
import 'supabase_service.dart';

class StorageService {
  StorageService(this._supabase);

  final SupabaseService _supabase;

  StorageFileApi get _bucket =>
      _supabase.client.storage.from(AppDb.productImagesBucket);

  Future<String> uploadProductImage({
    required Uint8List bytes,
    required String fileName,
  }) async {
    try {
      final ext = _extension(fileName);
      final path = '${_supabase.currentUser!.id}/${const Uuid().v4()}.$ext';
      await _bucket.uploadBinary(
        path,
        bytes,
        fileOptions: FileOptions(contentType: _contentType(ext)),
      );
      return _bucket.getPublicUrl(path);
    } catch (e) {
      throw ErrorHandler.handle(e, fallback: AppStrings.errImageUpload);
    }
  }

  Future<void> deleteByUrl(String url) async {
    final marker = '/${AppDb.productImagesBucket}/';
    final index = url.indexOf(marker);
    if (index == -1) return;
    final path = Uri.decodeComponent(url.substring(index + marker.length));
    try {
      await _bucket.remove([path]);
    } on AppException {
      // ignore
    } catch (_) {
      // ignore
    }
  }

  String _extension(String fileName) {
    final dot = fileName.lastIndexOf('.');
    if (dot == -1 || dot == fileName.length - 1) {
      return AppValues.defaultImageExtension;
    }
    return fileName.substring(dot + 1).toLowerCase();
  }

  String _contentType(String ext) => 'image/${ext == 'jpg' ? 'jpeg' : ext}';
}
