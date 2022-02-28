
import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:izzilly_customer/constant.dart';


class OnboardScreen extends StatefulWidget {
  @override
  _OnboardScreenState createState() => _OnboardScreenState();
}

final _controller = PageController(
  initialPage: 0,
);

int _currentPage = 0;

List<Widget> _pages = [
  Column(
    children: [
      Expanded(child: Image.asset('image/page1.png')),
      Text("Search your necessary service", style: kPageViewTextStyle,),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('image/reservation.png')),
      Text("Book anytime you want", style: kPageViewTextStyle,),
    ]
  ),
  Column(
      children: [
        Expanded(child: Image.asset('image/sell.png')),
        Text("Make money from your special skill", style: kPageViewTextStyle, ),
      ]
  ),
];

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children :[
          Expanded(
              child: PageView(
              controller: _controller,
              children: _pages,
                onPageChanged: (index){
                      setState(() {
                        _currentPage = index;
                      });
                },
              ),
            ),

          DotsIndicator(
            dotsCount: _pages.length,
            position: _currentPage.toDouble(),
            decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
          SizedBox(height: 20,),
          ]
      );

  }
}
