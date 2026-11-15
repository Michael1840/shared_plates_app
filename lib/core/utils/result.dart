sealed class Result<T> {
  const Result();

  const factory Result.ok(T value) = Ok<T>;

  const factory Result.error(Exception error) = Error<T>;

  const factory Result.castError() = CastError<T>;
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);

  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

final class Error<T> extends Result<T> {
  const Error(this.error);

  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}

final class CastError<T> extends Result<T> {
  const CastError();

  Exception get error => const FormatException('Unexpected data');

  @override
  String toString() => 'Result<$T>.castError()';
}
