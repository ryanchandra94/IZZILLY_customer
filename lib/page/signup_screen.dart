import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:izzilly_customer/page/Home_screen.dart';
import 'package:izzilly_customer/page/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:izzilly_customer/widget/registration_form.dart';


class SignupPage extends StatefulWidget {
  static const String id = 'Signup-screen';
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 100,),
                  Image.asset("image/logo.png"),
                  SizedBox(height: 10,),
                  Text('Sign Up', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                  SizedBox(height: 50,),
                  RegistrationForm(),


                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}
