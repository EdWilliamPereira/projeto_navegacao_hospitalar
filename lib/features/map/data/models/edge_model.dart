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
