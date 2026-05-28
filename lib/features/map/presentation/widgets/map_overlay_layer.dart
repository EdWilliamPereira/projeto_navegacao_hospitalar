import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../domain/entities/node.dart';
import '../pages/map_page.dart'; // nodeToLatLng

/// Renders a [Marker] for every node in the current floor graph.
/// Tapping any marker invokes [onNodeTap] with the tapped node's id,
/// allowing the user to set "I'm here" (FR-06).
class MapOverlayLayer extends StatelessWidget {
  final List<Node> nodes;
  final String? userNodeId;
  final ValueChanged<String> onNodeTap;

  const MapOverlayLayer({
    super.key,
    required this.nodes,
    required this.onNodeTap,
    this.userNodeId,
  });

  @override
  Widget build(BuildContext context) {
    // flutter_map ^8: MarkerLayer accepts a List<Marker>.
    return MarkerLayer(
      markers: nodes.map((node) {
        final isUser = node.id == userNodeId;
        return Marker(
          width: 36,
          height: 36,
          point: nodeToLatLng(node.x, node.y),
          child: GestureDetector(
            onTap: () => onNodeTap(node.id),
            child: Semantics(
              label: isUser
                  ? 'Your current location: ${node.name}'
                  : '${node.type.name}: ${node.name}. Tap to set as your location.',
              child: Icon(
                _iconForType(node.type, isUser),
                color: isUser ? Colors.blue : _colorForType(node.type, context),
                size: 30,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

/*
  IconData _iconForType(NodeType type, bool isUser) {
    if (isUser) return Icons.my_location;
    return switch (type) {
      NodeType.room => Icons.door_back_door,
      NodeType.elevator => Icons.elevator,
      NodeType.stairs => Icons.stairs,
      NodeType.junction => Icons.hub,
      NodeType.entrance => Icons.login,
    };
  }
*/
  IconData _iconForType(NodeType type, bool isUser) {
    if (isUser) return Icons.my_location;
    return switch (type) {
      NodeType.elevador => Icons.elevator,
      NodeType.escada => Icons.stairs,
      NodeType.entrada => Icons.door_front_door,
      NodeType.quarto => Icons.room,
      NodeType.juncao => Icons.circle_outlined,
    };
  }

/*
  Color _colorForType(NodeType type, BuildContext context) {
    return switch (type) {
      NodeType.quarto => Colors.blue,
      NodeType.elevador => Colors.orange,
      NodeType.escada => Colors.red,
      NodeType.juncao => Colors.grey,
      NodeType.entrada => Colors.green,
    };
  }
*/

  Color _colorForType(NodeType type, BuildContext context) {
    return switch (type) {
      NodeType.elevador => Colors.green.shade700,
      NodeType.escada => Colors.orange.shade700,
      NodeType.entrada => Colors.purple.shade700,
      NodeType.quarto => Theme.of(context).colorScheme.primary,
      NodeType.juncao => Colors.grey,
    };
  }
}
