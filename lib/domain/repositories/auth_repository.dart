import 'package:taxratesystem_mobile/domain/models/app_user.dart';

/// Authentication and session boundary.
///
/// Today this is satisfied by a local, offline implementation; when the backend
/// arrives, only a new implementation of this interface is required — the login
/// and profile screens keep working unchanged.
abstract interface class AuthRepository {
  /// The currently signed-in user, or `null` when the session is anonymous.
  Future<AppUser?> getCurrentUser();

  /// Signs the user in, or throws [AuthException] when the credentials are
  /// rejected.
  Future<AppUser> signIn({
    required String email,
    required String password,
  });

  /// Clears the session.
  Future<void> signOut();
}
