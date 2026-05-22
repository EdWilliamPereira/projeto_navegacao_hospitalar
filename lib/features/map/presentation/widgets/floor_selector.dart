import 'package:flutter/material.dart';

/// Vertical list of floor buttons. Each button is ≥ 44 dp — meets touch
/// target size requirements (FR-05 / WCAG 2.1 2.5.5).
class FloorSelector extends StatelessWidget {
  final int currentFloor;
  final ValueChanged<int> onFloorChanged;
  final int maxFloor;

  const FloorSelector({
    super.key,
    required this.currentFloor,
    required this.onFloorChanged,
    this.maxFloor = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Floor selector. Currently on floor $currentFloor.',
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display from highest to lowest floor (top of widget = top floor).
            for (var floor = maxFloor; floor >= 0; floor--)
              _FloorButton(
                floor: floor,
                isSelected: floor == currentFloor,
                onTap: () => onFloorChanged(floor),
              ),
          ],
        ),
      ),
    );
  }
}

class _FloorButton extends StatelessWidget {
  final int floor;
  final bool isSelected;
  final VoidCallback onTap;

  const _FloorButton({
    required this.floor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      selected: isSelected,
      label: 'Floor $floor${isSelected ? ', selected' : ''}',
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '$floor',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
