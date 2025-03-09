class ApiConstants {
  ApiConstants._();

  // Base URL for API calls - loaded from environment variables
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8000/api/',
  );

  // Common headers
  static const Map<String, dynamic> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Timeout settings in milliseconds
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
}
