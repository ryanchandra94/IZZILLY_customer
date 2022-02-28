import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:izzilly_customer/API_service/user_service.dart';

class AuthProvider extends ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String email;
  String name;
  String password;
  String phone;
  String error = '';
  bool loading = false;
  UserServices _userServices = UserServices();
  DocumentSnapshot snapshot;

  Future<UserCredential> registerCustomer(email, password) async {
    UserCredential userCredential;
    notifyListeners();
    try {
      userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password provided is too weak';
        notifyListeners();
        print('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        this.error = 'The account already exists for that email';
        notifyListeners();
        print('The account already exists for that email');
      }
    } catch (e) {
      this.error = e.toString();
      print(e);
    }
    return userCredential;
  }

  Future<void> saveCustomerDataToDb(
      {String name,
      String mobile,
      String email,
      double latitude,
      double longitude,
      String address}) async {
    User user = FirebaseAuth.instance.currentUser;
    DocumentReference _customers =
        FirebaseFirestore.instance.collection('customers').doc(user.uid);
    _customers.set({
      'uid': user.uid,
      'name': name,
      'mobile': mobile,
      'email': email,
      'address': address,
      'location': GeoPoint(latitude, longitude),
      'latitude': latitude,
      'longitude': longitude,
    });
    return null;
  }

  void _updateUser(
      {String id,
      String name,
      String mobile,
      String email,
      double latitude,
      double longitude,
      String address}) {
    _userServices.updateUserData({
      'id': id,
      'name': name,
      'mobile': mobile,
      'email': email,
      'address': address,
      'location': GeoPoint(latitude, longitude),
    });
  }

  Future<UserCredential> loginCustomer(email, password) async {
    this.email = email;
    UserCredential userCredential;
    notifyListeners();
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.code;
      notifyListeners();
      print(e);
    }
    return userCredential;
  }

  Future<UserCredential> resetPassword(email) async {
    UserCredential userCredential;
    notifyListeners();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password provided is too weak';
        notifyListeners();
        print('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        this.error = 'The account already exists for that email';
        notifyListeners();
        print('The account already exists for that email');
      }
    } catch (e) {
      this.error = e.toString();
      print(e);
    }
    return userCredential;
  }

  getUserDetails() async {
    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('customers')
        .doc(_auth.currentUser.uid)
        .get();

   if(result!=null){
     this.snapshot = result;
     notifyListeners();
   }else{
     this.snapshot = null;
     notifyListeners();
   }
    return result;
  }
}
