import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../main.dart';
import '../core/data/helpers/network_helper.dart';
import 'models/api_response_model.dart';
import 'models/model_converter.dart';
import 'models/pagination_model.dart';
import 'models/result_model.dart';

part 'api_routes.dart';

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

  static final Dio dioNoBase = Dio(
    BaseOptions(
      baseUrl: '',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  )..interceptors.add(ApiInterceptors());
}

class ApiHelper {
  static final Dio _dio = DioClient.dio;

  static Future<ApiResponseModel> request(
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

  static Future<Result<T>> requestModel<T>(
    String endpoint,
    DioMethod method, {
    required ModelConverter<T> converter,
    Map<String, dynamic>? req,
    String? contentType,
    FormData? formData,
    bool hasAuth = false,
  }) async {
    try {
      final ApiResponseModel response = await request(
        endpoint,
        method,
        data: req,
        hasAuth: hasAuth,
        contentType: contentType,
        formData: formData,
      );

      final errorResult = _handleError<T>(response);
      if (errorResult != null) return errorResult;

      if (response.data['data'] is! Map<String, dynamic>) {
        throw ArgumentError(
          'Expected Map<String, dynamic>, got ${response.data.runtimeType}',
        );
      }

      final model = converter.fromJson(response.data['data']);
      return Result.ok(model);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<List<T>>> requestModelList<T>(
    String endpoint,
    DioMethod method, {
    required ModelConverter<T> converter,
    Map<String, dynamic>? req,
    String? contentType,
    FormData? formData,
    bool hasAuth = false,
  }) async {
    try {
      final ApiResponseModel response = await request(
        endpoint,
        method,
        data: req,
        hasAuth: hasAuth,
        contentType: contentType,
        formData: formData,
      );

      final errorResult = _handleError<List<T>>(response);
      if (errorResult != null) return errorResult;

      if (response.data['data'] is! Iterable) {
        throw ArgumentError('Expected Map, got ${response.data.runtimeType}');
      }

      final list = converter.fromList(response.data['data']);
      return Result.ok(list);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Future<Result<PaginationModel<T>>> requestPaginatedList<T>(
    String endpoint,
    DioMethod method, {
    required ModelConverter<T> converter,
    Map<String, dynamic>? req,
    String? contentType,
    FormData? formData,
    bool hasAuth = false,
  }) async {
    try {
      final ApiResponseModel response = await request(
        endpoint,
        method,
        data: req,
        hasAuth: hasAuth,
        contentType: contentType,
        formData: formData,
      );

      final errorResult = _handleError<PaginationModel<T>>(response);
      if (errorResult != null) return errorResult;

      if (response.data['data'] is! Iterable) {
        throw ArgumentError('Expected Map, got ${response.data.runtimeType}');
      }

      final list = converter.fromList(response.data['data']);

      final PaginationModel<T> pagination = PaginationModel(
        items: list,
        nextUrl: response.data['next'],
        previousUrl: response.data['previous'],
      );

      return Result.ok(pagination);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  static Result<T>? _handleError<T>(ApiResponseModel response) {
    if (response.data == null) {
      return Result<T>.error(
        Exception('Request failed with status code ${response.statusCode}'),
      );
    } else if (!response.isSuccess) {
      final String? err = response.error;

      return Result<T>.error(
        Exception(
          err ?? 'Request failed with status code ${response.statusCode}',
        ),
      );
    } else {
      return null;
    }
  }
}

class ApiInterceptors extends Interceptor {
  bool _isRefreshing = false;
  late Dio _tokenDio;
  Completer<void>? _refreshCompleter;

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
    final options = err.requestOptions;

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

    if (statusCode == 500 || statusCode == 502) {
      try {
        final retryResponse = await _tokenDio.fetch(options);
        return handler.resolve(retryResponse);
      } catch (_) {
        return handler.reject(err);
      }
    }

    // Handle 401 unauthorized
    if (statusCode == 401) {
      if (_isRefreshing) {
        await _refreshCompleter?.future;
        final token = await tokenStorage.getAccessToken();
        options.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';
        final retryResponse = await _tokenDio.fetch(options);
        return handler.resolve(retryResponse);
      }

      _isRefreshing = true;
      _refreshCompleter = Completer();

      try {
        final refreshToken = await tokenStorage.getRefreshToken();
        if (refreshToken == null) {
          _isRefreshing = false;
          _refreshCompleter?.complete();
          await tokenStorage.clearTokens();
          return handler.reject(err);
        }

        final response = await _tokenDio.post(
          ApiRoutes.tokenRefresh,
          data: {'refresh': refreshToken},
        );

        final newAccess = response.data['access'];
        await tokenStorage.saveTokens(newAccess, null);

        _isRefreshing = false;
        _refreshCompleter?.complete();

        options.headers[HttpHeaders.authorizationHeader] = 'Bearer $newAccess';
        final retryResponse = await _tokenDio.fetch(options);
        return handler.resolve(retryResponse);
      } catch (e) {
        _isRefreshing = false;
        _refreshCompleter?.complete();
        await tokenStorage.clearTokens();
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
