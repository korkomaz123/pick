import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseRepository {
  final _firestoreClient = FirebaseFirestore.instance;
  final _firestorageClient = FirebaseStorage.instance;

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<dynamic> uploadMedia(File file, String path) async {
    final UploadTask uploadTask =
        _firestorageClient.ref().child(path).putFile(file);

    final taskSnapshot = await uploadTask.whenComplete(() {});
    return taskSnapshot.ref.getDownloadURL();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<void> deleteMedia(String url) async {
    final Reference storageRef = _firestorageClient.refFromURL(url);
    await storageRef.delete();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<DocumentReference> addToCollection(
    Map<String, dynamic> data,
    String path,
  ) async {
    final CollectionReference colRef = _firestoreClient.collection(path);
    return colRef.add(data);
  }

  // To verify is docId with username is present.
  // @path: should be col with document id which we wants.
  Future<bool> isDocExist(String path, String docId) async {
    final doc = await _firestoreClient.collection(path).doc(docId).get();
    return doc.exists;
  }

  // To set document data to document
  // @path : should be document level only
  Future<void> setDoc(String path, Map<String, dynamic> data) async {
    return _firestoreClient.doc(path).set(data);
  }

  /// To update document
  /// @params: [path]: must be collection level
  /// @params: [docId]: must be exist documentID
  /// @params: [data]: must be map data
  /// @return: updated document
  Future<dynamic> updateDoc(
    String path,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await _firestoreClient.collection(path).doc(docId).update(data);
    return (await loadDoc('$path/$docId')).data;
  }

  // To to remove specific doc from collection
  // @path : should be doc level only
  Future<void> removeDoc(String path) async {
    return _firestoreClient.doc(path).delete();
  }

  // To load single document from specific col with docId
  // @path: should be document level only
  Future<DocumentSnapshot> loadDoc(String path) {
    final DocumentReference docRef = _firestoreClient.doc(path);
    return docRef.get();
  }

  // To check exist same value on document
  // @path: should be collectioin level only
  Future<bool> checkDocByKey(String path, String key, dynamic value) async {
    final querySnap = await _firestoreClient
        .collection(path)
        .where(key, isEqualTo: value)
        .get();
    return querySnap.docs.isNotEmpty;
  }

  // load stream collection base on provided search criteria
  Stream<QuerySnapshot> loadCollectionStream({
    String? path,
    String? searchKey,
    String? searchValue,
    String? searchArrayKey,
    String? searchArrayValue,
    bool? noOrdered,
  }) {
    final CollectionReference colRef = _firestoreClient.collection(path!);
    if (searchKey != null && searchValue != null) {
      if (noOrdered != null && !!noOrdered) {
        return colRef.where(searchKey, isEqualTo: searchValue).snapshots();
      } else {
        return colRef
            .orderBy('createdAt', descending: true)
            .where(searchKey, isEqualTo: searchValue)
            .snapshots();
      }
    } else if (searchArrayKey != null && searchArrayValue != null) {
      return colRef
          .orderBy('createdAt', descending: true)
          .where(searchArrayKey, arrayContains: searchArrayValue)
          .snapshots();
    } else if (noOrdered != null && !!noOrdered) {
      return colRef.snapshots();
    }
    return colRef.orderBy('createdAt', descending: true).snapshots();
  }

  /// load stream collection base on modern search criteria
  /// search params format:
  /// type: List of Map<String, dynamic>
  /// key: field name, opt: the operator for query, value: expected value for search
  /// If you want to ignore search params, just set value to []
  Stream<QuerySnapshot> loadCollectionStreamCustom([
    String? path,
    List<Map<String, dynamic>>? conditions,
    List<Map<String, dynamic>>? orders,
  ]) {
    final CollectionReference colRef = _firestoreClient.collection(path!);
    Query query = colRef;
    if (conditions!.isNotEmpty) {
      for (var i = 0; i < conditions.length; i++) {
        query = queryWhere(query, conditions[i]);
      }
    }
    if (orders!.isNotEmpty) {
      for (var i = 0; i < orders.length; i++) {
        query = query.orderBy(
          orders[i]['field'],
          descending: orders[i]['descending'] as bool,
        );
      }
    }
    return query.snapshots();
  }

  /// To get query with where
  /// @params: [query]: must be collection reference or query
  /// @params: [condition]: Map data, [key]: document field, [opt]: operator, [value]: filter value
  Query queryWhere(
    Query query,
    Map<String, dynamic> condition,
  ) {
    switch (condition['opt'] as String) {
      case '==':
        return query.where(
          condition['key'],
          isEqualTo: condition['value'],
        );
      case '<':
        return query.where(
          condition['key'],
          isLessThan: condition['value'],
        );
      case '<=':
        return query.where(
          condition['key'],
          isLessThanOrEqualTo: condition['value'],
        );
      case '>':
        return query.where(
          condition['key'],
          isGreaterThan: condition['value'],
        );
      case '>=':
        return query.where(
          condition['key'],
          isGreaterThanOrEqualTo: condition['value'],
        );
      case 'in':
        return query.where(
          condition['key'],
          arrayContains: condition['value'],
        );
      case 'isNull':
        return query.where(condition['key'], isNull: true);
      case 'isNotNull':
        return query.where(condition['key'], isNull: false);
      case 'contains':
        return query.where(
          condition['key'],
          arrayContains: condition['value'],
        );
      default:
        return query.where(
          condition['key'],
          isEqualTo: condition['value'],
        );
    }
  }

  // To load multiple document from collection base on query
  // @path: should be col level only
  Future<QuerySnapshot> loadCollection(String path) {
    final colRef = _firestoreClient.collection(path);
    return colRef.get();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Future<QuerySnapshot> loadCollectionCustom([
    String? path,
    List<Map<String, dynamic>>? wheres,
    List<Map<String, dynamic>>? orders,
  ]) {
    final CollectionReference colRef = _firestoreClient.collection(path!);
    Query query = colRef;
    if (wheres != null) {
      for (var i = 0; i < wheres.length; i++) {
        query = queryWhere(query, wheres[i]);
      }
    }
    if (orders != null) {
      for (var i = 0; i < orders.length; i++) {
        query = query.orderBy(
          orders[i]['field'],
          descending: orders[i]['descending'] as bool,
        );
      }
    }
    return query.get();
  }

  //////////////////////////////////////////////////////////////////////////////
  ///
  //////////////////////////////////////////////////////////////////////////////
  Stream<Map<String, dynamic>> loadDocStream(String path) {
    final docRef = _firestoreClient.doc(path);
    return docRef.snapshots().asyncMap((doc) => doc.data()!);
  }

  /// method [loadCollectionPaginate]
  /// @params
  ///   [path]: the path of specified collection, must be collection level
  ///   [wheres]: where query [optional]
  ///   [orders]: orderby query [optional]
  ///   [lastDoc]: the last document of previous query [optional]
  ///   [length]: the number of limit length
  /// @return QuerySnapshot
  ///
  Future<QuerySnapshot> loadCollectionPaginate([
    String? path,
    List<Map<String, dynamic>>? wheres,
    List<Map<String, dynamic>>? orders,
    DocumentSnapshot? lastDoc,
    int? length,
  ]) {
    final CollectionReference colRef = _firestoreClient.collection(path!);
    Query query = colRef;

    /// [where] query
    if (wheres != null) {
      for (var i = 0; i < wheres.length; i++) {
        query = queryWhere(query, wheres[i]);
      }
    }

    /// [orderby] query
    if (orders != null) {
      for (var i = 0; i < orders.length; i++) {
        query = query.orderBy(
          orders[i]['field'],
          descending: orders[i]['descending'],
        );
      }
    }

    /// [startAfterDocument] set the start position of documents
    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    /// [limit] specified number of documents
    if (length != null) {
      query = query.limit(length);
    }
    return query.get();
  }
}
