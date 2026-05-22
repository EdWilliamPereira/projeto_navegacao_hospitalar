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
