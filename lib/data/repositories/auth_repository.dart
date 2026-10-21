import 'package:stockpilot/core/errors/app_exception.dart';
import 'package:stockpilot/data/models/user_model.dart';
import 'package:stockpilot/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stockpilot/core/constants/app_strings.dart';
import 'package:stockpilot/core/constants/app_db.dart';

class AuthRepository {
  AuthRepository(this._supabase);

  final SupabaseService _supabase;

  GoTrueClient get _auth => _supabase.client.auth;

  UserModel? get currentUser => UserModel.fromSupabaseUser(_auth.currentUser);

  bool get hasSession => _auth.currentSession != null;

  Stream<UserModel?> get userChanges => _auth.onAuthStateChange.map(
    (state) => UserModel.fromSupabaseUser(state.session?.user),
  );

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw AppException(e.message);
    } catch (_) {
      throw const AppException(
        AppStrings.errSignIn,
      );
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      final res = await _auth.signUp(
        email: email,
        password: password,
        data: {DbCol.fullName: fullName},
      );
      if (res.session != null) {
        await _auth.signOut();
      }
    } on AuthException catch (e) {
      throw AppException(e.message);
    } catch (_) {
      throw const AppException(
        AppStrings.errRegister,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on AuthException catch (e) {
      throw AppException(e.message);
    } catch (_) {
      throw const AppException(AppStrings.errSignOut);
    }
  }
}
