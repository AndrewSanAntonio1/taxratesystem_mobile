import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/constants/app_strings.dart';

/// "Resend Code" link with its cooldown line underneath.
///
/// Both verification screens render this, so the countdown copy and the
/// enabled/disabled colouring live in one place. The countdown itself is owned by
/// the code field; a screen passes the field's current values down on each tick.
class ResendCodeArea extends StatelessWidget {
  const ResendCodeArea({
    super.key,
    required this.canResend,
    required this.secondsRemaining,
    required this.onResend,
  });

  final bool canResend;
  final int secondsRemaining;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: canResend ? onResend : null,
          child: Text(
            AppStrings.resendCode,
            style: TextStyle(
              fontSize: AppDimens.subtitleFontSize,
              fontWeight: FontWeight.w600,
              // The CTA green marks the link as live; the muted grey keeps a
              // cooling-down link from reading as an action.
              color: canResend ? AppColors.actionGreen : AppColors.textMuted,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          secondsRemaining > 0
              ? AppStrings.resendCountdown(secondsRemaining)
              : AppStrings.resendAvailableNow,
          style: const TextStyle(
            fontSize: AppDimens.tinyFontSize,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}
