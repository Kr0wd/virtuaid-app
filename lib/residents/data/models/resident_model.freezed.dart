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

 String? get id; String get name;@JsonKey(name: 'date_of_birth') String get dateOfBirth; String? get url;@JsonKey(name: 'care_home') CareHome? get careHome;@JsonKey(name: 'created_by') String? get createdBy;
/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResidentModelCopyWith<ResidentModel> get copyWith => _$ResidentModelCopyWithImpl<ResidentModel>(this as ResidentModel, _$identity);

  /// Serializes this ResidentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.url, url) || other.url == url)&&(identical(other.careHome, careHome) || other.careHome == careHome)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dateOfBirth,url,careHome,createdBy);

@override
String toString() {
  return 'ResidentModel(id: $id, name: $name, dateOfBirth: $dateOfBirth, url: $url, careHome: $careHome, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class $ResidentModelCopyWith<$Res>  {
  factory $ResidentModelCopyWith(ResidentModel value, $Res Function(ResidentModel) _then) = _$ResidentModelCopyWithImpl;
@useResult
$Res call({
 String? id, String name,@JsonKey(name: 'date_of_birth') String dateOfBirth, String? url,@JsonKey(name: 'care_home') CareHome? careHome,@JsonKey(name: 'created_by') String? createdBy
});


$CareHomeCopyWith<$Res>? get careHome;

}
/// @nodoc
class _$ResidentModelCopyWithImpl<$Res>
    implements $ResidentModelCopyWith<$Res> {
  _$ResidentModelCopyWithImpl(this._self, this._then);

  final ResidentModel _self;
  final $Res Function(ResidentModel) _then;

/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = null,Object? dateOfBirth = null,Object? url = freezed,Object? careHome = freezed,Object? createdBy = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,careHome: freezed == careHome ? _self.careHome : careHome // ignore: cast_nullable_to_non_nullable
as CareHome?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareHomeCopyWith<$Res>? get careHome {
    if (_self.careHome == null) {
    return null;
  }

  return $CareHomeCopyWith<$Res>(_self.careHome!, (value) {
    return _then(_self.copyWith(careHome: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _ResidentModel implements ResidentModel {
  const _ResidentModel({this.id, required this.name, @JsonKey(name: 'date_of_birth') required this.dateOfBirth, this.url, @JsonKey(name: 'care_home') this.careHome, @JsonKey(name: 'created_by') this.createdBy});
  factory _ResidentModel.fromJson(Map<String, dynamic> json) => _$ResidentModelFromJson(json);

@override final  String? id;
@override final  String name;
@override@JsonKey(name: 'date_of_birth') final  String dateOfBirth;
@override final  String? url;
@override@JsonKey(name: 'care_home') final  CareHome? careHome;
@override@JsonKey(name: 'created_by') final  String? createdBy;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResidentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.url, url) || other.url == url)&&(identical(other.careHome, careHome) || other.careHome == careHome)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,dateOfBirth,url,careHome,createdBy);

@override
String toString() {
  return 'ResidentModel(id: $id, name: $name, dateOfBirth: $dateOfBirth, url: $url, careHome: $careHome, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class _$ResidentModelCopyWith<$Res> implements $ResidentModelCopyWith<$Res> {
  factory _$ResidentModelCopyWith(_ResidentModel value, $Res Function(_ResidentModel) _then) = __$ResidentModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String name,@JsonKey(name: 'date_of_birth') String dateOfBirth, String? url,@JsonKey(name: 'care_home') CareHome? careHome,@JsonKey(name: 'created_by') String? createdBy
});


@override $CareHomeCopyWith<$Res>? get careHome;

}
/// @nodoc
class __$ResidentModelCopyWithImpl<$Res>
    implements _$ResidentModelCopyWith<$Res> {
  __$ResidentModelCopyWithImpl(this._self, this._then);

  final _ResidentModel _self;
  final $Res Function(_ResidentModel) _then;

/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = null,Object? dateOfBirth = null,Object? url = freezed,Object? careHome = freezed,Object? createdBy = freezed,}) {
  return _then(_ResidentModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,careHome: freezed == careHome ? _self.careHome : careHome // ignore: cast_nullable_to_non_nullable
as CareHome?,createdBy: freezed == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareHomeCopyWith<$Res>? get careHome {
    if (_self.careHome == null) {
    return null;
  }

  return $CareHomeCopyWith<$Res>(_self.careHome!, (value) {
    return _then(_self.copyWith(careHome: value));
  });
}
}


/// @nodoc
mixin _$CareHome {

 String get name;
/// Create a copy of CareHome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CareHomeCopyWith<CareHome> get copyWith => _$CareHomeCopyWithImpl<CareHome>(this as CareHome, _$identity);

  /// Serializes this CareHome to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CareHome&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'CareHome(name: $name)';
}


}

/// @nodoc
abstract mixin class $CareHomeCopyWith<$Res>  {
  factory $CareHomeCopyWith(CareHome value, $Res Function(CareHome) _then) = _$CareHomeCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class _$CareHomeCopyWithImpl<$Res>
    implements $CareHomeCopyWith<$Res> {
  _$CareHomeCopyWithImpl(this._self, this._then);

  final CareHome _self;
  final $Res Function(CareHome) _then;

/// Create a copy of CareHome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _CareHome implements CareHome {
  const _CareHome({required this.name});
  factory _CareHome.fromJson(Map<String, dynamic> json) => _$CareHomeFromJson(json);

@override final  String name;

/// Create a copy of CareHome
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CareHomeCopyWith<_CareHome> get copyWith => __$CareHomeCopyWithImpl<_CareHome>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CareHomeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CareHome&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'CareHome(name: $name)';
}


}

/// @nodoc
abstract mixin class _$CareHomeCopyWith<$Res> implements $CareHomeCopyWith<$Res> {
  factory _$CareHomeCopyWith(_CareHome value, $Res Function(_CareHome) _then) = __$CareHomeCopyWithImpl;
@override @useResult
$Res call({
 String name
});




}
/// @nodoc
class __$CareHomeCopyWithImpl<$Res>
    implements _$CareHomeCopyWith<$Res> {
  __$CareHomeCopyWithImpl(this._self, this._then);

  final _CareHome _self;
  final $Res Function(_CareHome) _then;

/// Create a copy of CareHome
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_CareHome(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
