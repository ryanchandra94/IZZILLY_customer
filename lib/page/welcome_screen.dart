import 'package:flutter/material.dart';
import 'package:izzilly_customer/page/SIgnIn.dart';
import 'package:izzilly_customer/page/login_screen.dart';
import 'package:izzilly_customer/page/map_screen.dart';
import 'package:izzilly_customer/page/onboard_screen.dart';
import 'package:izzilly_customer/provider/location_provider.dart';
import 'package:provider/provider.dart';


class WelcomeScreen extends StatefulWidget {

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(child: SIgnIn(),),
                SizedBox(height: 20,),

                FlatButton(
                    color: Colors.blueAccent,
                    onPressed: ()async{
                      setState(() {
                        locationData.loading=true;
                      });
                      await locationData.getCurrentPosition();
                      if(locationData.permissionAllowed==true){
                        Navigator.pushReplacementNamed(context, MapScreen.id);
                        setState(() {
                          locationData.loading = false;
                        });
                      }else{
                        print('permission not allowed');
                        setState(() {
                          locationData.loading = false;
                        });
                      }
                    },
                    child: locationData.loading ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ) : Text("Set Location to Sign Up", style: TextStyle(color: Colors.white),)
                ),
                SizedBox(height: 5,),
                FlatButton(
                  color: Colors.blueAccent,
                  child: Text('Log In', style: TextStyle(color: Colors.white),),
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, LoginPage.id);
                  } ,
                ),
                SizedBox(height: 20,),
                FlatButton(
                  onPressed: (){

                  },
                  child: RichText(
                    text: TextSpan(
                        text: "Log In as a vendor? " ,
                        style: TextStyle(color: Colors.lightBlueAccent),
                        children: [
                          TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.lightBlueAccent
                              )
                          )
                        ]
                    ),
                  ),

                )
              ],
            ),
          ],
        )
      ),
    );
  }
}
