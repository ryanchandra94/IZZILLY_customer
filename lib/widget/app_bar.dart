import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/page/login_screen.dart';
import 'package:izzilly_customer/model/product_model.dart';
import 'package:izzilly_customer/widget/search_product_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';


class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {


  static List<Product> products = [];
  String offer;
  String shopName;
  DocumentSnapshot document;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (mounted) {
          setState(() {
            document = doc;

            offer = (((double.parse(doc['comparedPrice']) - doc['price']) /
                double.parse(doc['comparedPrice'])) *
                100)
                .toStringAsFixed(0);
            products.add(Product(
                comparedPrice: doc['comparedPrice'],
                category: doc['category']['categoryName'],
                image: doc['productImage'],
                price: doc['price'],
                productName: doc['productName'],
                shopName: doc['seller']['shopName'],
                document: doc));
          });
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    products.clear();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);
    return SliverAppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      floating: true,
      snap: true,
      leading: Container(
        ),
      title: Image.asset("image/logo.png", color: Colors.black, scale: 1.5,),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: SearchPage<Product>(
                onQueryUpdate: (s) => print(s),
                items: products,
                searchLabel: 'Search products',
                suggestion: Center(
                  child: Text('Filter product by name, category or price'),
                ),
                failure: Center(
                  child: Text('No Product Found'),
                ),
                filter: (product) => [
                  product.productName,
                  product.category,
                  product.price.toStringAsFixed(0),
                ],
                builder: (product) => SearchCard(offer: offer, product: product, document: product.document,),
              ),
            );
          },
          icon: Icon(CupertinoIcons.search, color: Colors.black,),
        ),
        IconButton(
          icon : Icon(Icons.account_circle_outlined, color: Colors.black,),
          onPressed: (){

            FirebaseAuth.instance.signOut();
            pushNewScreenWithRouteSettings(
                context,
                screen: LoginPage(),
                settings: RouteSettings(name: LoginPage.id),
              withNavBar: false,
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );

          },
        )
      ],
      centerTitle: false,
        leadingWidth: 0,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(20),
        child: Divider(thickness: 5,)
      ),

    );
  }
}
