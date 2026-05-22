import 'package:vibration/vibration.dart';

/// Haptic feedback for turn notifications (FR-08).
/// All methods are safe to call on devices without a vibrator (no-op).
class VibrationService {
  /// Short single pulse — signals the user to advance a step.
  Future<void> vibrateShort() async {
    // vibration ^2: hasVibrator() returns Future<bool?> — null-safe guard.
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: 50);
    }
  }

  /// Long pulse — signals arrival at the destination.
  Future<void> vibrateLong() async {
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: 200);
    }
  }

  /// Three-pulse pattern — configurable turn-approaching alert (FR-08).
  Future<void> vibratePattern() async {
    if (await Vibration.hasVibrator()) {
      // Pattern: [delay, duration, delay, duration, delay, duration]
      await Vibration.vibrate(pattern: [0, 200, 100, 200, 100, 200]);
    }
  }
}
