import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings_provider.g.dart';

const _kAvoidStairs = 'avoid_stairs';
const _kHighContrast = 'high_contrast';

/// Shared preferences instance — keepAlive so it is not recreated on every
/// navigation event.
@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) =>
    SharedPreferences.getInstance();

/// FR-07, FR-09: whether routes should exclude stair edges.
@riverpod
class AvoidStairs extends _$AvoidStairs {
  @override
  Future<bool> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getBool(_kAvoidStairs) ?? false;
  }

  Future<void> toggle() async {
    final current = await future;
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    await prefs.setBool(_kAvoidStairs, !current);
    // invalidateSelf() causes build() to rerun and fresh state to emit.
    ref.invalidateSelf();
  }
}

/// FR-10: high-contrast theme flag.
@riverpod
class HighContrast extends _$HighContrast {
  @override
  Future<bool> build() async {
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    return prefs.getBool(_kHighContrast) ?? false;
  }

  Future<void> toggle() async {
    final current = await future;
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    await prefs.setBool(_kHighContrast, !current);
    ref.invalidateSelf();
  }
}
