import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/API_service/user_service.dart';
import 'package:izzilly_customer/page/vendor_home_screen.dart';
import 'package:izzilly_customer/page/welcome_screen.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/widgets/framework.dart';

class SameLocation extends StatefulWidget {

  @override
  State<SameLocation> createState() => _SameLocationState();
}

class _SameLocationState extends State<SameLocation> {
  StoreServices _storeServices = StoreServices();
  User user = FirebaseAuth.instance.currentUser;
  UserServices _userServices = UserServices();
  StoreProvider _storeData = StoreProvider();
  var _userLatitude = 0.0;
  var _userLongitude = 0.0;

  double latitude =0.0;
  double longitude = 0.0;

  @override
  void didChangeDependencies() {
    final _storeData = Provider.of<StoreProvider>(context);


    _userServices.getUserById(user.uid).then((result) {
      if (user != null) {
        if(mounted){
          setState(() {
            _userLatitude = result['latitude'];
            _userLongitude = result['longitude'];
          });
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
      }
    });
    super.didChangeDependencies();
  }

  String getDistance(location) {
    var distance = Geolocator.distanceBetween(
        _userLatitude, _userLongitude, location.latitude, location.longitude);
    var distanceInKm = distance/1000;
    return distanceInKm.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('vendors')
            .orderBy('shopName')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) return Center(child: CircularProgressIndicator());
          List shopDistance = [];
          for (int i = 0; i <= snapshot.data.docs.length-1; i++) {
            var distance = Geolocator.distanceBetween(
                _userLatitude,
                _userLongitude,
                snapshot.data.docs[i]['location'].latitude,
                snapshot.data.docs[i]['location'].longitude);
            var distanceInKm = distance/1000;
            shopDistance.add(distanceInKm);
          }
          shopDistance.sort();
          if (snapshot.hasData) {
            print("error");
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '  Nearby Store',
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'View all', style: TextStyle(color: Colors.lightBlue, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {


                    if(double.parse(getDistance(document['location']))<=5){
                      return InkWell(
                        onTap: () {
                          Provider.of<StoreProvider>(context, listen: false)
                              .getSelectedStore(
                              document, getDistance(document['location']));
                          pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: VendorHomeScreen.id),
                            screen: VendorHomeScreen(),
                            withNavBar: true,
                            pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Padding(
                          padding:
                          const EdgeInsets.only(top: 4, right: 4, left: 4),
                          child: Container(
                            width: 120,
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 120,
                                  height: 100,
                                  child: Card(
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(4),
                                          child: Image.network(
                                            document['imageUrl'],
                                          ))),
                                ),
                                Container(
                                  height: 20,
                                  child: Text(
                                    document['shopName'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${getDistance(document['location'])} KM',
                                  style:
                                  TextStyle(color: Colors.grey, fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }else{
                      return Container(
                        child: Text("No Store to show"),
                      );

                    }

                  }).toList(),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
