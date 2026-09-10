import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  String? _error;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    final current = _currentController.text;
    final newPassword = _newController.text;
    final confirm = _confirmController.text;

    if (current.isEmpty) {
      setState(() => _error = 'Enter your current password');
      return;
    }
    if (newPassword.length < 6) {
      setState(() => _error = 'New password must be at least 6 characters');
      return;
    }
    if (confirm != newPassword) {
      setState(() => _error = 'Passwords do not match');
      return;
    }

    setState(() => _error = null);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password changed successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
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
          'Change Password',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PasswordField(
              controller: _currentController,
              label: 'Current Password',
            ),
            const SizedBox(height: 16),
            _PasswordField(
              controller: _newController,
              label: 'New Password',
            ),
            const SizedBox(height: 16),
            _PasswordField(
              controller: _confirmController,
              label: 'Confirm New Password',
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 18,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _error!,
                      style: TextStyle(
                        fontSize: AppDimens.smallFontSize,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          AppDimens.pageHorizontalPadding,
          12,
          AppDimens.pageHorizontalPadding,
          12,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: AppDimens.buttonHeight,
            child: ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.lock_reset, size: 20),
              label: const Text(
                'Change Password',
                style: TextStyle(
                  fontSize: AppDimens.bodyFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.focusBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppDimens.borderRadiusCard),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({required this.controller, required this.label});

  final TextEditingController controller;
  final String label;

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontSize: AppDimens.smallFontSize,
            fontWeight: FontWeight.w600,
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          style: TextStyle(color: scheme.onSurface),
          decoration: InputDecoration(
            hintText: '••••••••',
            hintStyle: TextStyle(color: scheme.onSurfaceVariant),
            prefixIcon: Icon(
              Icons.lock_outline,
              color: scheme.onSurfaceVariant,
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure ? Icons.visibility_off : Icons.visibility,
                color: scheme.onSurfaceVariant,
              ),
            ),
            filled: true,
            fillColor: scheme.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimens.inputContentPaddingH,
              vertical: AppDimens.inputContentPaddingV,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppDimens.borderRadiusMedium),
              borderSide: BorderSide(
                color: AppColors.divider,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(AppDimens.borderRadiusMedium),
              borderSide:
                  const BorderSide(color: AppColors.focusBlue, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}