import 'package:taxratesystem_mobile/core/errors/app_exception.dart';
import 'package:taxratesystem_mobile/domain/models/app_user.dart';
import 'package:taxratesystem_mobile/domain/repositories/auth_repository.dart';

/// Offline stand-in for the authentication API.
///
/// The project has no backend in this repository, so this implementation keeps
/// the session in memory and derives the profile from the e-mail the user typed.
/// That is a deliberate, documented placeholder — **it performs no real
/// credential check** and must be replaced by an HTTP implementation of
/// [AuthRepository] before shipping.
///
/// Keeping it here (rather than inlining `AppUser.fromEmail` in a widget) means
/// the login and profile screens already speak the final architecture, so the
/// swap is a one-line change in the composition root.
class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository();

  static const int minimumPasswordLength = 6;

  AppUser? _currentUser;

  @override
  Future<AppUser?> getCurrentUser() async => _currentUser;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final String normalizedEmail = email.trim().toLowerCase();

    if (normalizedEmail.isEmpty || !normalizedEmail.contains('@')) {
      throw const AuthException('Enter a valid e-mail address.');
    }
    if (password.length < minimumPasswordLength) {
      throw const AuthException(
        'Password must be at least $minimumPasswordLength characters.',
      );
    }

    final AppUser user = AppUser.fromEmail(normalizedEmail);
    _currentUser = user;
    return user;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
  }
}
