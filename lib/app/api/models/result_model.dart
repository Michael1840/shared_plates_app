sealed class Result<T> {
  const Result();

  /// Creates a successful [Result], completed with the specified [value].
  const factory Result.ok(T value) = Ok._;

  /// Creates an error [Result], completed with the specified [error].
  const factory Result.error(Exception error) = Error._;

  // /// Creates an network error [Result], completed with a generic [network error].
  // const factory Result.networkError() = NetworkError._;

  /// Creates an cast error [Result], completed with a generic [casting error].
  const factory Result.castError() = CastError._;
}

/// Subclass of Result for values
final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  /// Returned value in result
  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

/// Subclass of Result for errors
final class Error<T> extends Result<T> {
  const Error._(this.error);

  /// Returned error in result
  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}

// /// Subclass of Result for errors
// final class NetworkError<T> extends Result<T> {
//   const NetworkError._();

//   Exception get error =>
//       Exception('Failed to reach database, connection interrupted.');

//   @override
//   String toString() => 'Result<$T>.error($error)';
// }

/// Subclass of Result for errors
final class CastError<T> extends Result<T> {
  const CastError._();

  Exception get error =>
      Exception('Data type is not accepted, failed to cast.');

  @override
  String toString() => 'Result<$T>.error($error)';
}
