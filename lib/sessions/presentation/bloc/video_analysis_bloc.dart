import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/video_repository.dart';
import 'video_analysis_event.dart';
import 'video_analysis_state.dart';

class VideoAnalysisBloc extends Bloc<VideoAnalysisEvent, VideoAnalysisState> {
  final VideoRepository _videoRepository;

  VideoAnalysisBloc(this._videoRepository) : super(VideoAnalysisInitial()) {
    on<UploadVideo>(_onUploadVideo);
  }

  Future<void> _onUploadVideo(
    UploadVideo event,
    Emitter<VideoAnalysisState> emit,
  ) async {
    emit(VideoAnalysisLoading());
    try {
      final video = await _videoRepository.uploadVideo(
        videoFile: event.videoFile,
        title: event.title,
        description: event.description,
        sessionId: event.sessionId,
        residentId: event.residentId,
      );
      emit(VideoAnalysisSuccess(video));
    } catch (error) {
      emit(VideoAnalysisError(error.toString()));
    }
  }
}
