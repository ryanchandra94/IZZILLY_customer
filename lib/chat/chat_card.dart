import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/API_service/user_service.dart';
import 'package:intl/intl.dart';
import 'package:izzilly_customer/chat/chat_screens.dart';
import 'package:izzilly_customer/model/popup_model.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';

class ChatCard extends StatefulWidget {
  final Map<String, dynamic> chatData;
  ChatCard(this.chatData);
  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  UserServices _services = UserServices();
  CustomPopupMenuController _controller = CustomPopupMenuController();

  DocumentSnapshot doc;
  DocumentSnapshot storeDoc;
  String _lastChatDate='';
  StoreServices _storeServices = StoreServices();



  @override
  void initState() {
    _services
        .getProductDetail(widget.chatData['product']['productId'])
        .then((value) {
      setState(() {
        doc = value;
        _storeServices.getVendorDetails(value['seller']['selleruid']).then((result) {
          storeDoc = result;
        });
      });
    });
    getChatTime();
    super.initState();
  }
  List<PopUpMenuModel> menuItems = [
  PopUpMenuModel('Delete Chat', Icons.delete),
  ];

  getChatTime() {
    var _date = DateFormat.yMMMd().format(
        DateTime.fromMicrosecondsSinceEpoch(widget.chatData['lastChatTime']));
    var _today = DateFormat.yMMMd().format(
        DateTime.fromMicrosecondsSinceEpoch(DateTime.now().microsecondsSinceEpoch));
    if(_date==_today){
      if(mounted){
        setState(() {
          _lastChatDate = 'Today';
        });
      }else{
        if(mounted){
          setState(() {
            _lastChatDate = _date.toString();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return doc == null
        ? Container(
            child: Center(
              child: Text('No Chat'),
            ),
          )
        : Container(
            child: Stack(
              children: [
                SizedBox(height: 10,),
                ListTile(
                  onTap: (){
                    _services.messages.doc(widget.chatData['chatRoomId']).update({
                      'user_read' : 'true',
                    });
                    pushNewScreenWithRouteSettings(
                      context,
                      settings: RouteSettings(name: ChatScreen.id),
                      screen: ChatScreen(chatRoomId: widget.chatData['chatRoomId'], doc: storeDoc,),
                      withNavBar: true,
                      pageTransitionAnimation:
                      PageTransitionAnimation.cupertino,
                    );
                  },
                  leading: Container(
                      width: 70,
                      height: 70,
                      child: doc['productImage']!= null ? Image.network(doc['productImage']) : Container()),
                  title: Text(doc['seller']['shopName'], style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.chatData['lastChat'] != null)
                        Text(
                          widget.chatData['lastChat'],
                          maxLines: 1,
                          style: TextStyle(fontSize: 10),
                        )
                    ],
                  ),
                  /*trailing: IconButton(
                    icon: Icon(Icons.more_vert_sharp),
                    onPressed: () {},
                  ),*/

                ),
                Positioned(
                  right: 10.0,
                  top: 5.0,
                  child: Text(_lastChatDate),
                )
              ],
            ),
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
          );
  }
}
