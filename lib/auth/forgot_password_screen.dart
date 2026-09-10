import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/widgets/branded_header.dart';
import 'package:taxratesystem_mobile/widgets/dash_divider.dart';
import 'package:taxratesystem_mobile/widgets/primary_button.dart';
import 'package:taxratesystem_mobile/widgets/secondary_button.dart';
import 'package:taxratesystem_mobile/auth/password_reset_otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _emailFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocusNode.dispose();
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
          child: SecondaryButton(
            text: 'Back to Login',
            onPressed: () => Navigator.pop(context),
          ),
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
              const SizedBox(height: 16),
              const DashDivider(activeIndex: 0),
              const SizedBox(height: 20),
              Text(
                'Forgot Password?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your email address to reset your password.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.subtitleFontSize,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              _buildEmailField(),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Send Verification Code',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PasswordResetOtpScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        hintText: 'Email Address *',
        hintStyle: TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(
          Icons.email_outlined,
          color: AppColors.textSecondary,
        ),
        filled: true,
        fillColor: AppColors.inputSoft,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.inputContentPaddingH,
          vertical: AppDimens.inputContentPaddingV,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
          borderSide: BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
          borderSide: BorderSide(color: AppColors.inputBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
          borderSide: const BorderSide(color: AppColors.focusBlue, width: 2),
        ),
      ),
    );
  }
}
