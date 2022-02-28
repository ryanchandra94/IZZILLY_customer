import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izzilly_customer/API_service/store_service.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;
import 'package:url_launcher/url_launcher.dart';


class GoogleMapVendor extends StatefulWidget {

  final DocumentSnapshot document;
  GoogleMapVendor({this.document});

  @override
  State<GoogleMapVendor> createState() => _GoogleMapVendorState();
}

class _GoogleMapVendorState extends State<GoogleMapVendor> {

  GoogleMapController _controller;

  StoreProvider _store = StoreProvider();
  DocumentSnapshot doc;
  GeoPoint _location;
  var userId;

  @override
  void initState() {

    super.initState();
    _store.getShopDetails(widget.document['seller']['selleruid']).then((value) {
      if(mounted){
        setState(() {
          doc = value;
          _location = value['location'];
        });
      }
    });
  }

  _mapLauncher(location)async{
    final availableMaps = await launcher.MapLauncher.installedMaps;

    await availableMaps.first.showMarker(
        coords: launcher.Coords(location.latitude, location.longitude),
        title: 'vendor map');
  }




  @override
  Widget build(BuildContext context) {

  //GeoPoint _location = doc['location'] !=null ? doc['location'] : GeoPoint(30.98, 120.99);

    return Container(
    height: 200,
    color: Colors.grey.shade300,
    child: Stack(
    children:[
      _location != null ? Center(
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(_location.latitude, _location.longitude),
          zoom: 15
        ),
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller){
          if(mounted){
            _controller = controller;
          }
        },
      )
    ) : Container(),
      Center(child: Icon(Icons.location_on, size: 35,)),
      Center(child: CircleAvatar(radius: 60, backgroundColor: Colors.black12,),),
      Positioned(
        right: 4.0,
        top: 4.0,
        child: Material(
          elevation: 4,
          shape: Border.all(color: Colors.grey),
          child: IconButton(
            icon: Icon(Icons.alt_route_outlined),
            onPressed: (){
                _mapLauncher(_location);
            },
          ),
        ),
      )
    ]
    ),
    );

  }
}
