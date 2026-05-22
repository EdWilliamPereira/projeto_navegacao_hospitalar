import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../settings/presentation/providers/settings_provider.dart';
import '../providers/map_provider.dart';
import '../widgets/floor_selector.dart';
import '../widgets/map_overlay_layer.dart';
import '../widgets/route_polyline_layer.dart';
import 'package:hospital_nav/features/map/domain/entities/route_result.dart';
import 'package:hospital_nav/features/map/presentation/widgets/map_zoom_controls.dart';

/// Converts local canvas coordinates (arbitrary units) to a fake LatLng
/// space for flutter_map rendering. 1 unit ≈ 1 mm at 1:1000 scale.
/// The map has no real GPS dependency — FR-06 (manual "I'm here") handles
/// the user's position without any location permission.
LatLng nodeToLatLng(double x, double y) => LatLng(y / 1000, x / 1000);

/// Returns a [LatLngBounds] that fits all nodes in a route, or null if empty.
LatLngBounds? routeToLatLngBounds(RouteResult route) {
  if (route.isEmpty) return null;
  final points = route.nodes.map((n) => nodeToLatLng(n.x, n.y)).toList();
  return LatLngBounds.fromPoints(points);
}

class MapPage extends ConsumerWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graphAsync = ref.watch(floorGraphProvider);
    final routeAsync = ref.watch(currentRouteProvider);
    final currentFloor = ref.watch(selectedFloorProvider);
    final userNodeId = ref.watch(userLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Map'),
        actions: [
          IconButton(
            tooltip: 'Search destination',
            icon: const Icon(Icons.search),
            onPressed: () => context.pushNamed('search'),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () => context.pushNamed('settings'),
          ),
        ],
      ),
      body: graphAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(message: e.toString()),
        data: (graph) => Stack(
          children: [
            FlutterMap(
              mapController: ref.watch(mapControllerProvider),
              options: const MapOptions(
                initialCenter: LatLng(0.5, 0.5),
                initialZoom: 13,
                minZoom: 10,
                maxZoom: 18,
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.pinchZoom |
                      InteractiveFlag.drag |
                      InteractiveFlag.doubleTapZoom,
                ),
              ),
              children: [
                // Floor plan raster image — replace with real asset per floor.
                // flutter_map ^8 uses OverlayImageLayer + OverlayImage.
                OverlayImageLayer(
                  overlayImages: [
                    OverlayImage(
                      bounds: LatLngBounds(
                        const LatLng(0, 0),
                        const LatLng(1, 1),
                      ),
                      imageProvider: AssetImage(
                        'assets/floor_plans/floor_$currentFloor.png',
                        //'assets/floor_plans/floor_plans.png',
                      ),
                    ),
                  ],
                ),

                // POI markers — tapping a node sets "I'm here" (FR-06).
                MapOverlayLayer(
                  nodes: graph.nodes,
                  userNodeId: userNodeId,
                  onNodeTap: (nodeId) {
                    final origin = ref.read(userLocationProvider);
                    final destination = ref.read(selectedDestinationProvider);

                    // Second tap on the origin → deselect it (and clear route)
                    if (origin == nodeId) {
                      ref.read(userLocationProvider.notifier).clear();
                      ref.read(selectedDestinationProvider.notifier).clear();
                      ref.read(currentRouteProvider.notifier).clear();
                      return;
                    }
                    // Tap on a new origin node → select it and pan to it
                    else if (origin == null) {
                      ref.read(userLocationProvider.notifier).setLocation(nodeId);
                      return;
                    }
                    // Second tap on the destination → deselect it (and clear route)
                    else if (destination == nodeId) {
                      ref.read(selectedDestinationProvider.notifier).clear();
                      ref.read(currentRouteProvider.notifier).clear();
                      return;
                    }
                    // Origin exists, no destination yet → set destination and compute
                    else if (destination == null) {
                      ref.read(selectedDestinationProvider.notifier).setDestination(nodeId);
                      ref.read(currentRouteProvider.notifier).computeRoute(
                        destinationId: nodeId,
                        avoidStairs: ref.read(avoidStairsProvider).value ?? false,
                      );
                    }
                  },
                ),

                // Route polyline (FR-03) — visible only when a route exists.
                routeAsync.when(
                  data: (route) => route != null
                      ? RoutePolylineLayer(route: route)
                      : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),

            // Floor selector — positioned over the map (FR-01).
            Positioned(
              right: 12,
              bottom: 120,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Zoom controls — always visible
                  MapZoomControls(
                    controller: ref.watch(mapControllerProvider),
                    routeBounds: routeAsync.when(
                      data: (route) =>
                          route != null ? routeToLatLngBounds(route) : null,
                      loading: () => null,
                      error: (_, __) => null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Floor selector — unchanged
                  FloorSelector(
                    currentFloor: currentFloor,
                    onFloorChanged: (floor) =>
                        ref.read(selectedFloorProvider.notifier).setFloor(floor),
                  ),
                ],
              ),
            ),

            // Error banner for route failures.
            if (routeAsync.hasError)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _RouteErrorBanner(
                  message: routeAsync.error.toString(),
                  onDismiss: () =>
                      ref.read(currentRouteProvider.notifier).clear(),
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: routeAsync.when(
        data: (route) => route != null && !route.isEmpty ? FloatingActionButton.extended(
          onPressed: () => context.pushNamed(
            'navigate',
            pathParameters: {'destinationId': route.nodes.last.id},
          ),
          icon: const Icon(Icons.navigation),
          label: const Text('Start navigation'),
        )
        : null,
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    ),
  );
}

class _RouteErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;
  const _RouteErrorBanner({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.errorContainer,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            color: Theme.of(context).colorScheme.onErrorContainer,
            onPressed: onDismiss,
          ),
        ],
      ),
    ),
  );
}
