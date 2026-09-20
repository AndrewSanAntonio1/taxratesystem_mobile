import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/constants/app_strings.dart';
import 'package:taxratesystem_mobile/core/routing/app_router.dart';
import 'package:taxratesystem_mobile/widgets/app_password_field.dart';
import 'package:taxratesystem_mobile/widgets/brand_mark.dart';
import 'package:taxratesystem_mobile/widgets/primary_button.dart';

/// Redesigned against the project's `signup.png` reference: a white page whose
/// whole spine is the brand mark, one centred "Sign Up" title, four borderless
/// capsule fields (full name, phone, password, country) and the green CTA above
/// a quiet sign-in line.
///
/// One page only: Sign Up is the whole flow — a valid form shows the
/// "Account created" confirmation and returns to login. There is no account
/// verification or review step after it.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Vertical rhythm carried over from the other redesigned auth screens
  // (NewPasswordScreen): a long band above the mark, a wide one before the
  // title, then tight spacing through the fields and the CTA.
  static const double _topSpacing = 72;
  static const double _markToTitleSpacing = 64;
  static const double _titleToFieldSpacing = 47;
  static const double _fieldGap = 12;
  static const double _fieldToCtaSpacing = 24;
  static const double _ctaToFootnoteSpacing = 6;

  /// "Sign Up" title of the reference, between the old [AppDimens.titleFontSize]
  /// (22) and header size (28) — measured as the page's dominant line there.
  static const double _titleFontSize = 32;

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _country;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Serialises the four capsule fields and finishes the flow: a valid form
  /// shows the "Account created" confirmation, and acknowledging it lands the
  /// user on login. Sign Up is one page — there is no verification or review
  /// step after it.
  void _handleSignUp() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _showAccountCreatedModal();
  }

  /// "Account Created Successfully!" card, carried over from the retired
  /// review step: the flow's confirmation, whose button resets the app to
  /// login (discarding the signup state with it).
  void _showAccountCreatedModal() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => _AccountCreatedDialog(
        onProceed: () {
          Navigator.of(dialogContext).pop(); // close the card first
          context.replaceWithLogin(); // then reset the flow to login
        },
      ),
    );
  }

  /// Escape hatch of the sign-in line. Normally the screen was pushed from
  /// login, so popping keeps whatever the user had typed there; a deep-linked
  /// screen with no stack falls back to replacing with login, as the reset
  /// flow's footnote does.
  void _goToLogin() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      context.replaceWithLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          // The CTA scrolls with the form, as on the other redesigned auth
          // screens, so the keyboard cannot trap the button.
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
              Text(
                AppStrings.signUpTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: _titleToFieldSpacing),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildFullNameField(),
                    const SizedBox(height: _fieldGap),
                    _buildPhoneField(),
                    const SizedBox(height: _fieldGap),
                    _buildPasswordField(),
                    const SizedBox(height: _fieldGap),
                    _buildCountryDropdown(),
                  ],
                ),
              ),
              const SizedBox(height: _fieldToCtaSpacing),
              PrimaryButton(
                text: AppStrings.signUpAction,
                backgroundColor: AppColors.actionGreen,
                showShadow: false,
                onPressed: _handleSignUp,
              ),
              const SizedBox(height: _ctaToFootnoteSpacing),
              _buildSignInLine(),
            ],
          ),
        ),
      ),
    );
  }


  /// Capsule of the auth redesign: the mint fill alone marks the input and the
  /// placeholder carries the label, as on the other redesigned auth screens.
  /// The three text fields share it so they cannot drift apart; the password
  /// capsule's reveal toggle lives in [AppPasswordField].
  InputDecoration _capsuleDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: AppDimens.bodyFontSize,
        color: AppColors.textMuted,
      ),
      filled: true,
      fillColor: AppColors.inputMint,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.filledInputPaddingH,
        vertical: AppDimens.capsuleInputPaddingV,
      ),
      border: _capsuleBorder(),
      enabledBorder: _capsuleBorder(),
      focusedBorder: _capsuleBorder(AppColors.actionGreen),
    );
  }

  /// Flat by default; [focusColor] draws the focus ring in the action colour,
  /// since a borderless capsule gives no other focus feedback.
  OutlineInputBorder _capsuleBorder([Color? focusColor]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppDimens.borderRadiusLarge),
      borderSide: focusColor == null
          ? BorderSide.none
          : BorderSide(color: focusColor, width: 1.5),
    );
  }

  Widget _buildFullNameField() {
    return TextFormField(
      controller: _fullNameController,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(
        fontSize: AppDimens.bodyFontSize,
        color: AppColors.textDark,
      ),
      decoration: _capsuleDecoration(AppStrings.fullNameHint),
      validator: (value) => (value == null || value.trim().isEmpty)
          ? AppStrings.fullNameRequired
          : null,
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      style: const TextStyle(
        fontSize: AppDimens.bodyFontSize,
        color: AppColors.textDark,
      ),
      decoration: _capsuleDecoration(AppStrings.phoneHint),
      validator: (value) => (value == null || value.trim().isEmpty)
          ? AppStrings.phoneRequired
          : null,
    );
  }

  Widget _buildPasswordField() {
    return AppPasswordField(
      controller: _passwordController,
      hintText: AppStrings.passwordHint,
      obscure: _obscurePassword,
      onToggle: () => setState(() => _obscurePassword = !_obscurePassword),
      style: AppPasswordFieldStyle.capsule,
      validator: (value) =>
          (value == null || value.isEmpty) ? AppStrings.passwordRequired : null,
    );
  }

  /// Reference's fourth capsule. A value is mandatory — the validator marks it
  /// like the other fields — and the choice lands in [RegistrationData.country].
  Widget _buildCountryDropdown() {
    return DropdownButtonFormField<String>(
      // initialValue, not the deprecated `value` — this is a form field and the
      // selection starts empty (the hint shows) until the user picks a country.
      initialValue: _country,
      isExpanded: true,
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: AppColors.textMuted,
      ),
      dropdownColor: AppColors.surface,
      style: const TextStyle(
        fontSize: AppDimens.bodyFontSize,
        color: AppColors.textDark,
      ),
      decoration: _capsuleDecoration(AppStrings.countryHint),
      items: AppStrings.signupCountries
          .map(
            (country) => DropdownMenuItem<String>(
              value: country,
              child: Text(country),
            ),
          )
          .toList(),
      onChanged: (value) => setState(() => _country = value),
      validator: (value) =>
          (value == null || value.isEmpty) ? AppStrings.countryRequired : null,
    );
  }

  /// "Already have an account? Sign In" footnote of the reference, under the
  /// CTA instead of the old top-right back arrow. Popping keeps the login
  /// screen and whatever the user had typed there; the replacement fallback
  /// serves deep links, where nothing sits underneath to pop to.
  Widget _buildSignInLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppStrings.alreadyHaveAccount,
          style: const TextStyle(
            fontSize: AppDimens.bodyFontSize,
            color: AppColors.textMuted,
          ),
        ),
        TextButton(
          onPressed: _goToLogin,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            AppStrings.signIn,
            style: const TextStyle(
              fontSize: AppDimens.bodyFontSize,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ),
      ],
    );
  }
}

/// "Account Created Successfully!" card of the finished signup, carried over
/// from the retired review step: the green check, the headline, one explainer
/// line and the single "Proceed to Login" CTA that closes the flow.
class _AccountCreatedDialog extends StatelessWidget {
  const _AccountCreatedDialog({required this.onProceed});

  final VoidCallback onProceed;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusLarge),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: AppColors.successCheck,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppStrings.accountCreatedTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppDimens.titleFontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppStrings.accountCreatedMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppDimens.subtitleFontSize,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: AppDimens.buttonHeight,
              child: ElevatedButton(
                onPressed: onProceed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.deepNavy,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimens.borderRadiusLarge),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppStrings.accountCreatedAction,
                  style: TextStyle(
                    fontSize: AppDimens.bodyFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
