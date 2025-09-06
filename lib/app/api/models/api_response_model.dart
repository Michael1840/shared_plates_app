class ApiResponseModel<T> {
  final int? statusCode;
  final T? data;
  final String? message;
  final String? error;

  const ApiResponseModel({
    required this.statusCode,
    this.data,
    this.message,
    this.error,
  });

  bool get isSuccess =>
      statusCode != null && (statusCode! >= 200 && statusCode! < 300);
}
