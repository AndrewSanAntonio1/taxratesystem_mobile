import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _taxUpdates = true;
  bool _calculationReminders = false;
  bool _generalNotifications = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        title: Text(
          'Notification Settings',
          style: TextStyle(
            fontSize: AppDimens.bodyFontSize,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pageHorizontalPadding,
          24,
          AppDimens.pageHorizontalPadding,
          24,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard),
          ),
          child: Column(
            children: [
              _buildSwitchTile(
                title: 'Tax Updates',
                subtitle: 'Receive announcements regarding TRAIN/CREATE law updates',
                value: _taxUpdates,
                onChanged: (value) => setState(() => _taxUpdates = value),
              ),
              _buildDivider(context),
              _buildSwitchTile(
                title: 'Calculation Reminders',
                subtitle: 'Get reminders to compute periodic tax liabilities',
                value: _calculationReminders,
                onChanged: (value) =>
                    setState(() => _calculationReminders = value),
              ),
              _buildDivider(context),
              _buildSwitchTile(
                title: 'General Notifications',
                subtitle: 'App updates and news',
                value: _generalNotifications,
                onChanged: (value) =>
                    setState(() => _generalNotifications = value),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        activeTrackColor: AppColors.focusBlue,
        title: Text(
          title,
          style: TextStyle(
            fontSize: AppDimens.bodyFontSize,
            fontWeight: FontWeight.w600,
            color: scheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: AppDimens.smallFontSize,
            color: scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}