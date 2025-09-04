// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoModel _$VideoModelFromJson(Map<String, dynamic> json) => VideoModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String?,
  fileUrl: json['file'] as String,
  fileSize: (json['file_size'] as num).toInt(),
  uploadedAt: json['uploaded_at'] as String,
  updatedAt: json['updated_at'] as String,
  therapySessionId: (json['therapy_session'] as num?)?.toInt(),
  residentId: (json['resident'] as num?)?.toInt(),
);

Map<String, dynamic> _$VideoModelToJson(VideoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'file': instance.fileUrl,
      'file_size': instance.fileSize,
      'uploaded_at': instance.uploadedAt,
      'updated_at': instance.updatedAt,
      'therapy_session': instance.therapySessionId,
      'resident': instance.residentId,
    };
