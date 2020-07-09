import 'package:booklogr/services/http_service.dart';
import 'package:booklogr/models/book.dart';
import 'package:cloud_functions/cloud_functions.dart';

class BooksApiService {
  static const int maxResults = 15;
  final HttpsCallable searchCallable = CloudFunctions.instance.getHttpsCallable(
    functionName: 'runSearch',
  );

  Future<dynamic> runSearch({String query, int page}) async {
    int startIndex = (page - 1) * maxResults;
    try {
      HttpsCallableResult result = await searchCallable.call(<String, dynamic>{
        'query': query,
        'maxResults': maxResults,
        'startIndex': startIndex,
      });
      return jsonResultToBooks(result.data);
    } on CloudFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
      print(e.message);
      print(e.details);
      return null;
    } catch (e) {
      print('caught generic exception');
      print(e);
      return null;
    }
  }

  Future<Book> getBookFullDescription(Book book) async {
    HttpService httpService = HttpService(book.detailLink);
    var result = await httpService.getJsonData();
    if (result['volumeInfo']['description'] != null) {
      book.setDescription(result['volumeInfo']['description']);
      return book;
    } else {
      return null;
    }
  }

  List<Book> jsonResultToBooks(results) {
    List<Book> books = <Book>[];
    if (results['items'] != null) {
      results['items'].forEach((item) {
        if (item['volumeInfo']['imageLinks'] != null &&
            (item['volumeInfo']['authors'] != null) &&
            (item['volumeInfo']['description'] != null)) {
          books.add(Book.fromApiMap(item));
        }
      });
    }
    return books;
  }
}
