


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier{


  DocumentSnapshot productData;

  getProductDetails(details){
    this.productData = details;
    notifyListeners();
  }
}