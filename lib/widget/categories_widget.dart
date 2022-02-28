import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/product_service.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/page/product_list.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';



class VendorCategories extends StatefulWidget {
  @override
  _VendorCategoriesState createState() => _VendorCategoriesState();
}

class _VendorCategoriesState extends State<VendorCategories> {

  ProductServices _services = ProductServices();
  List _catList = [];
  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    
    FirebaseFirestore.instance.collection('products').where('seller.selleruid', isEqualTo: _store.storedetails['uid']).get().then((QuerySnapshot querySnapshot) =>
    {querySnapshot.docs.forEach((doc) {
      setState(() {
        _catList.add(doc['category']['categoryName']);
      });
    })
    });
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {

    var _store1 = Provider.of<StoreProvider>(context);
    _store1.selectedCategory(null);
    return FutureBuilder(
        future: _services.category.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot){
          if(snapshot.hasError){
            return Center(
              child: Text('Something went wrong....'),
            );
          }
          if(_catList.length==0){
            return Center(child: Container(),);
          }
          if(!snapshot.hasData){return Container();}
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        image: DecorationImage(

                          image: AssetImage('image/categories.png',)
                        )
                      ),

                    ),
                  ),
                ),
                Wrap(
                  direction: Axis.horizontal,
                  children: snapshot.data.docs.map((DocumentSnapshot document) {
                    return _catList.contains(document['name']) ?
                    InkWell(
                      onTap: (){
                        _store1.selectedCategory(document['name']);
                        _store1.selectedSubCategory(null);
                        pushNewScreenWithRouteSettings(
                          context,
                          settings: RouteSettings(name: ProductListScreen.id),
                          screen: ProductListScreen(),
                          withNavBar: true,
                          pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Container(
                        width: 120,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: .5,
                              )
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Center(
                                  child: Image.network(document['imageUrl']),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10,left: 8, right: 8),
                                child: Text(document['name'], textAlign: TextAlign.center,),
                              )
                            ],
                          ),
                        ),
                      ),
                    ) :
                    Text('');
                  }).toList(),
                ),
              ],
            )
          );
      },
    );
  }
}
