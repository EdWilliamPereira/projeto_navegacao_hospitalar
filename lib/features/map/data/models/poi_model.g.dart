// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poi_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PoiModel _$PoiModelFromJson(Map<String, dynamic> json) => _PoiModel(
  id: json['id'] as String,
  name: json['name'] as String,
  category: json['category'] as String,
  nodeId: json['nodeId'] as String,
  description: json['description'] as String? ?? '',
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$PoiModelToJson(_PoiModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'category': instance.category,
  'nodeId': instance.nodeId,
  'description': instance.description,
  'tags': instance.tags,
};
