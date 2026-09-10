import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/auth/registration_data.dart';
import 'package:taxratesystem_mobile/auth/login_screen.dart';
import 'package:taxratesystem_mobile/widgets/branded_header.dart';
import 'package:taxratesystem_mobile/widgets/step_progress_indicator.dart';
import 'package:taxratesystem_mobile/widgets/primary_button.dart';
import 'package:taxratesystem_mobile/widgets/secondary_button.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({
    super.key,
    this.registrationData = const RegistrationData(),
  });

  final RegistrationData registrationData;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool _agreed = false;

  RegistrationData get _data => widget.registrationData;

  String get _fullAddress {
    final parts = [_data.brgy, _data.street, _data.city, _data.province, _data.zip]
        .where((p) => p.trim().isNotEmpty)
        .toList();
    return parts.isEmpty ? '—' : parts.join(', ');
  }

  String get _formattedBirthDate {
    final d = _data.birthDate;
    if (d == null) return '—';
    return '${d.day}/${d.month}/${d.year}';
  }

  void _showSuccessModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
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
                'Account Created Successfully!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your account has been verified and set up. You can now log in to access the system.',
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
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepNavy,
                    foregroundColor: AppColors.textPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.borderRadiusLarge),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Proceed to Login',
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
      ),
    );
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
              _buildProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                'Review Your Information',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please check your details before creating your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.subtitleFontSize,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              _buildSummaryCard(
                icon: Icons.person_outline,
                title: 'Personal Information',
                children: [
                  _buildDataRow('Full Name', _data.fullName),
                  _buildDataRow('Birthday', _formattedBirthDate),
                  _buildDataRow('Gender', _data.gender),
                ],
              ),
              const SizedBox(height: 16),
              _buildSummaryCard(
                icon: Icons.location_on_outlined,
                title: 'Address Information',
                children: [
                  _buildDataRow('Complete Address', _fullAddress),
                  _buildDataRow('Contact Number', _data.contactNumber),
                ],
              ),
              const SizedBox(height: 16),
              _buildSummaryCard(
                icon: Icons.shield_outlined,
                title: 'Account Details',
                children: [
                  _buildDataRow('Username', _data.username),
                  _buildDataRow('Email', _data.email),
                ],
              ),
              const SizedBox(height: 20),
              _buildTermsCheckbox(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return const StepProgressIndicator(
      totalSteps: 4,
      currentStep: 3,
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.inputContentPaddingH),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.borderRadiusMedium),
        border: Border.all(color: AppColors.inputBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.textDark, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppDimens.subtitleFontSize,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value.trim().isEmpty ? '—' : value.trim(),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: AppDimens.subtitleFontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: _agreed,
              activeColor: AppColors.lightBlue,
              onChanged: (value) {
                setState(() {
                  _agreed = value ?? false;
                });
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: AppDimens.smallFontSize,
                  color: AppColors.textDark,
                ),
                children: [
                  TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms & Conditions',
                    style: TextStyle(
                      color: AppColors.lightBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      color: AppColors.lightBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
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
            text: 'Create Account',
            onPressed: () {
              if (_agreed) {
                _showSuccessModal();
              }
            },
          ),
        ),
      ],
    );
  }
}
