// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'new_resident_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewResidentEvent {

 String get name; String get dateOfBirth;
/// Create a copy of NewResidentEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewResidentEventCopyWith<NewResidentEvent> get copyWith => _$NewResidentEventCopyWithImpl<NewResidentEvent>(this as NewResidentEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewResidentEvent&&(identical(other.name, name) || other.name == name)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth));
}


@override
int get hashCode => Object.hash(runtimeType,name,dateOfBirth);

@override
String toString() {
  return 'NewResidentEvent(name: $name, dateOfBirth: $dateOfBirth)';
}


}

/// @nodoc
abstract mixin class $NewResidentEventCopyWith<$Res>  {
  factory $NewResidentEventCopyWith(NewResidentEvent value, $Res Function(NewResidentEvent) _then) = _$NewResidentEventCopyWithImpl;
@useResult
$Res call({
 String name, String dateOfBirth
});




}
/// @nodoc
class _$NewResidentEventCopyWithImpl<$Res>
    implements $NewResidentEventCopyWith<$Res> {
  _$NewResidentEventCopyWithImpl(this._self, this._then);

  final NewResidentEvent _self;
  final $Res Function(NewResidentEvent) _then;

/// Create a copy of NewResidentEvent
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


class AddResident implements NewResidentEvent {
  const AddResident({required this.name, required this.dateOfBirth});
  

@override final  String name;
@override final  String dateOfBirth;

/// Create a copy of NewResidentEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddResidentCopyWith<AddResident> get copyWith => _$AddResidentCopyWithImpl<AddResident>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddResident&&(identical(other.name, name) || other.name == name)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth));
}


@override
int get hashCode => Object.hash(runtimeType,name,dateOfBirth);

@override
String toString() {
  return 'NewResidentEvent.addResident(name: $name, dateOfBirth: $dateOfBirth)';
}


}

/// @nodoc
abstract mixin class $AddResidentCopyWith<$Res> implements $NewResidentEventCopyWith<$Res> {
  factory $AddResidentCopyWith(AddResident value, $Res Function(AddResident) _then) = _$AddResidentCopyWithImpl;
@override @useResult
$Res call({
 String name, String dateOfBirth
});




}
/// @nodoc
class _$AddResidentCopyWithImpl<$Res>
    implements $AddResidentCopyWith<$Res> {
  _$AddResidentCopyWithImpl(this._self, this._then);

  final AddResident _self;
  final $Res Function(AddResident) _then;

/// Create a copy of NewResidentEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? dateOfBirth = null,}) {
  return _then(AddResident(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class NewResidentSubmitted implements NewResidentEvent {
  const NewResidentSubmitted({required this.name, required this.dateOfBirth});
  

@override final  String name;
@override final  String dateOfBirth;

/// Create a copy of NewResidentEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewResidentSubmittedCopyWith<NewResidentSubmitted> get copyWith => _$NewResidentSubmittedCopyWithImpl<NewResidentSubmitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewResidentSubmitted&&(identical(other.name, name) || other.name == name)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth));
}


@override
int get hashCode => Object.hash(runtimeType,name,dateOfBirth);

@override
String toString() {
  return 'NewResidentEvent.submitted(name: $name, dateOfBirth: $dateOfBirth)';
}


}

/// @nodoc
abstract mixin class $NewResidentSubmittedCopyWith<$Res> implements $NewResidentEventCopyWith<$Res> {
  factory $NewResidentSubmittedCopyWith(NewResidentSubmitted value, $Res Function(NewResidentSubmitted) _then) = _$NewResidentSubmittedCopyWithImpl;
@override @useResult
$Res call({
 String name, String dateOfBirth
});




}
/// @nodoc
class _$NewResidentSubmittedCopyWithImpl<$Res>
    implements $NewResidentSubmittedCopyWith<$Res> {
  _$NewResidentSubmittedCopyWithImpl(this._self, this._then);

  final NewResidentSubmitted _self;
  final $Res Function(NewResidentSubmitted) _then;

/// Create a copy of NewResidentEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? dateOfBirth = null,}) {
  return _then(NewResidentSubmitted(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
