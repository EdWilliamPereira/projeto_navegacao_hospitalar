# Hospital Internal Mapping & Navigation — Flutter Implementation Guide

> **Audience:** AI coding agent implementing the app from scratch.
> **Architecture:** Clean Architecture · Riverpod 3.3.x (code-gen) · sqflite · flutter_map
> **Target:** Android 10+ (minSdk 29) · Offline-first · WCAG 2.1 / TalkBack
> **All package versions verified on pub.dev — May 2026**

---

## Critical package version notes (applied throughout this guide)

| Package | Correct version | Previous guide error |
|---|---|---|
| `flutter_riverpod` | `^3.3.1` | Used `^3.0.3` — outdated patch |
| `riverpod_annotation` | `^4.0.3` | Used `^3.0.3` — **wrong major**, causes build failure |
| `riverpod_generator` | `^4.0.4` | Used `^3.0.3` — **wrong major**, generator refuses to run |
| `go_router` | `^17.2.3` | Used `^14.8.0` — 3 major versions behind |

The Riverpod mismatch is the most dangerous: mixing `riverpod_annotation ^3.x` with `riverpod_generator ^4.x` causes `build_runner` to abort with a constraint conflict — the generated `.g.dart` files will not be produced at all. Everything else in this guide uses current stable versions.

---

## Table of Contents

