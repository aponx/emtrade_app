import 'package:emtrade/pages/dashboard.dart';
import 'package:emtrade/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashActivity extends StatefulWidget {
  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<SplashActivity> {
  final String assetName = 'images/ic_logo.svg';
  late Screen size;
  late String status = "";

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      navigateToHomeScreen();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new SvgPicture.asset(assetName, width: 300, fit: BoxFit.fill, semanticsLabel: 'Acme Logo'),
              ],
            )
        ),
      ),
    );
  }

  void navigateToHomeScreen() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard(index: 2)));
  }
}