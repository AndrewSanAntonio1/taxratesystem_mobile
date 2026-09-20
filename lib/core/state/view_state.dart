/// The four states any asynchronous screen can be in.
///
/// Using a sealed hierarchy (instead of separate `isLoading` / `error` fields)
/// makes the states mutually exclusive by construction and forces every
/// consumer to handle loading, empty and error explicitly.
sealed class ViewState<T> {
  const ViewState();

  /// Convenience accessor for code that only needs "the value, if any".
  T? get valueOrNull => switch (this) {
        ViewStateData<T>(:final T value) => value,
        _ => null,
      };

  bool get isLoading => this is ViewStateLoading<T>;
  bool get isEmpty => this is ViewStateEmpty<T>;
  bool get hasError => this is ViewStateError<T>;
}

/// Data is being fetched. Renders a spinner.
final class ViewStateLoading<T> extends ViewState<T> {
  const ViewStateLoading();
}

/// Data was fetched successfully. Renders [value].
final class ViewStateData<T> extends ViewState<T> {
  const ViewStateData(this.value);

  final T value;
}

/// The request succeeded but there is nothing to show. Renders an empty state.
final class ViewStateEmpty<T> extends ViewState<T> {
  const ViewStateEmpty();
}

/// The request failed. Renders [message] with a retry affordance.
final class ViewStateError<T> extends ViewState<T> {
  const ViewStateError(this.message);

  final String message;
}