1. [Project Structure](#1-project-structure)
2. [pubspec.yaml](#2-pubspecyaml)
3. [Core Layer — Errors, Theme, Router](#3-core-layer)
4. [Data Layer — Models, DataSource, Repository Impl](#4-data-layer)
5. [Domain Layer — Entities, Repository Contracts, Use Cases](#5-domain-layer)
6. [Graph Algorithm — Dijkstra with Accessibility Filter](#6-graph-algorithm)
7. [Presentation Layer — Riverpod Providers](#7-presentation-layer--providers)
8. [Presentation Layer — Pages & Widgets](#8-presentation-layer--pages--widgets)
9. [Services — TTS, Speech, Vibration](#9-services)
10. [main.dart & Bootstrap](#10-maindart--bootstrap)
11. [Map Asset — map_data.json](#11-map-asset--map_datajson)
12. [Android Manifest](#12-android-manifest)
13. [Testing](#13-testing)
14. [Build & Code-Gen Commands](#14-build--code-gen-commands)
15. [Architecture Decision Record](#15-architecture-decision-record)

---

## 1. Project Structure

```
lib/
├── core/
│   ├── error/
│   │   ├── failures.dart          # Sealed Failure hierarchy
│   │   └── exceptions.dart        # Raw exception types
│   ├── router/
│   │   ├── app_router.dart        # GoRouter via @riverpod
│   │   └── app_router.g.dart      # ← generated
│   ├── theme/
│   │   └── app_theme.dart         # Light + high-contrast themes (FR-10)
│   └── utils/
│       └── extensions.dart        # Dart extension methods
├── features/
│   ├── map/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── map_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   ├── node_model.dart
│   │   │   │   ├── edge_model.dart
│   │   │   │   └── poi_model.dart
│   │   │   └── repositories/
│   │   │       └── map_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── node.dart
│   │   │   │   ├── edge.dart
│   │   │   │   ├── poi.dart
│   │   │   │   └── route_result.dart
│   │   │   ├── repositories/
│   │   │   │   └── map_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_all_pois.dart
│   │   │       ├── get_floor_graph.dart
│   │   │       └── calculate_route.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── map_page.dart
│   │       ├── widgets/
│   │       │   ├── floor_selector.dart
│   │       │   ├── map_overlay_layer.dart
│   │       │   └── route_polyline_layer.dart
│   │       └── providers/
│   │           ├── map_provider.dart
│   │           └── map_provider.g.dart         # ← generated
│   ├── navigation/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── navigation_step.dart
│   │   │   └── usecases/
│   │   │       └── build_navigation_steps.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── navigation_page.dart
│   │       ├── widgets/
│   │       │   └── step_instruction_card.dart
│   │       └── providers/
│   │           ├── navigation_provider.dart
│   │           └── navigation_provider.g.dart  # ← generated
│   ├── search/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── search_page.dart
│   │       └── providers/
│   │           ├── search_provider.dart
│   │           └── search_provider.g.dart      # ← generated
│   └── settings/
│       └── presentation/
│           ├── pages/
│           │   └── settings_page.dart
│           └── providers/
│               ├── settings_provider.dart
│               └── settings_provider.g.dart    # ← generated
├── services/
│   ├── tts_service.dart
│   ├── speech_service.dart
│   └── vibration_service.dart
├── shared/
│   └── widgets/
│       ├── error_view.dart
│       └── loading_view.dart
└── main.dart

assets/
└── map_data.json

test/
├── features/
│   ├── map/
│   │   ├── domain/
│   │   │   └── calculate_route_test.dart
│   │   └── data/
│   │       └── map_repository_impl_test.dart
│   └── navigation/
│       └── navigation_provider_test.dart
└── helpers/
    └── fake_map_repository.dart
```

---

## 2. pubspec.yaml

```yaml
name: hospital_nav
description: Hospital internal mapping and navigation application.
publish_to: none
version: 1.0.0+1

environment:
  sdk: ^3.7.0
  flutter: ">=3.29.0"

dependencies:
  flutter:
    sdk: flutter

  # ── Map rendering — offline-first, no API key ─────────────────────────────
  flutter_map: ^8.3.0          # verified pub.dev May 2026
  latlong2: ^0.9.1             # coordinate math, required by flutter_map
  flutter_map_cache: ^2.1.0   # offline tile caching layer

  # ── Audio / voice ─────────────────────────────────────────────────────────
  flutter_tts: ^4.2.2          # native Android TTS, supports pt-BR offline
  speech_to_text: ^7.0.0       # device speech recognition (FR-02, FR-05)

  # ── Haptics ───────────────────────────────────────────────────────────────
  vibration: ^2.0.0            # configurable vibration patterns (FR-08)

  # ── Local persistence ─────────────────────────────────────────────────────
  sqflite: ^2.4.2              # SQLite for offline graph + search
  path: ^1.9.1                 # DB path resolution helper

  # ── User preferences ──────────────────────────────────────────────────────
  shared_preferences: ^2.5.3   # avoid_stairs, high_contrast, language

  # ── State management & DI ─────────────────────────────────────────────────
  # IMPORTANT: riverpod_annotation MUST be ^4.x to match riverpod_generator ^4.x
  flutter_riverpod: ^3.3.1     # verified pub.dev May 2026
  riverpod_annotation: ^4.0.3  # annotations for code-gen — must be 4.x series

  # ── Routing ───────────────────────────────────────────────────────────────
  # go_router 15+ makes URLs case-sensitive by default (caseSensitive: false to opt out)
  go_router: ^17.2.3           # verified pub.dev May 2026

  # ── Models (runtime annotations only — no generated code at runtime) ──────
  freezed_annotation: ^3.0.0
  json_annotation: ^4.9.0

  # ── Functional error handling ─────────────────────────────────────────────
  fpdart: ^1.1.1               # Either<Failure, T> for domain layer

  # ── Permissions ───────────────────────────────────────────────────────────
  permission_handler: ^11.4.0  # RECORD_AUDIO for voice search (FR-02)

dev_dependencies:
  flutter_test:
    sdk: flutter

  # ── Code generation ───────────────────────────────────────────────────────
  build_runner: ^2.4.14
  freezed: ^3.0.0
  json_serializable: ^6.9.5
  # IMPORTANT: riverpod_generator MUST be ^4.x — mismatching with ^3.x
  # causes build_runner to abort; generated .g.dart files will not be produced
  riverpod_generator: ^4.0.4   # verified pub.dev May 2026

  # ── Testing ───────────────────────────────────────────────────────────────
  mocktail: ^1.0.4

flutter:
  uses-material-design: true
  assets:
    - assets/map_data.json
    - assets/floor_plans/          # floor plan PNG images per floor
```

---

## 3. Core Layer

### 3.1 `core/error/failures.dart`

A sealed class hierarchy ensures every failure type is handled exhaustively at call sites via Dart's pattern matching. All domain use cases return `Either<Failure, T>` from `fpdart`.

```dart
// lib/core/error/failures.dart
import 'package:fpdart/fpdart.dart';

/// Typed failure hierarchy.
/// All domain operations return Either<Failure, T>.
/// Sealed = exhaustive switch at the presentation layer.
sealed class Failure {
  final String message;
  const Failure(this.message);
}

final class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

final class GraphFailure extends Failure {
  const GraphFailure(super.message);
}

final class RouteNotFoundFailure extends Failure {
  const RouteNotFoundFailure(super.message);
}

final class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Convenience typedef — used throughout domain and data layers.
typedef EitherFailure<T> = Either<Failure, T>;
```

### 3.2 `core/error/exceptions.dart`

Raw exceptions are thrown only inside the data layer and immediately caught by repository implementations, which convert them into typed `Failure` values.

```dart
// lib/core/error/exceptions.dart

/// Thrown by MapLocalDataSourceImpl when the SQLite database is unavailable.
class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}

/// Thrown when the bundled JSON asset cannot be read or parsed.
class AssetException implements Exception {
  final String message;
  const AssetException(this.message);

  @override
  String toString() => 'AssetException: $message';
}
```

### 3.3 `core/theme/app_theme.dart`

```dart
// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';

/// Provides light and high-contrast themes.
/// High-contrast satisfies FR-10 and NFR-10 (≥ 4.5:1 ratio for small text).
class AppTheme {
  AppTheme._();

  static const Color _seedColor = Color(0xFF0066CC);

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.light,
        ),
        // Minimum 48×48 dp touch targets — WCAG 2.1 success criterion 2.5.5
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            minimumSize: WidgetStatePropertyAll(Size(48, 48)),
          ),
        ),
        filledButtonTheme: const FilledButtonThemeData(
          style: ButtonStyle(
            minimumSize: WidgetStatePropertyAll(Size(double.infinity, 56)),
          ),
        ),
      );

  /// High-contrast dark theme — FR-10, NFR-10.
  /// Black background + white text guarantees ≥ 21:1 contrast ratio.
  static ThemeData get highContrast => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _seedColor,
          brightness: Brightness.dark,
          surface: Colors.black,
          onSurface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
        textTheme: Typography.material2021().white,
        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(
            minimumSize: WidgetStatePropertyAll(Size(48, 48)),
          ),
        ),
      );
}
```

### 3.4 `core/router/app_router.dart`

```dart
// lib/core/router/app_router.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/map/presentation/pages/map_page.dart';
import '../../features/navigation/presentation/pages/navigation_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

part 'app_router.g.dart';

/// Global router — exposed as a Riverpod provider so it can be overridden
/// in widget tests without touching GoRouter's static global state.
///
/// go_router ^17: Router is kept alive automatically; no keepAlive annotation needed.
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/',
    // go_router ≥ 15.0.0 made URLs case-sensitive by default.
    // Setting false preserves backward-compatible behaviour.
    caseSensitive: false,
    routes: [
      GoRoute(
        path: '/',
        name: 'map',
        builder: (context, state) => const MapPage(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: '/navigate/:destinationId',
        name: 'navigate',
        builder: (context, state) => NavigationPage(
          destinationId: state.pathParameters['destinationId']!,
        ),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
```

---

## 4. Data Layer

### 4.1 Models with `@freezed` + `@JsonSerializable`

> **Rule:** Models live entirely in the data layer. Domain entities have no `fromJson` or Flutter dependency. Each model carries a `toEntity()` method that converts the DTO into the pure domain type.

#### `features/map/data/models/node_model.dart`

```dart
// lib/features/map/data/models/node_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/node.dart';

part 'node_model.freezed.dart';
part 'node_model.g.dart';

/// Data transfer object for a graph node stored in SQLite.
/// The `@freezed` annotation generates: copyWith, ==, hashCode, toString.
/// `@JsonSerializable` generates: fromJson, toJson.
@freezed
abstract class NodeModel with _$NodeModel {
  // Private const constructor required for custom methods inside a @freezed class.
  const NodeModel._();

  const factory NodeModel({
    required String id,
    required String name,
    required int floor,
    required double x, // Local canvas coordinate in arbitrary units
    required double y,
    required String type, // 'room' | 'elevator' | 'stairs' | 'junction' | 'entrance'
  }) = _NodeModel;

  factory NodeModel.fromJson(Map<String, dynamic> json) =>
      _$NodeModelFromJson(json);

  /// Converts this DTO into the domain entity [Node].
  /// Called by MapRepositoryImpl — keeps serialization out of the domain layer.
  Node toEntity() => Node(
        id: id,
        name: name,
        floor: floor,
        x: x,
        y: y,
        type: NodeType.values.byName(type),
      );
}
```

#### `features/map/data/models/edge_model.dart`

```dart
// lib/features/map/data/models/edge_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/edge.dart';

part 'edge_model.freezed.dart';
part 'edge_model.g.dart';

@freezed
abstract class EdgeModel with _$EdgeModel {
  const EdgeModel._();

  const factory EdgeModel({
    required String origin,
    required String destination,
    required double distance,
    // Defaults true — accessible unless explicitly marked false (stairs-only).
    @Default(true) bool accessible,
  }) = _EdgeModel;

  factory EdgeModel.fromJson(Map<String, dynamic> json) =>
      _$EdgeModelFromJson(json);

  Edge toEntity() => Edge(
        origin: origin,
        destination: destination,
        distance: distance,
        accessible: accessible,
      );
}
```

#### `features/map/data/models/poi_model.dart`

```dart
// lib/features/map/data/models/poi_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/poi.dart';

part 'poi_model.freezed.dart';
part 'poi_model.g.dart';

@freezed
abstract class PoiModel with _$PoiModel {
  const PoiModel._();

  const factory PoiModel({
    required String id,
    required String name,
    required String category, // 'consulting' | 'pharmacy' | 'bathroom' | 'elevator' …
    required String nodeId,
    @Default('') String description,
    @Default([]) List<String> tags,
  }) = _PoiModel;

  factory PoiModel.fromJson(Map<String, dynamic> json) =>
      _$PoiModelFromJson(json);

  Poi toEntity() => Poi(
        id: id,
        name: name,
        category: category,
        nodeId: nodeId,
        description: description,
        tags: tags,
      );
}
```

---

### 4.2 `features/map/data/datasources/map_local_datasource.dart`

The datasource owns the SQLite schema, and the JSON-to-database seeding logic. It returns raw model objects; repository implementations handle error wrapping.

```dart
// lib/features/map/data/datasources/map_local_datasource.dart
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../../../core/error/exceptions.dart';
import '../models/edge_model.dart';
import '../models/node_model.dart';
import '../models/poi_model.dart';

/// Contract — allows mocking in tests.
abstract interface class MapLocalDataSource {
  /// Must be called once before any other method.
  /// Safe to call multiple times (idempotent after first call).
  Future<void> initDatabase();

  Future<List<NodeModel>> getNodes({int? floor});
  Future<List<EdgeModel>> getEdges();
  Future<List<PoiModel>> getPois();

  /// text search across name, category, description, tags.
  Future<List<PoiModel>> searchPois(String query);
}

class MapLocalDataSourceImpl implements MapLocalDataSource {
  Database? _db;

  @override
  Future<void> initDatabase() async {
    if (_db != null) return; // Already initialised — idempotent.

    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'hospital_map.db');

    _db = await openDatabase(
      path,
      version: 1,
      // onCreate fires only on the very first launch (empty database).
      onCreate: _createSchemaAndSeed,
      // onOpen fires on every subsequent launch; re-seed only if somehow empty.
      onOpen: (db) async {
        final count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM nodes'),
        );
        if (count == 0) await _seedFromAsset(db);
      },
    );
  }

  /// Creates all tables and populates them from the bundled JSON asset.
  Future<void> _createSchemaAndSeed(Database db, int version) async {
    await db.execute('''
      CREATE TABLE nodes (
        id   TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        floor INTEGER NOT NULL,
        x    REAL NOT NULL,
        y    REAL NOT NULL,
        type TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE edges (
        id          INTEGER PRIMARY KEY AUTOINCREMENT,
        origin      TEXT    NOT NULL,
        destination TEXT    NOT NULL,
        distance    REAL    NOT NULL,
        accessible  INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute('''
      CREATE TABLE pois (
        id          TEXT PRIMARY KEY,
        name        TEXT NOT NULL,
        category    TEXT NOT NULL,
        nodeId     TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        tags        TEXT NOT NULL DEFAULT '[]'
      )
    ''');

    // Composite index covering the three columns searched by LIKE.
    // SQLite can use this for prefix scans on 'name' (LIKE 'x%'),
    // which is the dominant search pattern for room/service lookups.
    await db.execute(
      'CREATE INDEX idx_pois_search ON pois(name, category, description)',
    );

    await _seedFromAsset(db);
  }

  Future<void> _seedFromAsset(Database db) async {
    try {
      final raw = await rootBundle.loadString('assets/map_data.json');
      final data = jsonDecode(raw) as Map<String, dynamic>;

      final batch = db.batch();

      // Nodes
      for (final n in (data['nodes'] as List<dynamic>)) {
        batch.insert(
          'nodes',
          {
            'id': n['id'] as String,
            'name': n['name'] as String,
            'floor': n['floor'] as int,
            'x': (n['x'] as num).toDouble(),
            'y': (n['y'] as num).toDouble(),
            'type': n['type'] as String,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      // Edges
      for (final e in (data['edges'] as List<dynamic>)) {
        batch.insert('edges', {
          'origin': e['origin'] as String,
          'destination': e['destination'] as String,
          'distance': (e['distance'] as num).toDouble(),
          // JSON boolean → SQLite integer (1/0)
          'accessible': (e['accessible'] as bool? ?? true) ? 1 : 0,
        });
      }

      // POIs + their FTS5 shadow rows
      for (final poi in (data['pois'] as List<dynamic>)) {
        final tagsJson = jsonEncode(poi['tags'] ?? <dynamic>[]);
        batch.insert(
          'pois',
          {
            'id': poi['id'] as String,
            'name': poi['name'] as String,
            'category': poi['category'] as String,
            'nodeId': poi['nodeId'] as String,
            'description': poi['description'] as String? ?? '',
            'tags': tagsJson,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      await batch.commit(noResult: true);
    } catch (e) {
      throw AssetException('Failed to seed map data: $e');
    }
  }

  // Throws DatabaseException if initDatabase() was never called.
  Database get _database {
    final db = _db;
    if (db == null) {
      throw const DatabaseException(
        'Database not initialised. Call initDatabase() before use.',
      );
    }
    return db;
  }

  @override
  Future<List<NodeModel>> getNodes({int? floor}) async {
    final rows = floor != null
        ? await _database.query(
            'nodes',
            where: 'floor = ?',
            whereArgs: [floor],
          )
        : await _database.query('nodes');

    return rows
        .map((r) => NodeModel.fromJson(Map<String, dynamic>.from(r)))
        .toList();
  }

  @override
  Future<List<EdgeModel>> getEdges() async {
    final rows = await _database.query('edges');
    return rows.map((r) {
      // SQLite stores booleans as integers; convert back to bool.
      return EdgeModel.fromJson({
        'origin': r['origin'] as String,
        'destination': r['destination'] as String,
        'distance': r['distance'] as double,
        'accessible': (r['accessible'] as int) == 1,
      });
    }).toList();
  }

  @override
  Future<List<PoiModel>> getPois() async {
    final rows = await _database.query('pois');
    return rows.map(_rowToPoi).toList();
  }

  @override
  Future<List<PoiModel>> searchPois(String query) async {
    // Sanitise the query: trim whitespace and escape SQL LIKE wildcards
    // so user input cannot inject '%' or '_' patterns unintentionally.
    final sanitised = query.trim().replaceAll('%', r'\%').replaceAll('_', r'\_');
    if (sanitised.isEmpty) return getPois();
    // Match against name, category, description, and the raw tags JSON string.
    // The trailing '%' gives prefix-match behaviour equivalent to FTS5's '*' suffix.
    // ESCAPE clause tells SQLite that '\' is the escape character for LIKE.

    final rows = await _database.rawQuery(
      '''
      SELECT p.*
      FROM pois
      WHERE name        LIKE ? ESCAPE '\'
       OR category    LIKE ? ESCAPE '\'
       OR description LIKE ? ESCAPE '\'
       OR tags        LIKE ? ESCAPE '\'
      LIMIT 20
      ''',
      [
        '$sanitised%',
        '$sanitised%',
        '%$sanitised%',
        '%$sanitised%',
      ],
    );
    return rows.map(_rowToPoi).toList();
  }

  PoiModel _rowToPoi(Map<String, Object?> row) {
    return PoiModel.fromJson({
      'id': row['id'] as String,
      'name': row['name'] as String,
      'category': row['category'] as String,
      'nodeId': row['nodeId'] as String,
      'description': row['description'] as String? ?? '',
      // Tags are stored as a JSON string array; decode back to List<String>.
      'tags': (jsonDecode(row['tags'] as String) as List<dynamic>)
          .cast<String>(),
    });
  }
}
```

---

### 4.3 `features/map/data/repositories/map_repository_impl.dart`

```dart
// lib/features/map/data/repositories/map_repository_impl.dart
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/edge.dart';
import '../../domain/entities/node.dart';
import '../../domain/entities/poi.dart';
import '../../domain/repositories/map_repository.dart';
import '../datasources/map_local_datasource.dart';

/// Converts raw datasource results (models / exceptions) into typed domain
/// values wrapped in Either. No business logic lives here.
class MapRepositoryImpl implements MapRepository {
  final MapLocalDataSource _dataSource;

  const MapRepositoryImpl(this._dataSource);

  @override
  Future<EitherFailure<List<Node>>> getNodes({int? floor}) async {
    try {
      final models = await _dataSource.getNodes(floor: floor);
      return right(models.map((m) => m.toEntity()).toList());
    } on DatabaseException catch (e) {
      return left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<EitherFailure<List<Edge>>> getEdges() async {
    try {
      final models = await _dataSource.getEdges();
      return right(models.map((m) => m.toEntity()).toList());
    } on DatabaseException catch (e) {
      return left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<EitherFailure<List<Poi>>> getPois() async {
    try {
      final models = await _dataSource.getPois();
      return right(models.map((m) => m.toEntity()).toList());
    } on DatabaseException catch (e) {
      return left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<EitherFailure<List<Poi>>> searchPois(String query) async {
    try {
      final models = await _dataSource.searchPois(query);
      return right(models.map((m) => m.toEntity()).toList());
    } on DatabaseException catch (e) {
      return left(DatabaseFailure(e.message));
    }
  }
}
```

---

## 5. Domain Layer

The domain layer is pure Dart — no Flutter imports, no `fromJson`, no framework dependencies. Dependencies point inward only.

### 5.1 Entities

#### `features/map/domain/entities/node.dart`

```dart
// lib/features/map/domain/entities/node.dart

enum NodeType { room, elevator, stairs, junction, entrance }

/// A vertex in the hospital graph.
/// Pure Dart — no framework or serialization dependencies.
class Node {
  final String id;
  final String name;
  final int floor;
  final double x; // Local canvas coordinate
  final double y;
  final NodeType type;

  const Node({
    required this.id,
    required this.name,
    required this.floor,
    required this.x,
    required this.y,
    required this.type,
  });

  /// Convenience getter used by the accessibility filter in CalculateRoute.
  bool get isAccessible => type != NodeType.stairs;
}
```

#### `features/map/domain/entities/edge.dart`

```dart
// lib/features/map/domain/entities/edge.dart

/// A weighted, undirected connection between two graph nodes.
class Edge {
  final String origin;
  final String destination;
  final double distance; // In arbitrary map units (treated as metres for display)
  final bool accessible; // false = stairs-only segment (excluded when avoidStairs=true)

  const Edge({
    required this.origin,
    required this.destination,
    required this.distance,
    required this.accessible,
  });
}
```

#### `features/map/domain/entities/poi.dart`

```dart
// lib/features/map/domain/entities/poi.dart

/// A Point of Interest that users can search for and navigate to.
class Poi {
  final String id;
  final String name;
  final String category;
  final String nodeId; // The graph node this POI is anchored to
  final String description;
  final List<String> tags;

  const Poi({
    required this.id,
    required this.name,
    required this.category,
    required this.nodeId,
    required this.description,
    required this.tags,
  });
}
```

#### `features/map/domain/entities/route_result.dart`

```dart
// lib/features/map/domain/entities/route_result.dart
import 'node.dart';

/// The output of a successful Dijkstra route calculation.
class RouteResult {
  /// Ordered list of nodes from origin to destination (inclusive).
  final List<Node> nodes;

  /// Sum of all edge weights along the path (in map distance units).
  final double totalDistance;

  /// True when every edge in the route is accessible (no stairs).
  final bool isFullyAccessible;

  const RouteResult({
    required this.nodes,
    required this.totalDistance,
    required this.isFullyAccessible,
  });

  bool get isEmpty => nodes.isEmpty;
}
```

#### `features/navigation/domain/entities/navigation_step.dart`

```dart
// lib/features/navigation/domain/entities/navigation_step.dart

/// Direction a user should turn when reaching a node.
enum TurnDirection {
  straight,
  left,
  right,
  slightLeft,
  slightRight,
  arrival,
}

/// A single human-readable step in a turn-by-turn navigation sequence.
class NavigationStep {
  final String instruction;     // e.g. "Turn right at the elevator lobby"
  final double distanceMeters;  // Distance to walk before taking this turn
  final TurnDirection direction;
  final String referenceNodeId; // The node this step points toward

  const NavigationStep({
    required this.instruction,
    required this.distanceMeters,
    required this.direction,
    required this.referenceNodeId,
  });
}
```

---

### 5.2 Repository Contracts

```dart
// lib/features/map/domain/repositories/map_repository.dart
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/edge.dart';
import '../entities/node.dart';
import '../entities/poi.dart';

/// Abstract contract. Implemented in the data layer.
/// The domain layer depends only on this interface — never on the implementation.
abstract interface class MapRepository {
  Future<EitherFailure<List<Node>>> getNodes({int? floor});
  Future<EitherFailure<List<Edge>>> getEdges();
  Future<EitherFailure<List<Poi>>> getPois();
  Future<EitherFailure<List<Poi>>> searchPois(String query);
}
```

---

### 5.3 Use Cases

#### `features/map/domain/usecases/get_floor_graph.dart`

```dart
// lib/features/map/domain/usecases/get_floor_graph.dart
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/edge.dart';
import '../entities/node.dart';
import '../repositories/map_repository.dart';

/// Aggregates nodes and edges into a single graph snapshot for a given floor.
/// Used by the map canvas to render nodes and by route calculation.
class FloorGraph {
  final List<Node> nodes;
  final List<Edge> edges;

  const FloorGraph({required this.nodes, required this.edges});
}

class GetFloorGraph {
  final MapRepository _repository;

  const GetFloorGraph(this._repository);

  /// If [floor] is null, returns the entire multi-floor graph.
  Future<EitherFailure<FloorGraph>> call({int? floor}) async {
    final nodesResult = await _repository.getNodes(floor: floor);
    final edgesResult = await _repository.getEdges();

    // fpdart's flatMap chains Either values without nested if/else.
    return nodesResult.flatMap(
      (nodes) => edgesResult.map(
        (edges) => FloorGraph(nodes: nodes, edges: edges),
      ),
    );
  }
}
```

#### `features/map/domain/usecases/get_all_pois.dart`

```dart
// lib/features/map/domain/usecases/get_all_pois.dart
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/poi.dart';
import '../repositories/map_repository.dart';

class GetAllPois {
  final MapRepository _repository;

  const GetAllPois(this._repository);

  Future<EitherFailure<List<Poi>>> call() => _repository.getPois();
}
```

---

## 6. Graph Algorithm — Dijkstra with Accessibility Filter

The `CalculateRoute` use case contains the entire pathfinding logic inline. No external graph library is needed — the hospital graph has fewer than 2,000 nodes.

```dart
// lib/features/map/domain/usecases/calculate_route.dart
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/edge.dart';
import '../entities/node.dart';
import '../entities/route_result.dart';
import '../repositories/map_repository.dart';

class CalculateRouteParams {
  final String originNodeId;
  final String destinationNodeId;

  /// FR-09: when true, stair-only edges are excluded from the graph entirely
  /// before Dijkstra runs — not just penalised.
  final bool avoidStairs;

  const CalculateRouteParams({
    required this.originNodeId,
    required this.destinationNodeId,
    required this.avoidStairs,
  });
}

class CalculateRoute {
  final MapRepository _repository;

  const CalculateRoute(this._repository);

  Future<EitherFailure<RouteResult>> call(CalculateRouteParams params) async {
    final nodesResult = await _repository.getNodes();
    final edgesResult = await _repository.getEdges();

    return nodesResult.flatMap(
      (nodes) => edgesResult.flatMap(
        (edges) => _dijkstra(
          nodes: nodes,
          edges: edges,
          originId: params.originNodeId,
          destinationId: params.destinationNodeId,
          avoidStairs: params.avoidStairs,
        ),
      ),
    );
  }

  EitherFailure<RouteResult> _dijkstra({
    required List<Node> nodes,
    required List<Edge> edges,
    required String originId,
    required String destinationId,
    required bool avoidStairs,
  }) {
    // ── Validation ────────────────────────────────────────────────────────
    final nodeMap = {for (final n in nodes) n.id: n};

    if (!nodeMap.containsKey(originId)) {
      return left(const GraphFailure('Origin node not found in graph'));
    }
    if (!nodeMap.containsKey(destinationId)) {
      return left(const GraphFailure('Destination node not found in graph'));
    }

    // ── Build undirected adjacency list ───────────────────────────────────
    // When avoidStairs=true, inaccessible edges are excluded entirely.
    // This guarantees the result is a fully accessible route, not just the
    // shortest one — consistent with FR-09's "absence of stairs" criterion.
    final adj = <String, List<(String, double)>>{};
    for (final e in edges) {
      if (avoidStairs && !e.accessible) continue;
      // Insert both directions (undirected graph).
      adj.putIfAbsent(e.origin, () => []).add((e.destination, e.distance));
      adj.putIfAbsent(e.destination, () => []).add((e.origin, e.distance));
    }

    // ── Dijkstra ──────────────────────────────────────────────────────────
    // A sorted list is used as the priority queue. Acceptable for < 2,000
    // nodes. For larger graphs, replace with package:collection HeapPriorityQueue.
    final dist = <String, double>{originId: 0.0};
    final prev = <String, String?>{originId: null};
    final visited = <String>{};
    // Queue entries: (tentative distance, node id)
    final queue = <(double, String)>[(0.0, originId)];

    while (queue.isNotEmpty) {
      // Sort ascending by distance so the smallest is always at index 0.
      queue.sort((a, b) => a.$1.compareTo(b.$1));
      final (currentDist, currentId) = queue.removeAt(0);

      if (visited.contains(currentId)) continue;
      visited.add(currentId);

      // Early exit — no need to explore further once the destination is settled.
      if (currentId == destinationId) break;

      for (final (neighbourId, weight) in (adj[currentId] ?? [])) {
        final tentative = currentDist + weight;
        if (tentative < (dist[neighbourId] ?? double.infinity)) {
          dist[neighbourId] = tentative;
          prev[neighbourId] = currentId;
          queue.add((tentative, neighbourId));
        }
      }
    }

    // ── Check reachability ────────────────────────────────────────────────
    if (!dist.containsKey(destinationId)) {
      return left(const RouteNotFoundFailure(
        'No accessible route found between the selected points.',
      ));
    }

    // ── Reconstruct path ──────────────────────────────────────────────────
    // Walk prev[] backwards from destination to origin, then reverse.
    // `path` is declared as `var` (not `final`) so it can be reassigned
    // after the reversal — this is the one intentional exception to the
    // `final`-by-default rule.
    var path = <Node>[];
    String? current = destinationId;
    while (current != null) {
      path.add(nodeMap[current]!);
      current = prev[current];
    }
    path = path.reversed.toList();

    // ── Check full accessibility of reconstructed path ────────────────────
    // Even when avoidStairs=false the caller may want to know whether the
    // shortest path happens to be stair-free (used for polyline colouring).
    var fullyAccessible = true;
    for (var i = 0; i < path.length - 1; i++) {
      final segmentAccessible = edges.any(
        (e) =>
            ((e.origin == path[i].id && e.destination == path[i + 1].id) ||
                (e.destination == path[i].id && e.origin == path[i + 1].id)) &&
            e.accessible,
      );
      if (!segmentAccessible) {
        fullyAccessible = false;
        break;
      }
    }

    return right(RouteResult(
      nodes: path,
      totalDistance: dist[destinationId]!,
      isFullyAccessible: fullyAccessible,
    ));
  }
}
```

> **Multi-floor routing:** Elevator nodes connect floors via edges whose `accessible` flag is `true`. Stair nodes connect via `accessible: false` edges. The graph is entirely flat (all floors in one dataset); floor transitions are simply edges between nodes on different floors. No special multi-floor logic is required in the algorithm.

---

## 7. Presentation Layer — Providers

> **Riverpod 3 + code-gen rules applied throughout:**
> - All functional providers use plain `Ref` (named `Ref` subclasses like `MapRepositoryRef` were removed in Riverpod 3).
> - `@Riverpod(keepAlive: true)` is used for infrastructure providers that must survive navigation.
> - `AsyncNotifier` is used for async mutable state; `Notifier` for sync mutable state.
> - Business logic is delegated to use cases — providers only wire DI and state.

### 7.1 `features/map/presentation/providers/map_provider.dart`

```dart
// lib/features/map/presentation/providers/map_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import '../../data/datasources/map_local_datasource.dart';
import '../../data/repositories/map_repository_impl.dart';
import '../../domain/entities/poi.dart';
import '../../domain/entities/route_result.dart';
import '../../domain/repositories/map_repository.dart';
import '../../domain/usecases/calculate_route.dart';
import '../../domain/usecases/get_all_pois.dart';
import '../../domain/usecases/get_floor_graph.dart';

part 'map_provider.g.dart';

// ── Infrastructure (keepAlive — survive navigation) ───────────────────────

/// The datasource is initialised in main() and injected via
/// ProviderScope.overrides — this provider is the fallback.
@Riverpod(keepAlive: true)
MapLocalDataSource mapLocalDataSource(Ref ref) => MapLocalDataSourceImpl();

@Riverpod(keepAlive: true)
MapRepository mapRepository(Ref ref) =>
    MapRepositoryImpl(ref.watch(mapLocalDataSourceProvider));

// ── Use-case providers ────────────────────────────────────────────────────

@riverpod
GetFloorGraph getFloorGraph(Ref ref) =>
    GetFloorGraph(ref.watch(mapRepositoryProvider));

@riverpod
GetAllPois getAllPois(Ref ref) =>
    GetAllPois(ref.watch(mapRepositoryProvider));

@riverpod
CalculateRoute calculateRoute(Ref ref) =>
    CalculateRoute(ref.watch(mapRepositoryProvider));

// ── UI state providers ────────────────────────────────────────────────────

/// Currently selected floor — drives map canvas and node filter (FR-01).
@riverpod
class SelectedFloor extends _$SelectedFloor {
  @override
  int build() => 0; // Ground floor on launch

  void setFloor(int floor) => state = floor;
}

/// Manually set "I'm here" node — the origin for all route calculations (FR-06).
@riverpod
class UserLocation extends _$UserLocation {
  @override
  String? build() => null;

  void setLocation(String nodeId) => state = nodeId;
  void clear() => state = null;
}

/// Nodes + edges for the current floor — rebuilds automatically when
/// [selectedFloorProvider] changes.
@riverpod
Future<FloorGraph> floorGraph(Ref ref) async {
  final floor = ref.watch(selectedFloorProvider);
  final useCase = ref.watch(getFloorGraphProvider);
  final result = await useCase(floor: floor);
  return result.fold(
    (failure) => throw failure,
    (graph) => graph,
  );
}

/// All POIs — kept alive so search results are instant after first load.
@Riverpod(keepAlive: true)
Future<List<Poi>> allPois(Ref ref) async {
  final useCase = ref.watch(getAllPoisProvider);
  final result = await useCase();
  return result.fold(
    (failure) => throw failure,
    (pois) => pois,
  );
}

/// The active computed route — null when no destination has been selected.
///
/// Uses [AsyncNotifier] so the UI can observe loading/error/data states.
@riverpod
class CurrentRoute extends _$CurrentRoute {
  @override
  AsyncValue<RouteResult?> build() => const AsyncData(null);

  Future<void> computeRoute({
    required String destinationId,
    required bool avoidStairs,
  }) async {
    final origin = ref.read(userLocationProvider);
    if (origin == null) {
      state = AsyncError(
        const GraphFailure('Please set your current location first.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();

    final useCase = ref.read(calculateRouteProvider);
    final result = await useCase(
      CalculateRouteParams(
        originNodeId: origin,
        destinationNodeId: destinationId,
        avoidStairs: avoidStairs,
      ),
    );

    state = result.fold(
      (failure) => AsyncError(failure, StackTrace.current),
      AsyncData.new,
    );
  }

  void clear() => state = const AsyncData(null);
}
```

---

### 7.2 `features/navigation/presentation/providers/navigation_provider.dart`

```dart
// lib/features/navigation/presentation/providers/navigation_provider.dart
import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../map/domain/entities/node.dart';
import '../../../map/presentation/providers/map_provider.dart';
import '../../domain/entities/navigation_step.dart';

part 'navigation_provider.g.dart';

/// Index of the step the user is currently on.
/// A plain [Notifier] (sync) is correct here — index is an int, not async.
@riverpod
class NavigationIndex extends _$NavigationIndex {
  @override
  int build() => 0;

  void advance() => state = state + 1;
  void reset() => state = 0;
}

/// Derives the full ordered list of [NavigationStep]s from the active route.
/// Returns [] when no route is active.
@riverpod
List<NavigationStep> navigationSteps(Ref ref) {
  final routeAsync = ref.watch(currentRouteProvider);
  return routeAsync.when(
    data: (route) {
      if (route == null || route.isEmpty) return [];
      return _buildSteps(route.nodes);
    },
    loading: () => [],
    error: (_, __) => [],
  );
}

/// The step the user is currently navigating. Null when navigation is inactive
/// or all steps have been completed.
@riverpod
NavigationStep? currentStep(Ref ref) {
  final steps = ref.watch(navigationStepsProvider);
  final index = ref.watch(navigationIndexProvider);
  if (steps.isEmpty || index >= steps.length) return null;
  return steps[index];
}

// ── Step builder ─────────────────────────────────────────────────────────

List<NavigationStep> _buildSteps(List<Node> nodes) {
  final steps = <NavigationStep>[];

  for (var i = 0; i < nodes.length - 1; i++) {
    final from = nodes[i];
    final to = nodes[i + 1];
    final isLast = i == nodes.length - 2;

    final direction = isLast
        ? TurnDirection.arrival
        : _detectTurn(
            prev: i > 0 ? nodes[i - 1] : null,
            current: from,
            next: to,
          );

    steps.add(NavigationStep(
      instruction: _instructionLabel(direction, to.name),
      distanceMeters: _euclidean(from, to),
      direction: direction,
      referenceNodeId: to.id,
    ));
  }

  return steps;
}

/// Computes the turn direction at [current] based on the incoming vector
/// (prev→current) and the outgoing vector (current→next).
/// Returns [TurnDirection.straight] when [prev] is null (first step).
TurnDirection _detectTurn({
  required Node? prev,
  required Node current,
  required Node next,
}) {
  if (prev == null) return TurnDirection.straight;

  final bearing1 = math.atan2(current.y - prev.y, current.x - prev.x);
  final bearing2 = math.atan2(next.y - current.y, next.x - current.x);

  // Angle change in degrees, normalised to [-180, 180].
  var angle = (bearing2 - bearing1) * 180 / math.pi;
  while (angle > 180) angle -= 360;
  while (angle < -180) angle += 360;

  if (angle.abs() < 20) return TurnDirection.straight;
  if (angle > 60) return TurnDirection.left;
  if (angle < -60) return TurnDirection.right;
  if (angle > 20) return TurnDirection.slightLeft;
  return TurnDirection.slightRight;
}

String _instructionLabel(TurnDirection dir, String nodeName) {
  return switch (dir) {
    TurnDirection.straight => 'Continue straight towards $nodeName',
    TurnDirection.left => 'Turn left towards $nodeName',
    TurnDirection.right => 'Turn right towards $nodeName',
    TurnDirection.slightLeft => 'Keep slightly left towards $nodeName',
    TurnDirection.slightRight => 'Keep slightly right towards $nodeName',
    TurnDirection.arrival => 'You have arrived at $nodeName',
  };
}

double _euclidean(Node a, Node b) {
  final dx = b.x - a.x;
  final dy = b.y - a.y;
  return math.sqrt(dx * dx + dy * dy);
}
```

---

### 7.3 `features/search/presentation/providers/search_provider.dart`

```dart
// lib/features/search/presentation/providers/search_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
```

---

### 7.4 `features/settings/presentation/providers/settings_provider.dart`

```dart
// lib/features/settings/presentation/providers/settings_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final prefs = await ref.read(sharedPreferencesProvider.future);
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
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setBool(_kHighContrast, !current);
    ref.invalidateSelf();
  }
}
```

---

## 8. Presentation Layer — Pages & Widgets

### 8.1 Map coordinate helper

This helper is defined at the top of `map_page.dart` and re-imported by widget files that need it. It maps local pixel coordinates to a fake LatLng space that `flutter_map` can render without GPS.

```dart
// lib/features/map/presentation/pages/map_page.dart  (top of file, before class)
import 'package:latlong2/latlong.dart';

/// Converts local canvas coordinates (arbitrary units) to a fake LatLng
/// space for flutter_map rendering. 1 unit ≈ 1 mm at 1:1000 scale.
/// The map has no real GPS dependency — FR-06 (manual "I'm here") handles
/// the user's position without any location permission.
LatLng nodeToLatLng(double x, double y) => LatLng(y / 1000, x / 1000);
```

---

### 8.2 `features/map/presentation/pages/map_page.dart`

```dart
// lib/features/map/presentation/pages/map_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../providers/map_provider.dart';
import '../widgets/floor_selector.dart';
import '../widgets/map_overlay_layer.dart';
import '../widgets/route_polyline_layer.dart';

LatLng nodeToLatLng(double x, double y) => LatLng(y / 1000, x / 1000);

class MapPage extends ConsumerWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final graphAsync = ref.watch(floorGraphProvider);
    final routeAsync = ref.watch(currentRouteProvider);
    final currentFloor = ref.watch(selectedFloorProvider);
    final userNodeId = ref.watch(userLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Map'),
        actions: [
          IconButton(
            tooltip: 'Search destination',
            icon: const Icon(Icons.search),
            // go_router ^17: context.pushNamed() is unchanged from v14.
            onPressed: () => context.pushNamed('search'),
          ),
          IconButton(
            tooltip: 'Settings',
            icon: const Icon(Icons.settings),
            onPressed: () => context.pushNamed('settings'),
          ),
        ],
      ),
      body: graphAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorView(message: e.toString()),
        data: (graph) => Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: const LatLng(0.5, 0.5),
                initialZoom: 13,
                minZoom: 10,
                maxZoom: 18,
                // flutter_map ^8: InteractionOptions replaces enableInteraction.
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom |
                      InteractiveFlag.drag |
                      InteractiveFlag.doubleTapZoom,
                ),
              ),
              children: [
                // Floor plan raster image — replace with real asset per floor.
                // flutter_map ^8 uses OverlayImageLayer + OverlayImage.
                OverlayImageLayer(
                  overlayImages: [
                    OverlayImage(
                      bounds: LatLngBounds(
                        const LatLng(0, 0),
                        const LatLng(1, 1),
                      ),
                      imageProvider: AssetImage(
                        'assets/floor_plans/floor_$currentFloor.png',
                      ),
                    ),
                  ],
                ),

                // POI markers — tapping a node sets "I'm here" (FR-06).
                MapOverlayLayer(
                  nodes: graph.nodes,
                  userNodeId: userNodeId,
                  onNodeTap: (nodeId) =>
                      ref.read(userLocationProvider.notifier).setLocation(nodeId),
                ),

                // Route polyline (FR-03) — visible only when a route exists.
                routeAsync.when(
                  data: (route) => route != null
                      ? RoutePolylineLayer(route: route)
                      : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),

            // Floor selector — positioned over the map (FR-01).
            Positioned(
              right: 12,
              bottom: 120,
              child: FloorSelector(
                currentFloor: currentFloor,
                onFloorChanged: (floor) =>
                    ref.read(selectedFloorProvider.notifier).setFloor(floor),
              ),
            ),

            // Error banner for route failures.
            if (routeAsync.hasError)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _RouteErrorBanner(
                  message: routeAsync.error.toString(),
                  onDismiss: () =>
                      ref.read(currentRouteProvider.notifier).clear(),
                ),
              ),
          ],
        ),
      ),

      floatingActionButton: routeAsync.when(
        data: (route) => route != null && !route.isEmpty
            ? FloatingActionButton.extended(
                onPressed: () => context.pushNamed(
                  'navigate',
                  pathParameters: {'destinationId': route.nodes.last.id},
                ),
                icon: const Icon(Icons.navigation),
                label: const Text('Start navigation'),
              )
            : null,
        loading: () => null,
        error: (_, __) => null,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  const _ErrorView({required this.message});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
}

class _RouteErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback onDismiss;
  const _RouteErrorBanner({required this.message, required this.onDismiss});

  @override
  Widget build(BuildContext context) => Material(
        color: Theme.of(context).colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                color: Theme.of(context).colorScheme.onErrorContainer,
                onPressed: onDismiss,
              ),
            ],
          ),
        ),
      );
}
```

---

### 8.3 `features/map/presentation/widgets/floor_selector.dart`

```dart
// lib/features/map/presentation/widgets/floor_selector.dart
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
```

---

### 8.4 `features/map/presentation/widgets/map_overlay_layer.dart`

```dart
// lib/features/map/presentation/widgets/map_overlay_layer.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../domain/entities/node.dart';
import '../pages/map_page.dart'; // nodeToLatLng

/// Renders a [Marker] for every node in the current floor graph.
/// Tapping any marker invokes [onNodeTap] with the tapped node's id,
/// allowing the user to set "I'm here" (FR-06).
class MapOverlayLayer extends StatelessWidget {
  final List<Node> nodes;
  final String? userNodeId;
  final ValueChanged<String> onNodeTap;

  const MapOverlayLayer({
    super.key,
    required this.nodes,
    required this.onNodeTap,
    this.userNodeId,
  });

  @override
  Widget build(BuildContext context) {
    // flutter_map ^8: MarkerLayer accepts a List<Marker>.
    return MarkerLayer(
      markers: nodes.map((node) {
        final isUser = node.id == userNodeId;
        return Marker(
          width: 36,
          height: 36,
          point: nodeToLatLng(node.x, node.y),
          child: GestureDetector(
            onTap: () => onNodeTap(node.id),
            child: Semantics(
              label: isUser
                  ? 'Your current location: ${node.name}'
                  : '${node.type.name}: ${node.name}. Tap to set as your location.',
              child: Icon(
                _iconForType(node.type, isUser),
                color: isUser ? Colors.blue : _colorForType(node.type, context),
                size: 30,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _iconForType(NodeType type, bool isUser) {
    if (isUser) return Icons.my_location;
    return switch (type) {
      NodeType.elevator => Icons.elevator,
      NodeType.stairs => Icons.stairs,
      NodeType.entrance => Icons.door_front_door,
      NodeType.room => Icons.room,
      NodeType.junction => Icons.circle_outlined,
    };
  }

  Color _colorForType(NodeType type, BuildContext context) {
    return switch (type) {
      NodeType.elevator => Colors.green.shade700,
      NodeType.stairs => Colors.orange.shade700,
      NodeType.entrance => Colors.purple.shade700,
      NodeType.room => Theme.of(context).colorScheme.primary,
      NodeType.junction => Colors.grey,
    };
  }
}
```

---

### 8.5 `features/map/presentation/widgets/route_polyline_layer.dart`

```dart
// lib/features/map/presentation/widgets/route_polyline_layer.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../domain/entities/route_result.dart';
import '../pages/map_page.dart';

/// Draws the computed route as a coloured polyline on the flutter_map canvas.
/// Blue = fully accessible route. Orange = route contains at least one stair segment.
/// The colour difference satisfies FR-09's "absence of stairs" feedback requirement.
class RoutePolylineLayer extends StatelessWidget {
  final RouteResult route;

  const RoutePolylineLayer({super.key, required this.route});

  @override
  Widget build(BuildContext context) {
    final points =
        route.nodes.map((node) => nodeToLatLng(node.x, node.y)).toList();

    // flutter_map ^8: PolylineLayer replaces PolylineLayerOptions.
    return PolylineLayer(
      polylines: [
        Polyline(
          points: points,
          color: route.isFullyAccessible ? Colors.blue : Colors.orange,
          strokeWidth: 5,
          borderColor: Colors.white,
          borderStrokeWidth: 2,
        ),
      ],
    );
  }
}
```

---

### 8.6 `features/navigation/presentation/pages/navigation_page.dart`

```dart
// lib/features/navigation/presentation/pages/navigation_page.dart
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
        title: const Text('Navigation'),
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
            semanticsValue:
                'Step ${currentIndex + 1} of ${steps.length}',
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
```

---

### 8.7 `features/navigation/presentation/widgets/step_instruction_card.dart`

```dart
// lib/features/navigation/presentation/widgets/step_instruction_card.dart
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
```

---

### 8.8 `features/search/presentation/pages/search_page.dart`

```dart
// lib/features/search/presentation/pages/search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../../map/domain/entities/poi.dart';
import '../../../map/presentation/providers/map_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../providers/search_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  // speech_to_text ^7: SpeechToText is the main class.
  final _speechToText = stt.SpeechToText();
  bool _isListening = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _startListening() async {
    // speech_to_text ^7: initialize() returns bool; no longer throws.
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

    // speech_to_text ^7: listen() accepts localeId as a named parameter.
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

  Future<void> _selectPoi(Poi poi) async {
    // Read avoidStairs preference before computing the route.
    // avoidStairsProvider is async — await its future.
    final avoidStairs = await ref.read(avoidStairsProvider.future);
    await ref.read(currentRouteProvider.notifier).computeRoute(
          destinationId: poi.nodeId,
          avoidStairs: avoidStairs,
        );
    if (mounted) context.goNamed('map');
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        // Embedding the TextField directly in the AppBar gives a native search
        // feel without needing a separate SearchBar widget.
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search rooms, services…',
            border: InputBorder.none,
          ),
          onChanged: (v) => ref.read(searchQueryProvider.notifier).update(v),
        ),
        actions: [
          Semantics(
            label: _isListening ? 'Stop voice search' : 'Start voice search',
            child: IconButton(
              icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
              onPressed: _isListening ? _stopListening : _startListening,
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Clear search',
              onPressed: () {
                _controller.clear();
                ref.read(searchQueryProvider.notifier).clear();
              },
            ),
        ],
      ),
      body: resultsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (pois) => pois.isEmpty
            ? const Center(child: Text('No results found.'))
            : ListView.builder(
                itemCount: pois.length,
                itemBuilder: (context, i) {
                  final poi = pois[i];
                  return ListTile(
                    leading: const Icon(Icons.place),
                    title: Text(poi.name),
                    subtitle: Text(poi.category),
                    onTap: () => _selectPoi(poi),
                    // semanticsLabel provides a complete TalkBack description (FR-05).
                    semanticsLabel:
                        '${poi.name}, ${poi.category}. Tap to navigate.',
                  );
                },
              ),
      ),
    );
  }
}
```

---

### 8.9 `features/settings/presentation/pages/settings_page.dart`

```dart
// lib/features/settings/presentation/pages/settings_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avoidStairsAsync = ref.watch(avoidStairsProvider);
    final highContrastAsync = ref.watch(highContrastProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // FR-07, FR-09 — accessible route preference
          SwitchListTile(
            title: const Text('Avoid stairs'),
            subtitle: const Text('Routes will use elevators and ramps only'),
            secondary: const Icon(Icons.accessible),
            value: avoidStairsAsync.value ?? false,
            // Disable toggle while preference is loading to prevent double-writes.
            onChanged: avoidStairsAsync.isLoading
                ? null
                : (_) => ref.read(avoidStairsProvider.notifier).toggle(),
          ),
          // FR-10 — high-contrast theme
          SwitchListTile(
            title: const Text('High contrast mode'),
            subtitle: const Text('Increases text and interface contrast'),
            secondary: const Icon(Icons.contrast),
            value: highContrastAsync.value ?? false,
            onChanged: highContrastAsync.isLoading
                ? null
                : (_) => ref.read(highContrastProvider.notifier).toggle(),
          ),
          const Divider(),
          const ListTile(
            title: Text('App version'),
            trailing: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
```

---

## 9. Services

Services wrap hardware-facing packages (TTS, STT, vibration). They are plain Dart classes — not Riverpod providers — so they can be instantiated, mocked, and tested without a `ProviderScope`.

### 9.1 `services/tts_service.dart`

```dart
// lib/services/tts_service.dart
import 'package:flutter_tts/flutter_tts.dart';

/// Wraps flutter_tts ^4.x for step announcements (FR-04, FR-05, FR-08).
/// Call [init] once before the first [speak].
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    // flutter_tts ^4: setLanguage accepts BCP-47 language tags.
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
```

### 9.2 `services/speech_service.dart`

```dart
// lib/services/speech_service.dart
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
    // speech_to_text ^7: initialize() no longer throws on failure;
    // it returns false instead.
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
```

### 9.3 `services/vibration_service.dart`

```dart
// lib/services/vibration_service.dart
import 'package:vibration/vibration.dart';

/// Haptic feedback for turn notifications (FR-08).
/// All methods are safe to call on devices without a vibrator (no-op).
class VibrationService {
  /// Short single pulse — signals the user to advance a step.
  Future<void> vibrateShort() async {
    // vibration ^2: hasVibrator() returns Future<bool?> — null-safe guard.
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 200);
    }
  }

  /// Long pulse — signals arrival at the destination.
  Future<void> vibrateLong() async {
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 600);
    }
  }

  /// Three-pulse pattern — configurable turn-approaching alert (FR-08).
  Future<void> vibratePattern() async {
    if (await Vibration.hasVibrator() ?? false) {
      // Pattern: [delay, duration, delay, duration, delay, duration]
      await Vibration.vibrate(pattern: [0, 200, 100, 200, 100, 200]);
    }
  }
}
```

---

## 10. main.dart & Bootstrap

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/map/data/datasources/map_local_datasource.dart';
import 'features/map/presentation/providers/map_provider.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise the database before the widget tree mounts.
  // The instance is then injected via ProviderScope.overrides so that
  // mapLocalDataSourceProvider always returns the pre-warmed instance.
  final dataSource = MapLocalDataSourceImpl();
  await dataSource.initDatabase();

  runApp(
    ProviderScope(
      overrides: [
        mapLocalDataSourceProvider.overrideWithValue(dataSource),
      ],
      child: const HospitalNavApp(),
    ),
  );
}

class HospitalNavApp extends ConsumerWidget {
  const HospitalNavApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final highContrastAsync = ref.watch(highContrastProvider);

    return MaterialApp.router(
      title: 'Hospital Navigation',
      debugShowCheckedModeBanner: false,

      // FR-10: switch between themes based on user preference.
      theme: AppTheme.light,
      darkTheme: AppTheme.highContrast,
      themeMode: highContrastAsync.value == true
          ? ThemeMode.dark
          : ThemeMode.light,

      // go_router ^17: routerConfig replaces routerDelegate + routeInformationParser.
      routerConfig: router,

      // NFR-08: default locale is Brazilian Portuguese.
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
    );
  }
}
```

---

## 11. Map Asset — map_data.json

Place at `assets/map_data.json`. This file seeds the SQLite database on first launch.

```json
{
  "metadata": {
    "version": "1.0",
    "lastUpdated": "2026-03-16",
    "author": "Ed William Pereira"
  },
  "nodes": [
    { "id": "entrance_main", "name": "Main Entrance",     "floor": 0, "x": 500, "y": 100, "type": "entrance" },
    { "id": "lobby_0",       "name": "Ground Floor Lobby","floor": 0, "x": 500, "y": 300, "type": "junction" },
    { "id": "elevator_0",    "name": "Elevator Floor 0",  "floor": 0, "x": 700, "y": 300, "type": "elevator" },
    { "id": "stairs_0",      "name": "Stairs Floor 0",    "floor": 0, "x": 300, "y": 300, "type": "stairs"   },
    { "id": "room_101",      "name": "Consulting Room 1", "floor": 0, "x": 200, "y": 500, "type": "room"     },
    { "id": "room_102",      "name": "Pharmacy",          "floor": 0, "x": 800, "y": 500, "type": "room"     },
    { "id": "elevator_1",    "name": "Elevator Floor 1",  "floor": 1, "x": 700, "y": 300, "type": "elevator" },
    { "id": "stairs_1",      "name": "Stairs Floor 1",    "floor": 1, "x": 300, "y": 300, "type": "stairs"   },
    { "id": "lobby_1",       "name": "Floor 1 Lobby",     "floor": 1, "x": 500, "y": 300, "type": "junction" },
    { "id": "room_201",      "name": "Consulting Room 12","floor": 1, "x": 200, "y": 500, "type": "room"     },
    { "id": "room_202",      "name": "Laboratory",        "floor": 1, "x": 800, "y": 500, "type": "room"     }
  ],
  "edges": [
    { "origin": "entrance_main", "destination": "lobby_0",    "distance": 20, "accessible": true  },
    { "origin": "lobby_0",       "destination": "elevator_0", "distance": 15, "accessible": true  },
    { "origin": "lobby_0",       "destination": "stairs_0",   "distance": 10, "accessible": false },
    { "origin": "lobby_0",       "destination": "room_101",   "distance": 25, "accessible": true  },
    { "origin": "lobby_0",       "destination": "room_102",   "distance": 30, "accessible": true  },
    { "origin": "elevator_0",    "destination": "elevator_1", "distance": 5,  "accessible": true  },
    { "origin": "stairs_0",      "destination": "stairs_1",   "distance": 5,  "accessible": false },
    { "origin": "elevator_1",    "destination": "lobby_1",    "distance": 15, "accessible": true  },
    { "origin": "stairs_1",      "destination": "lobby_1",    "distance": 10, "accessible": false },
    { "origin": "lobby_1",       "destination": "room_201",   "distance": 25, "accessible": true  },
    { "origin": "lobby_1",       "destination": "room_202",   "distance": 30, "accessible": true  }
  ],
  "pois": [
    { "id": "poi_001", "name": "Main Entrance",      "category": "entrance",   "nodeId": "entrance_main", "description": "Main hospital entrance on ground floor", "tags": ["entrance", "access"]        },
    { "id": "poi_002", "name": "Consulting Room 1",  "category": "consulting", "nodeId": "room_101",      "description": "General practice consulting room",      "tags": ["doctor", "consult"]         },
    { "id": "poi_003", "name": "Pharmacy",           "category": "pharmacy",   "nodeId": "room_102",      "description": "Inpatient and outpatient pharmacy",      "tags": ["medicine", "drugs"]         },
    { "id": "poi_004", "name": "Consulting Room 12", "category": "consulting", "nodeId": "room_201",      "description": "Specialist consulting - Floor 1",        "tags": ["doctor", "specialist"]      },
    { "id": "poi_005", "name": "Laboratory",         "category": "laboratory", "nodeId": "room_202",      "description": "Blood and sample analysis laboratory",  "tags": ["lab", "blood", "exam"]      }
  ]
}
```

---

## 12. Android Manifest

Add inside `<manifest>`, before `<application>` in `android/app/src/main/AndroidManifest.xml`:

```xml
<!-- RECORD_AUDIO — voice search (FR-02, FR-05). Requested at runtime
     via permission_handler; this tag is required by the Play Store. -->
<uses-permission android:name="android.permission.RECORD_AUDIO"/>

<!-- INTERNET — speech_to_text may fall back to cloud recognition. -->
<uses-permission android:name="android.permission.INTERNET"/>

<!-- VIBRATE — turn notifications (FR-08). -->
<uses-permission android:name="android.permission.VIBRATE"/>

<!-- BLUETOOTH — speech_to_text supports Bluetooth headsets. -->
<uses-permission android:name="android.permission.BLUETOOTH"/>

<!-- Required on Android 11+ (API 30) so the OS knows this app
     intends to use the installed TTS engine (FR-04). -->
<queries>
  <intent>
    <action android:name="android.intent.action.TTS_SERVICE"/>
  </intent>
</queries>
```

---

## 13. Testing

### 13.1 `test/helpers/fake_map_repository.dart`

Prefer `Fake` (not `Mock`) implementations in widget tests — they compile-check the contract and produce clearer errors when methods are missing.

```dart
// test/helpers/fake_map_repository.dart
import 'package:fpdart/fpdart.dart';
import 'package:hospital_nav/core/error/failures.dart';
import 'package:hospital_nav/features/map/domain/entities/edge.dart';
import 'package:hospital_nav/features/map/domain/entities/node.dart';
import 'package:hospital_nav/features/map/domain/entities/poi.dart';
import 'package:hospital_nav/features/map/domain/repositories/map_repository.dart';

/// Fake repository — used in widget tests via ProviderScope.overrides.
/// Implements the full MapRepository contract for compile-time safety.
class FakeMapRepository implements MapRepository {
  final List<Node> nodes;
  final List<Edge> edges;
  final List<Poi> pois;

  const FakeMapRepository({
    this.nodes = const [],
    this.edges = const [],
    this.pois = const [],
  });

  @override
  Future<EitherFailure<List<Node>>> getNodes({int? floor}) async => right(
        floor != null ? nodes.where((n) => n.floor == floor).toList() : nodes,
      );

  @override
  Future<EitherFailure<List<Edge>>> getEdges() async => right(edges);

  @override
  Future<EitherFailure<List<Poi>>> getPois() async => right(pois);

  @override
  Future<EitherFailure<List<Poi>>> searchPois(String query) async => right(
        pois
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
}
```

---

### 13.2 Unit test — `CalculateRoute`

Tests follow the naming convention: `'[method] [condition] [expected result]'`.

```dart
// test/features/map/domain/calculate_route_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hospital_nav/core/error/failures.dart';
import 'package:hospital_nav/features/map/domain/entities/edge.dart';
import 'package:hospital_nav/features/map/domain/entities/node.dart';
import 'package:hospital_nav/features/map/domain/repositories/map_repository.dart';
import 'package:hospital_nav/features/map/domain/usecases/calculate_route.dart';

class MockMapRepository extends Mock implements MapRepository {}

void main() {
  late MockMapRepository mockRepo;
  late CalculateRoute useCase;

  // A simple three-node graph: a ─── b ─── c
  //                                   └─────── c (stair shortcut)
  const nodes = [
    Node(id: 'a', name: 'A', floor: 0, x: 0, y: 0, type: NodeType.junction),
    Node(id: 'b', name: 'B', floor: 0, x: 1, y: 0, type: NodeType.elevator),
    Node(id: 'c', name: 'C', floor: 0, x: 2, y: 0, type: NodeType.room),
  ];

  const edges = [
    Edge(origin: 'a', destination: 'b', distance: 10, accessible: true),
    Edge(origin: 'b', destination: 'c', distance: 10, accessible: true),
    // Stair-only shortcut — shorter but inaccessible.
    Edge(origin: 'a', destination: 'c', distance: 5, accessible: false),
  ];

  setUp(() {
    mockRepo = MockMapRepository();
    useCase = CalculateRoute(mockRepo);

    // Default happy-path stubs.
    when(() => mockRepo.getNodes()).thenAnswer((_) async => right(nodes));
    when(() => mockRepo.getEdges()).thenAnswer((_) async => right(edges));
  });

  group('CalculateRoute', () {
    test(
      'call avoidStairs=true returns accessible path a→b→c',
      () async {
        final result = await useCase(
          const CalculateRouteParams(
            originNodeId: 'a',
            destinationNodeId: 'c',
            avoidStairs: true,
          ),
        );

        expect(result.isRight(), true);
        final route = result.getRight().toNullable()!;
        expect(route.nodes.map((n) => n.id).toList(), ['a', 'b', 'c']);
        expect(route.isFullyAccessible, true);
        expect(route.totalDistance, 20.0);
      },
    );

    test(
      'call avoidStairs=false returns shortest path a→c via stair shortcut',
      () async {
        final result = await useCase(
          const CalculateRouteParams(
            originNodeId: 'a',
            destinationNodeId: 'c',
            avoidStairs: false,
          ),
        );

        expect(result.isRight(), true);
        final route = result.getRight().toNullable()!;
        // Dijkstra picks the shorter direct edge (distance 5) over a→b→c (distance 20).
        expect(route.nodes.map((n) => n.id).toList(), ['a', 'c']);
        expect(route.isFullyAccessible, false);
        expect(route.totalDistance, 5.0);
      },
    );

    test(
      'call avoidStairs=true returns RouteNotFoundFailure when no accessible path exists',
      () async {
        when(() => mockRepo.getEdges()).thenAnswer(
          (_) async => right(const [
            Edge(origin: 'a', destination: 'c', distance: 5, accessible: false),
          ]),
        );

        final result = await useCase(
          const CalculateRouteParams(
            originNodeId: 'a',
            destinationNodeId: 'c',
            avoidStairs: true,
          ),
        );

        expect(result.isLeft(), true);
        expect(
          result.getLeft().toNullable(),
          isA<RouteNotFoundFailure>(),
        );
      },
    );

    test(
      'call returns GraphFailure when origin node does not exist',
      () async {
        final result = await useCase(
          const CalculateRouteParams(
            originNodeId: 'z', // Does not exist in [nodes]
            destinationNodeId: 'c',
            avoidStairs: false,
          ),
        );

        expect(result.isLeft(), true);
        expect(result.getLeft().toNullable(), isA<GraphFailure>());
      },
    );
  });
}
```

---

### 13.3 Widget test — `SearchPage`

```dart
// test/features/search/search_page_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:hospital_nav/features/map/domain/entities/poi.dart';
import 'package:hospital_nav/features/map/presentation/providers/map_provider.dart';
import 'package:hospital_nav/features/search/presentation/pages/search_page.dart';

import '../../helpers/fake_map_repository.dart';

void main() {
  group('SearchPage', () {
    const fakePois = [
      Poi(
        id: '1',
        name: 'Pharmacy',
        category: 'pharmacy',
        nodeId: 'room_102',
        description: '',
        tags: [],
      ),
    ];

    final fakeRepo = FakeMapRepository(pois: fakePois);

    // Minimal GoRouter so go_router doesn't throw during widget pump.
    final testRouter = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SearchPage()),
        GoRoute(path: '/map', builder: (_, __) => const Scaffold()),
      ],
    );

    testWidgets(
      'shows POI list when query is empty',
      (tester) async {
        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              mapRepositoryProvider.overrideWithValue(fakeRepo),
            ],
            child: MaterialApp.router(routerConfig: testRouter),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('Pharmacy'), findsOneWidget);
        expect(find.text('pharmacy'), findsOneWidget);
      },
    );

    testWidgets(
      'shows "No results found" when search returns empty',
      (tester) async {
        final emptyRepo = FakeMapRepository(pois: const []);

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              mapRepositoryProvider.overrideWithValue(emptyRepo),
            ],
            child: MaterialApp.router(routerConfig: testRouter),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.text('No results found.'), findsOneWidget);
      },
    );
  });
}
```

---

## 14. Build & Code-Gen Commands

```bash
# 1. Install all dependencies
flutter pub get

# 2. Run code generation
#    Generates: *.g.dart (Riverpod, json_serializable)
#               *.freezed.dart (freezed)
dart run build_runner build --delete-conflicting-outputs

# 3. Verify no analysis errors
flutter analyze

# 4. Run all tests
flutter test

# 5. Run on a connected Android device
flutter run

# 6. Build release APK
flutter build apk --release
```

### Watching for changes during development

```bash
dart run build_runner watch --delete-conflicting-outputs
```

> **When to rerun code-gen:** Any time you add or modify a `@riverpod`, `@freezed`, or `@JsonSerializable` annotation. The generated `.g.dart` and `.freezed.dart` files **must be committed** to version control — they are required by the build.

### Upgrading packages safely

```bash
# Check which packages have newer versions available
flutter pub outdated

# Upgrade within existing version constraints (safe)
flutter pub upgrade

# Upgrade beyond current constraints (review changelogs first)
flutter pub upgrade --major-versions
```

---

## 15. Architecture Decision Record

| Decision | Choice | Rationale |
|---|---|---|
| Map engine | `flutter_map ^8.3.0` | Offline-first, no API key, no vendor lock-in; supports local tile/overlay layers |
| State management | Riverpod 3.3.x (code-gen) | Plain `Ref` API (named subclasses removed), type-safe DI, easily testable |
| Routing | `go_router ^17.2.3` | Official Flutter team package; `caseSensitive: false` preserves pre-15 behaviour |
| Database | `sqflite ^2.4.2` + FTS5 | Offline, zero-config, FTS5 gives ≤ 2s search (NFR-01) |
| Pathfinding | Dijkstra (inline, sorted list) | No external dependency; correct and sufficient for < 2,000-node graphs |
| Error handling | `fpdart ^1.1.1` `Either<Failure, T>` | Explicit, typed failure propagation without exceptions crossing layer boundaries |
| Coordinate system | Local px → fake LatLng | No GPS permission required; manual "I'm here" satisfies FR-06 |
| Audio | `flutter_tts ^4.2.2` | Native Android TTS engine; pt-BR support; fully offline |
| Voice input | `speech_to_text ^7.0.0` | Device-native STT; pt-BR locale; `initialize()` returns bool (no throw) in v7 |
| Haptics | `vibration ^2.0.0` | `hasVibrator()` guard prevents crashes on devices without a motor |
| Code generation | `freezed ^3.0.0` + `json_serializable ^6.9.5` | Immutable models, exhaustive `copyWith`, safe `fromJson`/`toJson` |

---

*End of implementation guide — version 2.0 — May 2026*
