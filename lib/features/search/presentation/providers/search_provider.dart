import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../map/domain/entities/poi.dart';
import '../../../map/presentation/providers/map_provider.dart';

part 'search_provider.g.dart';

/// The text the user has typed (or spoken) into the search bar.
/// Driving a separate provider (rather than local state) means search results
/// survive widget rebuilds and can be tested in isolation.
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
  void clear() => state = '';
}

/// Determines which field the user is currently filling in.
/// [SearchMode.origin]      → typing/speaking sets the origin node.
/// [SearchMode.destination] → typing/speaking sets the destination node.
enum SearchMode { origin, destination }

@riverpod
class ActiveSearchMode extends _$ActiveSearchMode {
  @override
  SearchMode build() => SearchMode.destination;
 
  void setMode(SearchMode mode) => state = mode;
}

/// The origin node ID chosen inside the search flow.
/// Initialised from [userLocationProvider] when SearchPage opens, so a node
/// tapped on the map graph is already pre-populated here.
///
/// Kept separate from [userLocationProvider] so the user can change the
/// origin inside search without immediately moving the map marker until they
/// confirm by tapping "Start navigation".
@riverpod
class PendingOriginNodeId extends _$PendingOriginNodeId {
  @override
  String? build() => null;
 
  void set(String nodeId) => state = nodeId;
  void clear() => state = null;
}

/// The destination node ID chosen inside the search flow.
@riverpod
class PendingDestinationNodeId extends _$PendingDestinationNodeId {
  @override
  String? build() => null;
 
  void set(String nodeId) => state = nodeId;
  void clear() => state = null;
}

/// Search results — derives from [searchQueryProvider].
/// Returns all POIs when the query is blank (shows the full directory).
@riverpod
Future<List<Poi>> searchResults(Ref ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) {
    // Wait for allPoisProvider to emit rather than triggering a duplicate load.
    return ref.watch(allPoisProvider.future);
  }

  final repo = ref.watch(mapRepositoryProvider);
  final result = await repo.searchPois(query.trim());
  return result.fold(
    (failure) => throw failure,
    (pois) => pois,
  );
}

/// Returns the [Poi] whose [nodeId] matches [id], or null if not found.
/// Used by SearchPage to display the human-readable name of an already-
/// selected origin/destination node.
@riverpod
Future<Poi?> poiByNodeId(Ref ref, String? id) async {
  if (id == null) return null;
  final pois = await ref.watch(allPoisProvider.future);
  try {
    return pois.firstWhere((p) => p.nodeId == id);
  } catch (_) {
    return null; // Node exists in graph but has no associated POI label.
  }
}