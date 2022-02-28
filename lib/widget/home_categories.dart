import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/product_service.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:izzilly_customer/widget/product/home_product_list.dart';
import 'package:izzilly_customer/widget/product/home_product_list_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class HomeCategories extends StatefulWidget {
  @override
  _HomeCategoriesState createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State<HomeCategories> {
  ProductServices _services = ProductServices();
  List _catList = [];
  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
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

    return FutureBuilder(
      future: _services.category.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Something went wrong....'),
          );
        }
        if (_catList.length == 0) {
          return Center(
            child: Container(),
          );
        }
        if (!snapshot.hasData) {
          return Container();
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 25,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text('Categories', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                ),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return InkWell(
                    onTap: () {
                      _store1.selectedCategory(document['name']);
                      pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: HomeProductListScreen.id),
                        screen: HomeProductListScreen(),
                        withNavBar: true,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, right: 4, left: 4),
                      child: Container(
                        width: 120,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 120,
                              height: 100,
                              child: Card(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(
                                        document['imageUrl'],
                                      ))),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 8, right: 8),
                              child: Text(
                                document['name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        );

        /*SingleChildScrollView(
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
                        pushNewScreenWithRouteSettings(
                          context,
                          settings: RouteSettings(name: HomeProductListScreen.id),
                          screen: HomeProductListScreen(),
                          withNavBar: true,
                          pageTransitionAnimation:
                          PageTransitionAnimation.cupertino,
                        );
                      },
                      child: Container(
                        width: 100,
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
                                padding: const EdgeInsets.only(top: 10),
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
        );*/
      },
    );
  }
}
