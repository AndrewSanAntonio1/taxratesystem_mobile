import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/auth/otp_verification_screen.dart';
import 'package:taxratesystem_mobile/auth/registration_data.dart';
import 'package:taxratesystem_mobile/widgets/branded_header.dart';
import 'package:taxratesystem_mobile/widgets/step_progress_indicator.dart';
import 'package:taxratesystem_mobile/widgets/app_password_field.dart';
import 'package:taxratesystem_mobile/widgets/primary_button.dart';
import 'package:taxratesystem_mobile/widgets/secondary_button.dart';

class AccountSetupScreen extends StatefulWidget {
  const AccountSetupScreen({
    super.key,
    this.registrationData = const RegistrationData(),
  });

  final RegistrationData registrationData;

  @override
  State<AccountSetupScreen> createState() => _AccountSetupScreenState();
}

class _AccountSetupScreenState extends State<AccountSetupScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      bottomNavigationBar: Material(
        color: AppColors.surface,
        elevation: 8,
        child: SafeArea(
          minimum: const EdgeInsets.fromLTRB(
            AppDimens.footerPaddingH,
            AppDimens.footerPaddingV,
            AppDimens.footerPaddingH,
            AppDimens.footerPaddingV,
          ),
          child: _buildActionButtons(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.pageHorizontalPadding,
            AppDimens.pageTopPadding,
            AppDimens.pageHorizontalPadding,
            AppDimens.pageBottomPadding,
          ),
          child: Column(
            children: [
              const BrandedHeader(),
              const SizedBox(height: 20),
              const StepProgressIndicator(totalSteps: 4, currentStep: 1),
              const SizedBox(height: 24),
              Text(
                'Account Setup',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Set up your login credentials to secure your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.subtitleFontSize,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              _buildUsernameField(),
              const SizedBox(height: 16),
              AppPasswordField(
                controller: _passwordController,
                hintText: 'Password *',
                obscure: _obscurePassword,
                onToggle: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              AppPasswordField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password *',
                obscure: _obscureConfirmPassword,
                onToggle: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
              const SizedBox(height: 20),
              _buildPasswordRequirements(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return _buildField(
      controller: _usernameController,
      label: 'Choose a username *',
      prefixIcon: Icons.person_outline,
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        labelText: label,
        hintText: label,
        hintStyle: TextStyle(color: AppColors.textSecondary),
        labelStyle: TextStyle(color: AppColors.textSecondary),
        floatingLabelStyle: TextStyle(color: AppColors.textDark),
        prefixIcon: Icon(prefixIcon),
        filled: true,
        fillColor: AppColors.inputSoft,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
          borderSide: BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
          borderSide: const BorderSide(color: AppColors.lightBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.inputContentPaddingH,
          vertical: AppDimens.inputContentPaddingV,
        ),
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    final password = _passwordController.text;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inputSoft,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.inputBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Requirements:',
            style: TextStyle(
              fontSize: AppDimens.smallFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 12),
          _buildRequirement('At least 8 characters', password.length >= 8),
          _buildRequirement('1 uppercase letter', password.contains(RegExp(r'[A-Z]'))),
          _buildRequirement('1 number', password.contains(RegExp(r'[0-9]'))),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text, bool met) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            size: 18,
            color: met ? AppColors.successGreen : AppColors.divider,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: AppDimens.smallFontSize,
              color: met ? AppColors.textDark : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: SecondaryButton(
            text: 'Back',
            onPressed: () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PrimaryButton(
            text: 'Continue',
            onPressed: () {
              final data = widget.registrationData.copyWith(
                username: _usernameController.text.trim(),
                password: _passwordController.text,
              );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OtpVerificationScreen(registrationData: data),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
