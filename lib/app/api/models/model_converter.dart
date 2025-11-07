abstract class ModelConverter<T> {
  T fromJson(Map<String, dynamic> json);

  List<T> fromList(Iterable jsonList) =>
      jsonList.map((e) => fromJson(e as Map<String, dynamic>)).toList();
}
