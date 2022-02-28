import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/register_customer.dart';
import 'package:izzilly_customer/page/Home_screen.dart';
import 'package:izzilly_customer/page/login_screen.dart';
import 'package:izzilly_customer/page/main_screen.dart';
import 'package:izzilly_customer/provider/location_provider.dart';
import 'package:provider/provider.dart';



class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _confirmPasswordTextController = TextEditingController();
  var _phoneNumberTextController = TextEditingController();
  var _nameTextController = TextEditingController();
  var _locationTextController = TextEditingController();
  String email;
  String password;
  bool _isloading = false;


  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);
    return  SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(3),
              child: TextFormField(
                controller: _emailTextController,
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  if(value.isEmpty){
                    return"Enter email";
                  }
                  final bool _valid = EmailValidator.validate(_emailTextController.text);
                  if(!_valid){
                    return 'Invalid Email';
                  }
                  setState(() {
                    email = value;
                  });
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2, color: Theme.of(context).primaryColor,
                    )
                  ),
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(height: 3,),
            Padding(
              padding: const EdgeInsets.all(3),
              child: TextFormField(
                maxLength: 9,
                controller: _phoneNumberTextController,
                keyboardType: TextInputType.number,
                validator: (value){
                  if(value.isEmpty){
                    return"Enter phone number";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixText: '+886',

                  prefixIcon: Icon(Icons.phone_android),
                  labelText: 'Mobile Number',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2, color: Theme.of(context).primaryColor,
                      )
                  ),
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(height: 3,),
            Padding(
              padding: const EdgeInsets.all(3),
              child: TextFormField(
                controller: _nameTextController,
                validator: (value){
                  if(value.isEmpty){
                    return"Enter your name";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  labelText: 'Name',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2, color: Theme.of(context).primaryColor,
                      )
                  ),
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(height: 3,),
            Padding(
              padding: const EdgeInsets.all(3),
              child: TextFormField(
                obscureText: true,
                validator: (value){
                  if(value.isEmpty){
                    return"Enter your password";
                  }
                  if(value.length<6){
                    return 'Minimum 6 characters';
                  }
                  setState(() {
                    password = value;
                  });
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                  labelText: 'Password',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2, color: Theme.of(context).primaryColor,
                      )
                  ),
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(height: 3,),
            Padding(
              padding: const EdgeInsets.all(3),
              child: TextFormField(
                obscureText: true,
                validator: (value){
                  if(value.isEmpty){
                    return"Enter your Confirm password";
                  }
                  if(_passwordTextController.text != _confirmPasswordTextController.text){
                    return "Password does not match";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                  labelText: 'Confirm Password',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2, color: Theme.of(context).primaryColor,
                      )
                  ),
                  focusColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(height: 3,),
            SizedBox(height: 20,),
            Row(
              children: [
                Expanded(
                  child: FlatButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: (){
                      if(_formKey.currentState.validate()){

                        _auth.registerCustomer(email, password).then((credential){
                          _auth.saveCustomerDataToDb(
                              name: _nameTextController.text,
                              mobile: _phoneNumberTextController.text,
                              email: _emailTextController.text,
                              address: locationData.selectedAddress.addressLine,
                            latitude: locationData.latitude,
                            longitude: locationData.longitude,
                          ).then((value) {
                                setState(() {
                                  _formKey.currentState.reset();

                                });

                                Navigator.push(context, new MaterialPageRoute(
                                    builder: (context) => new MainScreen()));
                          });

                        });
                      }
                    },
                    child: Text("Sign Up", style: TextStyle(color: Colors.white),),
                  ),
                )
              ],
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Already have account?"),
                SizedBox(width: 10,),
                GestureDetector(
                    onTap: (){
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => LoginPage()));
                    },
                    child: Text("Log In", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
