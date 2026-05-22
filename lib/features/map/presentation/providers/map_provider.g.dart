// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The datasource is initialised in main() and injected via
/// ProviderScope.overrides — this provider is the fallback.

@ProviderFor(mapLocalDataSource)
final mapLocalDataSourceProvider = MapLocalDataSourceProvider._();

/// The datasource is initialised in main() and injected via
/// ProviderScope.overrides — this provider is the fallback.

final class MapLocalDataSourceProvider
    extends
        $FunctionalProvider<
          MapLocalDataSource,
          MapLocalDataSource,
          MapLocalDataSource
        >
    with $Provider<MapLocalDataSource> {
  /// The datasource is initialised in main() and injected via
  /// ProviderScope.overrides — this provider is the fallback.
  MapLocalDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapLocalDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapLocalDataSourceHash();

  @$internal
  @override
  $ProviderElement<MapLocalDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MapLocalDataSource create(Ref ref) {
    return mapLocalDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapLocalDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapLocalDataSource>(value),
    );
  }
}

String _$mapLocalDataSourceHash() =>
    r'2b35e89474bcdd12c3e60900657dfd2e7d5420bc';

@ProviderFor(mapRepository)
final mapRepositoryProvider = MapRepositoryProvider._();

final class MapRepositoryProvider
    extends $FunctionalProvider<MapRepository, MapRepository, MapRepository>
    with $Provider<MapRepository> {
  MapRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapRepositoryHash();

  @$internal
  @override
  $ProviderElement<MapRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapRepository create(Ref ref) {
    return mapRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapRepository>(value),
    );
  }
}

String _$mapRepositoryHash() => r'0af7785df0ee355b254e11f43f370ec0a9fc555a';

@ProviderFor(getFloorGraph)
final getFloorGraphProvider = GetFloorGraphProvider._();

final class GetFloorGraphProvider
    extends $FunctionalProvider<GetFloorGraph, GetFloorGraph, GetFloorGraph>
    with $Provider<GetFloorGraph> {
  GetFloorGraphProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getFloorGraphProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getFloorGraphHash();

  @$internal
  @override
  $ProviderElement<GetFloorGraph> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetFloorGraph create(Ref ref) {
    return getFloorGraph(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetFloorGraph value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetFloorGraph>(value),
    );
  }
}

String _$getFloorGraphHash() => r'217f9fb905590cb071b60862d21896f93693aea1';

@ProviderFor(getAllPois)
final getAllPoisProvider = GetAllPoisProvider._();

final class GetAllPoisProvider
    extends $FunctionalProvider<GetAllPois, GetAllPois, GetAllPois>
    with $Provider<GetAllPois> {
  GetAllPoisProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getAllPoisProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getAllPoisHash();

  @$internal
  @override
  $ProviderElement<GetAllPois> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetAllPois create(Ref ref) {
    return getAllPois(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetAllPois value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetAllPois>(value),
    );
  }
}

String _$getAllPoisHash() => r'3ce768644531096ab9e4295e2251d809aaa67dca';

@ProviderFor(calculateRoute)
final calculateRouteProvider = CalculateRouteProvider._();

final class CalculateRouteProvider
    extends $FunctionalProvider<CalculateRoute, CalculateRoute, CalculateRoute>
    with $Provider<CalculateRoute> {
  CalculateRouteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'calculateRouteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$calculateRouteHash();

  @$internal
  @override
  $ProviderElement<CalculateRoute> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CalculateRoute create(Ref ref) {
    return calculateRoute(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CalculateRoute value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CalculateRoute>(value),
    );
  }
}

String _$calculateRouteHash() => r'5631721f161f157d048b9a3588c7eda7803be1ec';

/// Currently selected floor — drives map canvas and node filter (FR-01).

@ProviderFor(SelectedFloor)
final selectedFloorProvider = SelectedFloorProvider._();

