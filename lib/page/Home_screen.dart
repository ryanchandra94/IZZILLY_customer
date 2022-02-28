import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/page/login_screen.dart';
import 'package:izzilly_customer/page/top_sales.dart';
import 'package:izzilly_customer/widget/app_bar.dart';
import 'package:izzilly_customer/widget/home_categories.dart';
import 'package:izzilly_customer/widget/home_paginate.dart';
import 'package:izzilly_customer/widget/image_slider.dart';
import 'package:izzilly_customer/widget/product/new_product_list.dart';
import 'package:izzilly_customer/widget/same_location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const String id = 'Home-screen';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _location = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(
            physics: ScrollPhysics(),
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
              return [
                MyAppBar()
              ];
            },
            body: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                  children: [
                ImageSlider(),
                    Divider(thickness: 4, color: Colors.grey,),
                SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(color: Colors.white, height: 200, child: HotSales()),
                    ),
                    Divider(thickness: 4, color: Colors.grey,),
                    Container(
                      color: Colors.white,
                        height: 200,
                        child: HomeCategories()),
                    SizedBox(height: 5,),
                    Divider(thickness: 4, color: Colors.grey,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(color:Colors.white, height: 500, child: NewProdcutList()),
                    ),
                Divider(thickness: 4, color: Colors.grey,),
                Padding(
                  padding: const EdgeInsets.only(top: 3, bottom: 3),
                  child: Container(height: 200, child: SameLocation()),
                ),
                    Divider(thickness: 4, color: Colors.grey,),


              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  child: Column(
                    children: [
                      Image.asset(
                        "image/logo.png",
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 20,),

                            Text(
                              "By IZZILLY TEAM",
                              style: TextStyle(
                                fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  color: Colors.grey),
                            )

                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
                    SizedBox(height: 20,)
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
