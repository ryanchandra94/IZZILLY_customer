import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/model/popup_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices{
  User user = FirebaseAuth.instance.currentUser;
  String collection = 'customers';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference messages = FirebaseFirestore.instance.collection('messages');
  CollectionReference products = FirebaseFirestore.instance.collection('products');

  Future<DocumentSnapshot> getUserById(String uid) async{
    var result = await _firestore.collection(collection).doc(uid).get();

    return result;
  }

  Future<void> updateUserData(Map<String, dynamic> values) async{
    String id = values['id'];
    await _firestore.collection(collection).doc(id).update(values);
  }

  Future<DocumentSnapshot> getProductDetail(id) async{
    DocumentSnapshot doc = await products.doc(id).get();
    return doc;
  }

  createChatRoom({chatData}){
    messages.doc(chatData['chatRoomId']).set(chatData).catchError((e){
        print(e.toString());
    });
  }

  createChat(String chatRoomId, message){
    messages.doc(chatRoomId).collection('chats').add(message).catchError((e){
      print(e.toString());
    });
    messages.doc(chatRoomId).update({
      'lastChat':message['message'],
      'lastChatTime' : message['time'],
      'user_read': false,
      'vendor_read': false,
    });

  }

  getChat(chatRoomId)async{
    return messages.doc(chatRoomId).collection('chats').orderBy('time').snapshots();
  }

  deleteChat(chatRoomId)async{

    return messages.doc(chatRoomId).delete();
  }

  popUpMenu(chatData, context){
    CustomPopupMenuController _controller = CustomPopupMenuController();
    List<PopUpMenuModel> menuItems = [
      PopUpMenuModel('Delete Chat', Icons.delete),
    ];
    return CustomPopupMenu(
      child: Container(
        child: Icon(Icons.more_vert_sharp, color: Colors.black),
        padding: EdgeInsets.all(20),
      ),
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: const Color(0xFF4C4C4C),
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: menuItems
                  .map(
                    (item) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    if(item.title == 'Delete Chat'){
                      deleteChat(chatData['chatRoomId']);
                      _controller.hideMenu();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Chat has been deleted'),
                      ));
                    }
                  },
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          item.icon,
                          size: 15,
                          color: Colors.white,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            padding:
                            EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              item.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ),
      pressType: PressType.singleClick,
      verticalMargin: -10,
      controller: _controller,
    );
  }

}


