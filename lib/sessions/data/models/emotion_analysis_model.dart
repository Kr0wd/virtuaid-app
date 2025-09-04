import 'package:json_annotation/json_annotation.dart';

part 'emotion_analysis_model.g.dart';

@JsonSerializable()
class EmotionAnalysisModel {
  final String id;
  final String title;
  final String description;
  final String file;
  @JsonKey(name: 'file_size')
  final int fileSize;
  @JsonKey(name: 'uploaded_at')
  final String uploadedAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  final String status;
  @JsonKey(name: 'therapy_session')
  final int therapySession;
  final int? resident;
  @JsonKey(name: 'emotion_analysis_urls')
  final EmotionAnalysisUrls emotionAnalysisUrls;

  EmotionAnalysisModel({
    required this.id,
    required this.title,
    required this.description,
    required this.file,
    required this.fileSize,
    required this.uploadedAt,
    required this.updatedAt,
    required this.status,
    required this.therapySession,
    this.resident,
    required this.emotionAnalysisUrls,
  });

  factory EmotionAnalysisModel.fromJson(Map<String, dynamic> json) =>
      _$EmotionAnalysisModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmotionAnalysisModelToJson(this);
}

@JsonSerializable()
class EmotionAnalysisUrls {
  final String frames;
  final String timeline;
  final String summary;

  EmotionAnalysisUrls({
    required this.frames,
    required this.timeline,
    required this.summary,
  });

  factory EmotionAnalysisUrls.fromJson(Map<String, dynamic> json) =>
      _$EmotionAnalysisUrlsFromJson(json);

  Map<String, dynamic> toJson() => _$EmotionAnalysisUrlsToJson(this);
}
