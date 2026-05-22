import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../map/domain/entities/node.dart';
import '../../../map/presentation/providers/map_provider.dart';
import '../../domain/entities/navigation_step.dart';

part 'navigation_provider.g.dart';

/// Index of the step the user is currently on.
/// A plain [Notifier] (sync) is correct here — index is an int, not async.
@riverpod
class NavigationIndex extends _$NavigationIndex {
  @override
  int build() => 0;

  void advance() => state = state + 1;
  void reset() => state = 0;
}

/// Derives the full ordered list of [NavigationStep]s from the active route.
/// Returns [] when no route is active.
@riverpod
List<NavigationStep> navigationSteps(Ref ref) {
  final routeAsync = ref.watch(currentRouteProvider);
  return routeAsync.when(
    data: (route) {
      if (route == null || route.isEmpty) return [];
      return _buildSteps(route.nodes);
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// The step the user is currently navigating. Null when navigation is inactive
/// or all steps have been completed.
@riverpod
NavigationStep? currentStep(Ref ref) {
  final steps = ref.watch(navigationStepsProvider);
  final index = ref.watch(navigationIndexProvider);
  if (steps.isEmpty || index >= steps.length) return null;
  return steps[index];
}

// Step builder

List<NavigationStep> _buildSteps(List<Node> nodes) {
  final steps = <NavigationStep>[];

  for (var i = 0; i < nodes.length - 1; i++) {
    final from = nodes[i];
    final to = nodes[i + 1];
    final isLast = i == nodes.length - 2;

    final direction = isLast
        ? TurnDirection.arrival
        : _detectTurn(
            prev: i > 0 ? nodes[i - 1] : null,
            current: from,
            next: to,
          );

    steps.add(NavigationStep(
      instruction: _instructionLabel(direction, to.name),
      distanceMeters: _euclidean(from, to),
      direction: direction,
      referenceNodeId: to.id,
    ));
  }

  return steps;
}

/// Computes the turn direction at [current] based on the incoming vector
/// (prev→current) and the outgoing vector (current→next).
/// Returns [TurnDirection.straight] when [prev] is null (first step).
TurnDirection _detectTurn({
  required Node? prev,
  required Node current,
  required Node next,
}) {
  if (prev == null) return TurnDirection.straight;

  final bearing1 = math.atan2(current.y - prev.y, current.x - prev.x);
  final bearing2 = math.atan2(next.y - current.y, next.x - current.x);

  // Angle change in degrees, normalised to [-180, 180].
  var angle = (bearing2 - bearing1) * 180 / math.pi;
  while (angle > 180) {
    angle -= 360;
  }
  while (angle < -180) {
    angle += 360;
  }

  if (angle.abs() < 20) return TurnDirection.straight;
  if (angle > 60) return TurnDirection.left;
  if (angle < -60) return TurnDirection.right;
  if (angle > 20) return TurnDirection.slightLeft;
  return TurnDirection.slightRight;
}

String _instructionLabel(TurnDirection dir, String nodeName) {
  return switch (dir) {
    TurnDirection.straight => 'Continue straight towards $nodeName',
    TurnDirection.left => 'Turn left towards $nodeName',
    TurnDirection.right => 'Turn right towards $nodeName',
    TurnDirection.slightLeft => 'Slight left towards $nodeName',
    TurnDirection.slightRight => 'Slight right towards $nodeName',
    TurnDirection.arrival => 'You have arrived at $nodeName',
  };
}

double _euclidean(Node a, Node b) {
  final dx = b.x - a.x;
  final dy = b.y - a.y;
  return math.sqrt(dx * dx + dy * dy);
}
