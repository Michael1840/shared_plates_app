import 'package:equatable/equatable.dart';

class DelayedResult<T> extends Equatable {
  const DelayedResult.fromValue(T result)
    : value = result,
      error = null,
      isInProgress = false;

  const DelayedResult.fromError(String err)
    : value = null,
      error = err,
      isInProgress = false;

  const DelayedResult.inProgress()
    : value = null,
      error = null,
      isInProgress = true;

  const DelayedResult.idle() : value = null, error = null, isInProgress = false;

  final T? value;
  final String? error;
  final bool isInProgress;

  bool get isSuccessful => value != null;

  bool get isError => error != null;

  bool get isIdle => value == null && error == null && !isInProgress;

  @override
  List<Object?> get props => [value, error, isInProgress];
}
