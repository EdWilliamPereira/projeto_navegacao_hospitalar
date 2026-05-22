// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Global router — exposed as a Riverpod provider so it can be overridden
/// in widget tests without touching GoRouter's static global state.
///
/// go_router ^17: Router is kept alive automatically; no keepAlive annotation needed.

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Global router — exposed as a Riverpod provider so it can be overridden
/// in widget tests without touching GoRouter's static global state.
///
/// go_router ^17: Router is kept alive automatically; no keepAlive annotation needed.

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Global router — exposed as a Riverpod provider so it can be overridden
  /// in widget tests without touching GoRouter's static global state.
  ///
  /// go_router ^17: Router is kept alive automatically; no keepAlive annotation needed.
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'e989d53f419d5ed19d9a6f551b9c3b1f97722a82';
