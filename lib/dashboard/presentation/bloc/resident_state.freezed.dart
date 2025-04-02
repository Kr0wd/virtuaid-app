// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resident_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResidentState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResidentState()';
}


}

/// @nodoc
class $ResidentStateCopyWith<$Res>  {
$ResidentStateCopyWith(ResidentState _, $Res Function(ResidentState) __);
}


/// @nodoc


class ResidentInitial implements ResidentState {
  const ResidentInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResidentState.initial()';
}


}




/// @nodoc


class ResidentLoading implements ResidentState {
  const ResidentLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResidentState.loading()';
}


}




/// @nodoc


class ResidentLoaded implements ResidentState {
  const ResidentLoaded(this.data);
  

 final  ResidentResponse data;

/// Create a copy of ResidentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResidentLoadedCopyWith<ResidentLoaded> get copyWith => _$ResidentLoadedCopyWithImpl<ResidentLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentLoaded&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,data);

@override
String toString() {
  return 'ResidentState.loaded(data: $data)';
}


}

/// @nodoc
abstract mixin class $ResidentLoadedCopyWith<$Res> implements $ResidentStateCopyWith<$Res> {
  factory $ResidentLoadedCopyWith(ResidentLoaded value, $Res Function(ResidentLoaded) _then) = _$ResidentLoadedCopyWithImpl;
@useResult
$Res call({
 ResidentResponse data
});


$ResidentResponseCopyWith<$Res> get data;

}
/// @nodoc
class _$ResidentLoadedCopyWithImpl<$Res>
    implements $ResidentLoadedCopyWith<$Res> {
  _$ResidentLoadedCopyWithImpl(this._self, this._then);

  final ResidentLoaded _self;
  final $Res Function(ResidentLoaded) _then;

/// Create a copy of ResidentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(ResidentLoaded(
null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ResidentResponse,
  ));
}

/// Create a copy of ResidentState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResidentResponseCopyWith<$Res> get data {
  
  return $ResidentResponseCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc


class ResidentError implements ResidentState {
  const ResidentError(this.message);
  

 final  String message;

/// Create a copy of ResidentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResidentErrorCopyWith<ResidentError> get copyWith => _$ResidentErrorCopyWithImpl<ResidentError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ResidentState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ResidentErrorCopyWith<$Res> implements $ResidentStateCopyWith<$Res> {
  factory $ResidentErrorCopyWith(ResidentError value, $Res Function(ResidentError) _then) = _$ResidentErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ResidentErrorCopyWithImpl<$Res>
    implements $ResidentErrorCopyWith<$Res> {
  _$ResidentErrorCopyWithImpl(this._self, this._then);

  final ResidentError _self;
  final $Res Function(ResidentError) _then;

/// Create a copy of ResidentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ResidentError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
