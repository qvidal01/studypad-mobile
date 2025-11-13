import 'dart:io' show Platform;

/// API Configuration for StudyPad Mobile
/// Handles environment-specific URLs and API endpoints
class ApiConfig {
  // Private constructor to prevent instantiation
  ApiConfig._();

  // Development - local backend
  static const String _devBaseUrlAndroid = 'http://10.0.2.2:8011'; // Android emulator localhost
  static const String _devBaseUrlIOS = 'http://localhost:8011'; // iOS simulator
  static const String _devBaseUrlOther = 'http://localhost:8011'; // Web/Desktop

  // Production - when deployed
  static const String _prodBaseUrl = 'https://api.studypad.yourdomain.com';

  // Environment flag - change this for production builds
  static const bool isProduction = false;

  // API version
  static const String apiVersion = 'v1';

  /// Get the appropriate base URL based on environment and platform
  static String get baseUrl {
    if (isProduction) {
      return _prodBaseUrl;
    }

    // Platform-specific URLs for development
    try {
      if (Platform.isAndroid) {
        return _devBaseUrlAndroid;
      } else if (Platform.isIOS) {
        return _devBaseUrlIOS;
      } else {
        return _devBaseUrlOther;
      }
    } catch (e) {
      // Fallback for web platform (Platform.isX throws on web)
      return _devBaseUrlOther;
    }
  }

  // API Endpoints
  static const String uploadEndpoint = '/api/$apiVersion/upload';
  static const String documentsEndpoint = '/api/$apiVersion/documents';
  static const String queryEndpoint = '/api/$apiVersion/query';
  static const String studioEndpoint = '/api/$apiVersion/studio';
  static const String healthEndpoint = '/health';

  // Full endpoint URLs
  static String get uploadUrl => '$baseUrl$uploadEndpoint';
  static String get documentsUrl => '$baseUrl$documentsEndpoint';
  static String get queryUrl => '$baseUrl$queryEndpoint';
  static String get studioUrl => '$baseUrl$studioEndpoint';
  static String get healthUrl => '$baseUrl$healthEndpoint';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 60); // For uploads

  // Upload limits
  static const int maxUploadSize = 10 * 1024 * 1024; // 10MB
  static const int maxUploadSizeMB = 10;

  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Supported file types
  static const List<String> supportedFileExtensions = [
    'pdf',
    'doc',
    'docx',
    'txt',
  ];

  static const List<String> supportedMimeTypes = [
    'application/pdf',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'text/plain',
  ];

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  /// Check if the app is running in debug mode
  static bool get isDebug {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  /// Get environment name for logging
  static String get environmentName => isProduction ? 'Production' : 'Development';

  /// Validate file size
  static bool isFileSizeValid(int sizeInBytes) {
    return sizeInBytes > 0 && sizeInBytes <= maxUploadSize;
  }

  /// Validate file extension
  static bool isFileExtensionSupported(String extension) {
    return supportedFileExtensions.contains(extension.toLowerCase().replaceAll('.', ''));
  }

  /// Validate MIME type
  static bool isMimeTypeSupported(String mimeType) {
    return supportedMimeTypes.contains(mimeType.toLowerCase());
  }
}
