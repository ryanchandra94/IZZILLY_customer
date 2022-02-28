import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:izzilly_customer/provider/coupon_provider.dart';
import 'package:provider/provider.dart';

class CouponWidget extends StatefulWidget {
  final String couponVendor;
  CouponWidget(this.couponVendor);

  @override
  _CouponWidgetState createState() => _CouponWidgetState();
}

class _CouponWidgetState extends State<CouponWidget> {
  Color color = Colors.grey;
  bool _enable = false;
  bool _visible = false;

  var _couponText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _coupon = Provider.of<CouponProvider>(context);

    return Container(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: TextField(
                    controller: _couponText,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText: 'Enter Voucher code',
                        hintStyle: TextStyle(color: Colors.grey)),
                    onChanged: (String value) {
                      if (value.length < 3) {
                        if (mounted) {
                          setState(() {
                            color = Colors.grey;
                            _enable = false;
                          });
                        }
                      }
                      if (value.isNotEmpty) {
                        if (mounted) {
                          setState(() {
                            color = Theme.of(context).primaryColor;
                            _enable = true;
                          });
                        }
                      }
                    },
                  ),
                ),
              ),
              AbsorbPointer(
                absorbing: _enable ? false : true,
                child: OutlineButton(
                    borderSide: BorderSide(color: color),
                    onPressed: () {
                      EasyLoading.show(status: 'Validating COupon...');
                      _coupon
                          .getCouponDetails(
                              _couponText.text, widget.couponVendor)
                          .then((value) {
                        if (_coupon.document == null) {
                          if (mounted) {
                            setState(() {
                              _coupon.discountRate = 0;
                              _visible = false;
                            });
                            EasyLoading.dismiss();
                            showDialog(_couponText.text, 'not valid');
                            return;
                          }
                        }
                        if(_coupon.expired==false){
                          if(mounted){
                            setState(() {
                              _visible = true;
                            });
                          }
                          EasyLoading.dismiss();
                          return;
                        }
                        if(_coupon.expired==true){
                          if(mounted){
                            setState(() {
                              _coupon.discountRate=0;
                              _visible=false;
                            });
                          }
                          EasyLoading.dismiss();
                          showDialog(_couponText.text, 'Expired');
                        }
                      });
                    },
                    child: Text(
                      'Apply',
                      style: TextStyle(color: color),
                    )),
              )
            ],
          ),
        ),
        Visibility(
          visible: _visible,
          child: _coupon.document==null? Container():Padding(
            padding: const EdgeInsets.all(8.0),
            child: DottedBorder(
                child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.lightBlueAccent.withOpacity(.4)),
                          width: MediaQuery.of(context).size.width - 80,
                          child: Column(
                            children: [
                              if(_coupon.document!=null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(_coupon.document['title']),
                              ),
                              Divider(
                                color: Colors.grey[800],
                              ),
                              if(_coupon.document!=null)
                              Text(_coupon.document['details']),
                              if(_coupon.document!=null)
                              Text('${_coupon.document['discountRate']}% discount'),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                            right: -5,
                            top: -10,
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.clear),
                            ))
                      ],
                    ))),
          ),
        )
      ],
    ));
  }

  showDialog(code, validity) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('APPLY COUPON'),
            content: Text(
                'this discount coupon $code you have entered is $validity. Please try with another code'),
            actions: [
              FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('OK', style: TextStyle(color: Theme.of(context).primaryColor),))
            ],
          );
        });
  }
}
