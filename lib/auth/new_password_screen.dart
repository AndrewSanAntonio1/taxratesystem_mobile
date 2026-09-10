import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/widgets/branded_header.dart';
import 'package:taxratesystem_mobile/widgets/dash_divider.dart';
import 'package:taxratesystem_mobile/widgets/app_password_field.dart';
import 'package:taxratesystem_mobile/widgets/primary_button.dart';
import 'package:taxratesystem_mobile/widgets/success_overlay_card.dart';
import 'package:taxratesystem_mobile/auth/login_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _showSuccess = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool get _hasMinLength => _newPasswordController.text.length >= 8;
  bool get _hasUppercase =>
      _newPasswordController.text.contains(RegExp(r'[A-Z]'));
  bool get _hasNumber => _newPasswordController.text.contains(RegExp(r'[0-9]'));

  void _goToLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _showSuccess ? Colors.transparent : AppColors.surface,
      bottomNavigationBar: _showSuccess
          ? null
          : Material(
              color: AppColors.surface,
              elevation: 8,
              child: SafeArea(
                minimum: const EdgeInsets.fromLTRB(
                  AppDimens.footerPaddingH,
                  AppDimens.footerPaddingV,
                  AppDimens.footerPaddingH,
                  AppDimens.footerPaddingV,
                ),
                child: PrimaryButton(
                  text: 'Reset Password',
                  onPressed: () {
                    setState(() {
                      _showSuccess = true;
                    });
                  },
                ),
              ),
            ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.pageHorizontalPadding,
                AppDimens.pageTopPadding,
                AppDimens.pageHorizontalPadding,
                32,
              ),
              child: Column(
                children: [
                  const BrandedHeader(),
                  const SizedBox(height: 16),
                  const DashDivider(activeIndex: 2),
                  const SizedBox(height: 20),
                  Text(
                    'Create New Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppDimens.titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your new password below.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppDimens.subtitleFontSize,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  AppPasswordField(
                    controller: _newPasswordController,
                    hintText: 'New Password *',
                    obscure: _obscureNew,
                    onToggle: () => setState(() {
                      _obscureNew = !_obscureNew;
                    }),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  AppPasswordField(
                    controller: _confirmPasswordController,
                    hintText: 'Confirm New Password *',
                    obscure: _obscureConfirm,
                    onToggle: () => setState(() {
                      _obscureConfirm = !_obscureConfirm;
                    }),
                  ),
                  const SizedBox(height: 20),
                  _buildGuidelinesCard(),
                ],
              ),
            ),
          ),
          if (_showSuccess)
            Positioned.fill(
              child: Container(
                color: AppColors.surface,
              ),
            ),
          if (_showSuccess)
            Center(
              child: SuccessOverlayCard(
                title: 'Password Reset Successfully!',
                message:
                    'Your password has been updated. You can now log in with your new credentials.',
                buttonText: 'Back to Login',
                onPressed: _goToLogin,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGuidelinesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.borderRadiusMedium),
      decoration: BoxDecoration(
        color: AppColors.inputSoft,
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGuidelineRow(
            label: 'At least 8 characters',
            met: _hasMinLength,
          ),
          const SizedBox(height: 10),
          _buildGuidelineRow(
            label: '1 uppercase letter',
            met: _hasUppercase,
          ),
          const SizedBox(height: 10),
          _buildGuidelineRow(
            label: '1 number',
            met: _hasNumber,
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelineRow({required String label, required bool met}) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.circle_outlined,
          size: 18,
          color: met ? AppColors.successGreen : AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: AppDimens.smallFontSize,
            color: met ? AppColors.successGreen : AppColors.textDark,
          ),
        ),
      ],
    );
  }
}
