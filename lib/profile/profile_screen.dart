import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/constants/app_strings.dart';
import 'package:taxratesystem_mobile/core/di/dependency_scope.dart';
import 'package:taxratesystem_mobile/core/routing/app_router.dart';
import 'package:taxratesystem_mobile/domain/models/app_user.dart';
import 'package:taxratesystem_mobile/presentation/controllers/session_controller.dart';
import 'package:taxratesystem_mobile/widgets/settings_tile.dart';

/// Profile and settings.
///
/// Reads the identity from [SessionController] (the same instance the login
/// screen writes to) instead of rendering a hardcoded name, so the profile
/// always reflects who actually signed in.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmLogout(
    BuildContext context,
    SessionController session,
  ) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(AppStrings.logout),
        content: const Text(AppStrings.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text(AppStrings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    await session.signOut();
    if (!context.mounted) return;
    context.replaceWithLogin();
  }

  @override
  Widget build(BuildContext context) {
    final SessionController session = context.dependencies.sessionController;
    return ListenableBuilder(
      listenable: session,
      builder: (context, _) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.pageHorizontalPadding,
                  20,
                  AppDimens.pageHorizontalPadding,
                  24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileCard(context, session),
                    const SizedBox(height: 28),
                    _buildSectionHeader(context, AppStrings.accountSection),
                    const SizedBox(height: 10),
                    SettingsTile(
                      icon: Icons.lock_outline,
                      title: AppStrings.changePassword,
                      onTap: () => context.pushChangePassword(),
                    ),
                    const SizedBox(height: 12),
                    SettingsTile(
                      icon: Icons.notifications_outlined,
                      title: AppStrings.notificationSettings,
                      onTap: () => context.pushNotificationSettings(),
                    ),
                    const SizedBox(height: 28),
                    _buildLogoutButton(context, session),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppDimens.pageHorizontalPadding,
        16,
        AppDimens.pageHorizontalPadding,
        20,
      ),
      decoration: BoxDecoration(color: scheme.primaryContainer),
      child: SafeArea(
        bottom: false,
        child: Text(
          AppStrings.profileTitle,
          style: TextStyle(
            fontSize: AppDimens.titleFontSize,
            fontWeight: FontWeight.bold,
            color: scheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  /// Handles every [ViewState] case: spinner while the session resolves, a
  /// failure message, and the resolved identity.
  Widget _buildProfileCard(BuildContext context, SessionController session) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final AppUser? user = session.user;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: scheme.primaryContainer,
            child: Icon(
              Icons.person,
              size: 38,
              color: scheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            user?.displayName ?? AppStrings.unknownUser,
            style: TextStyle(
              fontSize: AppDimens.titleFontSize - 2,
              fontWeight: FontWeight.bold,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? AppStrings.unknownUserEmail,
            style: TextStyle(
              fontSize: AppDimens.subtitleFontSize,
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (session.state.isLoading) ...[
            const SizedBox(height: 16),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2.2),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.sessionLoading,
              style: TextStyle(
                fontSize: AppDimens.tinyFontSize,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          if (session.errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              session.errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppDimens.smallFontSize,
                color: scheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return Text(
      title,
      style: TextStyle(
        fontSize: AppDimens.tinyFontSize,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: scheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, SessionController session) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: AppDimens.buttonHeight,
      child: OutlinedButton.icon(
        onPressed: () => _confirmLogout(context, session),
        icon: const Icon(Icons.logout, size: 20),
        label: const Text(
          AppStrings.logout,
          style: TextStyle(
            fontSize: AppDimens.bodyFontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: scheme.error,
          side: BorderSide(color: scheme.error, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard),
          ),
        ),
      ),
    );
  }
}