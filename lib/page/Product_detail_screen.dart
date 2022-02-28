import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/API_service/user_service.dart';
import 'package:izzilly_customer/chat/chat_screens.dart';
import 'package:izzilly_customer/provider/product_provider.dart';
import 'package:izzilly_customer/widget/googel_map_vendor.dart';
import 'package:izzilly_customer/widget/product/add_to_cart_widget.dart';
import 'package:izzilly_customer/widget/product/bottom_sheet_container.dart';
import 'package:izzilly_customer/widget/product/save_favourite.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String id = 'product-detail-screen';
  final DocumentSnapshot document;
  ProductDetailScreen({this.document});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  User user = FirebaseAuth.instance.currentUser;
  UserServices _services = UserServices();
  final _format = NumberFormat('##,##,##0');
  StoreProvider _store = StoreProvider();

  DocumentSnapshot doc;
  bool _loading = true;
  var _price;
  var _compared;
  String _formattedComparedPrice;
  String _formattedPrice;

  @override
  void initState() {
    _store.getShopDetails(widget.document['seller']['selleruid']).then((value) {
      if (mounted) {
        setState(() {
          doc = value;
          _price = int.parse(widget.document['price'].toStringAsFixed(0));
          _formattedPrice = '${_format.format(_price)}';

          _compared = int.parse(widget.document['comparedPrice']);
          _formattedComparedPrice = '${_format.format(_compared)}';
        });
      }
    });
    Timer(Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    });
    super.initState();
  }

  _callSeller(number) {
    launch(number);
  }

  createChatRoom(doc, ProductProvider _provider) {
    Map<String, dynamic> product = {
      'productId': _provider.productData.id,
      'productImage': _provider.productData['productImage'],
      'price': _provider.productData['price'],
      'title': _provider.productData['productName'],
    };

    List<String> users = [
      doc['uid'], // vendor
      user.uid, //user
    ];

    String chatRoomId = '${doc['uid']}.${user.uid}.${_provider.productData.id}';

    Map<String, dynamic> chatData = {
      'users': users,
      'chatRoomId': chatRoomId,
      'vendor': doc['uid'],
      'user': user.uid,
      'user_read': false,
      'vendor_read': false,
      'product': product,
      'lastChat': null,
      'lastChatTime': DateTime.now().microsecondsSinceEpoch
    };

    _services.createChatRoom(
      chatData: chatData,
    );

    pushNewScreenWithRouteSettings(
      context,
      settings: RouteSettings(name: ChatScreen.id),
      screen: ChatScreen(
        chatRoomId: chatRoomId,
        doc: doc,
      ),
      withNavBar: true,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  @override
  Widget build(BuildContext context) {

    String offer = (((double.parse(widget.document['comparedPrice']) -
                    widget.document['price']) /
                double.parse(widget.document['comparedPrice'])) *
            100)
        .toStringAsFixed(0);
    var _productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Center(child: Text('Product Details')),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.search),
            onPressed: () {},
          )
        ],
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Hero(
                        tag: 'product${widget.document['productImage']}',
                        child: Image.network(widget.document['productImage'])),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 9, right: 8, bottom: 2, top: 2),
                          child: Text(
                            widget.document['category']['categoryName'],
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.document['productName'],
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '\$'+_formattedPrice,
                                style: TextStyle(
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              if(widget.document['price'] < int.parse(widget.document['comparedPrice']))
                                Text(
                                  '\$'+_formattedComparedPrice,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey),
                                ),

                              SizedBox(
                                width: 10,
                              ),
                              if (int.parse(offer) > 0)
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8, top: 3, bottom: 3),
                                    child: Text(
                                      '$offer % OFF',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 12),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          Row(
                            children: [
                              SaveForLater(widget.document),
                              AddToCartWidget(widget.document),
                            ],
                          )
                        ]),
                  ),
                  Divider(
                    color: Colors.grey[300],
                    thickness: 6,
                  ),
                  Container(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, bottom: 8, left: 8),
                      child: Text(
                        'About this product',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 8.0, bottom: 8, left: 8),
                    child: ExpandableText(
                      widget.document['description'],
                      expandText: 'View more',
                      collapseText: 'View less',
                      maxLines: 2,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[400],
                  ),
                  Container(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, bottom: 8, left: 8),
                      child: Text(
                        'Other product info',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.grey[400],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 10, top: 8, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Collection : ${widget.document['collection']}',
                          style: TextStyle(color: Colors.grey, fontSize: 17),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Vendor : ${widget.document['seller']['shopName']}',
                          style: TextStyle(color: Colors.grey, fontSize: 17),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 5,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue.shade50,
                          radius: 38,
                          child: Icon(
                            CupertinoIcons.person_alt,
                            color: Colors.lightBlueAccent,
                            size: 60,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(
                            widget.document['seller']['shopName'] == null
                                ? Text('')
                                : widget.document['seller']['shopName']
                                    .toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Text(
                            'See Profile',
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 12,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  GoogleMapVendor(
                    document: widget.document,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: NeumorphicButton(
                            onPressed: () {
                              createChatRoom(doc, _productProvider);
                            },
                            style: NeumorphicStyle(
                                color: Theme.of(context).primaryColor),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.chat_bubble,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Chat',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: NeumorphicButton(
                            onPressed: () {
                              _callSeller('tel: +886${doc['mobile']}');
                            },
                            style: NeumorphicStyle(
                                color: Theme.of(context).primaryColor),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.phone,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Call',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> SaveFavourite() {
    CollectionReference _favourite =
        FirebaseFirestore.instance.collection('favourites');
    User user = FirebaseAuth.instance.currentUser;
    return _favourite
        .add({'product': widget.document.data(), 'customerId': user.uid});
  }
}
