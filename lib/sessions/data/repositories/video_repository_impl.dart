import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

import '../../../core/network/dio_service.dart';
import '../models/video_model.dart';
import 'video_repository.dart';

class VideoRepositoryImpl implements VideoRepository {
  final DioService _dioService;

  VideoRepositoryImpl(this._dioService);

  @override
  Future<VideoModel> uploadVideo({
    required File videoFile,
    required String title,
    String? description,
    int? sessionId,
    int? residentId,
  }) async {
    try {
      final formData = FormData();

      // Handle file upload differently based on platform
      if (kIsWeb) {
        // For web platforms, read file as bytes
        final bytes = await videoFile.readAsBytes();
        final filename = path.basename(videoFile.path);

        formData.files.add(
          MapEntry(
            'file',
            MultipartFile.fromBytes(
              bytes,
              filename: filename,
              contentType: _getContentType(filename),
            ),
          ),
        );
      } else {
        // For native platforms, use the file directly
        formData.files.add(
          MapEntry(
            'file',
            await MultipartFile.fromFile(
              videoFile.path,
              filename: path.basename(videoFile.path),
              contentType: _getContentType(videoFile.path),
            ),
          ),
        );
      }

      // Add other fields
      formData.fields.add(MapEntry('title', title));

      if (description != null) {
        formData.fields.add(MapEntry('description', description));
      }

      if (sessionId != null) {
        formData.fields.add(MapEntry('therapy_session', sessionId.toString()));
      }

      if (residentId != null) {
        formData.fields.add(MapEntry('resident', residentId.toString()));
      }

      final response = await _dioService.dioInstance.post(
        'analysis/videos/',
        data: formData,
        options: Options(
          headers: {Headers.contentTypeHeader: 'multipart/form-data'},
        ),
      );

      return VideoModel.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    } catch (e) {
      throw Exception('Failed to upload video: ${e.toString()}');
    }
  }

  // Helper method to determine content type based on file extension
  MediaType? _getContentType(String filename) {
    final ext = path.extension(filename).toLowerCase();
    switch (ext) {
      case '.mp4':
        return MediaType('video', 'mp4');
      case '.mov':
        return MediaType('video', 'quicktime');
      case '.avi':
        return MediaType('video', 'x-msvideo');
      case '.wmv':
        return MediaType('video', 'x-ms-wmv');
      case '.flv':
        return MediaType('video', 'x-flv');
      case '.webm':
        return MediaType('video', 'webm');
      default:
        return MediaType('video', 'mp4'); // Default to mp4
    }
  }

  Exception _handleError(DioException error) {
    if (error.response != null) {
      final data = error.response?.data;
      if (data != null && data is Map) {
        String errorMsg = '';
        data.forEach((key, value) {
          if (value is List) {
            errorMsg += '$key: ${value.join(', ')}\n';
          } else {
            errorMsg += '$key: $value\n';
          }
        });
        return Exception(errorMsg.trim());
      }
      return Exception(
        '${error.response?.statusCode}: ${error.response?.statusMessage}',
      );
    }
    return Exception('Network error: ${error.message}');
  }
}
