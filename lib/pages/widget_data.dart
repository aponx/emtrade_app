import 'package:emtrade/models/content_model.dart';
import 'package:flutter/material.dart';

class WidgetData extends StatelessWidget {
  final List<Content> data;

  WidgetData({required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, i) {
        return ListTile(
          title: Text(data[i].seoTitle!=""?data[i].seoTitle:data[i].name),
        );
      },
    );
  }
}