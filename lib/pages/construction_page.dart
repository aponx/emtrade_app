import 'package:emtrade/utils/utils.dart';
import 'package:flutter/material.dart';

class ConstructionActivity extends StatefulWidget {
  @override
  ConstructionState createState() => ConstructionState();
}

class ConstructionState extends State<ConstructionActivity> {
  late Screen size;
  late String status = "";

  @override
  void initState() {
    super.initState();
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
                Image.asset("images/under_construction.png", width: 300, fit: BoxFit.fill,)
              ],
            )
        ),
      ),
    );
  }
}