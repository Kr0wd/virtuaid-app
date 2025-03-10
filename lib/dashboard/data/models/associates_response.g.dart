// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'associates_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssociatesResponse _$AssociatesResponseFromJson(Map<String, dynamic> json) =>
    _AssociatesResponse(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: json['results'] as List<dynamic>,
    );

Map<String, dynamic> _$AssociatesResponseToJson(_AssociatesResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };
