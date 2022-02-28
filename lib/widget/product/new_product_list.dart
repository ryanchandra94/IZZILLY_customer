import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/product_service.dart';
import 'package:intl/intl.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/page/Product_detail_screen.dart';
import 'package:izzilly_customer/provider/product_provider.dart';
import 'package:like_button/like_button.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
class NewProdcutList extends StatelessWidget {
  ProductServices _services = ProductServices();


  @override
  Widget build(BuildContext context) {
    final _format = NumberFormat('##,##,##0');
    var _productProvider = Provider.of<ProductProvider>(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: FutureBuilder<QuerySnapshot>(
          future: _services.products.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(left: 140, right: 140),
                child: LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                  backgroundColor: Colors.white,
                ),
              );
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Center(
                          child: Text(
                        'Fresh Recommendation',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )),
                    ),
                  ),
                  new GridView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200,
                        childAspectRatio: 2 / 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: snapshot.data.size,
                      itemBuilder: (BuildContext context, int i) {
                        var data = snapshot.data.docs[i];
                        var _price = int.parse(data['price'].toStringAsFixed(0));
                        String _formattedPrice = '${_format.format(_price)}';
                        return Container(

                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                _productProvider.getProductDetails(data);
                                pushNewScreenWithRouteSettings(
                                  context,
                                  settings: RouteSettings(name: ProductDetailScreen.id),
                                  screen: ProductDetailScreen(document: data),
                                  withNavBar: true,
                                  pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                                );
                              },
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          height: 100,
                                          child: Center(
                                            child: Image.network(
                                              data['productImage'],
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        '\$'+_formattedPrice,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        data['productName'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),

                                    ],
                                  ),
                                  Positioned(
                                    right: 0.0,
                                    child: LikeButton(

                                      circleColor:
                                      CircleColor(

                                          start: Color(0xff00ddff),
                                          end: Color(0xff0099cc)),
                                      bubblesColor: BubblesColor(
                                        dotPrimaryColor: Color(0xff33b5e5),
                                        dotSecondaryColor: Color(0xff0099cc),
                                      ),
                                      likeBuilder: (bool isLiked) {
                                        return Icon(
                                          Icons.favorite, size: 30,
                                          color: isLiked ? Colors.red : Colors.grey,

                                        );
                                      },

                                      countBuilder: (int count, bool isLiked, String text) {
                                        var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
                                        Widget result;

                                        return result;
                                      },
                                    ),
                                  )
                                ],
                              )
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFE3F2FD),
                            border: Border.all(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(20)
                          ),

                        );
                      })
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
