import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:izzilly_customer/provider/order_provider.dart';
import 'package:provider/provider.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentScreen extends StatefulWidget {
  static const String id = 'razorpay-screen';

  @override
  _RazorpayPaymentScreenState createState() => _RazorpayPaymentScreenState();
}

class _RazorpayPaymentScreenState extends State<RazorpayPaymentScreen> {
  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;
  bool success;

  Future<void> openCheckout(OrderProvider orderProvider) async {


    User user = FirebaseAuth.instance.currentUser;
    PaymentSuccessResponse response;

    var options = {
      'key': 'rzp_test_QsKdr2qiGwrAcZ',
      'amount': '${orderProvider.amount}00',
      'name': orderProvider.shopName,
      'description': 'Fine T-Shirt',
      'prefill': {'contact': orderProvider.phoneNumber, 'email': orderProvider.email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);

    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if(mounted){
      success = true;
    }
    //EasyLoading.showSuccess("SUCCESS: " + response.paymentId,);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    EasyLoading.show(
      status: "ERROR: " + response.code.toString() + " - " + response.message,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    EasyLoading.show(
      status: "EXTERNAL_WALLET: " + response.walletName,
    );
  }


  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text('Payment Razorpay', style: TextStyle(color: Colors.white),),
        ),
        body: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total Amount to Pay:  \n\$${orderProvider.amount}',
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor)),
                      onPressed: (){
                        openCheckout(orderProvider).whenComplete(() {
                          if(success=true){
                            orderProvider.paymentStatus(true);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: Text('Continue', style: TextStyle(color: Colors.white),))
                ],
              )
            ])),
      ),
    );
  }




}
