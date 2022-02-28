import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/API_service/user_service.dart';
import 'package:izzilly_customer/page/vendor_home_screen.dart';
import 'package:izzilly_customer/page/welcome_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class HomePaginate extends StatefulWidget {
  @override
  _HomePaginateState createState() => _HomePaginateState();
}

class _HomePaginateState extends State<HomePaginate> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _stores = [];
  bool _loadingStores = true;
  UserServices _userServices = UserServices();
  int _per_page = 5;
  User user = FirebaseAuth.instance.currentUser;
  DocumentSnapshot _lastDocument;
  ScrollController _scrollController = ScrollController();
  bool _gettingMoreProducts = false;
  bool _moreProductsAvailable = true;
  var _userLatitude = 0.0;
  var _userLongitude = 0.0;
  double latitude =0.0;
  double longitude = 0.0;

  _getStores() async {
    Query q =
        _firestore.collection('vendors').orderBy('shopName').limit(_per_page);
    setState(() {
      _loadingStores = true;
    });

    QuerySnapshot querySnapshot = await q.get();

    _stores = querySnapshot.docs;
    _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    if(mounted){
      setState(() {
        _loadingStores = false;
      });
    }
  }

  _getMoreStores() async {
    print("_getMoreProducts called");
    if(_moreProductsAvailable == false){
      ///////no more stores
      print('No more products');
      return;
    }

    if(_gettingMoreProducts == true){
      return;
    }
    _gettingMoreProducts = true;
    Query q = _firestore
        .collection('vendors')
        .orderBy('shopName')
        .startAfter([_lastDocument.data()]).limit(_per_page);

    QuerySnapshot querySnapshot = await q.get();
    if(querySnapshot.docs.length < _per_page){
      _moreProductsAvailable = false;
    }
    _lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
    _stores.addAll(querySnapshot.docs);

    setState(() {
      _gettingMoreProducts = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  void didChangeDependencies() {

    _getStores();
    _scrollController.addListener(() {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = MediaQuery.of(context).size.height * 0.3;
      if(maxScroll - currentScroll <= delta){
        _getMoreStores();
      }

    });


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
    return _loadingStores == true
        ? Container(
            child: Center(
              child: Text("Loading......"),
            ),
          )
        : Container(
            child: _stores.length == 0
                ? Center(
                    child: Text('No stores to show'),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: _stores.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(4),
                        child: ListTile(
                          title: Container(
                              child: InkWell(
                                onTap: () {
                                  Provider.of<StoreProvider>(context, listen: false)
                                      .getSelectedStore(
                                      _stores[index], getDistance(_stores[index]['location']));
                                  pushNewScreenWithRouteSettings(
                                    context,
                                    settings: RouteSettings(name: VendorHomeScreen.id),
                                    screen: VendorHomeScreen(),
                                    withNavBar: true,
                                    pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                                  );
                                },
                                child: Row(
                            children: [
                                SizedBox(
                                  width: 120,
                                  height: 100,
                                  child: Card(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(
                                        _stores[index]['imageUrl'],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 35,
                                      child: Text(
                                        _stores[index]['shopName'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                      height: 20,
                                      width: 200,
                                      child: Text(
                                        _stores[index]['address'],
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                        width: MediaQuery.of(context).size.width -
                                            250,
                                        ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 12,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          '3.2',
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )
                            ],
                          ),
                              )),
                        ),
                      );
                    },
                  ));
  }
}
