// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'new_resident_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewResidentState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewResidentState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewResidentState()';
}


}

/// @nodoc
class $NewResidentStateCopyWith<$Res>  {
$NewResidentStateCopyWith(NewResidentState _, $Res Function(NewResidentState) __);
}


/// @nodoc


class NewResidentInitial implements NewResidentState {
  const NewResidentInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewResidentInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewResidentState.initial()';
}


}




/// @nodoc


class NewResidentLoading implements NewResidentState {
  const NewResidentLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewResidentLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewResidentState.loading()';
}


}




/// @nodoc


class NewResidentSuccess implements NewResidentState {
  const NewResidentSuccess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewResidentSuccess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NewResidentState.success()';
}


}




/// @nodoc


class NewResidentError implements NewResidentState {
  const NewResidentError(this.message);
  

 final  String message;

/// Create a copy of NewResidentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewResidentErrorCopyWith<NewResidentError> get copyWith => _$NewResidentErrorCopyWithImpl<NewResidentError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewResidentError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'NewResidentState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $NewResidentErrorCopyWith<$Res> implements $NewResidentStateCopyWith<$Res> {
  factory $NewResidentErrorCopyWith(NewResidentError value, $Res Function(NewResidentError) _then) = _$NewResidentErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$NewResidentErrorCopyWithImpl<$Res>
    implements $NewResidentErrorCopyWith<$Res> {
  _$NewResidentErrorCopyWithImpl(this._self, this._then);

  final NewResidentError _self;
  final $Res Function(NewResidentError) _then;

/// Create a copy of NewResidentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(NewResidentError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
