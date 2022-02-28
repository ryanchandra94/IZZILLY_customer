import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/cart_services.dart';
import 'package:izzilly_customer/widget/product/add_to_cart_widget.dart';


class CounterWidget extends StatefulWidget {

  final DocumentSnapshot document;
  final String docId;

  CounterWidget({this.document, this.docId});
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {

  CartServices _cart = CartServices();
  bool _loading = false;
  bool _exists = true;
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    getCartData();
    super.initState();
  }

  getCartData() async {
    final snapshot =
    await _cart.cart.doc(user.uid).collection('products').get();
    if (snapshot.docs.length == 0) {
      setState(() {
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return _exists ? InkWell(
      onTap: () {
        _cart.removeFromCart(widget.docId).then((value) {
          setState(() {
            if (!mounted) return;
            if(mounted){
              _exists = false;
            }
          });
        });
        _cart.checkData();
      },
      child: Container(
        height: 56,

        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete, color: Colors.lightBlueAccent),

                ],
              ),
            )),
      ),
    ) : AddToCartWidget(widget.document);
  }
}
