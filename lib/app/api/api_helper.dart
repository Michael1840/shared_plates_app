import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../main.dart';
import '../core/data/helpers/network_helper.dart';
import 'models/api_response_model.dart';

part 'api_routes.dart';
part 'api_service.dart';

enum DioMethod { post, get, put, delete }

class DioClient {
  static String get baseUrl {
    // if (kDebugMode) {
    //   return ApiRoutes.debugUrl;
    // }

    return ApiRoutes.releaseUrl;
  }

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  )..interceptors.add(ApiInterceptors());
}

class ApiHelper {
  ApiHelper._singleton();

  static final ApiHelper instance = ApiHelper._singleton();

  final Dio _dio = DioClient.dio;

  Future<ApiResponseModel> request(
    String endpoint,
    DioMethod method, {
    Map<String, dynamic>? data,
    String? contentType,
    bool hasAuth = true,
    formData,
  }) async {
    bool isOnline = await NetworkHelper.isOnline();

    if (!isOnline) {
      return const ApiResponseModel(statusCode: -1);
    }

    try {
      String? accessToken = await tokenStorage.getAccessToken();

      final options = Options(
        headers: {
          HttpHeaders.acceptHeader: 'application/json',
          if (hasAuth) HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
        contentType: contentType ?? Headers.jsonContentType,
      );

      final Response response;

      switch (method) {
        case DioMethod.post:
          response = await _dio.post(
            endpoint,
            data: data ?? formData,
            options: options,
          );
          break;
        case DioMethod.get:
          response = await _dio.get(
            endpoint,
            queryParameters: data,
            options: options,
          );
          break;
        case DioMethod.put:
          response = await _dio.put(
            endpoint,
            data: data ?? formData,
            options: options,
          );
          break;
        case DioMethod.delete:
          response = await _dio.delete(
            endpoint,
            data: data ?? formData,
            options: options,
          );
          break;
      }

      final parsedData = response.data;

      return ApiResponseModel(
        statusCode: response.statusCode,
        data: parsedData,
      );
    } catch (e) {
      print(e.toString());
      return const ApiResponseModel(statusCode: -1);
    }
  }
}

class ApiInterceptors extends Interceptor {
  bool _isRefreshing = false;
  late Dio _tokenDio;

  ApiInterceptors() {
    _tokenDio = Dio(
      BaseOptions(
        baseUrl: DioClient.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
      ),
    );
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final baseUrl = err.requestOptions.baseUrl;
    final endpoint = err.requestOptions.path;
    final statusCode = err.response?.statusCode;

    debugPrint(
      '────────────────────────── API ERROR ──────────────────────────',
    );
    debugPrint('🚨 STATUS CODE: $statusCode');
    debugPrint('🔗 URL: $baseUrl$endpoint');

    if (err.requestOptions.headers.isNotEmpty) {
      debugPrint('HEADERS: ${err.requestOptions.headers}');
    }

    if (err.requestOptions.data != null) {
      debugPrint('➡️ REQUEST BODY: ${err.requestOptions.data}');
    }

    if (err.response?.data != null) {
      debugPrint('⬅️ RESPONSE BODY: ${err.response?.data}');
    } else {
      // This is the key part to catch empty/null responses
      debugPrint('⬅️ RESPONSE BODY: (empty or null)');
    }

    debugPrint('❌ ERROR MESSAGE: ${err.message}');
    debugPrint(
      '─────────────────────────────────────────────────────────────────',
    );

    if (err.response?.statusCode == 502 || err.response?.statusCode == 500) {
      _isRefreshing = true;

      try {
        final options = err.requestOptions;

        final retryResponse = await Dio().fetch(options);
        _isRefreshing = false;
        return handler.resolve(retryResponse);
      } catch (e) {
        _isRefreshing = false;
        return handler.reject(err);
      }
    } else if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;

      final refreshToken = await tokenStorage.getRefreshToken();

      if (refreshToken == null) {
        // Optionally redirect to login
        handler.reject(err);
        return;
      }

      try {
        final response = await _tokenDio.post(
          ApiRoutes.tokenRefresh,
          data: {'refresh': refreshToken},
        );

        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];

        // Store new tokens
        await tokenStorage.saveTokens(newAccessToken, newRefreshToken);

        // Retry original request
        final options = err.requestOptions;
        options.headers[HttpHeaders.authorizationHeader] =
            'Bearer $newAccessToken';

        final retryResponse = await Dio().fetch(options);
        _isRefreshing = false;
        return handler.resolve(retryResponse);
      } catch (e) {
        await tokenStorage.clearTokens();
        _isRefreshing = false;
        return handler.reject(err);
      }
    }

    return handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final baseUrl = options.baseUrl;
    final endpoint = options.path;
    final method = options.method;
    final data = options.data;
    final queryParams = options.queryParameters;

    debugPrint(
      '────────────────────────── API REQUEST ──────────────────────────',
    );
    debugPrint('🔗 URL: $baseUrl$endpoint');
    debugPrint('➡️ METHOD: $method');

    if (options.headers.isNotEmpty) {
      debugPrint('HEADERS: ${options.headers}');
    }

    if (data != null) {
      debugPrint('➡️ REQUEST BODY: $data');
    }

    if (queryParams.isNotEmpty) {
      debugPrint('➡️ QUERY PARAMS: $queryParams');
    }

    debugPrint(
      '─────────────────────────────────────────────────────────────────',
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final baseUrl = response.requestOptions.baseUrl;
    final endpoint = response.requestOptions.path;
    final method = response.requestOptions.method;
    final statusCode = response.statusCode;
    final responseBody = response.data;

    debugPrint(
      '────────────────────────── API RESPONSE ─────────────────────────',
    );
    debugPrint('🔗 URL: $baseUrl$endpoint');
    debugPrint('⬅️ METHOD: $method');
    debugPrint('✅ STATUS CODE: $statusCode');

    if (responseBody != null) {
      debugPrint('⬅️ RESPONSE BODY: $responseBody');
    } else {
      debugPrint('⬅️ RESPONSE BODY: (empty)');
    }

    debugPrint(
      '─────────────────────────────────────────────────────────────────',
    );

    super.onResponse(response, handler);
  }
}
