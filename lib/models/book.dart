enum ReadStatus { none, alreadyRead, currentlyReading, willRead }

class Book {
  String id;
  String title;
  String author;
  String detailLink;
  String publisher;
  String image;
  String _description;

  Book(
      {this.id,
      this.title,
      this.author,
      this.detailLink,
      this.publisher,
      this.image});

  Book.fromApiMap(Map data) {
    List<dynamic> authors = data['volumeInfo']['authors'];
    dynamic images = data['volumeInfo']['imageLinks'];
    id = data['etag'];
    title = data['volumeInfo']['title'];
    detailLink = data['selfLink'];
    publisher = data['volumeInfo']['publisher'];
    author = authors.join(", ");
    image = images['thumbnail'];
  }

  Book.fromFirestoreMap(Map data) {
    id = data['id'];
    title = data['title'];
    author = data['author'];
    publisher = data['publisher'];
    image = data['image'];
    detailLink = data['detailLink'];
  }

  void setDescription(String description) {
    _description = description;
  }

  String get description {
    return _description;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'detailLink': detailLink,
      'publisher': publisher,
      'author': author,
      'image': image,
    };
  }
}

class HaveReadBook extends Book {
  HaveReadBook.fromFirestoreMap(data) : super.fromFirestoreMap(data);
}

class ReadingBook extends Book {
  ReadingBook.fromFirestoreMap(data) : super.fromFirestoreMap(data);
}

class WillReadBook extends Book {
  WillReadBook.fromFirestoreMap(data) : super.fromFirestoreMap(data);
}
