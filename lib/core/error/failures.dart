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
