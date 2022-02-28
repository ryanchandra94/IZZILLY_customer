import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/product_service.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:provider/provider.dart';

class
ProductFilterWidget extends StatefulWidget {
  @override
  _ProductFilterWidgetState createState() => _ProductFilterWidgetState();
}

class _ProductFilterWidgetState extends State<ProductFilterWidget> {
  List _subCatList = [];
  ProductServices _services = ProductServices();

  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
        .collection('products')
    .where('category.categoryName', isEqualTo: _store.selectedProductCategory)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _subCatList.add(doc['category']['subCategoryName']);
        });
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    var _storeData =  Provider.of<StoreProvider>(context);


    return FutureBuilder<DocumentSnapshot>(
      future: _services.category.doc(_storeData.selectedProductCategory).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }


        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data() as Map<String, dynamic>;
          return Container(
            height: 35,
            color: Colors.grey,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 10,),
                ActionChip(
                  elevation: 4,
                  
                  label: Text('All ${_storeData.selectedProductCategory}'),
                  onPressed: (){
                    _storeData.selectedSubCategory(null);
                  },
                  backgroundColor: Colors.white,
                ),
                ListView.builder(
                  shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: ScrollPhysics(),
                    itemBuilder: (BuildContext context, int index){
                     return Padding(
                       padding: const EdgeInsets.only(left: 8.0),
                       child:
                       _subCatList.contains(data['SubCat'][index]['name'])?

                       ActionChip(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)
                          ),
                          label: Text(data['SubCat'][index]['name']),
                          onPressed: (){
                            _storeData.selectedSubCategory(data['SubCat'][index]['name']);
                          },
                          backgroundColor: Colors.white,
                        ) : Container()
                     );
                    },
                    itemCount: data.length,
                    )
              ],

            ),
          );
        }

        return Container();
      },
    );
  }
}
