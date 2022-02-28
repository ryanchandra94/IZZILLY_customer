import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/register_customer.dart';
import 'package:izzilly_customer/API_service/user_service.dart';
import 'package:izzilly_customer/page/Home_screen.dart';
import 'package:izzilly_customer/page/SIgnIn.dart';
import 'package:izzilly_customer/page/main_screen.dart';
import 'package:izzilly_customer/page/map_screen.dart';
import 'package:izzilly_customer/page/signup_screen.dart';
import 'package:izzilly_customer/page/welcome_screen.dart';
import 'package:izzilly_customer/widget/reset_password.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const String id = 'Login-screen';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Icon icon;
  bool _visible = true;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Image.asset("image/logo.png"),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Log In',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter email';
                          }
                          final bool _valid = EmailValidator.validate(
                              _emailTextController.text);
                          if (!_valid) {
                            return 'Invalid email format';
                          }
                          return null;
                        },
                        controller: _emailTextController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2)),
                          focusColor: Colors.lightBlueAccent,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter password';
                          }
                          if (value.length < 6) {
                            return 'minimum 6 characters';
                          }
                          return null;
                        },
                        controller: _passwordTextController,
                        obscureText: _visible,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: _visible
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _visible = !_visible;
                              });
                              ;
                            },
                          ),
                          enabledBorder: OutlineInputBorder(),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'password',
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2)),
                          focusColor: Colors.lightBlueAccent,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, ResetPassword.id);
                            },
                            child: Text(
                              'Forget Password ? ',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Expanded(
                          child: FlatButton(
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _loading = true;
                                  });
                                  _authData
                                      .loginCustomer(_emailTextController.text,
                                          _passwordTextController.text)
                                      .then((credential) {
                                    if (credential != null) {
                                      setState(() {
                                        _loading = false;
                                      });

                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  new MainScreen()));
                                    } else {
                                      setState(() {
                                        _loading = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(_authData.error)));
                                    }
                                  });
                                }
                              },
                              child: _loading
                                  ? LinearProgressIndicator()
                                  : Text(
                                      "Login",
                                    )),
                        ),
                      ]),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have account?"),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SIgnIn()));
                              },
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }
}
