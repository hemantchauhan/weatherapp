abstract class HttpClient {
  Future<HTTPResponse> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  });
}

class HTTPResponse {
  Map<String, dynamic> data;
  Map<String, dynamic>? headers;
  int? statusCode;

  HTTPResponse({required this.data, this.headers, this.statusCode});
}
