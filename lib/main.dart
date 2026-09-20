import 'package:flutter/material.dart';
import 'package:taxratesystem_mobile/constants/app_strings.dart';
import 'package:taxratesystem_mobile/core/di/app_dependencies.dart';
import 'package:taxratesystem_mobile/core/di/dependency_scope.dart';
import 'package:taxratesystem_mobile/core/routing/app_router.dart';
import 'package:taxratesystem_mobile/core/routing/app_routes.dart';
import 'package:taxratesystem_mobile/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

/// Application root.
///
/// Two responsibilities only: install the [DependencyScope] (the composition
/// root's entry point) and configure [MaterialApp] to route through
/// [AppRouter]. Feature code never constructs its own dependencies, which is
/// what makes the screens testable.
class MyApp extends StatefulWidget {
  const MyApp({super.key, this.dependencies});

  /// Overrides the production dependencies. Tests inject fakes here.
  final AppDependencies? dependencies;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppDependencies _dependencies =
      widget.dependencies ?? AppDependencies();

  /// Only dispose what we created, so an injected container stays usable by the
  /// caller (and by other tests).
  late final bool _ownsDependencies = widget.dependencies == null;

  @override
  void dispose() {
    if (_ownsDependencies) _dependencies.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DependencyScope(
      dependencies: _dependencies,
      child: MaterialApp(
        title: AppStrings.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}