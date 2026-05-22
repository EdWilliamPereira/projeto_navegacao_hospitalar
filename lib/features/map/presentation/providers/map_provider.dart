import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../data/datasources/map_local_datasource.dart';
import '../../data/repositories/map_repository_impl.dart';
import '../../domain/entities/poi.dart';
import '../../domain/entities/route_result.dart';
import '../../domain/repositories/map_repository.dart';
import '../../domain/usecases/calculate_route.dart';
import '../../domain/usecases/get_all_pois.dart';
import '../../domain/usecases/get_floor_graph.dart';
import 'package:flutter_map/flutter_map.dart';

part 'map_provider.g.dart';

// Infrastructure (keepAlive — survive navigation)

/// The datasource is initialised in main() and injected via
/// ProviderScope.overrides — this provider is the fallback.
@Riverpod(keepAlive: true)
MapLocalDataSource mapLocalDataSource(Ref ref) => MapLocalDataSourceImpl();

@Riverpod(keepAlive: true)
MapRepository mapRepository(Ref ref) =>
    MapRepositoryImpl(ref.watch(mapLocalDataSourceProvider));

// Use-case providers

@riverpod
GetFloorGraph getFloorGraph(Ref ref) =>
    GetFloorGraph(ref.watch(mapRepositoryProvider));

@riverpod
GetAllPois getAllPois(Ref ref) =>
    GetAllPois(ref.watch(mapRepositoryProvider));

@riverpod
CalculateRoute calculateRoute(Ref ref) =>
    CalculateRoute(ref.watch(mapRepositoryProvider));

// UI state providers

/// Currently selected floor — drives map canvas and node filter (FR-01).
@riverpod
class SelectedFloor extends _$SelectedFloor {
  @override
  int build() => 0; // Ground floor on launch

  void setFloor(int floor) => state = floor;
}

/// Kept alive so the camera position survives floor changes.
@Riverpod(keepAlive: true)
MapController mapController(Ref ref) => MapController();

/// Manually set "I'm here" node — the origin for all route calculations (FR-06).
@Riverpod(keepAlive: true)
class UserLocation extends _$UserLocation {
  @override
  String? build() => null;

  void setLocation(String nodeId) => state = nodeId;
  void clear() => state = null;
}

// Tracks the destination
@Riverpod(keepAlive: true)
class SelectedDestination extends _$SelectedDestination {
  @override
  String? build() => null;

  void setDestination(String nodeId) => state = nodeId;
  void clear() => state = null;
}

/// Nodes + edges for the current floor — rebuilds automatically when
/// [selectedFloorProvider] changes.
@riverpod
Future<FloorGraph> floorGraph(Ref ref) async {
  final floor = ref.watch(selectedFloorProvider);
  final useCase = ref.watch(getFloorGraphProvider);
  final result = await useCase(floor: floor);
  return result.fold(
    (failure) => throw failure,
    (graph) => graph,
  );
}

/// All POIs — kept alive so search results are instant after first load.
@Riverpod(keepAlive: true)
Future<List<Poi>> allPois(Ref ref) async {
  final useCase = ref.watch(getAllPoisProvider);
  final result = await useCase();
  return result.fold(
    (failure) => throw failure,
    (pois) => pois,
  );
}

/// The active computed route — null when no destination has been selected.
///
/// Uses [AsyncNotifier] so the UI can observe loading/error/data states.
@riverpod
class CurrentRoute extends _$CurrentRoute {
  @override
  AsyncValue<RouteResult?> build() => const AsyncData(null);

  Future<void> computeRoute({
    required String destinationId,
    required bool avoidStairs,
  }) async {
    final origin = ref.read(userLocationProvider);
    if (origin == null) {
      state = AsyncError(
        const GraphFailure('Please set your current location first.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    final useCase = ref.read(calculateRouteProvider);
    final result = await useCase(
      CalculateRouteParams(
        originNodeId: origin,
        destinationNodeId: destinationId,
        avoidStairs: avoidStairs,
      ),
    );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      AsyncData.new,
    );
  }

  void clear() => state = const AsyncData(null);
}
