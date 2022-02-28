import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class CouponProvider with ChangeNotifier {


  bool expired;
  DocumentSnapshot document;
  int discountRate = 0;

   getCouponDetails(title, sellerId) async {
    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('coupons').doc(title).get();

    if(document.exists){
      if(document['sellerId']==sellerId){
        checkExpiry(document);
        this.document = document;
        notifyListeners();
      }else{
        this.document = null;
        notifyListeners();
      }
    }else{
      this.document = null;
      notifyListeners();
    }

  }


  checkExpiry(DocumentSnapshot document){
    DateTime date = document['Expiry'].toDate();
    var dateDiff = date.difference(DateTime.now()).inDays;
    if(dateDiff<0){
      this.expired=true;
      notifyListeners();
    }else{
      this.document = document;
      this.expired = false;
      this.discountRate = document['discountRate'];
      notifyListeners();
    }
  }
}
