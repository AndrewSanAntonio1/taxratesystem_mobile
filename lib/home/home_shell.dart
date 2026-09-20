import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/calculator/history_screen.dart';
import 'package:taxratesystem_mobile/calculator/tax_calculator_screen.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/constants/app_strings.dart';
import 'package:taxratesystem_mobile/core/di/dependency_scope.dart';
import 'package:taxratesystem_mobile/home/dashboard_screen.dart';
import 'package:taxratesystem_mobile/profile/profile_screen.dart';
import 'package:taxratesystem_mobile/taxes/taxes_screen.dart';
import 'package:taxratesystem_mobile/widgets/docking_bar.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Gives the profile tab an identity even when the session is restored
    // rather than created by an explicit sign-in. Idempotent by design.
    context.dependencies.sessionController.ensureLoaded();
  }

  final _screens = const [
    DashboardScreen(),
    TaxesScreen(),
    TaxCalculatorScreen(showAppBar: false),
    HistoryScreen(showAppBar: false),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: _screens[_currentIndex],
      bottomNavigationBar: DockingBar(
        activeIndex: _currentIndex,
        onSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        icons: const [
          Icons.home,
          Icons.receipt_long,
          Icons.calculate,
          Icons.history,
          Icons.person,
        ],
        labels: const [
          AppStrings.navHome,
          AppStrings.navTaxes,
          AppStrings.navCalculator,
          AppStrings.navHistory,
          AppStrings.navProfile,
        ],
      ),
    );
  }
}
