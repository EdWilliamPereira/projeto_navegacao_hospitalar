import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Wraps speech_to_text ^7.x for voice search (FR-02, FR-05).
/// Handles the RECORD_AUDIO permission gate internally.
class SpeechService {
  final SpeechToText _stt = SpeechToText();

  Future<bool> requestPermission() async {
    // permission_handler ^11: request() returns PermissionStatus.
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<bool> initialize() async {
    final granted = await requestPermission();
    if (!granted) return false;
    return _stt.initialize();
  }

  /// Starts listening and forwards results to [onResult].
  /// [isFinal] is true when the engine has stopped and committed the result.
  Future<void> listen({
    required void Function(String text, bool isFinal) onResult,
    String localeId = 'pt_BR',
  }) async {
    await _stt.listen(
      onResult: (result) =>
          onResult(result.recognizedWords, result.finalResult),
      localeId: localeId,
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );
  }

  Future<void> stop() => _stt.stop();

  bool get isListening => _stt.isListening;
}
