import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/widget/product/add_to_cart_widget.dart';
import 'package:izzilly_customer/widget/product/save_favourite.dart';


class BottomSheetContainer extends StatefulWidget {

  final DocumentSnapshot document;
  BottomSheetContainer(this.document);

  @override
  State<BottomSheetContainer> createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(flex:1 ,child: SaveForLater(widget.document)),
          Flexible(flex:1,child: AddToCartWidget(widget.document)),
        ],
      ),
    );
  }



}
