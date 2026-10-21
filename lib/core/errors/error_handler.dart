import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/app_db.dart';
import '../constants/app_strings.dart';
import 'app_exception.dart';

class ErrorHandler {
  ErrorHandler._();

  static AppException handle(
      Object error, {
        String? fallback,
        String? inUseMessage,
      }) {
    if (error is AppException) return error;
    if (error is PostgrestException) return _fromPostgrest(error, inUseMessage);
    if (error is StorageException) {
      return AppException(fallback ?? error.message);
    }
    if (_isNetworkError(error)) {
      return const AppException(AppStrings.errNetwork);
    }
    return AppException(fallback ?? AppStrings.errGeneric);
  }

  static AppException _fromPostgrest(PostgrestException e, String? inUseMessage) {
    switch (e.code) {
      case AppDb.pgUniqueViolation:
        return AppException(
          e.message.contains(DbCol.sku)
              ? AppStrings.errDuplicateSku
              : AppStrings.errDuplicate,
        );
      case AppDb.pgForeignKeyViolation:
        return AppException(inUseMessage ?? AppStrings.errInUse);
      case AppDb.pgCheckViolation:
        return const AppException(AppStrings.errInvalid);
      default:
        return AppException(e.message);
    }
  }

  static bool _isNetworkError(Object error) {
    final text = error.toString();
    return text.contains('SocketException') ||
        text.contains('ClientException') ||
        text.contains('Failed host lookup');
  }
}