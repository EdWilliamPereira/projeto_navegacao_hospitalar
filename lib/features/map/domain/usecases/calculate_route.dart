import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/edge.dart';
import '../entities/node.dart';
import '../entities/route_result.dart';
import '../repositories/map_repository.dart';

class CalculateRouteParams {
  final String originNodeId;
  final String destinationNodeId;

  /// FR-09: when true, stair-only edges are excluded from the graph entirely
  /// before Dijkstra runs — not just penalised.
  final bool avoidStairs;

  const CalculateRouteParams({
    required this.originNodeId,
    required this.destinationNodeId,
    required this.avoidStairs,
  });
}

class CalculateRoute {
  final MapRepository _repository;

  const CalculateRoute(this._repository);

  Future<EitherFailure<RouteResult>> call(CalculateRouteParams params) async {
    final nodesResult = await _repository.getNodes();
    final edgesResult = await _repository.getEdges();

    return nodesResult.flatMap(
      (nodes) => edgesResult.flatMap(
        (edges) => _dijkstra(
          nodes: nodes,
          edges: edges,
          originId: params.originNodeId,
          destinationId: params.destinationNodeId,
          avoidStairs: params.avoidStairs,
        ),
      ),
    );
  }

  EitherFailure<RouteResult> _dijkstra({
    required List<Node> nodes,
    required List<Edge> edges,
    required String originId,
    required String destinationId,
    required bool avoidStairs,
  }) {
    // Validation
    final nodeMap = {for (final n in nodes) n.id: n};

    if (!nodeMap.containsKey(originId)) {
      return left(const GraphFailure('Origin node not found in graph'));
    }
    if (!nodeMap.containsKey(destinationId)) {
      return left(const GraphFailure('Destination node not found in graph'));
    }

    // Build undirected adjacency list
    // When avoidStairs=true, inaccessible edges are excluded entirely.
    // This guarantees the result is a fully accessible route, not just the
    // shortest one — consistent with FR-09's "absence of stairs" criterion.
    final adj = <String, List<(String, double)>>{};
    for (final e in edges) {
      if (avoidStairs && !e.accessible) continue;
      // Insert both directions (undirected graph).
      adj.putIfAbsent(e.origin, () => []).add((e.destination, e.distance));
      adj.putIfAbsent(e.destination, () => []).add((e.origin, e.distance));
    }

    // Dijkstra
    // A sorted list is used as the priority queue. Acceptable for < 2,000
    // nodes. For larger graphs, replace with package:collection HeapPriorityQueue.
    final dist = <String, double>{originId: 0.0};
    final prev = <String, String?>{originId: null};
    final visited = <String>{};
    // Queue entries: (tentative distance, node id)
    final queue = <(double, String)>[(0.0, originId)];

    while (queue.isNotEmpty) {
      // Pop the closest unvisited node
      queue.sort((a, b) => a.$1.compareTo(b.$1));
      final (currentDist, currentId) = queue.removeAt(0);

      if (visited.contains(currentId)) continue;
      visited.add(currentId);

      // Early exit if destination is reached
      if (currentId == destinationId) break;

      for (final (String neighbourId, double weight) in (adj[currentId] ?? [])) {
        final tentative = currentDist + weight;
        if (tentative < (dist[neighbourId] ?? double.infinity)) {
          dist[neighbourId] = tentative;
          prev[neighbourId] = currentId;
          queue.add((tentative, neighbourId));
        }
      }
    }

    // ── Check reachability ────────────────────────────────────────────────
    if (!dist.containsKey(destinationId)) {
      return left(const RouteNotFoundFailure(
        'No accessible route found between the selected points.',
      ));
    }

    // ── Reconstruct path ──────────────────────────────────────────────────
    // Walk prev[] backwards from destination to origin, then reverse.
    // `path` is declared as `var` (not `final`) so it can be reassigned
    // after the reversal — this is the one intentional exception to the
    // `final`-by-default rule.
    var path = <Node>[];
    String? current = destinationId;
    while (current != null) {
      path.add(nodeMap[current]!);
      current = prev[current];
    }
    path = path.reversed.toList();

    // ── Check full accessibility of reconstructed path ────────────────────
    // Even when avoidStairs=false the caller may want to know whether the
    // shortest path happens to be stair-free (used for polyline colouring).
    var fullyAccessible = true;
    for (var i = 0; i < path.length - 1; i++) {
      final segmentAccessible = edges.any(
        (e) =>
            ((e.origin == path[i].id && e.destination == path[i + 1].id) ||
                (e.destination == path[i].id && e.origin == path[i + 1].id)) &&
            e.accessible,
      );
      if (!segmentAccessible) {
        fullyAccessible = false;
        break;
      }
    }

    return right(RouteResult(
      nodes: path,
      totalDistance: dist[destinationId]!,
      isFullyAccessible: fullyAccessible,
    ));
  }
}