
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
