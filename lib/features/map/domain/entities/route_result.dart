import 'node.dart';

/// The output of a successful Dijkstra route calculation.
class RouteResult {
  /// Ordered list of nodes from origin to destination (inclusive).
  final List<Node> nodes;

  /// Sum of all edge weights along the path (in map distance units).
  final double totalDistance;

  /// True when every edge in the route is accessible (no stairs).
  final bool isFullyAccessible;

  const RouteResult({
    required this.nodes,
    required this.totalDistance,
    required this.isFullyAccessible,
  });

  bool get isEmpty => nodes.isEmpty;
}
