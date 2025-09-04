// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emotion_analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmotionAnalysisModel _$EmotionAnalysisModelFromJson(
  Map<String, dynamic> json,
) => EmotionAnalysisModel(
  id: json['id'] as String,
  title: json['title'] as String,
  description: json['description'] as String,
  file: json['file'] as String,
  fileSize: (json['file_size'] as num).toInt(),
  uploadedAt: json['uploaded_at'] as String,
  updatedAt: json['updated_at'] as String,
  status: json['status'] as String,
  therapySession: (json['therapy_session'] as num).toInt(),
  resident: (json['resident'] as num?)?.toInt(),
  emotionAnalysisUrls: EmotionAnalysisUrls.fromJson(
    json['emotion_analysis_urls'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$EmotionAnalysisModelToJson(
  EmotionAnalysisModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'file': instance.file,
  'file_size': instance.fileSize,
  'uploaded_at': instance.uploadedAt,
  'updated_at': instance.updatedAt,
  'status': instance.status,
  'therapy_session': instance.therapySession,
  'resident': instance.resident,
  'emotion_analysis_urls': instance.emotionAnalysisUrls,
};

EmotionAnalysisUrls _$EmotionAnalysisUrlsFromJson(Map<String, dynamic> json) =>
    EmotionAnalysisUrls(
      frames: json['frames'] as String,
      timeline: json['timeline'] as String,
      summary: json['summary'] as String,
    );

Map<String, dynamic> _$EmotionAnalysisUrlsToJson(
  EmotionAnalysisUrls instance,
) => <String, dynamic>{
  'frames': instance.frames,
  'timeline': instance.timeline,
  'summary': instance.summary,
};
