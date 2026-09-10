import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/calculator/history_screen.dart';
import 'package:taxratesystem_mobile/calculator/tax_calculator_screen.dart';
import 'package:taxratesystem_mobile/constants/app_colors.dart';
import 'package:taxratesystem_mobile/home/dashboard_screen.dart';
import 'package:taxratesystem_mobile/profile/profile_screen.dart';
import 'package:taxratesystem_mobile/taxes/taxes_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: AppColors.surface,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        surfaceTintColor: Colors.transparent,
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        indicatorColor: AppColors.focusBlue.withValues(alpha: 0.1),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: AppColors.navInactive),
            selectedIcon: Icon(Icons.home, color: AppColors.navActive),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined, color: AppColors.navInactive),
            selectedIcon: Icon(Icons.receipt_long, color: AppColors.navActive),
            label: 'Taxes',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined, color: AppColors.navInactive),
            selectedIcon: Icon(Icons.calculate, color: AppColors.navActive),
            label: 'Calculator',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined, color: AppColors.navInactive),
            selectedIcon: Icon(Icons.history, color: AppColors.navActive),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: AppColors.navInactive),
            selectedIcon: Icon(Icons.person, color: AppColors.navActive),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
