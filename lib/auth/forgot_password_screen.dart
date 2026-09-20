import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/constants/app_strings.dart';
import 'package:taxratesystem_mobile/core/routing/app_router.dart';
import 'package:taxratesystem_mobile/widgets/brand_mark.dart';
import 'package:taxratesystem_mobile/widgets/primary_button.dart';

/// Step 1 of password recovery: collect the account email.
///
/// Redesigned against the project's `forgot-password.png` reference: one task
/// per screen — a centred brand mark, a hero title, a single helper paragraph,
/// one filled field and a full-width green CTA on white, with generous
/// breathing room and no chrome.
///
/// The flow is unchanged: the address collected here is followed by the
/// verification-code step ([context.openPasswordResetOtp]). The back
/// affordance the reference omits is kept as a quiet text link, so the screen
/// stays escapable without a platform gesture.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Vertical rhythm read off the 370x800 reference image: a long, empty band
  // above the brand mark and a wide one between the mark and the title, then
  // tight internal spacing through field and CTA.
  static const double _topSpacing = 72;
  static const double _logoToTitleSpacing = 56;
  static const double _titleToSubtitleSpacing = 14;
  static const double _subtitleToFieldSpacing = 32;
  static const double _fieldToCtaSpacing = 18;
  static const double _ctaToLinkSpacing = 20;

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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppDimens.pageHorizontalPadding,
            _topSpacing,
            AppDimens.pageHorizontalPadding,
            AppDimens.pageBottomPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BrandMark(),
              const SizedBox(height: _logoToTitleSpacing),
              const Text(
                AppStrings.forgotPasswordTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: _titleToSubtitleSpacing),
              const Text(
                AppStrings.forgotPasswordSubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.subtitleFontSize,
                  height: 1.45,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: _subtitleToFieldSpacing),
              _buildEmailField(),
              const SizedBox(height: _fieldToCtaSpacing),
              PrimaryButton(
                text: AppStrings.sendVerificationCode,
                backgroundColor: AppColors.actionGreen,
                showShadow: false,
                // The address travels to the code step, which displays it and
                // sends the code to it.
                onPressed: () => context.openPasswordResetOtp(
                  email: _emailController.text.trim(),
                ),
              ),
              const SizedBox(height: _ctaToLinkSpacing),
              _buildBackToLogin(),
            ],
          ),
        ),
      ),
    );
  }

  /// Borderless filled field: the mint fill alone marks the input, so the
  /// placeholder carries the label (as in the reference).
  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        fontSize: AppDimens.bodyFontSize,
        color: AppColors.textDark,
      ),
      decoration: InputDecoration(
        hintText: AppStrings.emailAddressHint,
        hintStyle: const TextStyle(
          fontSize: AppDimens.bodyFontSize,
          color: AppColors.textMuted,
        ),
        filled: true,
        fillColor: AppColors.inputMint,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.filledInputPaddingH,
          vertical: AppDimens.filledInputPaddingV,
        ),
        border: _fieldBorder(),
        enabledBorder: _fieldBorder(),
        focusedBorder: _fieldBorder(AppColors.actionGreen),
      ),
    );
  }

  /// Flat by default; [focusColor] draws the focus ring in the CTA colour, since
  /// a borderless field gives no other focus feedback.
  OutlineInputBorder _fieldBorder([Color? focusColor]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.borderRadiusField),
      borderSide: focusColor == null
          ? BorderSide.none
          : BorderSide(color: focusColor, width: 1.5),
    );
  }

  /// Quiet escape hatch. The reference screen is undecorated, but a user who
  /// opened this form by mistake still needs a labelled way back to login.
  Widget _buildBackToLogin() {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text(
          AppStrings.backToLogin,
          style: TextStyle(
            fontSize: AppDimens.subtitleFontSize,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
