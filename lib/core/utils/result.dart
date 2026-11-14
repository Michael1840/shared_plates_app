sealed class Result<T> {
  const new();

  const factory ok(T value) = Ok<T>;

  const factory error(Exception error) = Error<T>;

  const factory castError() = CastError<T>;
}

final class Ok<T> extends Result<T> {
  const new(this.value);

  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

final class Error<T> extends Result<T> {
  const new(this.error);

  final Exception error;

  @override
  String toString() => 'Result<$T>.error($error)';
}

final class CastError<T> extends Result<T> {
  const new();

  Exception get error => const FormatException('Unexpected data');

  @override
  String toString() => 'Result<$T>.castError()';
}
