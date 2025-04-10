// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResidentModel _$ResidentModelFromJson(Map<String, dynamic> json) =>
    _ResidentModel(
      id: json['id'] as String?,
      name: json['name'] as String,
      dateOfBirth: json['date_of_birth'] as String,
      url: json['url'] as String?,
      careHome:
          json['care_home'] == null
              ? null
              : CareHome.fromJson(json['care_home'] as Map<String, dynamic>),
      createdBy: json['created_by'] as String?,
    );

Map<String, dynamic> _$ResidentModelToJson(_ResidentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'date_of_birth': instance.dateOfBirth,
      'url': instance.url,
      'care_home': instance.careHome,
      'created_by': instance.createdBy,
    };

_CareHome _$CareHomeFromJson(Map<String, dynamic> json) =>
    _CareHome(name: json['name'] as String);

Map<String, dynamic> _$CareHomeToJson(_CareHome instance) => <String, dynamic>{
  'name': instance.name,
};
