import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/auth_model.dart';
import 'token_service.dart';
import 'package:google_sign_in/google_sign_in.dart' as gsi;

class AuthService {
  final Dio _dio;
  final TokenService _tokenService;

  // Namespaced to avoid any local symbol collision.
  final gsi.GoogleSignIn _googleSignIn = gsi.GoogleSignIn(
    scopes: <String>['email', 'profile'],
    // clientId / serverClientId if needed for web/iOS.
  );

  AuthService(this._dio, this._tokenService);

  // Try a list of endpoint paths and return the first successful POST/GET
  Future<Response<dynamic>> _postTryPaths(
    List<String> paths, {
    Object? data,
    Options? options,
  }) async {
    DioException? lastErr;
    for (final path in paths) {
      try {
        return await _dio.post(path, data: data, options: options);
      } on DioException catch (e) {
        lastErr = e;
        final code = e.response?.statusCode;
        if (code == 404 || code == 405) continue; // try next variant
        rethrow; // other errors: surface immediately
      }
    }
    throw lastErr ?? DioException(requestOptions: RequestOptions(path: paths.first));
  }

  Future<Response<dynamic>> _getTryPaths(
    List<String> paths, {
    Options? options,
  }) async {
    DioException? lastErr;
    for (final path in paths) {
      try {
        return await _dio.get(path, options: options);
      } on DioException catch (e) {
        lastErr = e;
        final code = e.response?.statusCode;
        if (code == 404 || code == 405) continue;
        rethrow;
      }
    }
    throw lastErr ?? DioException(requestOptions: RequestOptions(path: paths.first));
  }

  // Login user - no longer stores access token
  Future<AuthModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _postTryPaths(
        ['auth/app/login/', 'auth/login/'],
        // Include both keys to support backends expecting either username or email
        data: {
          'username': username,
          'email': username,
          'password': password,
        },
      );

      final accessToken = response.data['access'];
      final refreshToken = response.data['refresh'];

      // Only store the refresh token persistently
      await _tokenService.saveRefreshToken(refreshToken);

      final user = await _fetchUserInfo(accessToken);

      return AuthModel(accessToken: accessToken, user: user);
    } catch (e) {
  throw _handleError(e, 'Login failed');
    }
  }

  // Register new user
  Future<AuthModel> register({
    required String username,
    required String email,
    required String password1,
    required String password2,
    required String name,
  }) async {
    try {
      final response = await _postTryPaths(
        ['auth/app/register/', 'auth/register/'],
        data: {
          'username': username,
          'email': email,
          'password1': password1,
          'password2': password2,
          'name': name,
        },
      );

      final accessToken = response.data['access'];
      final refreshToken = response.data['refresh'];

      // Only store the refresh token persistently
      await _tokenService.saveRefreshToken(refreshToken);

      final user = await _fetchUserInfo(accessToken);

      return AuthModel(accessToken: accessToken, user: user);
    } catch (e) {
      throw _handleError(e, 'Registration failed');
    }
  }

  // Google Sign-In method
  Future<AuthModel> googleLogin() async {
    try {
      final gsi.GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google Sign-In was cancelled');
      }
      final gsi.GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      // accessToken is still available; use if your backend expects it:
      // final String? accessToken = googleAuth.accessToken;

      if (idToken == null) {
        throw Exception('Missing Google ID token');
      }

      final response = await _postTryPaths(
        ['auth/google/callback/', 'auth/google/login/'],
        data: {'id_token': idToken},
      );

      final backendAccessToken = response.data['access'];
      final refreshToken = response.data['refresh'];
      await _tokenService.saveRefreshToken(refreshToken);
      final user = await _fetchUserInfo(backendAccessToken);
      return AuthModel(accessToken: backendAccessToken, user: user);
    } catch (e) {
      await _googleSignIn.signOut();
      throw _handleError(e, 'Google login failed');
    }
  }

  // Logout user - takes current access token as parameter
  Future<void> logout(String? accessToken) async {
    try {
      final refreshToken = await _tokenService.getRefreshToken();
      if (accessToken != null) {
        // Also sign the user out of Google
        _googleSignIn.signOut();
        await _postTryPaths(
          ['auth/app/logout/', 'auth/logout/'],
          data: {'refresh': refreshToken},
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );
      }
    } catch (e) {
      // We still want to clear tokens even if the request fails
      print('Logout API call failed, but continuing to clear local tokens: $e');
    } finally {
      await _tokenService.clearTokens();
    }
  }

  // Refresh access token
  Future<String?> refreshToken() async {
    try {
      final refreshToken = await _tokenService.getRefreshToken();

      if (refreshToken == null) {
        throw Exception('No refresh token found');
      }

      final response = await _postTryPaths(
        ['auth/app/token/refresh/', 'auth/token/refresh/'],
        data: {'refresh': refreshToken},
      );

      // Return the new token but don't store it persistently
      return response.data['access'];
    } catch (e) {
      print('Token refresh failed: $e');
      // Clear refresh token if refresh fails
      await _tokenService.clearTokens();
      return null;
    }
  }

  // Verify current authentication status
  Future<AuthModel> checkAuthStatus(String? currentAccessToken) async {
    if (currentAccessToken == null) {
      // Try to refresh the token if there's a refresh token
      final newToken = await refreshToken();

      if (newToken == null) {
        return AuthModel.initial();
      }

      // If we got a new token, fetch user info
      final user = await _fetchUserInfo(newToken);
      return AuthModel(accessToken: newToken, user: user);
    }

    try {
      // Verify token validity by fetching user info
      final user = await _fetchUserInfo(currentAccessToken);
      return AuthModel(accessToken: currentAccessToken, user: user);
    } catch (e) {
      // If token is invalid, try refreshing
      final newToken = await refreshToken();

      if (newToken == null) {
        return AuthModel.initial();
      }

      final user = await _fetchUserInfo(newToken);
      return AuthModel(accessToken: newToken, user: user);
    }
  }

  // Helper to fetch user information
  Future<UserModel> _fetchUserInfo(String token) async {
    try {
      final response = await _getTryPaths(
        ['auth/app/user/', 'auth/user/'],
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return UserModel.fromJson({
        ...response.data,
        'isAdmin': response.data['is_admin'] ?? false,
      });
    } catch (e) {
      throw _handleError(e, 'Failed to fetch user information');
    }
  }

  // Error handling helper
  Exception _handleError(dynamic error, String fallbackMessage) {
    if (error is DioException) {
      final res = error.response;
      if (res != null) {
        final data = res.data;
        if (data is Map) {
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
        if (data is String && data.isNotEmpty) {
          final snippet = data.length > 200 ? '${data.substring(0, 200)}...' : data;
          return Exception('${res.statusCode}: ${res.statusMessage} - $snippet');
        }
        return Exception('${res.statusCode}: ${res.statusMessage}');
      }
      // Network/handshake/timeouts
      return Exception('$fallbackMessage: ${error.message}');
    }
    return Exception(fallbackMessage);
  }
}