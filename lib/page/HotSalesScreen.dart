import 'package:flutter/material.dart';
import 'package:izzilly_customer/widget/favorite_screen.dart';
import 'package:izzilly_customer/widget/topSalesList.dart';
import 'package:izzilly_customer/widget/topSales_viewAll.dart';


class HotSalesScreen extends StatelessWidget {

  static const String id = 'hotsales-screen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return[
              SliverAppBar(
                backgroundColor: Colors.lightBlueAccent,
                centerTitle: true,
                title: Text("Top Sales", style: TextStyle(fontSize: 25),),
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
              TopSalesList(),
            ],
          ),
        ),
      ),
    );
  }
}