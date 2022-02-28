import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';


class CartServices{
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  User user = FirebaseAuth.instance.currentUser;

  Future<void>addToCart(document, date){
    cart.doc(user.uid).set({
      'user' : user.uid,
      'sellerUid' : document['seller']['selleruid'],
      'shopName' : document['seller']['shopName']
    });
     return cart.doc(user.uid).collection('products').add({
      'productId' : document['productId'],
      'productName' : document['productName'],
      'productImage' : document['productImage'],
      'price' : document['price'],
      'comparedPrice' : document['comparedPrice'],
      'qty' : 1,
      'sellerUid' : document['seller']['selleruid'],
      'shopName' : document['seller']['shopName'],
      'total' : document['price'],
       'schedule' : date,
    });


  }


  Future<void> removeFromCart(docId)async{
    cart.doc(user.uid).collection('products').doc(docId).delete();

  }

  Future<void>checkData()async{
    final snapshot = await cart.doc(user.uid).collection('products').get();
    if(snapshot.docs.length == 0){
      cart.doc(user.uid).delete();
    }
  }

  Future<void>deleteCart()async{
    final result = await cart.doc(user.uid).collection('products').get().then((snapshot) {
      for(DocumentSnapshot ds in snapshot.docs){
        ds.reference.delete();
      }
    });
  }

  Future<String>checkSeller()async{
    final snapshot = await cart.doc(user.uid).get();
    return snapshot.exists ? snapshot['shopName'] : null;
  }

  Future<DocumentSnapshot> getCartItem()async{
    DocumentSnapshot doc = await cart.doc(user.uid).get();
    return doc;
  }
}