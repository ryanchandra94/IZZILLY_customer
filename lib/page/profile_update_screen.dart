import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:izzilly_customer/API_service/user_service.dart';

class UpdateProfile extends StatefulWidget {
  static const String id = 'update-profile';
  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _formKey = GlobalKey<FormState>();

  User user = FirebaseAuth.instance.currentUser;
  UserServices _user = UserServices();
  var name = TextEditingController();
  var email = TextEditingController();
  var mobile = TextEditingController();

  updateProfile() {
    if (_formKey.currentState.validate()) {
      return FirebaseFirestore.instance
          .collection('customers')
          .doc(user.uid)
          .update({
        'name': name.text,
        'email': email.text,
        'mobile': mobile.text,
      });
    }
  }

  @override
  void initState() {
    _user.getUserById(user.uid).then((value) {
      if (mounted) {
        setState(() {
          name.text = value['name'];
          mobile.text = value['mobile'].toString();
          email.text = value['email'];
        });
      }
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        title: Text(
          'Update Profile',
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      bottomSheet: InkWell(
        onTap: () {
          EasyLoading.show(status: 'Updating Profile');
          updateProfile().then((value){
              EasyLoading.showSuccess('Updated Successfully');
              Navigator.pop(context);
          });
        },
        child: Container(
          width: double.infinity,
          height: 56,
          color: Colors.blueGrey[900],
          child: Center(
            child: Text(
              'Update',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.zero),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.zero),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Email Name';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                maxLength: 9,
                keyboardType: TextInputType.number,
                controller: mobile,
                decoration: InputDecoration(
                    labelText: 'Mobile',
                    prefixText: '+886',
                    labelStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.zero),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
