import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../domain/entities/route_result.dart';
import '../pages/map_page.dart';

/// Draws the computed route as a coloured polyline on the flutter_map canvas.
/// Blue = fully accessible route. Orange = route contains at least one stair segment.
/// The colour difference satisfies FR-09's "absence of stairs" feedback requirement.
class RoutePolylineLayer extends StatelessWidget {
  final RouteResult route;

  const RoutePolylineLayer({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final points = route.nodes.map((node) => nodeToLatLng(node.x, node.y)).toList();

    return PolylineLayer(
      polylines: [
        Polyline(
          points: points,
          color: route.isFullyAccessible ? Colors.blue : Colors.orange,
          strokeWidth: 5,
          borderColor: Colors.white,
          borderStrokeWidth: 2,
        ),
      ],
    );
  }
}
