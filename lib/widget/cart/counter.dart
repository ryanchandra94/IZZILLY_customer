import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:izzilly_customer/API_service/cart_services.dart';
import 'package:intl/intl.dart';




class CounterForCard extends StatefulWidget {
  final DocumentSnapshot document;
  CounterForCard(this.document);

  @override
  State<CounterForCard> createState() => _CounterForCardState();
}

class _CounterForCardState extends State<CounterForCard> {
  User user = FirebaseAuth.instance.currentUser;
  bool _exists = false;
  bool _updating = false;
  CartServices _cart = CartServices();
  String docId;



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

  getCartData() {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('products')
        .where('productId', isEqualTo: widget.document['productId'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
              if (querySnapshot.docs.isNotEmpty)
                {
                  querySnapshot.docs.forEach((doc) {
                    if (doc['productId'] == widget.document['productId']) {
                      if (!mounted) return;
                      if (mounted) {
                        setState(() {
                          _exists = true;
                          docId = doc.id;
                        });
                      }
                    }
                  })
                }
              else
                {
                  if (mounted)
                    {
                      setState(() {
                        _exists = false;
                      })
                    }
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return _exists
        ? StreamBuilder(
            stream: getCartData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return Container(
                height: 28,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        _cart.removeFromCart(docId).then((value) {
                          setState(() {
                            if (!mounted) return;
                            if (mounted) {
                              _exists = false;
                            }
                          });
                        });
                        _cart.checkData();
                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: Center(
                            child: _updating
                                ? CircularProgressIndicator()
                                : Icon(CupertinoIcons.delete, color: Colors.blue, size: 30,),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )
        : StreamBuilder(
            stream: getCartData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return Container(
                height: 28,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(4)),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _updating = true;
                        });
                        _selectDate(context).then((date){
                          EasyLoading.show(status: 'Adding to Cart');
                          _cart.checkSeller().then((shopName) {

                            if(shopName==null){
                              if(mounted){
                                _exists=true;
                              }
                              _cart.addToCart(widget.document, date).then((value) {
                                if (mounted) {
                                  setState(() {
                                    _exists = true;
                                    _updating = false;
                                  });
                                }
                                EasyLoading.showSuccess('Added Successfully');
                              });
                              return;
                            }

                            if(shopName==widget.document['seller']['shopName']){
                              if(mounted){
                                _exists=true;
                              }
                              _cart.addToCart(widget.document, date).then((value) {
                                if (mounted) {
                                  setState(() {
                                    _exists = true;
                                    _updating = false;
                                  });
                                }
                                EasyLoading.showSuccess('Added Successfully');
                              });
                              return;
                            }else{
                              EasyLoading.showInfo('Please checkout previous vendor product');

                              if(mounted){
                                _updating = false;
                              }

                            }

                          });

                        });

                      },
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: Center(
                              child: _updating
                                  ? CircularProgressIndicator()
                                  : Icon(CupertinoIcons.cart_fill, color: Colors.blue, size: 30,)
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }

  /*showDialog(shopName) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Replace Cart item?'),
            content: Text(
                'Your cart contains items from $shopName. Do you want to discard the selection and add items from ${widget.document['seller']['shopName']}'),
            actions: [
              FlatButton(
                  onPressed: (){
                    _cart.deleteCart().then((value) {
                      _cart.addToCart(widget.document).then((value) {
                        if(mounted){
                          setState(() {
                            _exists = true;
                          });
                          Navigator.pop(context);
                        }
                      });
                    });



                  },
                  child: Text('Yes')),
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('No')),
            ],
          );
        });
  }*/
}
