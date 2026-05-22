// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'node_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NodeModel _$NodeModelFromJson(Map<String, dynamic> json) => _NodeModel(
  id: json['id'] as String,
  name: json['name'] as String,
  floor: (json['floor'] as num).toInt(),
  x: (json['x'] as num).toDouble(),
  y: (json['y'] as num).toDouble(),
  type: json['type'] as String,
);

Map<String, dynamic> _$NodeModelToJson(_NodeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'floor': instance.floor,
      'x': instance.x,
      'y': instance.y,
      'type': instance.type,
    };
