/// Direction a user should turn when reaching a node.
enum TurnDirection {
  straight,
  left,
  right,
  slightLeft,
  slightRight,
  arrival,
}

/// A single human-readable step in a turn-by-turn navigation sequence.
class NavigationStep {
  final String instruction;     // e.g. "Turn right at the elevator lobby"
  final double distanceMeters;  // Distance to walk before taking this turn
  final TurnDirection direction;
  final String referenceNodeId; // The node this step points toward

  const NavigationStep({
    required this.instruction,
    required this.distanceMeters,
    required this.direction,
    required this.referenceNodeId,
  });
}
