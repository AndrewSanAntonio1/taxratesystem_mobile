import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_strings.dart';
import 'package:taxratesystem_mobile/core/routing/app_router.dart';
import 'package:taxratesystem_mobile/widgets/otp_input_field.dart';
import 'package:taxratesystem_mobile/widgets/resend_code_area.dart';
import 'package:taxratesystem_mobile/widgets/verification_code_view.dart';

/// Step 2 of password recovery: confirm the code sent to the account's email.
///
/// Redesigned to the same `verification.png` reference as the registration step
/// ([OtpVerificationScreen]), so the two screens that both ask the user to verify
/// their account no longer drift: same brand mark, same copy rhythm, same
/// underline code slots and green CTA.
///
/// The flow is unchanged: a typed code continues to the new-password step
/// ([AppNavigation.openNewPassword]). The address the user typed on the previous
/// step travels with the route (see `PasswordResetOtpArgs`), so the destination
/// line names it; a route opened without one falls back to a generic phrase.
class PasswordResetOtpScreen extends StatefulWidget {
  const PasswordResetOtpScreen({super.key, this.email = ''});

  /// Address collected by the forgot-password step: the destination of the code,
  /// named under the helper line.
  final String email;

  @override
  State<PasswordResetOtpScreen> createState() => _PasswordResetOtpScreenState();
}

class _PasswordResetOtpScreenState extends State<PasswordResetOtpScreen> {
  final GlobalKey<OtpInputFieldState> _otpKey = GlobalKey<OtpInputFieldState>();

  /// Repaints the resend cooldown once a second; the countdown itself is owned by
  /// [OtpInputField], so this screen only mirrors its state into
  /// [ResendCodeArea].
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
    return VerificationCodeView(
      title: AppStrings.verifyAccountTitle,
      message: AppStrings.verifyCodeSentTo,
      destination: VerificationCodeView.destinationFor(widget.email),
      codeField: OtpInputField(
        key: _otpKey,
        style: OtpFieldStyle.underlined,
        obscureDigits: true,
        autofocus: true,
        onChanged: (_) {},
      ),
      resendArea: _buildResendArea(),
      actionLabel: AppStrings.verifyAction,
      onAction: () => context.openNewPassword(),
      backLabel: AppStrings.back,
      onBack: () => Navigator.pop(context),
    );
  }

  Widget _buildResendArea() {
    final OtpInputFieldState? state = _otpKey.currentState;
    return ResendCodeArea(
      canResend: state?.canResend ?? false,
      secondsRemaining: state?.secondsRemaining ?? 0,
      onResend: () => state?.resend(),
    );
  }
}
