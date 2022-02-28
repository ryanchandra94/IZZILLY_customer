import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/page/Product_detail_screen.dart';
import 'package:izzilly_customer/provider/product_provider.dart';
import 'package:izzilly_customer/widget/cart/counter.dart';
import 'package:izzilly_customer/widget/product/save_favourite.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final DocumentSnapshot document;
  ProductCard(this.document);

  @override
  Widget build(BuildContext context) {


    var _productProvider = Provider.of<ProductProvider>(context);
    String offer = (((double.parse(document['comparedPrice']) - document['price']) /
            double.parse(document['comparedPrice'])) * 100)
        .toStringAsFixed(0);
    return Container(
      height: 160,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 10, right: 10),
        child: Row(
          children: [
            Stack(
              children: [
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: (){
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
                    child: SizedBox(
                      height: 100,
                      width: 130,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Hero(
                            tag: 'product${document['productImage']}',
                              child: Image.network(document['productImage']))),
                    ),
                  ),
                ),
                if(double.parse(document['comparedPrice'])>0)
                Container(
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 3,
                      bottom: 3,
                    ),
                    child: Text(
                      '% ${offer} OFF',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              width: 250,
                              child: Text(
                                document['productName'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              children: [
                                Text(
                                  '\$${document['price'].toStringAsFixed(0)}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    color: Colors.red
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                if (int.parse(document['comparedPrice']) > 0)
                                  Text(
                                    '\$${document['comparedPrice']}',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough),
                                  ),

                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 160,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SaveForLater(document),
                                      CounterForCard(document),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
