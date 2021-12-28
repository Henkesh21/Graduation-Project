import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  DatabaseService({this.path}) {
    ref = _db.collection(path);
  }

  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }

  Future<void> updateDocument(Map data, String id) {
    return ref.document(id).setData(data);
  }

  Future<void> deleteDocument(String id) {
    return ref.document(id).delete();
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments();
  }

  Future<QuerySnapshot> getDocumentsWithCondition(String field, String val) {
    return ref.where(field, isEqualTo: val).getDocuments();
  }

  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots();
  }

  Stream<QuerySnapshot> streamDataCollectionWithCondition(
      String field, String val) {
    return ref.where(field, isEqualTo: val).snapshots();
  }

  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }
}
