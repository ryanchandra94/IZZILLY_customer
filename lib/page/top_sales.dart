import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/API_service/user_service.dart';
import 'package:izzilly_customer/page/HotSalesScreen.dart';
import 'package:izzilly_customer/page/Product_detail_screen.dart';
import 'package:izzilly_customer/page/vendor_home_screen.dart';
import 'package:izzilly_customer/page/welcome_screen.dart';
import 'package:izzilly_customer/provider/product_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class HotSales extends StatefulWidget {
  @override
  State<HotSales> createState() => _HotSalesState();
}

class _HotSalesState extends State<HotSales> {
  StoreServices _storeServices = StoreServices();
  User user = FirebaseAuth.instance.currentUser;
  UserServices _userServices = UserServices();
  StoreProvider _storeData = StoreProvider();
  var _userLatitude = 0.0;
  var _userLongitude = 0.0;





  @override
  Widget build(BuildContext context) {
    final _format = NumberFormat('##,##,##0');
    var _productProvider = Provider.of<ProductProvider>(context);
    return Container(
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('productName')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.data == null) return CircularProgressIndicator();

          if (snapshot.hasData) {
            print("error");
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Sales',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          pushNewScreenWithRouteSettings(
                              context,
                              settings: RouteSettings(name: HotSalesScreen.id),
                          screen: HotSalesScreen(),
                          withNavBar: true,
                          pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Text(
                          'View all', style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {

                    var _price = int.parse(document['price'].toStringAsFixed(0));
                    String _formattedPrice = '${_format.format(_price)}';

                    var _compared = int.parse(document['comparedPrice']);
                    String _formattedComparedPrice = '${_format.format(_compared)}';


                    String offer = (((double.parse(document['comparedPrice']) - document['price']) /
                        double.parse(document['comparedPrice'])) * 100)
                        .toStringAsFixed(0);



                      return InkWell(
                        onTap: () {
                          _productProvider.getProductDetails(document);
                          pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: ProductDetailScreen.id),
                            screen: ProductDetailScreen(document: document),
                            withNavBar: true,
                            pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Padding(
                          padding:
                          const EdgeInsets.only(top: 4, right: 4, left: 4),
                          child: Container(
                            width: 120,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 100,
                                  child: Card(
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: Image.network(
                                            document['productImage'],
                                          ))),
                                ),
                                Container(
                                  height: 20,
                                  child: Text(
                                    document['productName'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('\$'+_formattedPrice, style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),),
                                    SizedBox(width: 5,),
                                    Text('\$'+_formattedComparedPrice, style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),)
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );


                  }).toList(),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
