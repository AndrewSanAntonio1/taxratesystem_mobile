import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/constants/app_strings.dart';
import 'package:taxratesystem_mobile/core/routing/app_router.dart';
import 'package:taxratesystem_mobile/widgets/app_password_field.dart';
import 'package:taxratesystem_mobile/widgets/brand_mark.dart';
import 'package:taxratesystem_mobile/widgets/primary_button.dart';
import 'package:taxratesystem_mobile/widgets/success_overlay_card.dart';

/// Step 3 of password recovery: choose the new password.
///
/// Redesigned against the project's `create-newpassword.png` reference: a white,
/// undecorated page whose whole spine is the brand mark, one hero title, two
/// borderless capsule fields, the green CTA and a quiet sign-in line. The lockup
/// at the top of the reference is this app's own logo asset, and the keypad in
/// it is the platform's.
///
/// Two things the reference does not show are kept because the flow needs them:
/// the live password rules (rendered here as a quiet panel beside the fields
/// rather than the outlined card of the old layout) and the success card that
/// closes the reset. The back affordance the reference omits is carried by the
/// sign-in line, so the screen stays escapable without a platform gesture.
class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  // Vertical rhythm read off the 370x800 reference: a long, empty band above
  // the brand mark, a wide one before the title, then tight spacing through the
  // fields, the rules panel and the CTA.
  static const double _topSpacing = 72;
  static const double _markToTitleSpacing = 64;
  static const double _titleToFieldSpacing = 47;
  static const double _fieldGap = 12;
  static const double _fieldToRulesSpacing = 16;
  static const double _rulesToCtaSpacing = 18;
  static const double _ctaToFootnoteSpacing = 6;
  static const double _ruleGap = 10;

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
    context.replaceWithLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _showSuccess ? Colors.transparent : AppColors.surface,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              // The CTA scrolls with the form (as in the reference), so the page
              // stays scrollable once the keyboard covers the lower half.
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
                  const SizedBox(height: _markToTitleSpacing),
                  const Text(
                    AppStrings.newPasswordTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppDimens.titleFontSize,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: _titleToFieldSpacing),
                  AppPasswordField(
                    controller: _newPasswordController,
                    hintText: AppStrings.newPasswordHint,
                    style: AppPasswordFieldStyle.capsule,
                    obscure: _obscureNew,
                    onToggle: () => setState(() {
                      _obscureNew = !_obscureNew;
                    }),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: _fieldGap),
                  AppPasswordField(
                    controller: _confirmPasswordController,
                    hintText: AppStrings.confirmPasswordHint,
                    style: AppPasswordFieldStyle.capsule,
                    obscure: _obscureConfirm,
                    onToggle: () => setState(() {
                      _obscureConfirm = !_obscureConfirm;
                    }),
                  ),
                  const SizedBox(height: _fieldToRulesSpacing),
                  _buildPasswordRules(),
                  const SizedBox(height: _rulesToCtaSpacing),
                  PrimaryButton(
                    text: AppStrings.resetPasswordAction,
                    backgroundColor: AppColors.actionGreen,
                    showShadow: false,
                    onPressed: () {
                      setState(() {
                        _showSuccess = true;
                      });
                    },
                  ),
                  const SizedBox(height: _ctaToFootnoteSpacing),
                  _buildSignInLine(),
                ],
              ),
            ),
          ),
          if (_showSuccess)
            Positioned.fill(child: Container(color: AppColors.surface)),
          if (_showSuccess)
            Center(
              child: SuccessOverlayCard(
                title: AppStrings.passwordResetSuccessTitle,
                message: AppStrings.passwordResetSuccessMessage,
                buttonText: AppStrings.backToLogin,
                onPressed: _goToLogin,
              ),
            ),
        ],
      ),
    );
  }

  /// Live password rules. The reference has no such panel, but the rules are
  /// what let the user fix the password before submitting, so they stay — as a
  /// quiet, borderless panel that echoes the fields' own surface rather than the
  /// outlined card the old layout used.
  Widget _buildPasswordRules() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.filledInputPaddingH,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.inputSoft,
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRule(
            label: AppStrings.passwordRuleMinLength,
            met: _hasMinLength,
          ),
          const SizedBox(height: _ruleGap),
          _buildRule(
            label: AppStrings.passwordRuleUppercase,
            met: _hasUppercase,
          ),
          const SizedBox(height: _ruleGap),
          _buildRule(label: AppStrings.passwordRuleNumber, met: _hasNumber),
        ],
      ),
    );
  }

  Widget _buildRule({required String label, required bool met}) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.circle_outlined,
          size: 18,
          color: met ? AppColors.actionGreen : AppColors.textMuted,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: AppDimens.smallFontSize,
            color: met ? AppColors.actionGreen : AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  /// Footnote of the reference. Its accent is a muted purple that is not part of
  /// this app's palette, so the actionable half carries the action green of the
  /// auth redesign instead. Tapping it leaves the reset flow for login — the
  /// escape hatch the reference's undecorated page would otherwise not have.
  Widget _buildSignInLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Flexible(
          child: Text(
            AppStrings.alreadyHaveAccount,
            style: TextStyle(
              fontSize: AppDimens.subtitleFontSize,
              color: AppColors.textMuted,
            ),
          ),
        ),
        TextButton(
          onPressed: _goToLogin,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.actionGreen,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            minimumSize: const Size(0, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            AppStrings.signIn,
            style: TextStyle(
              fontSize: AppDimens.subtitleFontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
