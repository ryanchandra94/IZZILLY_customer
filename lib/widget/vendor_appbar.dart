import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/page/Product_detail_screen.dart';
import 'package:izzilly_customer/model/product_model.dart';
import 'package:izzilly_customer/widget/search_product_widget.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:izzilly_customer/widget/cart/counter.dart';

class VendorAppBar extends StatefulWidget {
  @override
  State<VendorAppBar> createState() => _VendorAppBarState();
}

class _VendorAppBarState extends State<VendorAppBar> {
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

    mapLauncher() async {
      GeoPoint location = _store.storedetails['location'];
      final availableMaps = await MapLauncher.installedMaps;

      await availableMaps.first.showMarker(
          coords: Coords(location.latitude, location.longitude),
          title: "${_store.storedetails['shopName']} is here");
    }

    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.lightBlueAccent,
      snap: true,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      expandedHeight: 300,
      flexibleSpace: SizedBox(
          child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(_store.storedetails['imageUrl']))),
              child: Container(
                color: Colors.grey.withOpacity(.7),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Text(
                        _store.storedetails['description'],
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      ),
                      Text(
                        _store.storedetails['address'],
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        _store.storedetails['email'],
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      Text(
                        'Distance : ${_store.distance} km',
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.star,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.star_half,
                            color: Colors.white,
                          ),
                          Icon(
                            Icons.star_outline,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '(3.5)',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              onPressed: () {
                                launch(
                                    'tel:+886 ${_store.storedetails['mobile']}');
                              },
                              icon: Icon(
                                Icons.phone,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              onPressed: () {
                                mapLauncher();
                              },
                              icon: Icon(
                                Icons.map,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      )),
      actions: [
        IconButton(onPressed: (){}, icon: Icon(CupertinoIcons.add, color: Colors.lightBlueAccent,))
        /*IconButton(
          onPressed: () {
            if (mounted) {
              setState(() {
                shopName = _store.storedetails['shopName'];
              });
            }
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
                builder: (product) => shopName != product.shopName
                    ? Container()
                    : SearchCard(offer: offer, product: product, document: product.document,),
              ),
            );
          },
          icon: Icon(CupertinoIcons.search),
        )*/
      ],
      title: Center(
        child: Text(
          _store.storedetails['shopName'],
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 25),
        ),
      ),
    );
  }
}
