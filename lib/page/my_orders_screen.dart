import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/order_service.dart';
import 'package:intl/intl.dart';
import 'package:izzilly_customer/provider/order_provider.dart';
import 'package:provider/provider.dart';

class MyOrders extends StatefulWidget {
  static const String id = 'order-screen';
  @override
  State<MyOrders> createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  OrderServices _orderServices = OrderServices();
  User user = FirebaseAuth.instance.currentUser;

  int tag = 0;
  List<String> options = [
    'All Orders', 'Ordered','Accepted','Rejected',
    'Done'
  ];

  @override
  Widget build(BuildContext context) {

    var _orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text(
            'My Orders',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                CupertinoIcons.search,
                color: Colors.white,
              ),
              onPressed: () {},
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: ChipsChoice<int>.single(
                choiceStyle: C2ChoiceStyle(borderRadius:BorderRadius.all(Radius.circular(3))),
                value: tag,
                onChanged: (val) {
                  if(val == 0){
                    _orderProvider.status = null;
                  }
                  setState(() =>
                  {
                    tag = val,
                    if(tag > 0){
                      _orderProvider.filterOrder(options[val])
                    }
                  });

                },
                choiceItems: C2Choice.listFrom<int, String>(
                  source: options,
                  value: (i, v) => i,
                  label: (i, v) => v,
                ),
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _orderServices.orders
                    .where('userId', isEqualTo: user.uid)
                    .where('orderStatus', isEqualTo: tag>0 ? _orderProvider.status : null)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data.size==0) {
                    return Center(
                      child: Text(tag>0 ? 'No ${options[tag]} order' : 'No Orders'),
                    );
                  }

                  return Expanded(
                    child: Column(
                      children: [

                    Expanded(
                    child: new ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                      return new Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            ListTile(
                                horizontalTitleGap: 0,
                                leading: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 14,
                                  child: Icon(
                                    CupertinoIcons.square_list,
                                    size: 18,
                                    color: document['orderStatus'] == 'Rejected'
                                        ? Colors.red : document['orderStatus'] == 'Accepted' ? Colors.lightBlueAccent
                                        : Colors.black,
                                  ),
                                ),
                                title: Text(
                                  document['orderStatus'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: document['orderStatus'] == 'Rejected'
                                          ? Colors.red : document['orderStatus'] == 'Accepted' ? Colors.lightBlueAccent
                                          : Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'On ${DateFormat.yMMMd().format(DateTime.parse(document['timestamp']))}',
                                  style: TextStyle(fontSize: 12),
                                ),
                                trailing: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Payment Type: ${document['cod'] == true ? 'Cash on Delivery' : 'Paid Online'}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Amount:  \$ ${document['total'].toStringAsFixed(0)}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),

                                  ],
                                )),
                            ExpansionTile(
                              title: Text(
                                'Order Details',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: Colors.black),
                              ),
                              subtitle: Text(
                                'View Order Details',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: Image.network(
                                            document['products'][index]
                                            ['productImage']),
                                      ),
                                      title: Text(document['products'][index]
                                      ['productName']),
                                      subtitle: Text(
                                          '\$${document['products'][index]['price']}'),
                                    );
                                  },
                                  itemCount: document['products'].length,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 8, bottom: 8),
                                  child: Card(
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Seller : ',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              Text(
                                                document['seller']
                                                ['shopName'],
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          if (int.parse(
                                              document['discount']) >
                                              0)
                                            Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'Discount : ',
                                                        style: TextStyle(
                                                            color:
                                                            Colors.black,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
                                                      ),
                                                      Text(
                                                        '\$${document['discount']}',
                                                        style: TextStyle(
                                                            color:
                                                            Colors.grey,
                                                            fontSize: 15),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  if(document['discountCode']!=null)
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Discount Code : ',
                                                          style: TextStyle(
                                                              color:
                                                              Colors.black,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                        Text(
                                                          '${document['discountCode']}',
                                                          style: TextStyle(
                                                              color:
                                                              Colors.grey,
                                                              fontSize: 15),
                                                        )
                                                      ],
                                                    ),
                                                ],
                                              ),
                                            ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              height: 3,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    ),
                    )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
