// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The text the user has typed (or spoken) into the search bar.
/// Driving a separate provider (rather than local state) means search results
/// survive widget rebuilds and can be tested in isolation.

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

/// The text the user has typed (or spoken) into the search bar.
/// Driving a separate provider (rather than local state) means search results
/// survive widget rebuilds and can be tested in isolation.
final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  /// The text the user has typed (or spoken) into the search bar.
  /// Driving a separate provider (rather than local state) means search results
  /// survive widget rebuilds and can be tested in isolation.
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'790bd96a8a13bb944767c7bf06a5378cfc78a54d';

/// The text the user has typed (or spoken) into the search bar.
/// Driving a separate provider (rather than local state) means search results
/// survive widget rebuilds and can be tested in isolation.

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ActiveSearchMode)
final activeSearchModeProvider = ActiveSearchModeProvider._();

final class ActiveSearchModeProvider
    extends $NotifierProvider<ActiveSearchMode, SearchMode> {
  ActiveSearchModeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeSearchModeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeSearchModeHash();

  @$internal
  @override
  ActiveSearchMode create() => ActiveSearchMode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchMode>(value),
    );
  }
}

String _$activeSearchModeHash() => r'7ba619f37daabf790efb76bce5359b976e7845fc';

abstract class _$ActiveSearchMode extends $Notifier<SearchMode> {
  SearchMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SearchMode, SearchMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SearchMode, SearchMode>,
              SearchMode,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The origin node ID chosen inside the search flow.
/// Initialised from [userLocationProvider] when SearchPage opens, so a node
/// tapped on the map graph is already pre-populated here.
///
/// Kept separate from [userLocationProvider] so the user can change the
/// origin inside search without immediately moving the map marker until they
/// confirm by tapping "Start navigation".

@ProviderFor(PendingOriginNodeId)
final pendingOriginNodeIdProvider = PendingOriginNodeIdProvider._();

/// The origin node ID chosen inside the search flow.
/// Initialised from [userLocationProvider] when SearchPage opens, so a node
/// tapped on the map graph is already pre-populated here.
///
/// Kept separate from [userLocationProvider] so the user can change the
/// origin inside search without immediately moving the map marker until they
/// confirm by tapping "Start navigation".
final class PendingOriginNodeIdProvider
    extends $NotifierProvider<PendingOriginNodeId, String?> {
  /// The origin node ID chosen inside the search flow.
  /// Initialised from [userLocationProvider] when SearchPage opens, so a node
  /// tapped on the map graph is already pre-populated here.
  ///
  /// Kept separate from [userLocationProvider] so the user can change the
  /// origin inside search without immediately moving the map marker until they
  /// confirm by tapping "Start navigation".
  PendingOriginNodeIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingOriginNodeIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingOriginNodeIdHash();

  @$internal
  @override
  PendingOriginNodeId create() => PendingOriginNodeId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$pendingOriginNodeIdHash() =>
    r'98007a89e730aec75cecd6e73a38ba9571b76aa8';

/// The origin node ID chosen inside the search flow.
/// Initialised from [userLocationProvider] when SearchPage opens, so a node
/// tapped on the map graph is already pre-populated here.
///
/// Kept separate from [userLocationProvider] so the user can change the
/// origin inside search without immediately moving the map marker until they
/// confirm by tapping "Start navigation".

abstract class _$PendingOriginNodeId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// The destination node ID chosen inside the search flow.

@ProviderFor(PendingDestinationNodeId)
final pendingDestinationNodeIdProvider = PendingDestinationNodeIdProvider._();

/// The destination node ID chosen inside the search flow.
final class PendingDestinationNodeIdProvider
    extends $NotifierProvider<PendingDestinationNodeId, String?> {
  /// The destination node ID chosen inside the search flow.
  PendingDestinationNodeIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingDestinationNodeIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingDestinationNodeIdHash();

  @$internal
  @override
  PendingDestinationNodeId create() => PendingDestinationNodeId();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$pendingDestinationNodeIdHash() =>
    r'a7720359650a40395460515bc8b3c434ecce3d81';

/// The destination node ID chosen inside the search flow.

abstract class _$PendingDestinationNodeId extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Search results — derives from [searchQueryProvider].
/// Returns all POIs when the query is blank (shows the full directory).

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsProvider._();

/// Search results — derives from [searchQueryProvider].
/// Returns all POIs when the query is blank (shows the full directory).

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Poi>>,
          List<Poi>,
          FutureOr<List<Poi>>
        >
    with $FutureModifier<List<Poi>>, $FutureProvider<List<Poi>> {
  /// Search results — derives from [searchQueryProvider].
  /// Returns all POIs when the query is blank (shows the full directory).
  SearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<Poi>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Poi>> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'81e054764551e15affc24cb8e177cf5a93195b35';

/// Returns the [Poi] whose [nodeId] matches [id], or null if not found.
/// Used by SearchPage to display the human-readable name of an already-
/// selected origin/destination node.

@ProviderFor(poiByNodeId)
final poiByNodeIdProvider = PoiByNodeIdFamily._();

/// Returns the [Poi] whose [nodeId] matches [id], or null if not found.
/// Used by SearchPage to display the human-readable name of an already-
/// selected origin/destination node.

final class PoiByNodeIdProvider
    extends $FunctionalProvider<AsyncValue<Poi?>, Poi?, FutureOr<Poi?>>
    with $FutureModifier<Poi?>, $FutureProvider<Poi?> {
  /// Returns the [Poi] whose [nodeId] matches [id], or null if not found.
  /// Used by SearchPage to display the human-readable name of an already-
  /// selected origin/destination node.
  PoiByNodeIdProvider._({
    required PoiByNodeIdFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'poiByNodeIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$poiByNodeIdHash();

  @override
  String toString() {
    return r'poiByNodeIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Poi?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Poi?> create(Ref ref) {
    final argument = this.argument as String?;
    return poiByNodeId(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PoiByNodeIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$poiByNodeIdHash() => r'02e41c0ea71142e9403fcd91ec3fb9f0d9ca4621';

/// Returns the [Poi] whose [nodeId] matches [id], or null if not found.
/// Used by SearchPage to display the human-readable name of an already-
/// selected origin/destination node.

final class PoiByNodeIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Poi?>, String?> {
  PoiByNodeIdFamily._()
    : super(
        retry: null,
        name: r'poiByNodeIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Returns the [Poi] whose [nodeId] matches [id], or null if not found.
  /// Used by SearchPage to display the human-readable name of an already-
  /// selected origin/destination node.

  PoiByNodeIdProvider call(String? id) =>
      PoiByNodeIdProvider._(argument: id, from: this);

  @override
  String toString() => r'poiByNodeIdProvider';
}
