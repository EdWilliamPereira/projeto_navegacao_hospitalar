// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Shared preferences instance — keepAlive so it is not recreated on every
/// navigation event.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// Shared preferences instance — keepAlive so it is not recreated on every
/// navigation event.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          AsyncValue<SharedPreferences>,
          SharedPreferences,
          FutureOr<SharedPreferences>
        >
    with
        $FutureModifier<SharedPreferences>,
        $FutureProvider<SharedPreferences> {
  /// Shared preferences instance — keepAlive so it is not recreated on every
  /// navigation event.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $FutureProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SharedPreferences> create(Ref ref) {
    return sharedPreferences(ref);
  }
}

String _$sharedPreferencesHash() => r'ad13470fe866595ad0f58a3e26f11048d94ef22e';

/// FR-07, FR-09: whether routes should exclude stair edges.

@ProviderFor(AvoidStairs)
final avoidStairsProvider = AvoidStairsProvider._();

/// FR-07, FR-09: whether routes should exclude stair edges.
final class AvoidStairsProvider
    extends $AsyncNotifierProvider<AvoidStairs, bool> {
  /// FR-07, FR-09: whether routes should exclude stair edges.
  AvoidStairsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'avoidStairsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$avoidStairsHash();

  @$internal
  @override
  AvoidStairs create() => AvoidStairs();
}

String _$avoidStairsHash() => r'e7aed0f533ff2bc0187a85753a070f9f625b3dd8';

/// FR-07, FR-09: whether routes should exclude stair edges.

abstract class _$AvoidStairs extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// FR-10: high-contrast theme flag.

@ProviderFor(HighContrast)
final highContrastProvider = HighContrastProvider._();

/// FR-10: high-contrast theme flag.
final class HighContrastProvider
    extends $AsyncNotifierProvider<HighContrast, bool> {
  /// FR-10: high-contrast theme flag.
  HighContrastProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'highContrastProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$highContrastHash();

  @$internal
  @override
  HighContrast create() => HighContrast();
}

String _$highContrastHash() => r'0277f3123941c4cdd26917db0e1f85325be44eda';

/// FR-10: high-contrast theme flag.

abstract class _$HighContrast extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
