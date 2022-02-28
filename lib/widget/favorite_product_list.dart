import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/product_service.dart';
import 'package:izzilly_customer/page/Product_detail_screen.dart';
import 'package:izzilly_customer/provider/product_provider.dart';
import 'package:izzilly_customer/widget/cart/counter.dart';
import 'package:izzilly_customer/widget/product/save_favourite.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class FavoriteProductData extends StatefulWidget {
  final DocumentSnapshot document;
  FavoriteProductData(this.document);

  @override
  State<FavoriteProductData> createState() => _FavoriteProductDataState();
}

class _FavoriteProductDataState extends State<FavoriteProductData> {

  DocumentSnapshot doc;
  ProductServices _services = ProductServices();
  String offer;
  @override
  void initState() {
    _services.getProductDetail(widget.document['product']['productId']).then((value) {
      if(mounted){
        setState(() {
          doc = value;
          offer = (((double.parse(value['comparedPrice']) - value['price']) /
              double.parse(value['comparedPrice'])) * 100)
              .toStringAsFixed(0);
        });
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {


    var _productProvider = Provider.of<ProductProvider>(context);

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
            doc!= null ? Stack(
              children: [

                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: (){
                      _productProvider.getProductDetails(doc);
                      pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: ProductDetailScreen.id),
                        screen: ProductDetailScreen(document: doc),
                        withNavBar: true,
                        pageTransitionAnimation:
                        PageTransitionAnimation.cupertino,
                      );
                    },

                    child: doc !=null ? SizedBox(
                      height: 100,
                      width: 130,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: doc['productImage'] !=null ? Hero(
                              tag: 'product${doc['productImage']}',
                              child: Image.network(doc['productImage'])): Container()),
                    ) : Container(),
                  ),
                ),
                if(double.parse(doc['comparedPrice'])>0)
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
            ) : Container(),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   doc != null ? Container(
                      child: Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 35,
                            ),
                            SizedBox(
                              width: 250,
                              child: Text(
                                doc['productName'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Text(
                                  '\$${doc['price'].toStringAsFixed(0)}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    color: Colors.red
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                if (int.parse(doc['comparedPrice']) > 0)
                                  Text(
                                    '\$${doc['comparedPrice']}',
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
                                  MediaQuery.of(context).size.width-159,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SaveForLater(doc),
                                      CounterForCard(doc),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ) : Container()
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