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