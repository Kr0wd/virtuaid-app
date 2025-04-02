// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ResidentResponse _$ResidentResponseFromJson(Map<String, dynamic> json) =>
    _ResidentResponse(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results:
          (json['results'] as List<dynamic>)
              .map((e) => ResidentModel.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ResidentResponseToJson(_ResidentResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };
