import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('notes');

class Database {
  static String? userUid;

  static Future<void> addItem({required String title, required String description}) async {
    DocumentReference documentReferencer = _mainCollection.doc(userUid).collection('items').doc();
    Map<String, dynamic> data = <String, dynamic>{
      'title': title,
      'description': description,
    };
    await documentReferencer
    .set(data)
    .whenComplete(() => print('Notes item added to Database'))
    .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection = _mainCollection.doc(userUid).collection('items');
    return notesItemCollection.snapshots();
  }

  static Future<void> updateItem({required String title, required String description, required String docId}) async {
    DocumentReference documentReferencer = _mainCollection.doc(userUid).collection('items').doc(docId);
    Map<String, dynamic> data = <String, dynamic>{
      'title': title,
      'description': description,
    };

    await documentReferencer
    .update(data)
    .whenComplete(() => print('Note item updated in Database'))
    .catchError((e) => print(e));
  }

  static Future<void> deleteItem({required String docId}) async{
    DocumentReference documentReferencer = _mainCollection.doc(userUid).collection('items').doc(docId);
    await documentReferencer
    .delete()
    .whenComplete(() => print('Note item deleted from Database'))
    .catchError((e) => print(e));
  }

}