import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/product_service.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/widget/favorite_product_list.dart';
import 'package:izzilly_customer/widget/product/product_card_widget.dart';
import 'package:izzilly_customer/widget/product/product_filter_widget.dart';
import 'package:izzilly_customer/widget/topSales_viewAll.dart';
import 'package:provider/provider.dart';


class TopSalesList extends StatefulWidget {

  @override
  State<TopSalesList> createState() => _TopSalesListState();
}

class _TopSalesListState extends State<TopSalesList> {
  User user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();



    var _storeProvider = Provider.of<StoreProvider>(context);

    return FutureBuilder<QuerySnapshot>(
      future: _services.products

          .orderBy('productName')
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);
        }

        if(snapshot.data.docs.isEmpty){
          return Container();
        }

        return Column(
          children: [

            Container(
                width: MediaQuery.of(context).size.width,
                height: 56,
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text('${snapshot.data.docs.length} items', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),),
                    ),
                  ],
                )
            ),
            ListView(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return new TopSalesViewAll(document);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}