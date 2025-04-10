import 'package:json_annotation/json_annotation.dart';

part 'video_model.g.dart';

@JsonSerializable()
class VideoModel {
  final String id;
  final String title;
  final String? description;
  @JsonKey(name: 'file')
  final String fileUrl;
  @JsonKey(name: 'file_size')
  final int fileSize;
  @JsonKey(name: 'uploaded_at')
  final String uploadedAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;
  @JsonKey(name: 'therapy_session')
  final int? therapySessionId;
  @JsonKey(name: 'resident')
  final int? residentId;

  VideoModel({
    required this.id,
    required this.title,
    this.description,
    required this.fileUrl,
    required this.fileSize,
    required this.uploadedAt,
    required this.updatedAt,
    this.therapySessionId,
    this.residentId,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) =>
      _$VideoModelFromJson(json);

  Map<String, dynamic> toJson() => _$VideoModelToJson(this);
}
