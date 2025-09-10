import 'package:dio/dio.dart';
import 'dart:io' show Platform;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'api_constants.dart';
import 'auth_interceptor.dart';
import '../../authentication/services/token_service.dart';
import '../../authentication/bloc/authentication_bloc.dart';

class DioService {
  static final DioService _singleton = DioService._internal();

  factory DioService() => _singleton;

  late final Dio dio;
  final _secureStorage = const FlutterSecureStorage();
  late final TokenService _tokenService;
  AuthenticationBloc? _authBloc;

  DioService._internal() {
    dio = _createDio();
    _tokenService = TokenService(_secureStorage);
    // AuthInterceptor will be added after authBloc is set
  }

  // Set the auth bloc after it's created
  void setAuthBloc(AuthenticationBloc authBloc) {
    _authBloc = authBloc;
    _addInterceptors();
  }

  Dio _createDio() {
    final resolvedBase = _resolveBaseUrl(ApiConstants.baseUrl);
    return Dio(
      BaseOptions(
        baseUrl: resolvedBase,
        headers: ApiConstants.headers,
        connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
  // Only treat 2xx as success; throw for 4xx/5xx so callers can handle
  validateStatus: (status) => status != null && status >= 200 && status < 300,
      ),
    );
  }

  String _resolveBaseUrl(String url) {
    var u = url;
    // Map localhost to Android emulator host if needed
    if ((u.contains('localhost') || u.contains('127.0.0.1')) && Platform.isAndroid) {
      u = u.replaceFirst('localhost', '10.0.2.2').replaceFirst('127.0.0.1', '10.0.2.2');
    }
    if (!u.endsWith('/')) u = '$u/';
    return u;
  }

  void _addInterceptors() {
    dio.interceptors.clear(); // Clear any existing interceptors
    dio.interceptors.addAll([
      // Add auth interceptor with auth bloc
      if (_authBloc != null) AuthInterceptor(_tokenService, dio, _authBloc!),

      // Pretty logger for development debugging
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    ]);
  }

  // Get the dio instance
  Dio get dioInstance => dio;

  // Get the token service
  TokenService get tokenService => _tokenService;
}
