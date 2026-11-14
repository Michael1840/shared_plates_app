Stream<T> reloadOn<T>(Stream<Object?> triggers, Future<T> Function() load) {
  Stream<Object?> ticks() async* {
    yield null;
    yield* triggers;
  }

  return ticks().asyncMap((_) => load());
}
