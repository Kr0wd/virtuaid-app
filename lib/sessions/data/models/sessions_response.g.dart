// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sessions_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionsResponse _$SessionsResponseFromJson(Map<String, dynamic> json) =>
    SessionsResponse(
      results:
          (json['results'] as List<dynamic>)
              .map((e) => SessionModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      count: (json['count'] as num).toInt(),
      nextPageUrl: json['next'] as String?,
      previousPageUrl: json['previous'] as String?,
    );

Map<String, dynamic> _$SessionsResponseToJson(SessionsResponse instance) =>
    <String, dynamic>{
      'results': instance.results,
      'count': instance.count,
      'next': instance.nextPageUrl,
      'previous': instance.previousPageUrl,
    };
