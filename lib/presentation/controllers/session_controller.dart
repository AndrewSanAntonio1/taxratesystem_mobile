import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:taxratesystem_mobile/constants/app_strings.dart';
import 'package:taxratesystem_mobile/core/errors/app_exception.dart';
import 'package:taxratesystem_mobile/core/state/view_state.dart';
import 'package:taxratesystem_mobile/domain/models/app_user.dart';
import 'package:taxratesystem_mobile/domain/repositories/auth_repository.dart';

/// Holds the signed-in user for the whole app.
///
/// Replaces the hardcoded `'Juan Dela Cruz'` / `'juan@example.com'` that the
/// profile screen used to render regardless of who logged in.
class SessionController extends ChangeNotifier {
  SessionController(this._repository);

  final AuthRepository _repository;

  /// Starts as "no user" rather than "loading" so that a screen which has not
  /// triggered a load yet renders an empty state instead of an endless spinner.
  ViewState<AppUser> _state = const ViewStateEmpty<AppUser>();

  ViewState<AppUser> get state => _state;

  AppUser? get user => _state.valueOrNull;

  bool get isSignedIn => _state.valueOrNull != null;

  /// Failure message to show on the login form, or `null`.
  String? get errorMessage => switch (_state) {
        ViewStateError<AppUser>(:final String message) => message,
        _ => null,
      };

  /// Loads the signed-in user, unless one is already in memory.
  ///
  /// Called when the home shell mounts so the profile tab has an identity even
  /// if the session is restored by a future (persistent) implementation.
  /// Idempotent and safe to call from `didChangeDependencies`.
  Future<void> ensureLoaded() async {
    if (_state.valueOrNull != null || _state.isLoading) return;
    await load();
  }

  /// Fetches the current user from the repository.
  Future<void> load() async {
    _set(const ViewStateLoading<AppUser>());
    await _guard(() async {
      final AppUser? user = await _repository.getCurrentUser();
      _state = user == null
          ? const ViewStateEmpty<AppUser>()
          : ViewStateData<AppUser>(user);
    });
  }

  /// Assigns [state] and notifies listeners on a microtask.
  ///
  /// Deferring the notification means a caller that starts a load during the
  /// build phase — a screen's `didChangeDependencies`, for example — cannot
  /// trigger "setState() or markNeedsBuild() called during build". Callers that
  /// `await` the load still observe the notification before it returns.
  void _set(ViewState<AppUser> state) {
    _state = state;
    scheduleMicrotask(notifyListeners);
  }

  /// Signs in; returns `true` on success.
  ///
  /// On failure [state] becomes [ViewStateError] and the message is available
  /// for the login screen to display.
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _set(const ViewStateLoading<AppUser>());
    var succeeded = false;
    await _guard(() async {
      _state = ViewStateData<AppUser>(
        await _repository.signIn(email: email, password: password),
      );
      succeeded = true;
    });
    return succeeded;
  }

  Future<void> signOut() async {
    await _guard(() async {
      await _repository.signOut();
      _state = const ViewStateEmpty<AppUser>();
    });
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } on AppException catch (error) {
      _state = ViewStateError<AppUser>(error.message);
    } catch (_) {
      _state = const ViewStateError<AppUser>(AppStrings.genericErrorMessage);
    }
    notifyListeners();
  }
}