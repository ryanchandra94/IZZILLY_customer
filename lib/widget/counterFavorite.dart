import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/cart_services.dart';
import 'package:izzilly_customer/API_service/favorite_services.dart';
import 'package:izzilly_customer/widget/product/add_to_cart_widget.dart';
import 'package:izzilly_customer/widget/product/save_favourite.dart';


class CounterFavourite extends StatefulWidget {

  final DocumentSnapshot document;
  final String docId;

  CounterFavourite({this.document, this.docId});
  @override
  _CounterFavouriteState createState() => _CounterFavouriteState();
}

class _CounterFavouriteState extends State<CounterFavourite> {

  FavoriteService _favorite = FavoriteService();
  bool _loading = false;
  bool _exists = true;
  User user = FirebaseAuth.instance.currentUser;


  @override
  void initState() {
    getFavoriteData();
    super.initState();
  }

  getFavoriteData() async {
    final snapshot =
    await _favorite.favorite.where('customerId',isEqualTo: user.uid).get();
    if (snapshot.docs.length == 0) {
      setState(() {
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _exists ? InkWell(
      onTap: () {
        _favorite.removeFavorite(widget.docId).then((value) {
          setState(() {
            if (!mounted) return;
            if(mounted){
              _exists = false;
            }
          });
        });
      },

      child: Container(
        height: 56,

        child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.heart_slash_fill, color: Colors.red),

                ],
              ),
            )),
      ),
    ) : SaveForLater(widget.document);
  }
}