// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edge_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EdgeModel {

 String get origin; String get destination; double get distance;// Defaults true — accessible unless explicitly marked false (stairs-only).
 bool get accessible;
/// Create a copy of EdgeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EdgeModelCopyWith<EdgeModel> get copyWith => _$EdgeModelCopyWithImpl<EdgeModel>(this as EdgeModel, _$identity);

  /// Serializes this EdgeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EdgeModel&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.accessible, accessible) || other.accessible == accessible));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,origin,destination,distance,accessible);

@override
String toString() {
  return 'EdgeModel(origin: $origin, destination: $destination, distance: $distance, accessible: $accessible)';
}


}

/// @nodoc
abstract mixin class $EdgeModelCopyWith<$Res>  {
  factory $EdgeModelCopyWith(EdgeModel value, $Res Function(EdgeModel) _then) = _$EdgeModelCopyWithImpl;
@useResult
$Res call({
 String origin, String destination, double distance, bool accessible
});




}
/// @nodoc
class _$EdgeModelCopyWithImpl<$Res>
    implements $EdgeModelCopyWith<$Res> {
  _$EdgeModelCopyWithImpl(this._self, this._then);

  final EdgeModel _self;
  final $Res Function(EdgeModel) _then;

/// Create a copy of EdgeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? origin = null,Object? destination = null,Object? distance = null,Object? accessible = null,}) {
  return _then(_self.copyWith(
origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double,accessible: null == accessible ? _self.accessible : accessible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [EdgeModel].
extension EdgeModelPatterns on EdgeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EdgeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EdgeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EdgeModel value)  $default,){
final _that = this;
switch (_that) {
case _EdgeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EdgeModel value)?  $default,){
final _that = this;
switch (_that) {
case _EdgeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String origin,  String destination,  double distance,  bool accessible)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EdgeModel() when $default != null:
return $default(_that.origin,_that.destination,_that.distance,_that.accessible);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String origin,  String destination,  double distance,  bool accessible)  $default,) {final _that = this;
switch (_that) {
case _EdgeModel():
return $default(_that.origin,_that.destination,_that.distance,_that.accessible);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String origin,  String destination,  double distance,  bool accessible)?  $default,) {final _that = this;
switch (_that) {
case _EdgeModel() when $default != null:
return $default(_that.origin,_that.destination,_that.distance,_that.accessible);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EdgeModel extends EdgeModel {
  const _EdgeModel({required this.origin, required this.destination, required this.distance, this.accessible = true}): super._();
  factory _EdgeModel.fromJson(Map<String, dynamic> json) => _$EdgeModelFromJson(json);

@override final  String origin;
@override final  String destination;
@override final  double distance;
// Defaults true — accessible unless explicitly marked false (stairs-only).
@override@JsonKey() final  bool accessible;

/// Create a copy of EdgeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EdgeModelCopyWith<_EdgeModel> get copyWith => __$EdgeModelCopyWithImpl<_EdgeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EdgeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EdgeModel&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.distance, distance) || other.distance == distance)&&(identical(other.accessible, accessible) || other.accessible == accessible));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,origin,destination,distance,accessible);

@override
String toString() {
  return 'EdgeModel(origin: $origin, destination: $destination, distance: $distance, accessible: $accessible)';
}


}

/// @nodoc
abstract mixin class _$EdgeModelCopyWith<$Res> implements $EdgeModelCopyWith<$Res> {
  factory _$EdgeModelCopyWith(_EdgeModel value, $Res Function(_EdgeModel) _then) = __$EdgeModelCopyWithImpl;
@override @useResult
$Res call({
 String origin, String destination, double distance, bool accessible
});




}
/// @nodoc
class __$EdgeModelCopyWithImpl<$Res>
    implements _$EdgeModelCopyWith<$Res> {
  __$EdgeModelCopyWithImpl(this._self, this._then);

  final _EdgeModel _self;
  final $Res Function(_EdgeModel) _then;

/// Create a copy of EdgeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? origin = null,Object? destination = null,Object? distance = null,Object? accessible = null,}) {
  return _then(_EdgeModel(
origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,distance: null == distance ? _self.distance : distance // ignore: cast_nullable_to_non_nullable
as double,accessible: null == accessible ? _self.accessible : accessible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
