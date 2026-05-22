import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/poi.dart';

part 'poi_model.freezed.dart';
part 'poi_model.g.dart';

@freezed
abstract class PoiModel with _$PoiModel {
  const PoiModel._();

  const factory PoiModel({
    required String id,
    required String name,
    required String category, // 'consulting' | 'pharmacy' | 'bathroom' | 'elevator' …
    required String nodeId,
    @Default('') String description,
    @Default([]) List<String> tags,
  }) = _PoiModel;

  factory PoiModel.fromJson(Map<String, dynamic> json) =>
      _$PoiModelFromJson(json);

  Poi toEntity() => Poi(
    id: id,
    name: name,
    category: category,
    nodeId: nodeId,
    description: description,
    tags: tags,
  );
}
