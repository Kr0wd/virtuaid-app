import 'dart:io';

abstract class VideoAnalysisEvent {
  const VideoAnalysisEvent();
}

class UploadVideo extends VideoAnalysisEvent {
  final File videoFile;
  final String title;
  final String? description;
  final int? sessionId;
  final int? residentId;

  const UploadVideo({
    required this.videoFile,
    required this.title,
    this.description,
    this.sessionId,
    this.residentId,
  });
}
