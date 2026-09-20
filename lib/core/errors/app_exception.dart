/// Domain-level failures.
///
/// Repositories throw these instead of leaking `SocketException`, `FormatException`
/// or any other infrastructure detail, so the presentation layer can map a
/// failure to a user-facing message without knowing where the data came from.
library;

/// Base class for every expected, recoverable failure in the app.
///
/// [message] is safe to show to a user.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// Sign-in / registration could not be completed (bad credentials, offline...).
final class AuthException extends AppException {
  const AuthException(super.message);
}

/// The tax amount could not be computed.
final class CalculationException extends AppException {
  const CalculationException(super.message);
}

/// Reading or writing locally persisted data failed.
final class StorageException extends AppException {
  const StorageException(super.message);
}
