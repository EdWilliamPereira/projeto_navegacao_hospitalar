// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'node_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NodeModel {

 String get id; String get name; int get floor; double get x;// Local canvas coordinate in arbitrary units
 double get y; String get type;
/// Create a copy of NodeModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NodeModelCopyWith<NodeModel> get copyWith => _$NodeModelCopyWithImpl<NodeModel>(this as NodeModel, _$identity);

  /// Serializes this NodeModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NodeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,floor,x,y,type);

@override
String toString() {
  return 'NodeModel(id: $id, name: $name, floor: $floor, x: $x, y: $y, type: $type)';
}


}

/// @nodoc
abstract mixin class $NodeModelCopyWith<$Res>  {
  factory $NodeModelCopyWith(NodeModel value, $Res Function(NodeModel) _then) = _$NodeModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, int floor, double x, double y, String type
});




}
/// @nodoc
class _$NodeModelCopyWithImpl<$Res>
    implements $NodeModelCopyWith<$Res> {
  _$NodeModelCopyWithImpl(this._self, this._then);

  final NodeModel _self;
  final $Res Function(NodeModel) _then;

/// Create a copy of NodeModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? floor = null,Object? x = null,Object? y = null,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,floor: null == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as int,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [NodeModel].
extension NodeModelPatterns on NodeModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NodeModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NodeModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NodeModel value)  $default,){
final _that = this;
switch (_that) {
case _NodeModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NodeModel value)?  $default,){
final _that = this;
switch (_that) {
case _NodeModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int floor,  double x,  double y,  String type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NodeModel() when $default != null:
return $default(_that.id,_that.name,_that.floor,_that.x,_that.y,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int floor,  double x,  double y,  String type)  $default,) {final _that = this;
switch (_that) {
case _NodeModel():
return $default(_that.id,_that.name,_that.floor,_that.x,_that.y,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int floor,  double x,  double y,  String type)?  $default,) {final _that = this;
switch (_that) {
case _NodeModel() when $default != null:
return $default(_that.id,_that.name,_that.floor,_that.x,_that.y,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NodeModel extends NodeModel {
  const _NodeModel({required this.id, required this.name, required this.floor, required this.x, required this.y, required this.type}): super._();
  factory _NodeModel.fromJson(Map<String, dynamic> json) => _$NodeModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  int floor;
@override final  double x;
// Local canvas coordinate in arbitrary units
@override final  double y;
@override final  String type;

/// Create a copy of NodeModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NodeModelCopyWith<_NodeModel> get copyWith => __$NodeModelCopyWithImpl<_NodeModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NodeModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NodeModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.x, x) || other.x == x)&&(identical(other.y, y) || other.y == y)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,floor,x,y,type);

@override
String toString() {
  return 'NodeModel(id: $id, name: $name, floor: $floor, x: $x, y: $y, type: $type)';
}


}

/// @nodoc
abstract mixin class _$NodeModelCopyWith<$Res> implements $NodeModelCopyWith<$Res> {
  factory _$NodeModelCopyWith(_NodeModel value, $Res Function(_NodeModel) _then) = __$NodeModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int floor, double x, double y, String type
});




}
/// @nodoc
class __$NodeModelCopyWithImpl<$Res>
    implements _$NodeModelCopyWith<$Res> {
  __$NodeModelCopyWithImpl(this._self, this._then);

  final _NodeModel _self;
  final $Res Function(_NodeModel) _then;

/// Create a copy of NodeModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? floor = null,Object? x = null,Object? y = null,Object? type = null,}) {
  return _then(_NodeModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,floor: null == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as int,x: null == x ? _self.x : x // ignore: cast_nullable_to_non_nullable
as double,y: null == y ? _self.y : y // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
