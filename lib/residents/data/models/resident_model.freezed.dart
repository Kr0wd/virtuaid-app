// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resident_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResidentModel {

 String get name;@JsonKey(name: 'date_of_birth') String get dateOfBirth;
/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResidentModelCopyWith<ResidentModel> get copyWith => _$ResidentModelCopyWithImpl<ResidentModel>(this as ResidentModel, _$identity);

  /// Serializes this ResidentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentModel&&(identical(other.name, name) || other.name == name)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,dateOfBirth);

@override
String toString() {
  return 'ResidentModel(name: $name, dateOfBirth: $dateOfBirth)';
}


}

/// @nodoc
abstract mixin class $ResidentModelCopyWith<$Res>  {
  factory $ResidentModelCopyWith(ResidentModel value, $Res Function(ResidentModel) _then) = _$ResidentModelCopyWithImpl;
@useResult
$Res call({
 String name,@JsonKey(name: 'date_of_birth') String dateOfBirth
});




}
/// @nodoc
class _$ResidentModelCopyWithImpl<$Res>
    implements $ResidentModelCopyWith<$Res> {
  _$ResidentModelCopyWithImpl(this._self, this._then);

  final ResidentModel _self;
  final $Res Function(ResidentModel) _then;

/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? dateOfBirth = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ResidentModel implements ResidentModel {
  const _ResidentModel({required this.name, @JsonKey(name: 'date_of_birth') required this.dateOfBirth});
  factory _ResidentModel.fromJson(Map<String, dynamic> json) => _$ResidentModelFromJson(json);

@override final  String name;
@override@JsonKey(name: 'date_of_birth') final  String dateOfBirth;

/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResidentModelCopyWith<_ResidentModel> get copyWith => __$ResidentModelCopyWithImpl<_ResidentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResidentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResidentModel&&(identical(other.name, name) || other.name == name)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,dateOfBirth);

@override
String toString() {
  return 'ResidentModel(name: $name, dateOfBirth: $dateOfBirth)';
}


}

/// @nodoc
abstract mixin class _$ResidentModelCopyWith<$Res> implements $ResidentModelCopyWith<$Res> {
  factory _$ResidentModelCopyWith(_ResidentModel value, $Res Function(_ResidentModel) _then) = __$ResidentModelCopyWithImpl;
@override @useResult
$Res call({
 String name,@JsonKey(name: 'date_of_birth') String dateOfBirth
});




}
/// @nodoc
class __$ResidentModelCopyWithImpl<$Res>
    implements _$ResidentModelCopyWith<$Res> {
  __$ResidentModelCopyWithImpl(this._self, this._then);

  final _ResidentModel _self;
  final $Res Function(_ResidentModel) _then;

/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? dateOfBirth = null,}) {
  return _then(_ResidentModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
