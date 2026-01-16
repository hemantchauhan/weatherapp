import 'package:dio/dio.dart';
import 'package:weatherapp/src/core/network/http_client.dart';

/// Dio-specific error mapper (implementation detail)
class _DioErrorMapper {
  static String mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection and try again.';

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.cancel:
        return 'Request was cancelled. Please try again.';

      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network settings.';

      case DioExceptionType.badCertificate:
        return 'SSL certificate error. Please check your connection.';

      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return 'No internet connection. Please check your network settings.';
        }
        return 'An unexpected error occurred. Please try again later.';
    }
  }

  static String _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;

    if (statusCode == null) {
      return 'Invalid response from server. Please try again.';
    }

    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your input and try again.';
      case 401:
        return 'Authentication failed. Please check your API key.';
      case 403:
        return 'Access forbidden. Please check your permissions.';
      case 404:
        return 'Weather data not found for this location.';
      case 429:
        return 'Too many requests. Please wait a moment and try again.';
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Server error. Please try again later.';
      default:
        return 'Error $statusCode: ${_extractErrorMessage(error.response?.data) ?? 'An error occurred'}';
    }
  }

  static String? _extractErrorMessage(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      return responseData['message'] as String? ??
          responseData['error'] as String? ??
          responseData['msg'] as String?;
    }
    return null;
  }
}

class DioHttpClient implements HttpClient {
  final Dio dio;

  DioHttpClient(this.dio);

  @override
  Future<HTTPResponse> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: headers != null ? Options(headers: headers) : null,
      );

      return HTTPResponse(
        data: response.data as Map<String, dynamic>,
        statusCode: response.statusCode,
        headers: response.headers.map,
      );
    } on DioException catch (e) {
      throw Exception(_DioErrorMapper.mapDioException(e));
    }
  }
}
