import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:izzilly_customer/widget/counterFavorite.dart';

class SaveForLater extends StatefulWidget {

  final DocumentSnapshot document;
  SaveForLater(this.document);

  @override
  State<SaveForLater> createState() => _SaveForLaterState();
}

class _SaveForLaterState extends State<SaveForLater> {
  User user = FirebaseAuth.instance.currentUser;
  CollectionReference favorite = FirebaseFirestore.instance.collection('favourites');

  bool _exist = false;
  String _docId;
  bool _loading = true;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFavouriteData();

  }
  getFavouriteData() async {
    final snapshot =
    await favorite.where('customerId', isEqualTo: user.uid).get();
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

    FirebaseFirestore.instance
        .collection('favourites')
        .where('customerId', isEqualTo: user.uid)
        .where('productId', isEqualTo: widget.document['productId'])
        .get()
        .then((QuerySnapshot querySnapshot) => {
      querySnapshot.docs.forEach((doc) {
        if(doc['productId'] == widget.document['productId']){
          if(mounted){
            setState(() {
              _exist = true;
              _docId = doc.id;
            });
          }

        }
      })
    });

    return _loading ? Container(

      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor),
        ),
      ),
    ) : _exist ? CounterFavourite(document: widget.document, docId: _docId):
    InkWell(
        onTap: (){
          EasyLoading.show(status: 'Saving');
          SaveFavourite().then((value) => {
            EasyLoading.showSuccess(
              'Saved Successfully',
            ),
          if(mounted){
              setState(() {
            _exist = true;
          })
        }
          });
        },
        child: IconButton(
          iconSize: 30,
          icon: Icon(CupertinoIcons.heart_fill, color: Colors.red,),
        )
    );
  }

  Future<void>SaveFavourite(){
    CollectionReference _favourite = FirebaseFirestore.instance.collection('favourites');
    User user = FirebaseAuth.instance.currentUser;
    return _favourite.add({
      'product' : widget.document.data(),
      'customerId' : user.uid,
      'productId' : widget.document['productId'],
    }

    );
  }
}