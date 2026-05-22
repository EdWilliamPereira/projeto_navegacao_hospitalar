import 'package:flutter_tts/flutter_tts.dart';

/// Wraps flutter_tts ^4.x for step announcements (FR-04, FR-05, FR-08).
/// Call [init] once before the first [speak].
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await _tts.setLanguage('pt-BR');   // NFR-08 — Brazilian Portuguese
    await _tts.setSpeechRate(0.5);     // Slower than default for clarity
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    // flutter_tts ^4: awaitSpeakCompletion(true) makes speak() await
    // full playback before resolving — required so step announcements
    // don't overlap with each other.
    await _tts.awaitSpeakCompletion(true);

    _initialized = true;
  }

  Future<void> speak(String text) async {
    if (!_initialized) await init();
    // Stop any in-progress speech before starting the new utterance.
    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async => _tts.stop();

  Future<void> dispose() async => _tts.stop();
}
