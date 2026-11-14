import 'package:equatable/equatable.dart';

class Feed<T> extends Equatable {
  const new(this.value, {required this.fetchedAt, this.isStale = false});

  final T value;
  final DateTime fetchedAt;
  final bool isStale;

  Feed<T> copyWithValue(T next) =>
      Feed(next, fetchedAt: fetchedAt, isStale: isStale);

  @override
  List<Object?> get props => [value, fetchedAt, isStale];
}
