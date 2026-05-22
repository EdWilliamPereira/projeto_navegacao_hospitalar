import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../services/tts_service.dart';
import '../../../../services/vibration_service.dart';
import '../../domain/entities/navigation_step.dart';
import '../providers/navigation_provider.dart';
import '../widgets/step_instruction_card.dart';

/// Turn-by-turn navigation screen.
/// Uses ConsumerStatefulWidget because TtsService and VibrationService require
/// lifecycle management (init in initState, cleanup in dispose).
class NavigationPage extends ConsumerStatefulWidget {
  final String destinationId;

  const NavigationPage({super.key, required this.destinationId});

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  late final TtsService _tts;
  late final VibrationService _vibration;

  @override
  void initState() {
    super.initState();
    _tts = TtsService();
    _vibration = VibrationService();
    // Initialise TTS then read and announce the first step.
    _tts.init().then((_) => _announceCurrentStep());
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _announceCurrentStep() async {
    final step = ref.read(currentStepProvider);
    if (step != null) {
      await _tts.speak(step.instruction);
      await _vibration.vibrateShort();
    }
  }

  Future<void> _advanceStep() async {
    // Haptic feedback before state change so the buzz feels immediate (FR-08).
    await _vibration.vibrateShort();
    ref.read(navigationIndexProvider.notifier).advance();
    // Allow one frame for providers to recompute before reading new state.
    await Future.delayed(const Duration(milliseconds: 100));
    await _announceCurrentStep();

    // Check whether we've passed the last step.
    final steps = ref.read(navigationStepsProvider);
    final index = ref.read(navigationIndexProvider);
    if (index >= steps.length) {
      await _vibration.vibrateLong();
      await _tts.speak('You have arrived at your destination.');
      if (mounted) context.goNamed('map');
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = ref.watch(navigationStepsProvider);
    final currentIndex = ref.watch(navigationIndexProvider);
    final currentStep = ref.watch(currentStepProvider);

    if (steps.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Navigation')),
        body: const Center(child: Text('No active route.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Turn-by-Turn Navigation'),
        leading: IconButton(
          tooltip: 'Exit navigation',
          icon: const Icon(Icons.close),
          onPressed: () {
            _tts.stop();
            ref.read(navigationIndexProvider.notifier).reset();
            context.goNamed('map');
          },
        ),
        actions: [
          // FR-05: Replay the current TTS instruction on demand.
          IconButton(
            tooltip: 'Repeat instruction',
            icon: const Icon(Icons.volume_up),
            onPressed: _announceCurrentStep,
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress bar — visually shows how far along the route the user is.
          LinearProgressIndicator(
            value: steps.isEmpty ? 0 : (currentIndex + 1) / steps.length,
            semanticsLabel: 'Navigation progress',
            semanticsValue: 'Step ${currentIndex + 1} of ${steps.length}',
          ),

          // Large tappable card for the current instruction (FR-04, FR-05).
          if (currentStep != null)
            Expanded(
              flex: 3,
              child: StepInstructionCard(
                step: currentStep,
                onTap: _advanceStep,
              ),
            ),
          
          // Upcoming steps — a preview of what comes next.
          Expanded(
            flex: 2,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: steps.length - currentIndex - 1,
              itemBuilder: (context, i) {
                final upcoming = steps[currentIndex + 1 + i];
                return ListTile(
                  leading: _TurnIcon(direction: upcoming.direction),
                  title: Text(upcoming.instruction),
                  subtitle: Text(
                    '${upcoming.distanceMeters.toStringAsFixed(0)} m',
                  ),
                );
              },
            ),
          ),

          // Explicit "Next step" button — large target, keyboard accessible.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton.icon(
                onPressed: _advanceStep,
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Next step'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TurnIcon extends StatelessWidget {
  final TurnDirection direction;
  const _TurnIcon({required this.direction});

  @override
  Widget build(BuildContext context) {
    final icon = switch (direction) {
      /*
      TurnDirection.straight => Icons.arrow_upward,
      TurnDirection.left => Icons.arrow_back,
      TurnDirection.right => Icons.arrow_forward,
      TurnDirection.slightLeft => Icons.arrow_upward_rounded,
      TurnDirection.slightRight => Icons.arrow_upward_rounded,
      TurnDirection.arrival => Icons.check_circle,
      */
      TurnDirection.left => Icons.turn_left,
      TurnDirection.right => Icons.turn_right,
      TurnDirection.slightLeft => Icons.turn_slight_left,
      TurnDirection.slightRight => Icons.turn_slight_right,
      TurnDirection.arrival => Icons.place,
      TurnDirection.straight => Icons.straight,
    };
    return Icon(icon, semanticLabel: direction.name);
  }
}
