import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';

class PaymentProvider with ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  PaymentMethod _paymentMethod = PaymentMethod();

  PaymentProvider.initialize() {
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51JwnomCxCMRuGAnmN5g8ovCnkKk1CGADrA8q8d7fopaAx8GcMGbd0R0tP3fo9J4ij05UdbMScUhw2pnmjQ3N5RkA00EFQjR26T"));
  }

  void addCard() {
    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
        .then((paymentMethod) {
          _paymentMethod = paymentMethod;
    }).catchError((err){
      print('There was an error: ${err.toString()}');
    });
  }
}
