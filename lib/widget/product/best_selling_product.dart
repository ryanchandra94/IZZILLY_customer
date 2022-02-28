import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/product_service.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/widget/product/product_card_widget.dart';
import 'package:provider/provider.dart';

class BestSellingProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _store = Provider.of<StoreProvider>(context);
    return FutureBuilder<QuerySnapshot>(
      future: _services.products
          .where('published', isEqualTo: true)
          .where('collection', isEqualTo: 'Best Selling').orderBy('productName')
          .where('seller.selleruid', isEqualTo: _store.storedetails['uid'])
          .limitToLast(10)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }

        if(!snapshot.hasData){
          return Container();
        }

        if(snapshot.data.docs.isEmpty){
          return Container();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8),
              child: Container(
                width: MediaQuery.of(context).size.width,

                child: Text('Best Selling Products', style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),),
              ),
            ),
            ListView(
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return new ProductCard(document);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
