import 'package:equatable/equatable.dart';

// implements the segmented state pattern
class DelayedResult<T> extends Equatable {
  final T? value;
  final String? error;
  final bool isInProgress;

  const DelayedResult.fromError(String err)
      : value = null,
        error = err,
        isInProgress = false;

  // don't change to const
  DelayedResult.fromValue(T result)
      : value = result,
        error = null,
        isInProgress = false;

  const DelayedResult.inProgress()
      : value = null,
        error = null,
        isInProgress = true;

  const DelayedResult.idle()
      : value = null,
        error = null,
        isInProgress = false;

  bool get isSuccessful => value != null;

  bool get isError => error != null;

  bool get isIdle => value == null && error == null && !isInProgress;

  @override
  List<Object?> get props => [
        value,
        error,
        isInProgress,
      ];
}
