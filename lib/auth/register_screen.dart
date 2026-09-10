import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_dimens.dart';
import 'package:taxratesystem_mobile/auth/account_setup_screen.dart';
import 'package:taxratesystem_mobile/auth/registration_data.dart';
import 'package:taxratesystem_mobile/widgets/branded_header.dart';
import 'package:taxratesystem_mobile/widgets/step_progress_indicator.dart';
import 'package:taxratesystem_mobile/widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _brgyController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _zipController = TextEditingController();
  String? _suffix;
  DateTime? _dateOfBirth;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _brgyController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _zipController.dispose();
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
          child: PrimaryButton(
            text: 'Next',
            onPressed: _handleNext,
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
              const SizedBox(height: 20),
              const StepProgressIndicator(totalSteps: 4, currentStep: 0),
              const SizedBox(height: 24),
              Text(
                'Create Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please provide your personal and address details',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppDimens.subtitleFontSize,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader(Icons.person_outlined, 'Personal Information'),
              const SizedBox(height: 16),
              _buildFirstNameRow(),
              const SizedBox(height: 16),
              _buildDateOfBirthField(),
              const SizedBox(height: 16),
              _buildEmailField(),
              const SizedBox(height: 24),
              _buildSectionHeader(Icons.home_outlined, 'Address Information'),
              const SizedBox(height: 16),
              _buildTextField(_brgyController, 'Brgy', Icons.location_on_outlined),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(_streetController, 'Street', Icons.streetview),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(_cityController, 'City', Icons.location_city_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(_provinceController, 'Province', Icons.map_outlined),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(_zipController, 'Zip Code', Icons.numbers, keyboardType: TextInputType.number),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNext() {
    final data = RegistrationData(
      fullName: _firstNameController.text.trim(),
      gender: '',
      birthDate: _dateOfBirth,
      contactNumber: '',
      brgy: _brgyController.text.trim(),
      street: _streetController.text.trim(),
      city: _cityController.text.trim(),
      province: _provinceController.text.trim(),
      zip: _zipController.text.trim(),
      email: _emailController.text.trim(),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AccountSetupScreen(registrationData: data),
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textDark, size: 22),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildFirstNameRow() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: _firstNameController,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            style: TextStyle(color: AppColors.textDark),
            decoration: InputDecoration(
              labelText: 'First Name *',
              hintText: 'First Name *',
              hintStyle: TextStyle(color: AppColors.textSecondary),
              labelStyle: TextStyle(color: AppColors.textSecondary),
              floatingLabelStyle: TextStyle(color: AppColors.textDark),
              filled: true,
              fillColor: AppColors.inputFill,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
                borderSide: const BorderSide(color: AppColors.lightBlue, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimens.inputContentPaddingH,
                vertical: AppDimens.inputContentPaddingV,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.inputFill,
              borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
            ),
            child: DropdownButton<String>(
              value: _suffix,
              isExpanded: true,
              underline: const SizedBox(),
              dropdownColor: AppColors.surface,
              hint: Text(
                'Suffix',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              style: TextStyle(color: AppColors.textDark, fontSize: 14),
              items: ['None', 'JR', 'SR', 'II', 'III', 'IV', 'V']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _suffix = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateOfBirthField() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _dateOfBirth ?? DateTime(2000),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) {
          setState(() {
            _dateOfBirth = picked;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          hintText: 'Date of Birth',
          hintStyle: TextStyle(color: AppColors.textSecondary),
          labelStyle: TextStyle(color: AppColors.textSecondary),
          floatingLabelStyle: TextStyle(color: AppColors.textDark),
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          filled: true,
          fillColor: AppColors.inputFill,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
            borderSide: const BorderSide(color: AppColors.lightBlue, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimens.inputContentPaddingH,
            vertical: AppDimens.inputContentPaddingV,
          ),
        ),
        child: Text(
          _dateOfBirth != null
              ? '${_dateOfBirth!.day}/${_dateOfBirth!.month}/${_dateOfBirth!.year}'
              : 'Select date',
          style: TextStyle(
            color: _dateOfBirth != null ? AppColors.textDark : AppColors.textSecondary,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        labelText: 'Email Address *',
        hintText: 'Email Address *',
        hintStyle: TextStyle(color: AppColors.textSecondary),
        labelStyle: TextStyle(color: AppColors.textSecondary),
        floatingLabelStyle: TextStyle(color: AppColors.textDark),
        prefixIcon: const Icon(Icons.email_outlined),
        filled: true,
        fillColor: AppColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
          borderSide: const BorderSide(color: AppColors.lightBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.inputContentPaddingH,
          vertical: AppDimens.inputContentPaddingV,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: AppColors.textDark),
      decoration: InputDecoration(
        labelText: label,
        hintText: label,
        hintStyle: TextStyle(color: AppColors.textSecondary),
        labelStyle: TextStyle(color: AppColors.textSecondary),
        floatingLabelStyle: TextStyle(color: AppColors.textDark),
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: AppColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.borderRadiusSmall),
          borderSide: const BorderSide(color: AppColors.lightBlue, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.inputContentPaddingH,
          vertical: AppDimens.inputContentPaddingV,
        ),
      ),
    );
  }
}
