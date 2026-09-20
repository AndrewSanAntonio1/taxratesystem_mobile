import 'package:flutter/widgets.dart';
import 'package:taxratesystem_mobile/core/di/app_dependencies.dart';

/// Makes the app's [AppDependencies] available to the widget tree.
///
/// This is the dependency-injection seam (InheritedWidget is Flutter's built-in
/// mechanism, so no third-party state-management package is needed). Widgets
/// call `DependencyScope.of(context)` — or the typed getters below — instead of
/// reaching for singletons, which is what makes them testable.
class DependencyScope extends InheritedWidget {
  const DependencyScope({
    super.key,
    required this.dependencies,
    required super.child,
  });

  final AppDependencies dependencies;

  /// Looks up the dependencies registered above [context].
  ///
  /// Throws a descriptive [FlutterError] when the scope is missing, which turns
  /// a confusing null crash into an actionable message.
  static AppDependencies of(BuildContext context) {
    final DependencyScope? scope =
        context.dependOnInheritedWidgetOfExactType<DependencyScope>();
    if (scope == null) {
      throw FlutterError(
        'DependencyScope.of() was called with a context that does not contain '
        'a DependencyScope.\n'
        'Make sure the widget is built below the DependencyScope installed by '
        'MyApp in lib/main.dart (or wrap it in a test).',
      );
    }
    return scope.dependencies;
  }

  /// Resolves dependencies if a scope is present, otherwise returns `null`.
  ///
  /// Lets leaf widgets fall back to sensible defaults instead of crashing.
  static AppDependencies? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DependencyScope>()?.dependencies;

  @override
  bool updateShouldNotify(DependencyScope oldWidget) =>
      dependencies != oldWidget.dependencies;
}

/// Terse, discoverable accessors: `context.dependencies.historyController`.
extension DependencyScopeContext on BuildContext {
  AppDependencies get dependencies => DependencyScope.of(this);

  AppDependencies? get maybeDependencies => DependencyScope.maybeOf(this);
}
