import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/widget/product/home_product_list.dart';
import 'package:izzilly_customer/widget/product/product-list-widget.dart';
import 'package:izzilly_customer/widget/vendor_appbar.dart';
import 'package:provider/provider.dart';

class HomeProductListScreen extends StatelessWidget {
  static const String id = 'Home-list-screen';
  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return[
              SliverAppBar(
                backgroundColor: Colors.lightBlueAccent,
                title: Text(_storeProvider.selectedProductCategory, style: TextStyle(fontSize: 25),),
                iconTheme: IconThemeData(
                    color: Colors.white
                ),
              ),
            ];
          },
          body: ListView(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              HomeProductList(),
            ],
          ),
        ),
      ),
    );
  }
}
