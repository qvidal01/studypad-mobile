import 'dart:io';
import 'package:dio/dio.dart';
import '../config/api_config.dart';

/// API Service for handling all HTTP requests to the StudyPad backend
/// Uses Dio for HTTP requests with retry logic and error handling
class ApiService {
  late final Dio _dio;
  static ApiService? _instance;

  // Private constructor for singleton pattern
  ApiService._internal() {
    _dio = Dio(_buildBaseOptions());
    _setupInterceptors();
  }

  /// Get singleton instance
  factory ApiService() {
    _instance ??= ApiService._internal();
    return _instance!;
  }

  /// Build base options for Dio
  BaseOptions _buildBaseOptions() {
    return BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectionTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      sendTimeout: ApiConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      validateStatus: (status) {
        // Accept all status codes to handle them manually
        return status != null && status < 500;
      },
    );
  }

  /// Setup interceptors for logging and error handling
  void _setupInterceptors() {
    if (ApiConfig.isDebug) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          error: true,
          logPrint: (obj) => print('[API] $obj'),
        ),
      );
    }

    // Add retry interceptor
    _dio.interceptors.add(
      InterceptorsWrapper(
        onError: (error, handler) async {
          if (_shouldRetry(error)) {
            try {
              final response = await _retry(error.requestOptions);
              handler.resolve(response);
            } catch (e) {
              handler.next(error);
            }
          } else {
            handler.next(error);
          }
        },
      ),
    );
  }

  /// Determine if request should be retried
  bool _shouldRetry(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500);
  }

  /// Retry failed request with exponential backoff
  Future<Response> _retry(RequestOptions requestOptions) async {
    int retries = 0;
    while (retries < ApiConfig.maxRetries) {
      await Future.delayed(
        ApiConfig.retryDelay * (retries + 1),
      );
      try {
        return await _dio.request(
          requestOptions.path,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          options: Options(
            method: requestOptions.method,
            headers: requestOptions.headers,
          ),
        );
      } catch (e) {
        retries++;
        if (retries >= ApiConfig.maxRetries) {
          rethrow;
        }
      }
    }
    throw DioException(
      requestOptions: requestOptions,
      error: 'Max retries exceeded',
    );
  }

  // ==================== Health Check ====================

  /// Check if the API is healthy and reachable
  Future<ApiResponse<Map<String, dynamic>>> checkHealth() async {
    try {
      final response = await _dio.get(ApiConfig.healthEndpoint);
      return ApiResponse.success(response.data);
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  // ==================== Document Management ====================

  /// Upload a document to the backend
  Future<ApiResponse<Map<String, dynamic>>> uploadDocument({
    required File file,
    String? title,
    void Function(int sent, int total)? onProgress,
  }) async {
    try {
      // Validate file size
      final fileSize = await file.length();
      if (!ApiConfig.isFileSizeValid(fileSize)) {
        return ApiResponse.error(
          'File size exceeds maximum allowed size of ${ApiConfig.maxUploadSizeMB}MB',
        );
      }

      final fileName = file.path.split('/').last;
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
        if (title != null) 'title': title,
      });

      final response = await _dio.post(
        ApiConfig.uploadEndpoint,
        data: formData,
        onSendProgress: onProgress,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(response.data);
      } else {
        return ApiResponse.error(
          response.data['error'] ?? 'Upload failed',
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// Get list of all documents
  Future<ApiResponse<List<dynamic>>> getDocuments({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiConfig.documentsEndpoint,
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(response.data['documents'] ?? []);
      } else {
        return ApiResponse.error(
          response.data['error'] ?? 'Failed to fetch documents',
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  /// Delete a document by ID
  Future<ApiResponse<void>> deleteDocument(String documentId) async {
    try {
      final response = await _dio.delete(
        '${ApiConfig.documentsEndpoint}/$documentId',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return ApiResponse.success(null);
      } else {
        return ApiResponse.error(
          response.data['error'] ?? 'Failed to delete document',
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  // ==================== Chat / Query ====================

  /// Send a query to chat with documents
  Future<ApiResponse<Map<String, dynamic>>> sendQuery({
    required String query,
    List<String>? documentIds,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.queryEndpoint,
        data: {
          'query': query,
          if (documentIds != null && documentIds.isNotEmpty)
            'document_ids': documentIds,
        },
      );

      if (response.statusCode == 200) {
        return ApiResponse.success(response.data);
      } else {
        return ApiResponse.error(
          response.data['error'] ?? 'Query failed',
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  // ==================== Studio ====================

  /// Generate study materials using AI studio
  Future<ApiResponse<Map<String, dynamic>>> generateStudioContent({
    required String contentType,
    required List<String> documentIds,
    Map<String, dynamic>? options,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.studioEndpoint,
        data: {
          'content_type': contentType,
          'document_ids': documentIds,
          if (options != null) ...options,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(response.data);
      } else {
        return ApiResponse.error(
          response.data['error'] ?? 'Studio generation failed',
        );
      }
    } on DioException catch (e) {
      return ApiResponse.error(_handleError(e));
    } catch (e) {
      return ApiResponse.error('Unexpected error: $e');
    }
  }

  // ==================== Error Handling ====================

  /// Handle Dio errors and convert to user-friendly messages
  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timeout. Please try again.';
      case DioExceptionType.receiveTimeout:
        return 'Server response timeout. Please try again.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['error'];
        if (statusCode == 400) {
          return message ?? 'Bad request. Please check your input.';
        } else if (statusCode == 401) {
          return 'Unauthorized. Please log in again.';
        } else if (statusCode == 403) {
          return 'Access forbidden.';
        } else if (statusCode == 404) {
          return 'Resource not found.';
        } else if (statusCode == 413) {
          return 'File too large. Maximum size is ${ApiConfig.maxUploadSizeMB}MB.';
        } else if (statusCode != null && statusCode >= 500) {
          return 'Server error. Please try again later.';
        }
        return message ?? 'Request failed.';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      case DioExceptionType.connectionError:
        return 'Connection error. Please check your internet connection.';
      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return 'No internet connection. Please check your network.';
        }
        return 'An unexpected error occurred. Please try again.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

/// Generic API response wrapper
class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  ApiResponse._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse._(
      data: data,
      isSuccess: true,
    );
  }

  factory ApiResponse.error(String error) {
    return ApiResponse._(
      error: error,
      isSuccess: false,
    );
  }
}
