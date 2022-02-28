import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:izzilly_customer/page/login_screen.dart';
import 'package:izzilly_customer/page/map_screen.dart';
import 'package:izzilly_customer/provider/location_provider.dart';
import 'package:provider/provider.dart';
import './SIgnIn2.dart';
import 'package:adobe_xd/page_link.dart';
import './SIgnIn.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SIgnIn1 extends StatefulWidget {
  SIgnIn1({
    Key key,
  }) : super(key: key);

  @override
  State<SIgnIn1> createState() => _SIgnIn1State();
}

class _SIgnIn1State extends State<SIgnIn1> {
  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          Pinned.fromPins(
            Pin(start: 0.0, end: 0.0),
            Pin(size: 457.0, start: 0.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0x666e5e5e),
                border: Border.all(width: 1.0, color: const Color(0x66707070)),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: -47.0, end: -21.0),
            Pin(start: 0.0, end: 226.0),
            child:
                // Adobe XD layer: 'chefimage' (shape)
                Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('image/page3.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Pinned.fromPins(
            Pin(start: 0.0, end: 0.0),
            Pin(size: 433.8, end: 0.0),
            child:
                // Adobe XD layer: 'The New Standard' (group)
                Stack(
              children: <Widget>[
                Pinned.fromPins(
                  Pin(start: 0.0, end: 0.0),
                  Pin(start: 0.0, end: 0.0),
                  child: SvgPicture.string(
                    _svg_tg0u0,
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                  ),
                ),
                Pinned.fromPins(
                  Pin(start: 65.0, end: 65.0),
                  Pin(size: 120.0, middle: 0.3899),
                  child: Text(
                    'If you have services to offer register NOW!',
                    style: TextStyle(
                      fontFamily: 'Segoe UI',
                      fontSize: 30,
                      color: const Color(0xff000000),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Pinned.fromPins(
                  Pin(size: 65.0, middle: 0.5012),
                  Pin(size: 15.0, middle: 0.7319),
                  child:
                      // Adobe XD layer: 'PageIndicator' (group)
                      Stack(
                    children: <Widget>[
                      Pinned.fromPins(
                        Pin(size: 15.0, middle: 0.5),
                        Pin(start: 0.0, end: 0.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.elliptical(9999.0, 9999.0)),
                            color: const Color(0xff2bc6ed),
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 15.0, end: 0.0),
                        Pin(start: 0.0, end: 0.0),
                        child: PageLink(
                          links: [
                            PageLinkInfo(
                              transition: LinkTransition.Fade,
                              ease: Curves.easeOut,
                              duration: 0.3,
                              pageBuilder: () => SIgnIn2(),
                            ),
                          ],
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(9999.0, 9999.0)),
                              color: const Color(0x662bc6ed),
                            ),
                          ),
                        ),
                      ),
                      Pinned.fromPins(
                        Pin(size: 15.0, start: 0.0),
                        Pin(start: 0.0, end: 0.0),
                        child: PageLink(
                          links: [
                            PageLinkInfo(
                              transition: LinkTransition.Fade,
                              ease: Curves.easeOut,
                              duration: 0.3,
                              pageBuilder: () => SIgnIn(),
                            ),
                          ],
                          child: SvgPicture.string(
                            _svg_r8kwtf,
                            allowDrawingOutsideViewBox: true,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Pinned.fromPins(
              Pin(start: 0, end: -10),
              Pin(size:120.9, middle: 1),
              child:Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FlatButton(
                        color: Colors.blueAccent,
                        onPressed: ()async{
                          setState(() {
                            locationData.loading=true;
                          });
                          await locationData.getCurrentPosition();
                          if(locationData.permissionAllowed==true){
                            Navigator.pushReplacementNamed(context, MapScreen.id);
                            setState(() {
                              locationData.loading = false;
                            });
                          }else{
                            print('permission not allowed');
                            setState(() {
                              locationData.loading = false;
                            });
                          }
                        },
                        child: locationData.loading ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ) : Text("Set Location to Sign Up", style: TextStyle(color: Colors.white),)
                    ),
                    SizedBox(width: 30,),
                    GestureDetector(
                        onTap: (){Navigator.pushReplacementNamed(context, LoginPage.id);},
                        child: Text('Already have account? Log In', style: TextStyle(color: Colors.lightBlueAccent, fontWeight: FontWeight.bold),))
                  ],
                ),
              )
            // Adobe XD layer: 'Sign In' (component)
            //SignIn(),
          )
        ],
      ),
    );
  }
}

const String _svg_tg0u0 =
    '<svg viewBox="0.0 425.5 412.0 433.8" ><path transform="translate(0.0, 477.94)" d="M 85.95883941650391 7.039246559143066 C 85.95883941650391 7.039246559143066 263.524658203125 7.039246559143066 344.9856567382812 7.039246559143066 C 394.6768493652344 7.039246559143066 411.9497680664062 -31.60113143920898 411.8027954101562 -44.66676330566406 C 411.71923828125 -52.473876953125 412.28564453125 -71.45996856689453 411.8027954101562 7.039246559143066 C 410.5647583007812 208.3192901611328 411.8027954101562 381.3228759765625 411.8027954101562 381.3228759765625 L 0 381.3228759765625 L 0 104.5798263549805 C 0 50.70965194702148 38.48508071899414 7.039246559143066 85.95883941650391 7.039246559143066 Z" fill="#ffffff" stroke="#707070" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_r8kwtf =
    '<svg viewBox="0.0 0.0 15.0 15.0" ><path  d="M 7.5 0 C 11.64213562011719 0 15 3.357864856719971 15 7.5 C 15 11.64213562011719 11.64213562011719 15 7.5 15 C 3.357864856719971 15 0 11.64213562011719 0 7.5 C 0 3.357864856719971 3.357864856719971 0 7.5 0 Z" fill="#2bc6ed" fill-opacity="0.4" stroke="none" stroke-width="1" stroke-opacity="0.4" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
