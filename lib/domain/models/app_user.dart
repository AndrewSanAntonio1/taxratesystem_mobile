/// The identity of the signed-in user.
///
/// Deliberately small: the mobile client only needs enough to greet the user
/// and address the account, so we do not model the whole registration payload
/// (YAGNI). Extend it when the profile endpoints arrive.
class AppUser {
  const AppUser({
    required this.email,
    required this.displayName,
  });

  final String email;
  final String displayName;

  /// Best-effort display name derived from an e-mail address, used by the local
  /// (offline) sign-in implementation until the real profile API exists.
  factory AppUser.fromEmail(String email) {
    final String localPart = email.split('@').first;
    final Iterable<String> words = localPart
        .split(RegExp(r'[._\-+]+'))
        .where((String part) => part.trim().isNotEmpty);
    if (words.isEmpty) {
      return AppUser(email: email, displayName: email);
    }
    final String name = words
        .map(
          (String word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
    return AppUser(email: email, displayName: name);
  }
}