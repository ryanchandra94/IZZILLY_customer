import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:izzilly_customer/API_service/cart_services.dart';
import 'package:izzilly_customer/widget/cart/counter_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';


class AddToCartWidget extends StatefulWidget {
  final DocumentSnapshot document;
  AddToCartWidget(this.document);
  @override
  _AddToCartWidgetState createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  CartServices _cart = CartServices();
  User user = FirebaseAuth.instance.currentUser;
  bool _loading = true;
  bool _exist = false;
  int _qty;
  String _docId;


  Future<String> _selectDate(context) async {
    DateTime _selectedDate = DateTime.now();
    String dateText;

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );
    if (picked != null && picked != _selectedDate) {
      if (mounted) {
        setState(() {
          _selectedDate = picked;
          String formattedText = DateFormat('yyyy-MM-dd').format(_selectedDate);
          dateText = formattedText;
        });
      }
    }

    return dateText != null ? dateText : null;
  }


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
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('products')
        .where('productId', isEqualTo: widget.document['productId'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            if(doc['productId'] == widget.document['productId']){
              if(!mounted)return;
              if(mounted){
                setState(() {
                  _exist = true;
                  _qty = doc['qty'];
                  _docId = doc.id;
                });
              }

            }
          })
    });

    return _loading
        ? Container(
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor),
              ),
            ),
          ) : _exist ? CounterWidget(document: widget.document, docId: _docId,)
        : InkWell(
            onTap: () {
              _selectDate(context).then((date) {
                EasyLoading.show(status: 'Adding to Cart');
                _cart.addToCart(widget.document, date).then((value) {
                  if(mounted){
                    setState(() {
                      _exist = true;
                    });
                  }
                  EasyLoading.showSuccess('Added Successfully');
                });
              });
            },
            child: IconButton(
              iconSize: 30.0,
              icon: Icon(CupertinoIcons.cart_fill, color: Colors.lightBlueAccent,),)
          );
  }
}
