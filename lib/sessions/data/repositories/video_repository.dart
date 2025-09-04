import 'dart:io';
import '../models/video_model.dart';

abstract class VideoRepository {
  Future<VideoModel> uploadVideo({
    required File videoFile,
    required String title,
    String? description,
    int? sessionId,
    int? residentId,
  });
}
