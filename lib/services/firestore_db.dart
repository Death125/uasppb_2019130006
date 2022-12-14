import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uasppb_2019130006/model/product_model.dart';

class FirestoreDB {
  //Initialize Firebase Cloud FireStore
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Stream<List<Product>> getAllProducts() {
    return _firebaseFirestore
        .collection('product')
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }
}
