
import '../../../../core/error/failures.dart';
import '../entities/poi.dart';
import '../repositories/map_repository.dart';

class GetAllPois {
  final MapRepository _repository;

  const GetAllPois(this._repository);

  Future<EitherFailure<List<Poi>>> call() => _repository.getPois();
}
