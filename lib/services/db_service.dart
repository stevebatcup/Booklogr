import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:booklogr/models/globals.dart';
import 'package:booklogr/models/book.dart';

class BooksCollection<T> {
  final Firestore _db = Firestore.instance;
  final String userId;
  String listType;
  Query ref;

  BooksCollection({this.userId}) {
    ref = _db
        .collection("lists")
        .where('userId', isEqualTo: this.userId)
        .where('listType', isEqualTo: listName());
  }

  String listName() {
    return '${T.toString()}s';
  }

  Future<bool> bookIsPresent(Book book) async {
    QuerySnapshot snap =
        await ref.where('books', arrayContains: book.toJson()).getDocuments();
    return snap.documents.isNotEmpty;
  }

  Future<void> addBook(Book book) async {
    QuerySnapshot snap = await ref.getDocuments();
    _db
        .collection('lists')
        .document(snap.documents.single.documentID)
        .updateData({
      'books': FieldValue.arrayUnion([book.toJson()])
    });
  }

  Future<void> deleteBook(Book book) async {
    QuerySnapshot snap = await ref.getDocuments();
    _db
        .collection('lists')
        .document(snap.documents.single.documentID)
        .updateData({
      'books': FieldValue.arrayRemove([book.toJson()])
    });
  }

  Stream<List<T>> streamData() {
    return ref.snapshots().map((snap) {
      List<T> bookList = [];
      snap.documents.forEach((doc) {
        List booksData = doc.data['books'];
        booksData.forEach((bookData) {
          bookList.add(Global.models[T](bookData) as T);
        });
      });
      return bookList;
    });
  }
}
