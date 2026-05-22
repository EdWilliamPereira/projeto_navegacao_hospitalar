// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'navigation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Index of the step the user is currently on.
/// A plain [Notifier] (sync) is correct here — index is an int, not async.

@ProviderFor(NavigationIndex)
final navigationIndexProvider = NavigationIndexProvider._();

/// Index of the step the user is currently on.
/// A plain [Notifier] (sync) is correct here — index is an int, not async.
final class NavigationIndexProvider
    extends $NotifierProvider<NavigationIndex, int> {
  /// Index of the step the user is currently on.
  /// A plain [Notifier] (sync) is correct here — index is an int, not async.
  NavigationIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'navigationIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$navigationIndexHash();

  @$internal
  @override
  NavigationIndex create() => NavigationIndex();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$navigationIndexHash() => r'b69c2e0b85ec87879d379d67a955f158d35e721a';

/// Index of the step the user is currently on.
/// A plain [Notifier] (sync) is correct here — index is an int, not async.

abstract class _$NavigationIndex extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Derives the full ordered list of [NavigationStep]s from the active route.
/// Returns [] when no route is active.

@ProviderFor(navigationSteps)
final navigationStepsProvider = NavigationStepsProvider._();

/// Derives the full ordered list of [NavigationStep]s from the active route.
/// Returns [] when no route is active.

final class NavigationStepsProvider
    extends
        $FunctionalProvider<
          List<NavigationStep>,
          List<NavigationStep>,
          List<NavigationStep>
        >
    with $Provider<List<NavigationStep>> {
  /// Derives the full ordered list of [NavigationStep]s from the active route.
  /// Returns [] when no route is active.
  NavigationStepsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'navigationStepsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$navigationStepsHash();

  @$internal
  @override
  $ProviderElement<List<NavigationStep>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<NavigationStep> create(Ref ref) {
    return navigationSteps(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<NavigationStep> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<NavigationStep>>(value),
    );
  }
}

String _$navigationStepsHash() => r'51ed8a29485546f29e26e63f86c35407a7b8466f';

/// The step the user is currently navigating. Null when navigation is inactive
/// or all steps have been completed.

@ProviderFor(currentStep)
final currentStepProvider = CurrentStepProvider._();

/// The step the user is currently navigating. Null when navigation is inactive
/// or all steps have been completed.

final class CurrentStepProvider
    extends
        $FunctionalProvider<NavigationStep?, NavigationStep?, NavigationStep?>
    with $Provider<NavigationStep?> {
  /// The step the user is currently navigating. Null when navigation is inactive
  /// or all steps have been completed.
  CurrentStepProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentStepProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentStepHash();

  @$internal
  @override
  $ProviderElement<NavigationStep?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  NavigationStep? create(Ref ref) {
    return currentStep(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NavigationStep? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NavigationStep?>(value),
    );
  }
}

String _$currentStepHash() => r'c2d5d6a1ddc78433b4b9c9831f60a3509faf3bed';
