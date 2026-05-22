import 'package:flutter/material.dart';

import '../../domain/entities/navigation_step.dart';

/// Large, accessible card showing the current navigation instruction.
/// The entire card is a tap target (≥ 48 dp) — tapping advances to the
/// next step (FR-04). Semantics are set so TalkBack reads a complete,
/// actionable description (FR-05).
class StepInstructionCard extends StatelessWidget {
  final NavigationStep step;
  final VoidCallback onTap;

  const StepInstructionCard({
    super.key,
    required this.step,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Semantics(
      button: true,
      label:
          '${step.instruction}. '
          '${step.distanceMeters.toStringAsFixed(0)} metres. '
          'Double-tap to advance to next step.',
      excludeSemantics: true, // Prevent children from adding duplicate labels.
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          margin: const EdgeInsets.all(16),
          color: cs.primaryContainer,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  step.instruction,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: cs.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  '${step.distanceMeters.toStringAsFixed(0)} metres',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: cs.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Tap anywhere to advance',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: cs.onPrimaryContainer.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
