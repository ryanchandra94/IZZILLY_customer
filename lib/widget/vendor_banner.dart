import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:provider/provider.dart';

class VendorBanner extends StatefulWidget {
  @override
  _VendorBannerState createState() => _VendorBannerState();
}

class _VendorBannerState extends State<VendorBanner> {
  var _index = 0;
  int _dataLength = 1;
  StoreServices _services = StoreServices();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    var _storeProvider = Provider.of<StoreProvider>(context);
    getVendorBannerFromDb(_storeProvider);
    super.didChangeDependencies();
  }

  Future getVendorBannerFromDb(StoreProvider storeProvider) async {
    var _firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _firestore
        .collection('vendorBanner')
        .where('selleruid', isEqualTo: storeProvider.storedetails['uid'])
        .get();
    if (mounted) {
      setState(() {
        _dataLength = snapshot.docs.length;
      });
    }
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if (_dataLength != 0)
            FutureBuilder(
              future: getVendorBannerFromDb(_store),
              builder: (_, snapShot) {
                return snapShot.data == null
                    ? CircularProgressIndicator()
                    : Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: CarouselSlider.builder(
                          itemCount: snapShot.data.length,
                          options: CarouselOptions(
                            onPageChanged: (int i, CarouselPageChangedReason) {
                              setState(() {
                                _index = i;
                              });
                            },
                            initialPage: 0,
                            autoPlay: true,
                            height: 180,
                          ),
                          itemBuilder: (context, int index, _) {
                            DocumentSnapshot sliderImage = snapShot.data[index];
                            Map getImage = sliderImage.data();
                            return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Image.network(
                                      getImage['imageUrl'],
                                      fit: BoxFit.fill,
                                    )));
                          },
                        ),
                      );
              },
            ),
          if (_dataLength != 0)
            DotsIndicator(
              dotsCount: _dataLength,
              position: _index.toDouble(),
              decorator: DotsDecorator(
                size: const Size.square(5.0),
                activeSize: const Size(18.0, 5.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
              ),
            ),
        ],
      ),
    );
  }
}
