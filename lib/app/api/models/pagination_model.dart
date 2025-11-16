// ignore_for_file: public_member_api_docs, sort_constructors_first
class PaginationModel<T> {
  final String? nextUrl;
  final String? previousUrl;
  final List<T> items;

  const PaginationModel({this.nextUrl, this.previousUrl, required this.items});

  PaginationModel<T> copyWith({
    String? nextUrl,
    String? previousUrl,
    List<T>? items,
  }) {
    return PaginationModel<T>(
      nextUrl: nextUrl ?? this.nextUrl,
      previousUrl: previousUrl ?? this.previousUrl,
      items: items ?? this.items,
    );
  }
}
