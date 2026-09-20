/// Centralised user-facing copy and formatting tokens.
///
/// Screens must not hardcode labels: renaming a label or localising the app
/// should be a single-file change. Values that are *layout* concerns stay in
/// [AppDimens], values that are *colour* concerns stay in [AppColors].
class AppStrings {
  AppStrings._();

  // ---------------------------------------------------------------- branding
  static const String appTitle = 'Manila Tax Rate System';
  static const String appName = 'TaxRateSystem';
  static const String welcomeBackGreeting = 'Welcome back!';

  // ------------------------------------------------------------- formatting
  static const String currencySymbol = '₱';
  static const String amountInputPrefix = 'P ';

  // ------------------------------------------------------------- navigation
  static const String navHome = 'Home';
  static const String navTaxes = 'Taxes';
  static const String navCalculator = 'Calculator';
  static const String navHistory = 'History';
  static const String navProfile = 'Profile';

  // -------------------------------------------------------------- auth flow
  static const String helloWelcomeBack = 'Hello, Welcome back!';
  static const String login = 'Login';
  static const String createNewAccount = 'Create new account';
  static const String emailRequired = 'Email is required';
  static const String passwordRequired = 'Password is required';

  // ------------------------------------------------------ password recovery
  static const String forgotPasswordTitle = 'Forgot Password';
  static const String forgotPasswordSubtitle =
      'Enter the email address linked to your account and we will send you a verification code.';
  static const String emailAddressHint = 'Email Address';
  static const String sendVerificationCode = 'Send Verification Code';
  static const String backToLogin = 'Back to Login';

  // ------------------------------------------------- verification code steps
  static const String verifyAccountTitle = 'Verify Your Account';
  static const String verifyCodeSentTo =
      'A 6-digit verification code has been sent to';

  /// Stands in for the address when the route carries none, so the destination
  /// line still reads as a sentence.
  static const String verifyDestinationFallback = 'your email address';
  static const String verifyAction = 'Verify';
  static const String back = 'Back';
  static const String resendCode = 'Resend Code';
  static const String resendAvailableNow = 'You can now resend the code';

  /// Cooldown line shown beneath [resendCode] while the timer is running.
  static String resendCountdown(int seconds) =>
      'Resend in 00:${seconds.toString().padLeft(2, '0')}';

  // -------------------------------------------------- create new password step
  static const String newPasswordTitle = 'Create New Password';
  static const String newPasswordHint = 'New Password *';
  static const String confirmPasswordHint = 'Confirm New Password *';
  static const String resetPasswordAction = 'Reset Password';
  static const String passwordRuleMinLength = 'At least 8 characters';
  static const String passwordRuleUppercase = '1 uppercase letter';
  static const String passwordRuleNumber = '1 number';

  /// Footnote of the create-new-password reference. "Sign in" leaves the reset
  /// flow, where the user already has the account they are recovering.
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signIn = 'Sign in';
  static const String passwordResetSuccessTitle =
      'Password Reset Successfully!';
  static const String passwordResetSuccessMessage =
      'Your password has been updated. You can now log in with your new credentials.';

  // ----------------------------------------------------------- sign up step
  static const String signUpTitle = 'Sign Up';
  static const String fullNameHint = 'Full name';
  static const String phoneHint = 'Phone';
  static const String passwordHint = 'Password';
  static const String countryHint = 'Country';
  static const String signUpAction = 'Sign Up';

  /// Per-field errors of the single-step signup form. [passwordRequired] and
  /// [passwordRuleMinLength] are shared with the other auth forms.
  static const String fullNameRequired = 'Full name is required';
  static const String phoneRequired = 'Phone number is required';
  static const String countryRequired = 'Select your country';

  /// Shortlist behind the signup form's country dropdown. A literal list until
  /// a backend catalogue exists; the Philippines leads it as the app's market.
  static const List<String> signupCountries = <String>[
    'Philippines',
    'United States',
    'Canada',
    'Australia',
    'United Kingdom',
    'Germany',
  ];

  /// Confirmation card of the finished signup — the flow's only feedback,
  /// since there is no verification or review step after the form.
  static const String accountCreatedTitle = 'Account Created Successfully!';
  static const String accountCreatedMessage =
      'Your account has been created. You can now log in to access the system.';
  static const String accountCreatedAction = 'Proceed to Login';

  // -------------------------------------------------------------- calculator
  static const String taxCalculatorTitle = 'Tax Calculator';
  static const String selectTaxType = 'Select Tax Type';
  static const String taxableIncomeLabel = 'Taxable Income (PHP)';
  static const String amountHint = 'Enter amount';
  static const String amountHelper = 'Enter annual gross taxable income';
  static const String calculateTax = 'Calculate Tax';
  static const String calculationResultTitle = 'Calculation Result';
  static const String calculateAgain = 'Calculate Again';
  static const String saveCalculation = 'Save Calculation';
  static const String calculationSaved = 'Calculation saved to history';
  static const String calculatedTaxAmountLabel = 'Calculated Tax Amount';
  static const String taxableIncomeDetailLabel = 'Taxable Income';
  static const String taxableBaseLabel = 'Taxable Base';
  static const String applicableBracketLabel = 'Applicable Bracket';
  static const String effectiveRuleLabel = 'Effective Rule';
  static const String stepByStepBreakdown = 'Step-by-Step Breakdown';

  // ----------------------------------------------------------------- history
  static const String calculationHistoryTitle = 'Calculation History';
  static const String noSavedCalculationsTitle = 'No saved calculations yet';
  static const String noSavedCalculationsMessage =
      'Calculate a tax and tap "Save Calculation" to keep it here.';
  static const String savedCalculationTitle = 'Saved Calculation';
  static const String backToHistory = 'Back to History';
  static const String viewDetails = 'View Details >';
  static const String sortNewestFirst = 'Newest first';
  static const String sortOldestFirst = 'Oldest first';

  // ------------------------------------------------------------------ taxes
  static const String taxesTitle = 'Taxes';
  static const String calculateThisTax = 'Calculate This Tax';
  static const String noTaxTypesTitle = 'No tax types available';
  static const String noTaxTypesMessage =
      'The tax catalogue is empty. Please try again.';
  static const String taxDetailMissingTitle = 'No reference data yet';
  static const String taxDetailMissingMessage =
      'Reference details for this tax type have not been published.';
  static const String currentRateLabel = 'Current Rate';
  static const String effectiveDateLabel = 'Effective Date';
  static const String bracketsLabel = 'Tax Brackets';
  static const String taxRateColumnLabel = 'Tax Rate';
  static const String exampleTitle = 'Example Calculation';
  static const String amountLabel = 'Amount';
  static const String computationLabel = 'Computation';
  static const String estimatedTaxLabel = 'Estimated Tax';

  // ---------------------------------------------------------------- profile
  static const String profileTitle = 'Profile & Settings';
  static const String accountSection = 'ACCOUNT';
  static const String changePassword = 'Change Password';
  static const String notificationSettings = 'Notification Settings';
  static const String logout = 'Logout';
  static const String logoutConfirmMessage =
      'Are you sure you want to log out?';
  static const String cancel = 'Cancel';
  static const String unknownUser = 'Signed-in user';
  static const String unknownUserEmail = '—';
  static const String sessionLoading = 'Loading your profile...';

  // ----------------------------------------------------------------- errors
  static const String invalidAmountError = 'Enter a valid taxable amount';
  static const String genericErrorMessage =
      'Something went wrong. Please try again.';
  static const String retry = 'Retry';
}
