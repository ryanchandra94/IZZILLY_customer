import 'package:flutter/material.dart';
import 'package:adobe_xd/pinned.dart';
import 'package:izzilly_customer/page/login_screen.dart';
import 'package:izzilly_customer/page/map_screen.dart';
import 'package:izzilly_customer/provider/location_provider.dart';
import 'package:provider/provider.dart';
import './SIgnIn1.dart';
import 'package:adobe_xd/page_link.dart';
import './SIgnIn2.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SIgnIn extends StatefulWidget {
  SIgnIn({
    Key key,
  }) : super(key: key);

  @override
  State<SIgnIn> createState() => _SIgnInState();
}

class _SIgnInState extends State<SIgnIn> {

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
              Pin(size: 569.0, start: 0.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0x666e5e5e),
                  border: Border.all(width: 1.0, color: const Color(0x66707070)),
                ),
              ),
            ),
            Pinned.fromPins(
              Pin(start: -34.0, end: -34.0),
              Pin(start: 0.0, end: 226.0),
              child:
                  // Adobe XD layer: 'chefimage' (shape)
                  Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('image/page1.png'),
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
                      'The NEW standard in finding your services with',
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
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(9999.0, 9999.0)),
                              color: const Color(0xff2bc6ed),
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
      ),
    );
  }
}

const String _svg_tg0u0 =
    '<svg viewBox="0.0 425.5 412.0 433.8" ><path transform="translate(0.0, 477.94)" d="M 85.95883941650391 7.039246559143066 C 85.95883941650391 7.039246559143066 263.524658203125 7.039246559143066 344.9856567382812 7.039246559143066 C 394.6768493652344 7.039246559143066 411.9497680664062 -31.60113143920898 411.8027954101562 -44.66676330566406 C 411.71923828125 -52.473876953125 412.28564453125 -71.45996856689453 411.8027954101562 7.039246559143066 C 410.5647583007812 208.3192901611328 411.8027954101562 381.3228759765625 411.8027954101562 381.3228759765625 L 0 381.3228759765625 L 0 104.5798263549805 C 0 50.70965194702148 38.48508071899414 7.039246559143066 85.95883941650391 7.039246559143066 Z" fill="#ffffff" stroke="#707070" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
const String _svg_snr06 =
    '<svg viewBox="193.2 666.0 14.5 13.7" ><defs><filter id="shadow"><feDropShadow dx="10" dy="10" stdDeviation="15"/></filter></defs><path transform="translate(193.17, 665.96)" d="M 7.578835487365723 0.2691251933574677 L 9.429244995117188 4.567012786865234 L 14.12471675872803 4.984409809112549 C 14.27476978302002 4.997672557830811 14.40243911743164 5.098462581634521 14.44931030273438 5.240668296813965 C 14.49617671966553 5.382874965667725 14.45323276519775 5.539141654968262 14.34012985229492 5.637978076934814 L 14.34012985229492 5.637978076934814 L 10.7864465713501 8.716415405273438 L 11.83642482757568 13.27619457244873 C 11.87117099761963 13.42506885528564 11.81126403808594 13.57997226715088 11.68510723114014 13.66745758056641 C 11.55894947052002 13.75494003295898 11.3919038772583 13.75741672515869 11.26317405700684 13.6737117767334 L 7.23159122467041 11.28158283233643 L 3.188234806060791 13.68307018280029 C 3.05875563621521 13.75984668731689 2.895656585693359 13.75252342224121 2.773681163787842 13.66445350646973 C 2.65170431137085 13.57638835906982 2.594361782073975 13.4245548248291 2.627932071685791 13.27853107452393 L 2.627932071685791 13.27853107452393 L 3.677909374237061 8.718753814697266 L 0.1277604401111603 5.637978076934814 C 0.01303562521934509 5.53807544708252 -0.0296858437359333 5.379300117492676 0.01956581324338913 5.2358717918396 C 0.06881750375032425 5.092441558837891 0.200313538312912 4.992687225341797 0.3525874614715576 4.983238220214844 L 5.030402660369873 4.567012786865234 L 6.884343147277832 0.2691251933574677 C 6.943101406097412 0.1302766501903534 7.079953193664551 0.03996211662888527 7.23159122467041 0.03996217623353004 C 7.383227348327637 0.03996217623353004 7.52008056640625 0.1302767693996429 7.578835487365723 0.2691251933574677 Z" fill="#2bc6ed" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" filter="url(#shadow)"/></svg>';
