import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_db.dart';

class UserModel {
  final String id;
  final String email;
  final String fullName;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
  });

  static UserModel? fromSupabaseUser(User? user) {
    if (user == null) return null;
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      fullName: (user.userMetadata?[DbCol.fullName] as String?) ?? '',
    );
  }
}