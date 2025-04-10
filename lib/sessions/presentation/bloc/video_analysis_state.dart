import '../../data/models/video_model.dart';

abstract class VideoAnalysisState {
  const VideoAnalysisState();
}

class VideoAnalysisInitial extends VideoAnalysisState {}

class VideoAnalysisLoading extends VideoAnalysisState {}

class VideoAnalysisSuccess extends VideoAnalysisState {
  final VideoModel video;

  const VideoAnalysisSuccess(this.video);
}

class VideoAnalysisError extends VideoAnalysisState {
  final String message;

  const VideoAnalysisError(this.message);
}
