// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resident_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResidentResponse {

 int get count; String? get next; String? get previous; List<ResidentModel> get results;
/// Create a copy of ResidentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResidentResponseCopyWith<ResidentResponse> get copyWith => _$ResidentResponseCopyWithImpl<ResidentResponse>(this as ResidentResponse, _$identity);

  /// Serializes this ResidentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'ResidentResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class $ResidentResponseCopyWith<$Res>  {
  factory $ResidentResponseCopyWith(ResidentResponse value, $Res Function(ResidentResponse) _then) = _$ResidentResponseCopyWithImpl;
@useResult
$Res call({
 int count, String? next, String? previous, List<ResidentModel> results
});




}
/// @nodoc
class _$ResidentResponseCopyWithImpl<$Res>
    implements $ResidentResponseCopyWith<$Res> {
  _$ResidentResponseCopyWithImpl(this._self, this._then);

  final ResidentResponse _self;
  final $Res Function(ResidentResponse) _then;

/// Create a copy of ResidentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<ResidentModel>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ResidentResponse implements ResidentResponse {
  const _ResidentResponse({required this.count, this.next, this.previous, required final  List<ResidentModel> results}): _results = results;
  factory _ResidentResponse.fromJson(Map<String, dynamic> json) => _$ResidentResponseFromJson(json);

@override final  int count;
@override final  String? next;
@override final  String? previous;
 final  List<ResidentModel> _results;
@override List<ResidentModel> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of ResidentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResidentResponseCopyWith<_ResidentResponse> get copyWith => __$ResidentResponseCopyWithImpl<_ResidentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResidentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResidentResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'ResidentResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class _$ResidentResponseCopyWith<$Res> implements $ResidentResponseCopyWith<$Res> {
  factory _$ResidentResponseCopyWith(_ResidentResponse value, $Res Function(_ResidentResponse) _then) = __$ResidentResponseCopyWithImpl;
@override @useResult
$Res call({
 int count, String? next, String? previous, List<ResidentModel> results
});




}
/// @nodoc
class __$ResidentResponseCopyWithImpl<$Res>
    implements _$ResidentResponseCopyWith<$Res> {
  __$ResidentResponseCopyWithImpl(this._self, this._then);

  final _ResidentResponse _self;
  final $Res Function(_ResidentResponse) _then;

/// Create a copy of ResidentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_ResidentResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<ResidentModel>,
  ));
}


}

// dart format on
