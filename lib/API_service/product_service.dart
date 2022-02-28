import 'package:cloud_firestore/cloud_firestore.dart';

class ProductServices{
  CollectionReference category = FirebaseFirestore.instance.collection('category');

  CollectionReference products = FirebaseFirestore.instance.collection('products');
  CollectionReference favorite = FirebaseFirestore.instance.collection('favourites');


  Future<DocumentSnapshot> getProductDetail(id) async{
    DocumentSnapshot doc = await products.doc(id).get();
    return doc;
  }
}