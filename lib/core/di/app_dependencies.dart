import 'package:taxratesystem_mobile/data/repositories/in_memory_history_repository.dart';
import 'package:taxratesystem_mobile/data/repositories/local_auth_repository.dart';
import 'package:taxratesystem_mobile/data/repositories/local_tax_calculation_repository.dart';
import 'package:taxratesystem_mobile/data/repositories/static_tax_reference_repository.dart';
import 'package:taxratesystem_mobile/domain/repositories/auth_repository.dart';
import 'package:taxratesystem_mobile/domain/repositories/history_repository.dart';
import 'package:taxratesystem_mobile/domain/repositories/tax_calculation_repository.dart';
import 'package:taxratesystem_mobile/domain/repositories/tax_reference_repository.dart';
import 'package:taxratesystem_mobile/presentation/controllers/history_controller.dart';
import 'package:taxratesystem_mobile/presentation/controllers/session_controller.dart';

/// The composition root: the single place that decides which concrete
/// implementation satisfies each abstraction.
///
/// Nothing else in the app constructs a repository, and no repository is a
/// global singleton, so:
///
/// * swapping the offline implementations for HTTP ones is a change to this
///   file only;
/// * a test can build an `AppDependencies` with fakes and inject it through
///   [DependencyScope].
///
/// App-lifetime controllers live here too, so a screen never has to own state
/// that outlives it.
class AppDependencies {
  /// Builds a container with the production implementations, allowing any
  /// single dependency to be overridden (used by tests).
  AppDependencies({
    HistoryRepository? historyRepository,
    TaxReferenceRepository? taxReferenceRepository,
    AuthRepository? authRepository,
    TaxCalculationRepository? taxCalculationRepository,
  })  : historyRepository = historyRepository ?? InMemoryHistoryRepository(),
        taxReferenceRepository =
            taxReferenceRepository ?? const StaticTaxReferenceRepository(),
        authRepository = authRepository ?? LocalAuthRepository(),
        taxCalculationRepository =
            taxCalculationRepository ?? const LocalTaxCalculationRepository();

  final HistoryRepository historyRepository;
  final TaxReferenceRepository taxReferenceRepository;
  final AuthRepository authRepository;
  final TaxCalculationRepository taxCalculationRepository;

  /// App-wide history state, shared by the result screen (writes) and the
  /// history tab (reads).
  late final HistoryController historyController =
      HistoryController(historyRepository);

  /// App-wide session state, shared by login, the home shell and the profile.
  late final SessionController sessionController =
      SessionController(authRepository);

  void dispose() {
    historyController.dispose();
    sessionController.dispose();
  }
}
