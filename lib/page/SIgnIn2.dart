import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:izzilly_customer/page/login_screen.dart';
import 'package:izzilly_customer/page/map_screen.dart';
import 'package:izzilly_customer/provider/location_provider.dart';
import 'package:provider/provider.dart';
import './SIgnIn1.dart';
import 'package:adobe_xd/page_link.dart';
import './SIgnIn.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SIgnIn2 extends StatefulWidget {
  SIgnIn2({
    Key key,
  }) : super(key: key);

  @override
  State<SIgnIn2> createState() => _SIgnIn2State();
}

class _SIgnIn2State extends State<SIgnIn2> {
  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);
    return SafeArea(
      child: Scaffold(
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
              Pin(start: -34.0, end: -34.0),
              Pin(start: -50.0, end: 230.0),
              child:
              // Adobe XD layer: 'chefimage' (shape)
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('image/page2.png'),
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
                    Pin(start: 49.0, end: 48.0),
                    Pin(size: 120.0, middle: 0.2815),
                    child: Text(
                      'Stop cold calling maximize your earnings with',
                      style: TextStyle(
                        fontFamily: 'Segoe UI',
                        fontSize: 30,
                        color: const Color(0xff000000),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Pinned.fromPins(
                    Pin(size: 200.0, middle: 0.5042),
                    Pin(size: 68.0, middle: 0.5932),
                    child:
                    // Adobe XD layer: 'izzilly' (shape)
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage('image/logo.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
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
                          child: PageLink(
                            links: [
                              PageLinkInfo(
                                transition: LinkTransition.Fade,
                                ease: Curves.easeOut,
                                duration: 0.3,
                                pageBuilder: () => SIgnIn1(),
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
                          Pin(size: 15.0, end: 0.0),
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
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(9999.0, 9999.0)),
                                color: const Color(0x662bc6ed),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              )
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

        )
      ),
    );
  }
}

const String _svg_tg0u0 =
    '<svg viewBox="0.0 425.5 412.0 433.8" ><path transform="translate(0.0, 477.94)" d="M 85.95883941650391 7.039246559143066 C 85.95883941650391 7.039246559143066 263.524658203125 7.039246559143066 344.9856567382812 7.039246559143066 C 394.6768493652344 7.039246559143066 411.9497680664062 -31.60113143920898 411.8027954101562 -44.66676330566406 C 411.71923828125 -52.473876953125 412.28564453125 -71.45996856689453 411.8027954101562 7.039246559143066 C 410.5647583007812 208.3192901611328 411.8027954101562 381.3228759765625 411.8027954101562 381.3228759765625 L 0 381.3228759765625 L 0 104.5798263549805 C 0 50.70965194702148 38.48508071899414 7.039246559143066 85.95883941650391 7.039246559143066 Z" fill="#ffffff" stroke="#707070" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_mszdv9 =
    '<svg viewBox="192.8 654.3 14.1 13.4" ><path transform="translate(192.82, 654.28)" d="M 7.376471996307373 0.2645169496536255 L 9.177474975585938 4.476025104522705 L 13.74758243560791 4.885032176971436 C 13.89362907409668 4.898029327392578 14.01788711547852 4.996795177459717 14.06350612640381 5.136143207550049 C 14.1091251373291 5.275490760803223 14.06732845306396 5.428617477416992 13.95724010467529 5.525465488433838 L 13.95724010467529 5.525465488433838 L 10.49844074249268 8.542033195495605 L 11.52038383483887 13.01017284393311 C 11.55420398712158 13.15605640411377 11.49589729309082 13.30784511566162 11.37310791015625 13.3935718536377 C 11.25031757354736 13.47929668426514 11.08773422241211 13.48172283172607 10.96244049072266 13.39970302581787 L 7.038496971130371 11.05564880371094 L 3.103097438812256 13.40886878967285 C 2.977076530456543 13.48410224914551 2.818331956863403 13.47692775726318 2.699612617492676 13.3906307220459 C 2.580893039703369 13.30433464050293 2.525081634521484 13.15555095672607 2.5577552318573 13.01246452331543 L 2.557754993438721 13.01246452331543 L 3.579699277877808 8.544325828552246 L 0.1243373826146126 5.52546501159668 C 0.0126756438985467 5.427571773529053 -0.02890517935156822 5.271988391876221 0.01903147622942924 5.131441593170166 C 0.0669681578874588 4.990894794464111 0.1949533224105835 4.893145561218262 0.3431616425514221 4.883886337280273 L 4.896081924438477 4.476025104522705 L 6.700522422790527 0.2645169496536255 C 6.757711410522461 0.1284589618444443 6.890909194946289 0.03995956853032112 7.038497447967529 0.0399596244096756 C 7.186086177825928 0.0399596244096756 7.319283962249756 0.1284590661525726 7.376471996307373 0.2645169496536255 Z" fill="#2bc6ed" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
