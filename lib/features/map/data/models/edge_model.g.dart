// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EdgeModel _$EdgeModelFromJson(Map<String, dynamic> json) => _EdgeModel(
  origin: json['origin'] as String,
  destination: json['destination'] as String,
  distance: (json['distance'] as num).toDouble(),
  accessible: json['accessible'] as bool? ?? true,
);

Map<String, dynamic> _$EdgeModelToJson(_EdgeModel instance) =>
    <String, dynamic>{
      'origin': instance.origin,
      'destination': instance.destination,
      'distance': instance.distance,
      'accessible': instance.accessible,
    };
