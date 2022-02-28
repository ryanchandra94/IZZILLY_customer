import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:izzilly_customer/page/signup_screen.dart';
import 'package:izzilly_customer/provider/location_provider.dart';
import 'package:provider/provider.dart';

class MapProfile extends StatefulWidget {
  static const String id = 'map-screen-profile';
  @override
  _MapProfileState createState() => _MapProfileState();
}

class _MapProfileState extends State<MapProfile> {
  LatLng currentLocation;
  GoogleMapController _mapController;
  bool _locating = false;


  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    setState(() {
      currentLocation = LatLng(locationData.latitude, locationData.longitude);
    });

    void onCreated(GoogleMapController controller) {
      setState(() {
        _mapController = controller;
      });
    }

    return Scaffold(
      body: Center(
          child: SafeArea(
            child: Stack(children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentLocation,
                  zoom: 14.4746,
                ),
                zoomControlsEnabled: false,
                minMaxZoomPreference: MinMaxZoomPreference(1.5, 20.8),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapType: MapType.normal,
                mapToolbarEnabled: true,
                onCameraMove: (CameraPosition position) {
                  setState(() {
                    _locating = true;
                  });
                  locationData.onCameraMove(position);
                },
                onMapCreated: onCreated,
                onCameraIdle: () {
                  setState(() {
                    _locating = false;
                  });
                  locationData.getMoveCamera();
                },
              ),
              Center(
                  child: Container(
                      height: 50,
                      margin: EdgeInsets.only(bottom: 40),
                      child: Image.asset(
                        'image/position.png',
                        scale: 5,
                      ))),
              Positioned(
                bottom: 0.0,
                child: Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _locating
                          ? LinearProgressIndicator(
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(left:10, right: 20),
                        child: TextButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.location_searching, color: Theme.of(context).primaryColor,),
                            label: Text(
                              _locating
                                  ? 'Locating....'
                                  : locationData.selectedAddress.featureName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(locationData.selectedAddress.addressLine),
                      ),
                      SizedBox(height: 15,),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width-40,
                          child: AbsorbPointer(
                            absorbing: _locating ? true : false,
                            child: FlatButton(
                              onPressed: (){
                                locationData.savePrefs();

                                Navigator.pop(context);
                              },
                              color: _locating ? Colors.grey : Theme.of(context).primaryColor,
                              child: Text('Confirm Location', style: TextStyle(color: Colors.white),),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          )),
    );
  }
}
