import 'dart:async';
import 'package:adobe_xd/pinned.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:izzilly_customer/API_service/cart_provider.dart';
import 'package:izzilly_customer/API_service/register_customer.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/page/Home_screen.dart';
import 'package:izzilly_customer/page/HotSalesScreen.dart';
import 'package:izzilly_customer/page/Product_detail_screen.dart';
import 'package:izzilly_customer/page/SIgnIn.dart';
import 'package:izzilly_customer/page/cart_screen.dart';
import 'package:izzilly_customer/chat/chat_screens.dart';
import 'package:izzilly_customer/page/login_screen.dart';
import 'package:izzilly_customer/page/main_screen.dart';
import 'package:izzilly_customer/page/map_screen.dart';
import 'package:izzilly_customer/page/map_screen_profile.dart';
import 'package:izzilly_customer/page/my_orders_screen.dart';
import 'package:izzilly_customer/page/payment/create_new_card.dart';
import 'package:izzilly_customer/page/payment/credit_card_list.dart';
import 'package:izzilly_customer/page/payment/paypal_screen.dart';
import 'package:izzilly_customer/page/payment/razorpay/razorpay_payment_screen.dart';
import 'package:izzilly_customer/page/payment/stripe/existing-cards.dart';
import 'package:izzilly_customer/page/payment/payment-home.dart';
import 'package:izzilly_customer/page/product_list.dart';
import 'package:izzilly_customer/page/profile_screen.dart';
import 'package:izzilly_customer/page/profile_update_screen.dart';
import 'package:izzilly_customer/page/signup_screen.dart';
import 'package:izzilly_customer/page/vendor_home_screen.dart';
import 'package:izzilly_customer/page/welcome_screen.dart';
import 'package:izzilly_customer/provider/coupon_provider.dart';
import 'package:izzilly_customer/provider/location_provider.dart';
import 'package:izzilly_customer/provider/order_provider.dart';
import 'package:izzilly_customer/provider/payment_provider.dart';
import 'package:izzilly_customer/provider/product_provider.dart';
import 'package:izzilly_customer/widget/product/home_product_list.dart';
import 'package:izzilly_customer/widget/product/home_product_list_screen.dart';
import 'package:izzilly_customer/widget/reset_password.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';


void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.grey,
    statusBarColor: Colors.grey,
  ));
  await Firebase.initializeApp();
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => StoreProvider()),
            Provider(create: (context) => StoreProvider()),
            ChangeNotifierProvider(create: (_) => LocationProvider()),
            ChangeNotifierProvider(create: (_) => CartProvider()),
            ChangeNotifierProvider(create: (_) => CouponProvider()),
            ChangeNotifierProvider(create: (_) => OrderProvider()),
            ChangeNotifierProvider(create: (_) => ProductProvider()),

    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme:
          ThemeData(primaryColor: Colors.lightBlueAccent, fontFamily: 'Lato'),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginPage.id: (context) => LoginPage(),
        SignupPage.id: (context) => SignupPage(),
        HomePage.id: (context) => HomePage(),
        ResetPassword.id: (context) => ResetPassword(),
        MainScreen.id: (context)=> MainScreen(),
        VendorHomeScreen.id: (context) => VendorHomeScreen(),
        MapScreen.id : (context) => MapScreen(),
        ProductListScreen.id : (context) => ProductListScreen(),
        HomeProductList.id : (context) => HomeProductList(),
        HomeProductListScreen.id : (context) => HomeProductListScreen(),
        ProductDetailScreen.id : (context) => ProductDetailScreen(),
        CartScreen.id : (context) => CartScreen(),
        ProfileScreen.id : (context) => ProfileScreen(),
        UpdateProfile.id : (context) => UpdateProfile(),
        ExistingCardsPage.id : (context) => ExistingCardsPage(),
        PaymentHome.id : (context) => PaymentHome(),
        MyOrders.id : (context) => MyOrders(),
        CreditCardList.id : (context) => CreditCardList(),
        CreateNewCreditCard.id : (context) => CreateNewCreditCard(),
        RazorpayPaymentScreen.id : (context) => RazorpayPaymentScreen(),
        MapProfile.id : (context) => MapProfile(),
        PaypalPayment.id : (context) => PaypalPayment(),
        ChatScreen.id : (context) => ChatScreen(),
        HotSalesScreen.id : (context) => HotSalesScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  static const String id = 'Splash-screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  User user = FirebaseAuth.instance.currentUser;



  
  
  @override
  void initState() {
    Timer(
        Duration(
          seconds: 3,
        ), () {
      FirebaseAuth.instance.currentUser == null
          ? Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SIgnIn()))
          : Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => MainScreen()));
    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: Stack(
          children: <Widget>[
            Pinned.fromPins(
              Pin(start: 0.0, end: 0.0),
              Pin(size: 139.0, middle: 0.5007),
              child:
              // Adobe XD layer: 'izzilly' (shape)
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: const AssetImage('image/logo_app.png', ),

                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

const String _svg_vohmv6 =
    '<svg viewBox="177.1 390.0 28.9 27.5" ><path transform="translate(177.11, 389.96)" d="M 15.13320446014404 0.5006307363510132 L 18.82789611816406 9.140384674072266 L 28.20330047607422 9.979447364807129 C 28.5029125213623 10.00611019134521 28.75782203674316 10.20872497558594 28.85140609741211 10.49459266662598 C 28.94499206542969 10.7804594039917 28.85924911499023 11.0945930480957 28.63340759277344 11.29327297210693 L 28.63340759277344 11.29327297210693 L 21.53780937194824 17.48165130615234 L 23.6342887878418 26.64787483215332 C 23.70366859436035 26.94715118408203 23.58405303955078 27.2585391998291 23.33215713500977 27.43440246582031 C 23.08025741577148 27.61026382446289 22.7467212677002 27.61524391174316 22.48968696594238 27.44698143005371 L 14.43986034393311 22.63824081420898 L 6.366533279418945 27.46578598022461 C 6.108006000518799 27.6201229095459 5.782347202301025 27.60540390014648 5.538798809051514 27.42836952209473 C 5.295250415802002 27.2513370513916 5.180755138397217 26.94611358642578 5.24778413772583 26.6525764465332 L 5.247783660888672 26.6525764465332 L 7.344264030456543 17.48635292053223 L 0.2557165026664734 11.29327201843262 C 0.02664655633270741 11.09244823455811 -0.05865497514605522 10.77327442169189 0.03968531265854836 10.48494720458984 C 0.1380256563425064 10.19661998748779 0.400582492351532 9.996091842651367 0.7046264410018921 9.977096557617188 L 10.04477405548096 9.140384674072266 L 13.7465181350708 0.5006307363510132 C 13.8638391494751 0.2215128093957901 14.13708972930908 0.03995955735445023 14.43986225128174 0.03995966911315918 C 14.74263381958008 0.03995966911315918 15.01588439941406 0.221513032913208 15.13320446014404 0.5006307363510132 Z" fill="#2bc6ed" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
