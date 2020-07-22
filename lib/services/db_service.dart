import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:booklogr/models/globals.dart';
import 'package:booklogr/models/book.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

class BooksCollection<T> {
  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String listType;
  Query ref;

  Future<void> initUserCollection(FirebaseUser user) async {
    ref = _db
        .collection("lists")
        .where('userId', isEqualTo: user.uid)
        .where('listType', isEqualTo: listName());
  }

  String listName() {
    return '${T.toString()}s';
  }

  Future<bool> bookIsPresent(Book book) async {
    if (ref != null) {
      QuerySnapshot snap =
          await ref.where('books', arrayContains: book.toJson()).getDocuments();
      return snap.documents.isNotEmpty;
    } else {
      return false;
    }
  }

  Future<void> addBook(Book book) async {
    if (ref != null) {
      QuerySnapshot snap = await ref.getDocuments();
      _db
          .collection('lists')
          .document(snap.documents.single.documentID)
          .updateData({
        'books': FieldValue.arrayUnion([book.toJson()])
      });
    }
  }

  Future<void> deleteBook(Book book) async {
    if (ref != null) {
      QuerySnapshot snap = await ref.getDocuments();
      _db
          .collection('lists')
          .document(snap.documents.single.documentID)
          .updateData({
        'books': FieldValue.arrayRemove([book.toJson()])
      });
    }
  }

  Stream<List<T>> streamData() {
    return _auth.onAuthStateChanged.switchMap(
      (user) {
        if (user != null) {
          initUserCollection(user);
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
        } else {
          return Stream<List<T>>.value(null);
        }
      },
    );
  }
}
