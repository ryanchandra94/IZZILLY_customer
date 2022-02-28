import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/widget/cart/counter.dart';
import 'package:intl/intl.dart';

class CartCard extends StatefulWidget {
  final DocumentSnapshot document;
  CartCard({this.document});

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  final _format = NumberFormat('##,##,##0');
  var _price;
  var _compared;
  String _formattedComparedPrice;
  String _formattedPrice;

  @override
  void initState() {
    if(mounted){
      _price = int.parse(widget.document['price'].toStringAsFixed(0));
      _formattedPrice = '${_format.format(_price)}';

      _compared = int.parse(widget.document['comparedPrice']);
      _formattedComparedPrice = '${_format.format(_compared)}';
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {



    return Container(
        height: 130,
        decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[300],
              ),
            ),
            color: Colors.white),
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  height: 130,
                  width: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      widget.document['productImage'],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Container(
                  child: Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8),
                          child: new Container(
                            width: 300,
                              child: Text(widget.document['productName'],
                                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8),
                          child: Text(
                            '\$'+_formattedPrice,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red),
                          ),
                        ),
                        if (widget.document['comparedPrice'] != null)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0, top: 8),
                            child: Text(
                              '\$'+ _formattedComparedPrice,
                              style:
                                  TextStyle(decoration: TextDecoration.lineThrough, fontSize: 15, color: Colors.grey),
                            ),
                          ),

                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 8),
                          child: Text(widget.document['schedule'], style: TextStyle(fontSize: 20,
                              fontWeight: FontWeight.bold),),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 10,
              bottom: 10,
              child: CounterForCard(widget.document),
            ),

          ],
        ));
  }
}
