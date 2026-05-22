enum NodeType { room, elevator, stairs, junction, entrance }

/// A vertex in the hospital graph.
/// Pure Dart — no framework or serialization dependencies.
class Node {
  final String id;
  final String name;
  final int floor;
  final double x; // Local canvas coordinate
  final double y;
  final NodeType type;

  const Node({
    required this.id,
    required this.name,
    required this.floor,
    required this.x,
    required this.y,
    required this.type,
  });

  /// Convenience getter used by the accessibility filter in CalculateRoute.
  bool get isAccessible => type != NodeType.stairs;
}
