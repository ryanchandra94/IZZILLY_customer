import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/widget/product/product-list-widget.dart';
import 'package:izzilly_customer/widget/vendor_appbar.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  static const String id = 'Product-list-screen';
  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text('Services List'),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return[
              SliverAppBar(
                title: Text(_storeProvider.selectedProductCategory),
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
              ProductList(),
            ],
          ),
        ),
      ),
    );
  }
}
