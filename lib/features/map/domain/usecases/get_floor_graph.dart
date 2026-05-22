
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
