import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

const db = admin.firestore();
const lists = ['HaveReadBooks', 'ReadingBooks', 'WillReadBooks'];

export const createUserRecord = functions.auth
  .user()
  .onCreate((user, context) => {

    const userRef = db.doc(`users/${user.uid}`);

    return userRef.set({
      name: user.displayName,
      email: user.email,
      createdAt: context.timestamp
    });
  });


export const createUserLists = functions.auth
  .user()
  .onCreate(async (user, context) => {

    let autoID;
    let listRef;

    for (let index in lists) {
      autoID = db.collection(`lists`).doc().id;
      listRef = db.doc(`lists/${autoID}`);
      await listRef.set({
        userId: user.uid,
        books: [],
        listType: lists[index],
      });
    }
    return true;
  });
