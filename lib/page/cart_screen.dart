import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:izzilly_customer/API_service/cart_provider.dart';
import 'package:izzilly_customer/API_service/cart_services.dart';
import 'package:izzilly_customer/API_service/order_service.dart';
import 'package:izzilly_customer/API_service/register_customer.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/API_service/user_service.dart';
import 'package:izzilly_customer/page/payment/payment-home.dart';
import 'package:izzilly_customer/page/profile_screen.dart';
import 'package:izzilly_customer/provider/coupon_provider.dart';
import 'package:izzilly_customer/provider/order_provider.dart';
import 'package:izzilly_customer/widget/cart/cart_list.dart';
import 'package:izzilly_customer/widget/cart/cod_toggle.dart';
import 'package:izzilly_customer/widget/cart/coupon_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'cart-screen';
  final DocumentSnapshot document;
  CartScreen({this.document});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var textStyle = TextStyle(color: Colors.grey);
  double discount = 0;

  UserServices _userService = UserServices();
  StoreProvider _store = StoreProvider();
  User user = FirebaseAuth.instance.currentUser;
  bool _checkingUser = false;
  OrderServices _orderServices = OrderServices();
  DocumentSnapshot doc;
  CartServices _cartServices = CartServices();



  @override
  void initState() {
    _store.getShopDetails(widget.document['sellerUid']).then((value) {
      if(mounted){
        setState(() {
          doc = value;

        });
      }
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    var _cartProvider = Provider.of<CartProvider>(context);

    var userDetails = Provider.of<AuthProvider>(context);
    var _coupon = Provider.of<CouponProvider>(context);
    userDetails.getUserDetails().then((value){
      double subtotal = double.parse(_cartProvider.subTotal.toString());
      double discountRate = _coupon.discountRate/100;
      if(mounted){
        setState(() {
          discount = subtotal*discountRate;
        });
      }
    });


    var _payable = _cartProvider.subTotal - discount;
    final orderProvider = Provider.of<OrderProvider>(context);
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.grey[200],
          bottomSheet: userDetails.snapshot == null ? Container() : Container(
            height: 50,
            color: Colors.lightBlueAccent,
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Total : \$${_cartProvider.subTotal}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ],
                        ),
                        RaisedButton(
                            child: _checkingUser ? CircularProgressIndicator() :  Text(
                              'CHECKOUT',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            color: Colors.blueAccent,
                            onPressed: () {
                              if(mounted){
                                setState(() {
                                  _checkingUser = true;
                                });
                              }
                              _userService.getUserById(user.uid).then((value) => {
                                if(value['name']==null){
                                  if(mounted){
                                    setState(() {
                                  _checkingUser = true;
                                })
                                  },
                                pushNewScreenWithRouteSettings(
                                context,
                                settings: RouteSettings(name: ProfileScreen.id),
                                screen: ProfileScreen(),
                                withNavBar: true,
                                pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                              )
                                }else{
                                  /////confirm payment method (cash or online payment)
                                  if(_cartProvider.cod==false){
                                    //pay online
                                    orderProvider.totalAmount(
                                        _payable, widget.document['shopName'],
                                        userDetails.snapshot['mobile'], userDetails.snapshot['email']
                                    ),
                                    Navigator.pushNamed(context, PaymentHome.id).whenComplete(() {
                                      if(orderProvider.success==true){
                                        _saveOrder(_cartProvider,_payable,_coupon, orderProvider);
                                      }
                                    })
                                  }else{
                                    _saveOrder(_cartProvider, _payable, _coupon, orderProvider),
                                  }
                                  

                                }
                              });
                            })
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBozIsSxrolled) {
                return [
                  SliverAppBar(
                    backgroundColor: Colors.lightBlueAccent,
                      floating: true,
                      snap: true,
                      elevation: 0.0,
                      title: Center(
                        child: Text(
                          'Shopping Cart',
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    actions: [
                      IconButton(
                        icon: Icon(CupertinoIcons.add, color: Colors.lightBlueAccent,),
                      )
                    ],
                  ),
                ];
              },
              body: SafeArea(
                child: doc==null ? Center(child: CircularProgressIndicator()) : _cartProvider.cartQty > 0 ? SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 80),
                  child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        //CodToggleSwitch(),
                        Divider(color: Colors.grey[300],),
                        CartList(
                          document: widget.document,
                        ),

                        // coupon
                        if(doc.data()!=null)
                        CouponWidget(doc['uid']),

                        // bill detail card
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 4, left: 4, top: 4, bottom: 100),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Bill Details',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          'Cart Value',
                                          style: textStyle,
                                        )),
                                        Text(
                                          '\$ ${_cartProvider.subTotal.toStringAsFixed(0)}',
                                          style: textStyle,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if(discount>0)
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          'Discount',
                                          style: textStyle,
                                        )),
                                        Text(
                                          '\$ $discount',
                                          style: textStyle,
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      color: Colors.grey,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          'Total Amount',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                        Text(
                                          '\$ ${_payable.toStringAsFixed(0)}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'Total Saving',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ),
                                            Text(
                                              '\$ $discount',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ) : Container()
              ))),
    );
  }

  _saveOrder(CartProvider cartProvider, payable, CouponProvider coupon, OrderProvider orderProvider){
    _orderServices.saveOrder({
      'products' : cartProvider.cartList,
      'userId' : user.uid,
      'total' : payable,
      'discount' : discount.toStringAsFixed(0),
      'discountCode' : coupon.document==null? null : coupon.document['title'],
      'cod' : "Pay Online",
      'seller':{
        'shopName' : widget.document['shopName'],
        'sellerId' : widget.document['sellerUid'],
      },
      'timestamp' : DateTime.now().toString(),
      'orderStatus' : 'Ordered',
    }).then((value) {
      orderProvider.success=false;
        _cartServices.deleteCart().then((value) {
          _cartServices.checkData().then((value) {
            EasyLoading.showSuccess('Your order is submitted');
            Navigator.pop(context);
          });
        });
    });

  }
}
