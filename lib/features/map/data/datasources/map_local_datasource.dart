import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../../../../core/error/exceptions.dart' as exceptions;
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

  /// FTS5 full-text search across name, category, description, tags.
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
      version: 5,
      // onCreate fires only on the very first launch (empty database).
      onCreate: _createSchemaAndSeed,
      onUpgrade: (db, oldVersion, newVersion) async {
        // Full drop-and-recreate is safe because all data comes from the
        // bundled asset — there is no user-generated data to preserve.
        await db.execute('DROP TABLE IF EXISTS pois_fts');
        await db.execute('DROP TABLE IF EXISTS pois');
        await db.execute('DROP TABLE IF EXISTS edges');
        await db.execute('DROP TABLE IF EXISTS nodes');
        await _createSchemaAndSeed(db, newVersion);
      },
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
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        floor INTEGER NOT NULL,
        x REAL NOT NULL,
        y REAL NOT NULL,
        type TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE edges (
        origin TEXT NOT NULL,
        destination TEXT NOT NULL,
        distance REAL NOT NULL,
        accessible INTEGER NOT NULL DEFAULT 1,
        PRIMARY KEY (origin, destination)
      )
    ''');

    await db.execute('''
      CREATE TABLE pois (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        nodeId TEXT NOT NULL,
        description TEXT NOT NULL DEFAULT '',
        tags TEXT NOT NULL DEFAULT '[]'
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

      // Insert nodes
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

      // Insert edges
      for (final e in (data['edges'] as List<dynamic>)) {
        batch.insert('edges', {
          'origin': e['origin'] as String,
          'destination': e['destination'] as String,
          'distance': (e['distance'] as num).toDouble(),
          // JSON boolean → SQLite integer (1/0)
          'accessible': (e['accessible'] as bool? ?? true) ? 1 : 0,
        });
      }

      // Insert POIs
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
      throw exceptions.AssetException('Failed to seed map data: $e');
    }
  }

  // Throws DatabaseException if initDatabase() was never called.
  Database get _database {
    final db = _db;
    if (db == null) {
      throw const exceptions.DatabaseException(
          'Database not initialized. Call initDatabase() first.');
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
    final sanitised = query
    .trim()
    .replaceAll(r'\', r'\\')  // escape the escape char first
    .replaceAll('%', r'\%')
    .replaceAll('_', r'\_');
    if (sanitised.isEmpty) return getPois();
    // Match against name, category, description, and the raw tags JSON string.
    // The trailing '%' gives prefix-match behaviour equivalent to FTS5's '*' suffix.
    // ESCAPE clause tells SQLite that '\' is the escape character for LIKE.

    final rows = await _database.rawQuery(
      '''
      SELECT p.* 
      FROM pois as p 
      WHERE name        LIKE ? ESCAPE '\'
       OR category    LIKE ? ESCAPE '\'
       OR description LIKE ? ESCAPE '\'
       OR tags        LIKE ? ESCAPE '\'
      LIMIT 20
      ''',
      [
        '$sanitised%',   // prefix match on name
        '$sanitised%',   // prefix match on category
        '%$sanitised%',  // substring match on description
        '%$sanitised%',  // substring match on tags JSON
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
      'tags': (jsonDecode(row['tags'] as String) as List<dynamic>).cast<String>(),
    });
  }
}
