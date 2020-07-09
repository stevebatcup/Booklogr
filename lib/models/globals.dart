import 'package:booklogr/models/book.dart';

/// Static global state. Immutable services that do not care about build context.
class Global {
  // Data Models
  static final Map models = {
    HaveReadBook: (data) => HaveReadBook.fromFirestoreMap(data),
    ReadingBook: (data) => ReadingBook.fromFirestoreMap(data),
    WillReadBook: (data) => WillReadBook.fromFirestoreMap(data),
  };
}
