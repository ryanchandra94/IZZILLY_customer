


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService{
  CollectionReference favorite = FirebaseFirestore.instance.collection('favourites');
  User user = FirebaseAuth.instance.currentUser;


  Future<void> removeFavorite(docId)async{
    FirebaseFirestore.instance.collection('favourites').doc(docId).delete();

  }
}