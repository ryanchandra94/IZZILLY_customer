import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/widget/categories_widget.dart';
import 'package:izzilly_customer/widget/product/Featured_product.dart';
import 'package:izzilly_customer/widget/product/best_selling_product.dart';
import 'package:izzilly_customer/widget/product/recently_added_products.dart';
import 'package:izzilly_customer/widget/vendor_appbar.dart';
import 'package:izzilly_customer/widget/vendor_banner.dart';


class VendorHomeScreen extends StatelessWidget {
  static const String id = 'vendor-home-screen';


  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
          body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            VendorAppBar()
          ];
        },
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            VendorBanner(),
            RecentlyAddedProducts(),
            FeaturedProducts(),
            BestSellingProducts(),

          ],
        )
      )),
    );
  }
}
