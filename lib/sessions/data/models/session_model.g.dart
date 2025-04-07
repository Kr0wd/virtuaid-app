// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CareHome _$CareHomeFromJson(Map<String, dynamic> json) =>
    _CareHome(name: json['name'] as String);

Map<String, dynamic> _$CareHomeToJson(_CareHome instance) => <String, dynamic>{
  'name': instance.name,
};

_ResidentDetails _$ResidentDetailsFromJson(Map<String, dynamic> json) =>
    _ResidentDetails(
      url: json['url'] as String,
      id: json['id'] as String,
      name: json['name'] as String,
      dateOfBirth: json['date_of_birth'] as String,
      careHome: CareHome.fromJson(json['care_home'] as Map<String, dynamic>),
      createdBy: json['created_by'] as String,
    );

Map<String, dynamic> _$ResidentDetailsToJson(_ResidentDetails instance) =>
    <String, dynamic>{
      'url': instance.url,
      'id': instance.id,
      'name': instance.name,
      'date_of_birth': instance.dateOfBirth,
      'care_home': instance.careHome,
      'created_by': instance.createdBy,
    };

_SessionModel _$SessionModelFromJson(Map<String, dynamic> json) =>
    _SessionModel(
      id: (json['id'] as num).toInt(),
      residentDetails: ResidentDetails.fromJson(
        json['resident_details'] as Map<String, dynamic>,
      ),
      feedbackStatus: json['feedback_status'] as String,
      scheduledDate: json['scheduled_date'] as String,
      endTime: json['end_time'] as String?,
      status: json['status'] as String,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      resident: json['resident'] as String,
      feedback: json['feedback'] as String?,
    );

Map<String, dynamic> _$SessionModelToJson(_SessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'resident_details': instance.residentDetails,
      'feedback_status': instance.feedbackStatus,
      'scheduled_date': instance.scheduledDate,
      'end_time': instance.endTime,
      'status': instance.status,
      'notes': instance.notes,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'resident': instance.resident,
      'feedback': instance.feedback,
    };
