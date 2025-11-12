/// API Configuration for StudyPad Mobile
class ApiConfig {
  // Development - local backend
  static const String devBaseUrl = 'http://10.0.2.2:8011'; // Android emulator localhost
  static const String devBaseUrlIOS = 'http://localhost:8011'; // iOS simulator

  // Production - when deployed
  static const String prodBaseUrl = 'https://api.studypad.yourdomain.com';

  // Current environment - change this for production
  static const bool isProduction = false;

  // Get the appropriate base URL
  static String get baseUrl {
    if (isProduction) {
      return prodBaseUrl;
    }
    // For Android emulator, use 10.0.2.2 to access host machine's localhost
    // For iOS simulator, use localhost
    // You can detect platform and return appropriate URL
    return devBaseUrl;
  }

  // API Endpoints
  static const String uploadEndpoint = '/api/v1/upload';
  static const String documentsEndpoint = '/api/v1/documents';
  static const String queryEndpoint = '/api/v1/query';
  static const String studioEndpoint = '/api/v1/studio';
  static const String healthEndpoint = '/health';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Upload limits
  static const int maxUploadSize = 10 * 1024 * 1024; // 10MB
}
