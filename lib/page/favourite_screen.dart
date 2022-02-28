import 'package:flutter/material.dart';
import 'package:izzilly_customer/widget/favorite_screen.dart';


class FavouriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return[
              SliverAppBar(
                centerTitle: true,
                backgroundColor: Colors.lightBlueAccent,
                title: Text("My Favorite", style: TextStyle(fontSize: 25),),
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
              FavoriteList(),
            ],
          ),
        ),
      ),
    );
  }
}