/// Currently selected floor — drives map canvas and node filter (FR-01).
final class SelectedFloorProvider
    extends $NotifierProvider<SelectedFloor, int> {
  /// Currently selected floor — drives map canvas and node filter (FR-01).
  SelectedFloorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedFloorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedFloorHash();

  @$internal
  @override
  SelectedFloor create() => SelectedFloor();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$selectedFloorHash() => r'48705968a45672db9791bb05662dc67a6e6b8932';

/// Currently selected floor — drives map canvas and node filter (FR-01).

abstract class _$SelectedFloor extends $Notifier<int> {
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

/// Kept alive so the camera position survives floor changes.

@ProviderFor(mapController)
final mapControllerProvider = MapControllerProvider._();

/// Kept alive so the camera position survives floor changes.

final class MapControllerProvider
    extends $FunctionalProvider<MapController, MapController, MapController>
    with $Provider<MapController> {
  /// Kept alive so the camera position survives floor changes.
  MapControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapControllerHash();

  @$internal
  @override
  $ProviderElement<MapController> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapController create(Ref ref) {
    return mapController(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapController>(value),
    );
  }
}

String _$mapControllerHash() => r'44b58685f9922d33731780e3e9210eebeecc66ca';

/// Manually set "I'm here" node — the origin for all route calculations (FR-06).

@ProviderFor(UserLocation)
final userLocationProvider = UserLocationProvider._();

/// Manually set "I'm here" node — the origin for all route calculations (FR-06).
final class UserLocationProvider
    extends $NotifierProvider<UserLocation, String?> {
  /// Manually set "I'm here" node — the origin for all route calculations (FR-06).
  UserLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userLocationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userLocationHash();

  @$internal
  @override
  UserLocation create() => UserLocation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$userLocationHash() => r'4b1b7631a148f8bfda4207dbaa1bca6a7d95f3de';

/// Manually set "I'm here" node — the origin for all route calculations (FR-06).

abstract class _$UserLocation extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(SelectedDestination)
final selectedDestinationProvider = SelectedDestinationProvider._();

final class SelectedDestinationProvider
    extends $NotifierProvider<SelectedDestination, String?> {
  SelectedDestinationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedDestinationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedDestinationHash();

  @$internal
  @override
  SelectedDestination create() => SelectedDestination();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedDestinationHash() =>
    r'a51b74f72e81c08ecacbb18a900df630ed385cba';

abstract class _$SelectedDestination extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Nodes + edges for the current floor — rebuilds automatically when
/// [selectedFloorProvider] changes.

@ProviderFor(floorGraph)
final floorGraphProvider = FloorGraphProvider._();

/// Nodes + edges for the current floor — rebuilds automatically when
/// [selectedFloorProvider] changes.

final class FloorGraphProvider
    extends
        $FunctionalProvider<
          AsyncValue<FloorGraph>,
          FloorGraph,
          FutureOr<FloorGraph>
        >
    with $FutureModifier<FloorGraph>, $FutureProvider<FloorGraph> {
  /// Nodes + edges for the current floor — rebuilds automatically when
  /// [selectedFloorProvider] changes.
  FloorGraphProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'floorGraphProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$floorGraphHash();

  @$internal
  @override
  $FutureProviderElement<FloorGraph> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<FloorGraph> create(Ref ref) {
    return floorGraph(ref);
  }
}

String _$floorGraphHash() => r'844763a3129a52390a2f92d379ee4a58d4fed6ff';

/// All POIs — kept alive so search results are instant after first load.

@ProviderFor(allPois)
final allPoisProvider = AllPoisProvider._();

/// All POIs — kept alive so search results are instant after first load.

final class AllPoisProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Poi>>,
          List<Poi>,
          FutureOr<List<Poi>>
        >
    with $FutureModifier<List<Poi>>, $FutureProvider<List<Poi>> {
  /// All POIs — kept alive so search results are instant after first load.
  AllPoisProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allPoisProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allPoisHash();

  @$internal
  @override
  $FutureProviderElement<List<Poi>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Poi>> create(Ref ref) {
    return allPois(ref);
  }
}

String _$allPoisHash() => r'ba8f0da64f2bdc4b5fb128f7a2a52c8b00bcacbe';

/// The active computed route — null when no destination has been selected.
///
/// Uses [AsyncNotifier] so the UI can observe loading/error/data states.

@ProviderFor(CurrentRoute)
final currentRouteProvider = CurrentRouteProvider._();

/// The active computed route — null when no destination has been selected.
///
/// Uses [AsyncNotifier] so the UI can observe loading/error/data states.
final class CurrentRouteProvider
    extends $NotifierProvider<CurrentRoute, AsyncValue<RouteResult?>> {
  /// The active computed route — null when no destination has been selected.
  ///
  /// Uses [AsyncNotifier] so the UI can observe loading/error/data states.
  CurrentRouteProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentRouteProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentRouteHash();

  @$internal
  @override
  CurrentRoute create() => CurrentRoute();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<RouteResult?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<RouteResult?>>(value),
    );
  }
}

String _$currentRouteHash() => r'b89781998990c454d97bebe8ee5804e9d9ba5716';

/// The active computed route — null when no destination has been selected.
///
/// Uses [AsyncNotifier] so the UI can observe loading/error/data states.

abstract class _$CurrentRoute extends $Notifier<AsyncValue<RouteResult?>> {
  AsyncValue<RouteResult?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<RouteResult?>, AsyncValue<RouteResult?>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<RouteResult?>, AsyncValue<RouteResult?>>,
              AsyncValue<RouteResult?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
