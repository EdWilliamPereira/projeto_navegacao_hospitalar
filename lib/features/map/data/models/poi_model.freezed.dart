// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poi_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PoiModel {

 String get id; String get name; String get category;// 'consulting' | 'pharmacy' | 'bathroom' | 'elevator' …
 String get nodeId; String get description; List<String> get tags;
/// Create a copy of PoiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PoiModelCopyWith<PoiModel> get copyWith => _$PoiModelCopyWithImpl<PoiModel>(this as PoiModel, _$identity);

  /// Serializes this PoiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PoiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.tags, tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,nodeId,description,const DeepCollectionEquality().hash(tags));

@override
String toString() {
  return 'PoiModel(id: $id, name: $name, category: $category, nodeId: $nodeId, description: $description, tags: $tags)';
}


}

/// @nodoc
abstract mixin class $PoiModelCopyWith<$Res>  {
  factory $PoiModelCopyWith(PoiModel value, $Res Function(PoiModel) _then) = _$PoiModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String category, String nodeId, String description, List<String> tags
});




}
/// @nodoc
class _$PoiModelCopyWithImpl<$Res>
    implements $PoiModelCopyWith<$Res> {
  _$PoiModelCopyWithImpl(this._self, this._then);

  final PoiModel _self;
  final $Res Function(PoiModel) _then;

/// Create a copy of PoiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? nodeId = null,Object? description = null,Object? tags = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PoiModel].
extension PoiModelPatterns on PoiModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PoiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PoiModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PoiModel value)  $default,){
final _that = this;
switch (_that) {
case _PoiModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PoiModel value)?  $default,){
final _that = this;
switch (_that) {
case _PoiModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String category,  String nodeId,  String description,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PoiModel() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.nodeId,_that.description,_that.tags);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String category,  String nodeId,  String description,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _PoiModel():
return $default(_that.id,_that.name,_that.category,_that.nodeId,_that.description,_that.tags);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String category,  String nodeId,  String description,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _PoiModel() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.nodeId,_that.description,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PoiModel extends PoiModel {
  const _PoiModel({required this.id, required this.name, required this.category, required this.nodeId, this.description = '', final  List<String> tags = const []}): _tags = tags,super._();
  factory _PoiModel.fromJson(Map<String, dynamic> json) => _$PoiModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String category;
// 'consulting' | 'pharmacy' | 'bathroom' | 'elevator' …
@override final  String nodeId;
@override@JsonKey() final  String description;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of PoiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PoiModelCopyWith<_PoiModel> get copyWith => __$PoiModelCopyWithImpl<_PoiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PoiModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PoiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,nodeId,description,const DeepCollectionEquality().hash(_tags));

@override
String toString() {
  return 'PoiModel(id: $id, name: $name, category: $category, nodeId: $nodeId, description: $description, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$PoiModelCopyWith<$Res> implements $PoiModelCopyWith<$Res> {
  factory _$PoiModelCopyWith(_PoiModel value, $Res Function(_PoiModel) _then) = __$PoiModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String category, String nodeId, String description, List<String> tags
});




}
/// @nodoc
class __$PoiModelCopyWithImpl<$Res>
    implements _$PoiModelCopyWith<$Res> {
  __$PoiModelCopyWithImpl(this._self, this._then);

  final _PoiModel _self;
  final $Res Function(_PoiModel) _then;

/// Create a copy of PoiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? nodeId = null,Object? description = null,Object? tags = null,}) {
  return _then(_PoiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
