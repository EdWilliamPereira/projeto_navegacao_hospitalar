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
