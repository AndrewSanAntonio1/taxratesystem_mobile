import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/widgets/branded_header.dart';
import 'package:taxratesystem_mobile/widgets/dash_divider.dart';
import 'package:taxratesystem_mobile/widgets/otp_input_field.dart';
import 'package:taxratesystem_mobile/widgets/primary_button.dart';
import 'package:taxratesystem_mobile/widgets/secondary_button.dart';
import 'package:taxratesystem_mobile/auth/new_password_screen.dart';

class PasswordResetOtpScreen extends StatefulWidget {
  const PasswordResetOtpScreen({super.key});

  @override
  State<PasswordResetOtpScreen> createState() => _PasswordResetOtpScreenState();
}

class _PasswordResetOtpScreenState extends State<PasswordResetOtpScreen> {
  final _otpKey = GlobalKey<OtpInputFieldState>();
  Timer? _uiTimer;

  @override
  void initState() {
    super.initState();
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _uiTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final otpState = _otpKey.currentState;
    final canResend = otpState?.canResend ?? false;
    final secondsRemaining = otpState?.secondsRemaining ?? 0;

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
            text: 'Back',
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
              const DashDivider(activeIndex: 1),
              const SizedBox(height: 20),
              Text(
                'Verify Your Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the 6-digit code sent to your email.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.subtitleFontSize,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              OtpInputField(
                key: _otpKey,
                onChanged: (_) {},
              ),
              const SizedBox(height: 24),
              _buildResendArea(canResend: canResend, secondsRemaining: secondsRemaining),
              const SizedBox(height: 28),
              PrimaryButton(
                text: 'Verify',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NewPasswordScreen(),
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

  Widget _buildResendArea({required bool canResend, required int secondsRemaining}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: canResend ? () => _otpKey.currentState?.resend() : null,
          child: Text(
            'Resend Code',
            style: TextStyle(
              fontSize: AppDimens.subtitleFontSize,
              fontWeight: FontWeight.w600,
              color: canResend ? AppColors.lightBlue : AppColors.textSecondary,
            ),
          ),
        ),
        if (!canResend) ...[
          const SizedBox(width: 8),
          Text(
            'Resend in 00:${secondsRemaining.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontSize: AppDimens.smallFontSize,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
