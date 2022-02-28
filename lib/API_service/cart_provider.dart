import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/cart_services.dart';

class CartProvider with ChangeNotifier {
  CartServices _cart = CartServices();
  int subTotal = 0;
  int cartQty = 0;
  QuerySnapshot snapshot;
  DocumentSnapshot document;
  bool cod = false;
  List cartList = [];


  Future<int> getCartTotal() async {
    var cartTotal = 0;
    List _newList = [];
    QuerySnapshot snapshot =
        await _cart.cart.doc(_cart.user.uid).collection('products').get();
    if(snapshot==null){
      return null;
    }
    snapshot.docs.forEach((doc) {
      if(!_newList.contains(doc.data())){
        _newList.add(doc.data());
        this.cartList = _newList;
        notifyListeners();
      }
      cartTotal = cartTotal + doc['total'].toInt();
    });

    this.subTotal = cartTotal;
    this.cartQty = snapshot.size;
    this.snapshot = snapshot;
    notifyListeners();

    return cartTotal;
  }

  getPaymentMethod(index){
    if(index == 0){
      this.cod = false;
      notifyListeners();
    }else{
      this.cod = true;
      notifyListeners();
    }


  }

  getShopName()async{
    DocumentSnapshot doc = await _cart.cart.doc(_cart.user.uid).get();
    if(doc.exists){
      this.document = doc;
      notifyListeners();
    }else{
      this.document=null;
      notifyListeners();
    }
}


  
}
