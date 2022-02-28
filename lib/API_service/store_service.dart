import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:izzilly_customer/API_service/user_service.dart';

class StoreServices {

  CollectionReference vendorbanner = FirebaseFirestore.instance.collection('vendorBanner');
  CollectionReference vendors = FirebaseFirestore.instance.collection('vendors');


  getTopPickedStore() async{
    return FirebaseFirestore.instance
        .collection('vendors')
        .where('accVerified', isEqualTo: true).where('isTopPicked', isEqualTo: true).orderBy('shopName').snapshots();
  }

  Future<DocumentSnapshot>getVendorDetails(sellerUid)async{
    DocumentSnapshot snapshot = await vendors.doc(sellerUid).get();
    return snapshot;
  }
}

class StoreProvider with ChangeNotifier{

  UserServices _userServices = UserServices();
  StoreServices _storeServices = StoreServices();
  User user = FirebaseAuth.instance.currentUser;
  String userLocation = "";
  String selectedStore = 'Vendor name';
  String selectedStoreId = 'vendor ID';
  var _userLatitude = 0.0;
  var _userLongitude = 0.0;
  DocumentSnapshot storedetails;
  String distance;
  String selectedProductCategory;
  String selectedProductSubCategory;
  DocumentSnapshot sellerDetails;
  CollectionReference vendors = FirebaseFirestore.instance.collection('vendors');



  void getSelectedStore(storeDetails, distance){
    this.storedetails = storeDetails;
    this.distance = distance;
    notifyListeners();
  }

  void selectedCategory(category){
    this.selectedProductCategory = category;
    notifyListeners();
  }

  void selectedSubCategory(subcategory){
    this.selectedProductSubCategory = subcategory;
    notifyListeners();
  }

  Future<void> getUserLocation(context) async{

    _userServices.getUserById(user.uid).then((result) {

      if(user != null){
          this.userLocation = result.get('location')?? '';
          notifyListeners();
      }
    });
  }

  Future<void>getUserLocationData(context)async{
    _userServices.getUserById(user.uid).then((result) {
      if(user != null){
        this._userLatitude = result['latitude'];
        this._userLongitude = result['longitude'];
        notifyListeners();
      }
    });
  }

  getSellerDetails(details){
    this.sellerDetails = details;
    notifyListeners();
  }


  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<DocumentSnapshot>getShopDetails(sellerUid)async{
    DocumentSnapshot snapshot = await vendors.doc(sellerUid).get();
    return snapshot;
  }



}




