// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'associates_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AssociatesResponse {

 int get count; String? get next; String? get previous; List<dynamic> get results;
/// Create a copy of AssociatesResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssociatesResponseCopyWith<AssociatesResponse> get copyWith => _$AssociatesResponseCopyWithImpl<AssociatesResponse>(this as AssociatesResponse, _$identity);

  /// Serializes this AssociatesResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssociatesResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'AssociatesResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class $AssociatesResponseCopyWith<$Res>  {
  factory $AssociatesResponseCopyWith(AssociatesResponse value, $Res Function(AssociatesResponse) _then) = _$AssociatesResponseCopyWithImpl;
@useResult
$Res call({
 int count, String? next, String? previous, List<dynamic> results
});




}
/// @nodoc
class _$AssociatesResponseCopyWithImpl<$Res>
    implements $AssociatesResponseCopyWith<$Res> {
  _$AssociatesResponseCopyWithImpl(this._self, this._then);

  final AssociatesResponse _self;
  final $Res Function(AssociatesResponse) _then;

/// Create a copy of AssociatesResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AssociatesResponse implements AssociatesResponse {
  const _AssociatesResponse({required this.count, this.next, this.previous, required final  List<dynamic> results}): _results = results;
  factory _AssociatesResponse.fromJson(Map<String, dynamic> json) => _$AssociatesResponseFromJson(json);

@override final  int count;
@override final  String? next;
@override final  String? previous;
 final  List<dynamic> _results;
@override List<dynamic> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of AssociatesResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssociatesResponseCopyWith<_AssociatesResponse> get copyWith => __$AssociatesResponseCopyWithImpl<_AssociatesResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssociatesResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssociatesResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'AssociatesResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class _$AssociatesResponseCopyWith<$Res> implements $AssociatesResponseCopyWith<$Res> {
  factory _$AssociatesResponseCopyWith(_AssociatesResponse value, $Res Function(_AssociatesResponse) _then) = __$AssociatesResponseCopyWithImpl;
@override @useResult
$Res call({
 int count, String? next, String? previous, List<dynamic> results
});




}
/// @nodoc
class __$AssociatesResponseCopyWithImpl<$Res>
    implements _$AssociatesResponseCopyWith<$Res> {
  __$AssociatesResponseCopyWithImpl(this._self, this._then);

  final _AssociatesResponse _self;
  final $Res Function(_AssociatesResponse) _then;

/// Create a copy of AssociatesResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_AssociatesResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<dynamic>,
  ));
}


}

// dart format on
