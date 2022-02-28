import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';


class OrderProvider with ChangeNotifier{


  String status;
  String amount;
  bool success = false;
  String shopName;
  String phoneNumber;
  String email;

  filterOrder(status){
    this.status=status;
    notifyListeners();
  }


  totalAmount(amount, shopName, phone, email){
      this.amount = amount.toStringAsFixed(0);
      this.shopName = shopName;
      this.phoneNumber = phone;
      this.email = email;
      notifyListeners();
  }

  paymentStatus(success){
    this.success = success;
    notifyListeners();
  }
}