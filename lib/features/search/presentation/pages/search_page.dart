import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../map/domain/entities/poi.dart';
import '../../../map/presentation/providers/map_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../providers/search_provider.dart';

/// Search page that allows the user to pick both an origin and a destination.
///
/// Flow:
///   1. Opens with [SearchMode.destination] active by default.
///   2. If the user had already tapped a node on the map, [userLocationProvider]
///      is pre-populated; the origin chip shows that node's POI name.
///   3. The user can tap either chip to switch the active field and search/speak
///      a replacement.
///   4. Tapping a result row assigns it to whichever field is active, then
///      automatically switches focus to the other field if it is still empty.
///   5. Once both fields are filled, "Get directions" computes the route and
///      navigates back to the map.

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _speechToText = stt.SpeechToText();
  bool _isListening = false;

  // Lifecycle
  @override
  void initState() {
    super.initState();
 
    // Pre-populate the pending origin from whatever the user tapped on the map.
    // Using addPostFrameCallback so providers are available on the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final mapOrigin = ref.read(userLocationProvider);
      if (mapOrigin != null) {
        ref.read(pendingOriginNodeIdProvider.notifier).set(mapOrigin);
      }
      // Set the search field text to empty and focus destination by default.
      ref.read(activeSearchModeProvider.notifier).setMode(SearchMode.destination);
      ref.read(searchQueryProvider.notifier).clear();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Voice input
  Future<void> _startListening() async {
    final available = await _speechToText.initialize(
      onError: (error) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Speech error: ${error.errorMsg}')),
          );
        }
      },
    );
    
    if (!available) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Speech recognition not available on this device.')),
        );
      }
      return;
    }

  setState(() => _isListening = true);

    await _speechToText.listen(
      onResult: (result) {
        // result.recognizedWords contains the current transcription.
        _controller.text = result.recognizedWords;
        ref.read(searchQueryProvider.notifier).update(result.recognizedWords);
        // result.finalResult is true when the engine has stopped listening.
        if (result.finalResult) {
          setState(() => _isListening = false);
        }
      },
      localeId: 'pt_BR', // NFR-08: Brazilian Portuguese
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 3),
    );
  }

  Future<void> _stopListening() async {
    await _speechToText.stop();
    setState(() => _isListening = false);
  }

  // Selection logic
  /// Called when the user taps a result row.
  /// Assigns [poi] to the active field, clears the search bar, and
  /// auto-switches focus to the other field if it is still empty.
  Future<void> _selectPoi(Poi poi) async {
    final mode = ref.read(activeSearchModeProvider);
    if (mode == SearchMode.origin) {
      ref.read(pendingOriginNodeIdProvider.notifier).set(poi.nodeId);
      // Auto-advance to destination if not yet filled.
      final dest = ref.read(pendingDestinationNodeIdProvider);
      if (dest == null) {
        ref.read(activeSearchModeProvider.notifier).setMode(SearchMode.destination);
      }
    } else {
      ref.read(pendingDestinationNodeIdProvider.notifier).set(poi.nodeId);
      // Auto-advance to origin if not yet filled.
      final origin = ref.read(pendingOriginNodeIdProvider);
      if (origin == null) {
        ref.read(activeSearchModeProvider.notifier).setMode(SearchMode.origin);
      }
    }

    // Clear the search field so the list resets to the full POI directory.
    _controller.clear();
    ref.read(searchQueryProvider.notifier).clear();
  }

  /// Switches the active mode and repopulates the text field with the
  /// current value of that field (if any) so the user can refine it.
  void _activateField(SearchMode mode) {
    ref.read(activeSearchModeProvider.notifier).setMode(mode);
    _controller.clear();
    ref.read(searchQueryProvider.notifier).clear();
    // Focus the text field after the frame rebuilds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _textFieldFocusNode.requestFocus();
    });
  }
 
  final _textFieldFocusNode = FocusNode();

  // Route computation logic — called when the user taps "Get directions"
  Future<void> _getDirections() async {
    final origin = ref.read(pendingOriginNodeIdProvider);
    final destination = ref.read(pendingDestinationNodeIdProvider);
 
    if (origin == null || destination == null) return;
 
    // Commit the chosen origin back to the shared map provider so the
    // marker on the map canvas also updates.
    ref.read(userLocationProvider.notifier).setLocation(origin);

    // Read avoidStairs preference before computing the route.
    // avoidStairsProvider is async — await its future.
    final avoidStairs = await ref.read(avoidStairsProvider.future);
    await ref.read(currentRouteProvider.notifier).computeRoute(
          destinationId: destination,
          avoidStairs: avoidStairs,
        );
 
    if (mounted) context.goNamed('map');
  }

  // UI
  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(activeSearchModeProvider);
    final origin = ref.watch(pendingOriginNodeIdProvider);
    final destination = ref.watch(pendingDestinationNodeIdProvider);
    final resultsAsync = ref.watch(searchResultsProvider);

    final canGetDirections = origin != null && destination != null;

    return Scaffold(
      appBar: AppBar(
        // Embedding the TextField directly in the AppBar gives a native search
        // feel without needing a separate SearchBar widget.
        titleSpacing: 0,
        title: _TwoFieldHeader(
          mode: mode,
          origin: origin,
          destination: destination,
          onActivate: _activateField,
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _SearchBar(
            controller: _controller,
            focusNode: _textFieldFocusNode,
            isListening: _isListening,
            mode: mode,
            onChanged: (v) => ref.read(searchQueryProvider.notifier).update(v),
            onMicTap: _isListening ? _stopListening : _startListening,
            onClear: () {
              _controller.clear();
              ref.read(searchQueryProvider.notifier).clear();
            },
          ),
        ),
      ),

      // Result list
      body: Column(
        children: [
          Expanded(
            child: resultsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (pois) => pois.isEmpty
                ? const Center(child: Text('No results found.'))
                : ListView.builder(
                    itemCount: pois.length,
                    itemBuilder: (context, i) {
                      final poi = pois[i];
                      // Highlight the row if this POI is already selected
                      // for the active field.
                      final isActive = mode == SearchMode.origin
                        ? poi.nodeId == origin
                        : poi.nodeId == destination;
                      return _PoiResultTile(
                        poi: poi,
                        isActive: isActive,
                        onTap: () => _selectPoi(poi),
                      );
                    },
                  ),
            ),
          ),

          // "Get directions" button, enabled only when both fields set
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: FilledButton.icon(
                onPressed: canGetDirections ? _getDirections : null,
                icon: const Icon(Icons.directions),
                label: const Text('Get directions'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Auxiliary widgets
 
/// Two tappable chips showing the currently selected origin and destination.
/// The active chip is visually highlighted.
class _TwoFieldHeader extends ConsumerWidget {
  final SearchMode mode;
  final String? origin;
  final String? destination;
  final ValueChanged<SearchMode> onActivate;
 
  const _TwoFieldHeader({
    required this.mode,
    required this.origin,
    required this.destination,
    required this.onActivate,
  });
 
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch derived POI names for both fields (async but typically instant
    // after the first allPoisProvider load).
    final originPoiAsync = ref.watch(poiByNodeIdProvider(origin));
    final destPoiAsync = ref.watch(poiByNodeIdProvider(destination));
 
    final originLabel = originPoiAsync.when(
      data: (poi) => poi?.name ?? (origin != null ? 'Node set' : null),
      loading: () => origin != null ? '…' : null,
      error: (_, __) => origin,
    );
 
    final destLabel = destPoiAsync.when(
      data: (poi) => poi?.name ?? (destination != null ? 'Node set' : null),
      loading: () => destination != null ? '…' : null,
      error: (_, __) => destination,
    );
 
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Row(
        children: [
          // Origin chip
          Expanded(
            child: _FieldChip(
              icon: Icons.my_location,
              label: originLabel ?? 'Set origin',
              isActive: mode == SearchMode.origin,
              isFilled: originLabel != null,
              semanticLabel: originLabel != null
                  ? 'Origin: $originLabel. Tap to change.'
                  : 'Origin not set. Tap to set.',
              onTap: () => onActivate(SearchMode.origin),
            ),
          ),
          const Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
          // Destination chip
          Expanded(
            child: _FieldChip(
              icon: Icons.place,
              label: destLabel ?? 'Set destination',
              isActive: mode == SearchMode.destination,
              isFilled: destLabel != null,
              semanticLabel: destLabel != null
                  ? 'Destination: $destLabel. Tap to change.'
                  : 'Destination not set. Tap to set.',
              onTap: () => onActivate(SearchMode.destination),
            ),
          ),
        ],
      ),
    );
  }
}
 
class _FieldChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isFilled;
  final String semanticLabel;
  final VoidCallback onTap;
 
  const _FieldChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isFilled,
    required this.semanticLabel,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
 
    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isActive
                ? cs.primaryContainer
                : isFilled
                    ? cs.secondaryContainer.withValues(alpha: 0.5)
                    : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: isActive
                ? Border.all(color: cs.primary, width: 2)
                : Border.all(color: Colors.transparent),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive ? cs.primary : cs.onSurfaceVariant,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isActive
                            ? cs.onPrimaryContainer
                            : isFilled
                                ? cs.onSecondaryContainer
                                : cs.onSurfaceVariant,
                        fontWeight:
                            isFilled ? FontWeight.w600 : FontWeight.normal,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
 
/// The actual text + mic input bar, rendered in AppBar.bottom.
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isListening;
  final SearchMode mode;
  final ValueChanged<String> onChanged;
  final VoidCallback onMicTap;
  final VoidCallback onClear;
 
  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.isListening,
    required this.mode,
    required this.onChanged,
    required this.onMicTap,
    required this.onClear,
  });
 
  @override
  Widget build(BuildContext context) {
    final hint = mode == SearchMode.origin
        ? 'Search for origin…'
        : 'Search for destination…';
 
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              autofocus: true,
              decoration: InputDecoration(
                hintText: hint,
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
              ),
              onChanged: onChanged,
            ),
          ),
          // Mic button
          Semantics(
            label: isListening ? 'Stop voice search' : 'Start voice search',
            child: IconButton(
              icon: Icon(isListening ? Icons.mic_off : Icons.mic),
              onPressed: onMicTap,
            ),
          ),
          // Clear button — only when text is present
          if (controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Clear search',
              onPressed: onClear,
            ),
        ],
      ),
    );
  }
}
 
/// A single search result row with an active-state highlight.
class _PoiResultTile extends StatelessWidget {
  final Poi poi;
  final bool isActive;
  final VoidCallback onTap;
 
  const _PoiResultTile({
    required this.poi,
    required this.isActive,
    required this.onTap,
  });
 
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Semantics(
      // semanticsLabel provides a complete TalkBack description (FR-05).
      label: '${poi.name}, ${poi.category}. Tap to select.',
      child: ListTile(
          tileColor: isActive ? cs.primaryContainer.withValues(alpha: 0.4) : null,
          leading: Icon(
            Icons.place,
            color: isActive ? cs.primary : null,
          ),
          title: Text(poi.name),
          subtitle: Text(poi.category),
          trailing: isActive ? Icon(Icons.check, color: cs.primary) : null,
          onTap: onTap,
        ),
    );
  }
}