import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:izzilly_customer/API_service/payment_service/stripe-payment-service.dart';
import 'package:izzilly_customer/page/payment/create_new_card.dart';
import 'package:izzilly_customer/page/payment/paypal_screen.dart';
import 'package:izzilly_customer/page/payment/razorpay/razorpay_payment_screen.dart';
import 'package:izzilly_customer/page/payment/stripe/existing-cards.dart';
import 'package:izzilly_customer/provider/order_provider.dart';
import 'package:provider/provider.dart';


class PaymentHome extends StatefulWidget {
  static const String id = 'stripe-home';
  PaymentHome({Key key}) : super(key: key);

  @override
  PaymentHomeState createState() => PaymentHomeState();
}

class PaymentHomeState extends State<PaymentHome> {

  onItemPress(BuildContext context, int index, amount, orderProvider) async {
    switch(index) {
      case 0:
         Navigator.pushNamed(context, CreateNewCreditCard.id);
        break;
      case 1:
        payViaNewCard(context, amount, orderProvider );
        break;
      case 2:
        Navigator.pushNamed(context, ExistingCardsPage.id);
        break;
    }
  }

  payViaNewCard(BuildContext context, amount, OrderProvider orderProvider) async {

    await EasyLoading.show(status: 'Please wait...');
    var response = await StripeService.payWithNewCard(
      amount: '${amount}00',
      currency: 'USD'
    );
    if(response.success==true){
      orderProvider.success = true;
    }
    await EasyLoading.dismiss();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response.message),
        duration: new Duration(milliseconds: response.success == true ? 1200 : 3000),
      )
    ).closed.then((_) {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Payment', style: TextStyle(color: Colors.white, fontSize: 25),),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Material(
            elevation: 4,
            child: SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: Image.asset("image/paypal-logo.png",fit: BoxFit.fitWidth,),
                )),
          ),
          //TODO:Paypal
          Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 40, right: 40),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
                      onPressed: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => PaypalPayment(
                              onFinish: (number) async {

                                // payment done
                                print('order id: '+number);

                              },
                            ),
                          ),
                        );

                      },
                      child: Text('Proceed to payment...'),
                    ),
                  ),
                ],
              )          ),
          Divider(color: Colors.grey,),
          Material(
            elevation: 4,
            child: SizedBox(
              height: 60,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                  child: Image.asset("image/stripe-logo.png",fit: BoxFit.fitWidth,),
                )),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: ListView.separated(
              shrinkWrap: true,
                itemBuilder: (context, index) {
                  Icon icon;
                  Text text;

                  switch(index) {
                    case 0:
                      icon = Icon(Icons.add_circle, color: theme.primaryColor);
                      text = Text('Add Cards');
                      break;
                    case 1:
                      icon = Icon(Icons.payment_outlined, color: theme.primaryColor);
                      text = Text('Pay via new card');
                      break;
                    case 2:
                      icon = Icon(Icons.credit_card, color: theme.primaryColor);
                      text = Text('Pay via existing card');
                      break;
                  }

                  return InkWell(
                    onTap: () {
                      onItemPress(context, index, orderProvider.amount, orderProvider);
                    },
                    child: ListTile(
                      title: text,
                      leading: icon,
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: theme.primaryColor,
                ),
                itemCount: 3
            ),
          ),
        ],
      )
    );
  }
}