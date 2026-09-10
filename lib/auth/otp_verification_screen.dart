import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/auth/registration_data.dart';
import 'package:taxratesystem_mobile/auth/review_screen.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/widgets/branded_header.dart';
import 'package:taxratesystem_mobile/widgets/otp_input_field.dart';
import 'package:taxratesystem_mobile/widgets/primary_button.dart';
import 'package:taxratesystem_mobile/widgets/secondary_button.dart';
import 'package:taxratesystem_mobile/widgets/step_progress_indicator.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    this.registrationData = const RegistrationData(),
  });

  final RegistrationData registrationData;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final GlobalKey<OtpInputFieldState> _otpKey = GlobalKey<OtpInputFieldState>();
  Timer? _uiTimer;

  @override
  void initState() {
    super.initState();
    _uiTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _uiTimer?.cancel();
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
              const StepProgressIndicator(totalSteps: 4, currentStep: 2),
              const SizedBox(height: 24),
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
                'Enter the 6-digit verification code sent to your email address',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.subtitleFontSize,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              OtpInputField(key: _otpKey, onChanged: (_) {}),
              const SizedBox(height: 24),
              _buildResendArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResendArea() {
    final state = _otpKey.currentState;
    final enabled = state?.canResend ?? false;
    final secondsRemaining = state?.secondsRemaining ?? 0;
    return Column(
      children: [
        GestureDetector(
          onTap: enabled && state != null ? state.resend : null,
          child: Text(
            'Resend Code',
            style: TextStyle(
              fontSize: AppDimens.subtitleFontSize,
              fontWeight: FontWeight.w600,
              color: enabled ? AppColors.lightBlue : AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          secondsRemaining > 0
              ? 'Resend in 00:${secondsRemaining.toString().padLeft(2, '0')}'
              : 'You can now resend the code',
          style: TextStyle(
            fontSize: AppDimens.tinyFontSize,
            color: AppColors.textSecondary,
          ),
        ),
      ],
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      ReviewScreen(registrationData: widget.registrationData),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}