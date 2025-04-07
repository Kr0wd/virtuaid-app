// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

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


/// @nodoc
mixin _$ResidentDetails {

 String get url; String get id; String get name;@JsonKey(name: 'date_of_birth') String get dateOfBirth;@JsonKey(name: 'care_home') CareHome get careHome;@JsonKey(name: 'created_by') String get createdBy;
/// Create a copy of ResidentDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResidentDetailsCopyWith<ResidentDetails> get copyWith => _$ResidentDetailsCopyWithImpl<ResidentDetails>(this as ResidentDetails, _$identity);

  /// Serializes this ResidentDetails to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentDetails&&(identical(other.url, url) || other.url == url)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.careHome, careHome) || other.careHome == careHome)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,id,name,dateOfBirth,careHome,createdBy);

@override
String toString() {
  return 'ResidentDetails(url: $url, id: $id, name: $name, dateOfBirth: $dateOfBirth, careHome: $careHome, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class $ResidentDetailsCopyWith<$Res>  {
  factory $ResidentDetailsCopyWith(ResidentDetails value, $Res Function(ResidentDetails) _then) = _$ResidentDetailsCopyWithImpl;
@useResult
$Res call({
 String url, String id, String name,@JsonKey(name: 'date_of_birth') String dateOfBirth,@JsonKey(name: 'care_home') CareHome careHome,@JsonKey(name: 'created_by') String createdBy
});


$CareHomeCopyWith<$Res> get careHome;

}
/// @nodoc
class _$ResidentDetailsCopyWithImpl<$Res>
    implements $ResidentDetailsCopyWith<$Res> {
  _$ResidentDetailsCopyWithImpl(this._self, this._then);

  final ResidentDetails _self;
  final $Res Function(ResidentDetails) _then;

/// Create a copy of ResidentDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,Object? id = null,Object? name = null,Object? dateOfBirth = null,Object? careHome = null,Object? createdBy = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,careHome: null == careHome ? _self.careHome : careHome // ignore: cast_nullable_to_non_nullable
as CareHome,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of ResidentDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareHomeCopyWith<$Res> get careHome {
  
  return $CareHomeCopyWith<$Res>(_self.careHome, (value) {
    return _then(_self.copyWith(careHome: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _ResidentDetails implements ResidentDetails {
  const _ResidentDetails({required this.url, required this.id, required this.name, @JsonKey(name: 'date_of_birth') required this.dateOfBirth, @JsonKey(name: 'care_home') required this.careHome, @JsonKey(name: 'created_by') required this.createdBy});
  factory _ResidentDetails.fromJson(Map<String, dynamic> json) => _$ResidentDetailsFromJson(json);

@override final  String url;
@override final  String id;
@override final  String name;
@override@JsonKey(name: 'date_of_birth') final  String dateOfBirth;
@override@JsonKey(name: 'care_home') final  CareHome careHome;
@override@JsonKey(name: 'created_by') final  String createdBy;

/// Create a copy of ResidentDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResidentDetailsCopyWith<_ResidentDetails> get copyWith => __$ResidentDetailsCopyWithImpl<_ResidentDetails>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResidentDetailsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResidentDetails&&(identical(other.url, url) || other.url == url)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.careHome, careHome) || other.careHome == careHome)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url,id,name,dateOfBirth,careHome,createdBy);

@override
String toString() {
  return 'ResidentDetails(url: $url, id: $id, name: $name, dateOfBirth: $dateOfBirth, careHome: $careHome, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class _$ResidentDetailsCopyWith<$Res> implements $ResidentDetailsCopyWith<$Res> {
  factory _$ResidentDetailsCopyWith(_ResidentDetails value, $Res Function(_ResidentDetails) _then) = __$ResidentDetailsCopyWithImpl;
@override @useResult
$Res call({
 String url, String id, String name,@JsonKey(name: 'date_of_birth') String dateOfBirth,@JsonKey(name: 'care_home') CareHome careHome,@JsonKey(name: 'created_by') String createdBy
});


@override $CareHomeCopyWith<$Res> get careHome;

}
/// @nodoc
class __$ResidentDetailsCopyWithImpl<$Res>
    implements _$ResidentDetailsCopyWith<$Res> {
  __$ResidentDetailsCopyWithImpl(this._self, this._then);

  final _ResidentDetails _self;
  final $Res Function(_ResidentDetails) _then;

/// Create a copy of ResidentDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,Object? id = null,Object? name = null,Object? dateOfBirth = null,Object? careHome = null,Object? createdBy = null,}) {
  return _then(_ResidentDetails(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as String,careHome: null == careHome ? _self.careHome : careHome // ignore: cast_nullable_to_non_nullable
as CareHome,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of ResidentDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CareHomeCopyWith<$Res> get careHome {
  
  return $CareHomeCopyWith<$Res>(_self.careHome, (value) {
    return _then(_self.copyWith(careHome: value));
  });
}
}


/// @nodoc
mixin _$SessionModel {

 int get id;@JsonKey(name: 'resident_details') ResidentDetails get residentDetails;@JsonKey(name: 'feedback_status') String get feedbackStatus;@JsonKey(name: 'scheduled_date') String get scheduledDate;@JsonKey(name: 'end_time') String? get endTime; String get status; String? get notes;@JsonKey(name: 'created_at') String get createdAt;@JsonKey(name: 'updated_at') String get updatedAt; String get resident; String? get feedback;
/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionModelCopyWith<SessionModel> get copyWith => _$SessionModelCopyWithImpl<SessionModel>(this as SessionModel, _$identity);

  /// Serializes this SessionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.residentDetails, residentDetails) || other.residentDetails == residentDetails)&&(identical(other.feedbackStatus, feedbackStatus) || other.feedbackStatus == feedbackStatus)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.resident, resident) || other.resident == resident)&&(identical(other.feedback, feedback) || other.feedback == feedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,residentDetails,feedbackStatus,scheduledDate,endTime,status,notes,createdAt,updatedAt,resident,feedback);

@override
String toString() {
  return 'SessionModel(id: $id, residentDetails: $residentDetails, feedbackStatus: $feedbackStatus, scheduledDate: $scheduledDate, endTime: $endTime, status: $status, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, resident: $resident, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class $SessionModelCopyWith<$Res>  {
  factory $SessionModelCopyWith(SessionModel value, $Res Function(SessionModel) _then) = _$SessionModelCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'resident_details') ResidentDetails residentDetails,@JsonKey(name: 'feedback_status') String feedbackStatus,@JsonKey(name: 'scheduled_date') String scheduledDate,@JsonKey(name: 'end_time') String? endTime, String status, String? notes,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt, String resident, String? feedback
});


$ResidentDetailsCopyWith<$Res> get residentDetails;

}
/// @nodoc
class _$SessionModelCopyWithImpl<$Res>
    implements $SessionModelCopyWith<$Res> {
  _$SessionModelCopyWithImpl(this._self, this._then);

  final SessionModel _self;
  final $Res Function(SessionModel) _then;

/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? residentDetails = null,Object? feedbackStatus = null,Object? scheduledDate = null,Object? endTime = freezed,Object? status = null,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,Object? resident = null,Object? feedback = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,residentDetails: null == residentDetails ? _self.residentDetails : residentDetails // ignore: cast_nullable_to_non_nullable
as ResidentDetails,feedbackStatus: null == feedbackStatus ? _self.feedbackStatus : feedbackStatus // ignore: cast_nullable_to_non_nullable
as String,scheduledDate: null == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as String,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,resident: null == resident ? _self.resident : resident // ignore: cast_nullable_to_non_nullable
as String,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResidentDetailsCopyWith<$Res> get residentDetails {
  
  return $ResidentDetailsCopyWith<$Res>(_self.residentDetails, (value) {
    return _then(_self.copyWith(residentDetails: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _SessionModel implements SessionModel {
  const _SessionModel({required this.id, @JsonKey(name: 'resident_details') required this.residentDetails, @JsonKey(name: 'feedback_status') required this.feedbackStatus, @JsonKey(name: 'scheduled_date') required this.scheduledDate, @JsonKey(name: 'end_time') this.endTime, required this.status, this.notes, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'updated_at') required this.updatedAt, required this.resident, this.feedback});
  factory _SessionModel.fromJson(Map<String, dynamic> json) => _$SessionModelFromJson(json);

@override final  int id;
@override@JsonKey(name: 'resident_details') final  ResidentDetails residentDetails;
@override@JsonKey(name: 'feedback_status') final  String feedbackStatus;
@override@JsonKey(name: 'scheduled_date') final  String scheduledDate;
@override@JsonKey(name: 'end_time') final  String? endTime;
@override final  String status;
@override final  String? notes;
@override@JsonKey(name: 'created_at') final  String createdAt;
@override@JsonKey(name: 'updated_at') final  String updatedAt;
@override final  String resident;
@override final  String? feedback;

/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionModelCopyWith<_SessionModel> get copyWith => __$SessionModelCopyWithImpl<_SessionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.residentDetails, residentDetails) || other.residentDetails == residentDetails)&&(identical(other.feedbackStatus, feedbackStatus) || other.feedbackStatus == feedbackStatus)&&(identical(other.scheduledDate, scheduledDate) || other.scheduledDate == scheduledDate)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.resident, resident) || other.resident == resident)&&(identical(other.feedback, feedback) || other.feedback == feedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,residentDetails,feedbackStatus,scheduledDate,endTime,status,notes,createdAt,updatedAt,resident,feedback);

@override
String toString() {
  return 'SessionModel(id: $id, residentDetails: $residentDetails, feedbackStatus: $feedbackStatus, scheduledDate: $scheduledDate, endTime: $endTime, status: $status, notes: $notes, createdAt: $createdAt, updatedAt: $updatedAt, resident: $resident, feedback: $feedback)';
}


}

/// @nodoc
abstract mixin class _$SessionModelCopyWith<$Res> implements $SessionModelCopyWith<$Res> {
  factory _$SessionModelCopyWith(_SessionModel value, $Res Function(_SessionModel) _then) = __$SessionModelCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'resident_details') ResidentDetails residentDetails,@JsonKey(name: 'feedback_status') String feedbackStatus,@JsonKey(name: 'scheduled_date') String scheduledDate,@JsonKey(name: 'end_time') String? endTime, String status, String? notes,@JsonKey(name: 'created_at') String createdAt,@JsonKey(name: 'updated_at') String updatedAt, String resident, String? feedback
});


@override $ResidentDetailsCopyWith<$Res> get residentDetails;

}
/// @nodoc
class __$SessionModelCopyWithImpl<$Res>
    implements _$SessionModelCopyWith<$Res> {
  __$SessionModelCopyWithImpl(this._self, this._then);

  final _SessionModel _self;
  final $Res Function(_SessionModel) _then;

/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? residentDetails = null,Object? feedbackStatus = null,Object? scheduledDate = null,Object? endTime = freezed,Object? status = null,Object? notes = freezed,Object? createdAt = null,Object? updatedAt = null,Object? resident = null,Object? feedback = freezed,}) {
  return _then(_SessionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,residentDetails: null == residentDetails ? _self.residentDetails : residentDetails // ignore: cast_nullable_to_non_nullable
as ResidentDetails,feedbackStatus: null == feedbackStatus ? _self.feedbackStatus : feedbackStatus // ignore: cast_nullable_to_non_nullable
as String,scheduledDate: null == scheduledDate ? _self.scheduledDate : scheduledDate // ignore: cast_nullable_to_non_nullable
as String,endTime: freezed == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,resident: null == resident ? _self.resident : resident // ignore: cast_nullable_to_non_nullable
as String,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SessionModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResidentDetailsCopyWith<$Res> get residentDetails {
  
  return $ResidentDetailsCopyWith<$Res>(_self.residentDetails, (value) {
    return _then(_self.copyWith(residentDetails: value));
  });
}
}

// dart format on
