import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:izzilly_customer/API_service/register_customer.dart';
import 'package:izzilly_customer/page/login_screen.dart';
import 'package:izzilly_customer/page/map_screen.dart';
import 'package:izzilly_customer/page/map_screen_profile.dart';
import 'package:izzilly_customer/page/my_orders_screen.dart';
import 'package:izzilly_customer/page/payment/credit_card_list.dart';
import 'package:izzilly_customer/page/profile_update_screen.dart';
import 'package:izzilly_customer/provider/location_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile-screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<AuthProvider>(context);
    var locationData = Provider.of<LocationProvider>(context);
    User user = FirebaseAuth.instance.currentUser;
    userDetails.getUserDetails();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFECEFF1),
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          elevation: 0.0,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            'Profile Screen',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
        ),
        body:userDetails.snapshot == null ? Center(child: CircularProgressIndicator()) : SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Center(
              child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'MY ACCOUNT',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Card(
                elevation: 4,
                child: Stack(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Text(userDetails.snapshot != null ?
                                          userDetails.snapshot['name'][0] : "",
                                          style: TextStyle(
                                              fontSize: 50, color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        height: 70,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (userDetails.snapshot != null)
                                            Text(
                                              userDetails.snapshot['name'] != null ? userDetails.snapshot['name'] : 'Your Name',
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            if (userDetails.snapshot != null)
                                            Text(
                                              userDetails.snapshot['email']!=null ? userDetails.snapshot['email'] : 'Email',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                            if (userDetails.snapshot != null)
                                            Text(
                                              userDetails.snapshot['mobile']!=null ? userDetails.snapshot['mobile'] : 'Mobile Phone',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (userDetails.snapshot != null)
                            ListTile(
                              tileColor: Colors.white,
                              leading: Icon(
                                Icons.location_on,
                                color: Colors.redAccent,
                              ),
                              title: Text(
                                userDetails.snapshot['address'],
                                maxLines: 1,
                              ),
                              trailing: SizedBox(
                                width: 70,
                                child: OutlineButton(
                                  padding: EdgeInsets.zero,
                                  borderSide: BorderSide(color: Colors.redAccent),
                                  child: Text(
                                    'Change',
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                  onPressed: () {
                                    locationData.getCurrentPosition().then((value) {
                                      if (value != null) {
                                        pushNewScreenWithRouteSettings(context,
                                            screen: MapProfile(),
                                            settings:
                                                RouteSettings(name: MapProfile.id),
                                            withNavBar: false,
                                            pageTransitionAnimation:
                                                PageTransitionAnimation.cupertino);
                                      } else {
                                        EasyLoading.dismiss();
                                        print('Permission not allowed');
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 10.0,
                      top: 10.0,
                      child: IconButton(
                          icon: Icon(
                        Icons.edit_outlined,
                        color: Colors.black,
                      ),
                        onPressed: (){
                          pushNewScreenWithRouteSettings(
                            context,
                            screen: UpdateProfile(),
                            settings: RouteSettings(name: UpdateProfile.id),
                            withNavBar: false,
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              ListTile(
                onTap: (){
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: MyOrders.id),
                    screen: MyOrders(),
                    withNavBar: true,
                    pageTransitionAnimation:
                    PageTransitionAnimation.cupertino,
                  );
                },
                leading: Icon(Icons.history),
                title: Text("My Orders", style: TextStyle(fontSize: 18),),
                horizontalTitleGap: 2,
              ),
              Divider(),
              ListTile(
                onTap: (){
                  pushNewScreenWithRouteSettings(
                    context,
                    settings: RouteSettings(name: CreditCardList.id),
                    screen: CreditCardList(),
                    withNavBar: true,
                    pageTransitionAnimation:
                    PageTransitionAnimation.cupertino,
                  );
                },
                leading: Icon(Icons.credit_card),
                title: Text("Manage Credit Card", style: TextStyle(fontSize: 18)),
                horizontalTitleGap: 2,
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.comment_outlined),
                title: Text("My Ratings & Review", style: TextStyle(fontSize: 18)),
                horizontalTitleGap: 2,
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.notifications_none),
                title: Text("Notifications", style: TextStyle(fontSize: 18)),
                horizontalTitleGap: 2,
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.power_settings_new),
                title: Text("Log Out", style: TextStyle(fontSize: 18)),
                horizontalTitleGap: 2,
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  pushNewScreenWithRouteSettings(
                    context,
                    screen: LoginPage(),
                    settings: RouteSettings(name: LoginPage.id),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
            ],
          )),
        ),
      ),
    );
  }
}
