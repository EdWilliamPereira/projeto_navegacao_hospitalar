/// A weighted, undirected connection between two graph nodes.
class Edge {
  final String origin;
  final String destination;
  final double distance; // In arbitrary map units (treated as metres for display)
  final bool accessible; // false = stairs-only segment (excluded when avoidStairs=true)

  const Edge({
    required this.origin,
    required this.destination,
    required this.distance,
    required this.accessible,
  });
}
