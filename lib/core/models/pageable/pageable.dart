abstract class Pageable<T> {
  /// Index of the first record for the current page.
  int get startIndex;

  /// Page size.
  int get pageSize;

  /// Items on the current page.
  List<T> get items;
}
