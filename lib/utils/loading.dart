import 'package:flutter/material.dart';

import 'mytoast.dart';

class Loading{

  static show(BuildContext context){
    AlertDialog alert = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF1F3FBB),
          ),
          Container(margin: const EdgeInsets.only(top: 5),child:const Text("Loading..." )),
        ],),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return FutureBuilder(
          future: Future.delayed(Duration(seconds: 10)).then((value) => true),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              MyToast.show("Not responding. check your internet connection");
              Navigator.of(context).pop();
            }
            return alert;
          },
        );
      },
    );
  }

  static dismiss(BuildContext context){
    Navigator.pop(context);
  }
}