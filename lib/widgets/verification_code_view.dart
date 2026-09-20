import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/constants/app_strings.dart';
import 'package:taxratesystem_mobile/widgets/brand_mark.dart';
import 'package:taxratesystem_mobile/widgets/primary_button.dart';

/// Shared layout of the verification-code steps.
///
/// Redesigned against the project's `verification.png` reference: a white page
/// with no chrome, a centred brand mark, a hero title, a helper line, the address
/// the code went to, the code slots and one full-width green CTA — the keypad in
/// the reference is the platform's own, so nothing replaces it here.
///
/// The code field, the resend row, the CTA target and the escape hatch are
/// injected, so the registration step and the password-reset step render one
/// layout while each keeps its own state and destination.
class VerificationCodeView extends StatelessWidget {
  const VerificationCodeView({
    super.key,
    required this.title,
    required this.message,
    required this.destination,
    required this.codeField,
    required this.actionLabel,
    required this.onAction,
    required this.backLabel,
    required this.onBack,
    this.resendArea,
  });

  final String title;

  /// Helper line read above [destination], e.g. "...has been sent to".
  final String message;

  /// The address the code was sent to, emphasised below [message].
  final String destination;

  final Widget codeField;

  /// Resend link and cooldown; omitted by a step that cannot resend.
  final Widget? resendArea;

  final String actionLabel;
  final VoidCallback onAction;
  final String backLabel;
  final VoidCallback onBack;

  // Vertical rhythm read off the 370x800 reference: a long, empty band above the
  // brand mark, a wide one before the title, then tight spacing through the code
  // slots and the CTA.
  static const double _topSpacing = 72;
  static const double _markToTitleSpacing = 56;
  static const double _titleToMessageSpacing = 26;
  static const double _messageToDestinationSpacing = 20;
  static const double _destinationToCodeSpacing = 40;
  static const double _codeToResendSpacing = 16;
  static const double _resendToCtaSpacing = 18;
  static const double _codeToCtaSpacing = 18;
  static const double _ctaToBackSpacing = 12;

  /// The destination line's text: the address the code went to, or a readable
  /// phrase when the step was reached without one, so the line never renders
  /// empty. Screens hold the raw argument and render through this.
  static String destinationFor(String email) {
    final String trimmed = email.trim();
    return trimmed.isEmpty ? AppStrings.verifyDestinationFallback : trimmed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          // The CTA scrolls with the form (as in the reference), so the page has
          // to stay scrollable once the keyboard covers the lower half.
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppDimens.pageHorizontalPadding,
            _topSpacing,
            AppDimens.pageHorizontalPadding,
            AppDimens.pageBottomPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const BrandMark(),
              const SizedBox(height: _markToTitleSpacing),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppDimens.titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: _titleToMessageSpacing),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppDimens.subtitleFontSize,
                  height: 1.4,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: _messageToDestinationSpacing),
              Text(
                destination,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: AppDimens.bodyFontSize,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: _destinationToCodeSpacing),
              codeField,
              if (resendArea != null) ...<Widget>[
                const SizedBox(height: _codeToResendSpacing),
                resendArea!,
              ],
              SizedBox(
                height: resendArea == null
                    ? _codeToCtaSpacing
                    : _resendToCtaSpacing,
              ),
              PrimaryButton(
                text: actionLabel,
                backgroundColor: AppColors.actionGreen,
                showShadow: false,
                onPressed: onAction,
              ),
              const SizedBox(height: _ctaToBackSpacing),
              _buildBackLink(),
            ],
          ),
        ),
      ),
    );
  }

  /// Quiet escape hatch. The reference screen is undecorated and leans on the
  /// platform back gesture; a visible link keeps the step escapable on a device
  /// without one, matching the other redesigned auth form.
  Widget _buildBackLink() {
    return Center(
      child: TextButton(
        onPressed: onBack,
        child: Text(
          backLabel,
          style: const TextStyle(
            fontSize: AppDimens.subtitleFontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
