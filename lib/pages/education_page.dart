import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emtrade/models/content_model.dart';
import 'package:emtrade/pages/shimmer_list.dart';
import 'package:emtrade/pages/widget_data.dart';
import 'package:emtrade/utils/loading.dart';
import 'package:emtrade/utils/string_extension.dart';
import 'package:emtrade/utils/utils.dart';
import 'package:flutter/material.dart';

import '../api/api_services.dart';

class EducationActivity extends StatefulWidget {
  const EducationActivity({super.key});

  @override
  EducationState createState() => EducationState();
}

class EducationState extends State<EducationActivity> {
  late Screen size;
  late String status = "";

  int page  = 1;
  int pageSize = 10;
  int totalPage = 0;
  int currentPage = 1;
  String sort = "published_at DESC";
  String search = "";
  String category = "";
  String contentFormat = "";
  ScrollController? controller;
  List<Content> contentList = <Content>[];

  @override
  void initState() {
    super.initState();
    getContents();
    controller = ScrollController()..addListener(() {
      if (controller!.offset >= controller!.position.maxScrollExtent) {
        setState(() {
          getContents();
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void getContents() {
    if((page == 1) || (currentPage != totalPage)){
      // Loading.show(context);
      ApiService.getContents(page, pageSize, sort, search, category, contentFormat).then((value) {
        // Loading.dismiss(context);
        if ((value.statusCode == 201) || (value.statusCode == 200)) {
          try {
            var responseParsed = json.decode(value.body);
            print("RESPON_ARTIKEL: " + responseParsed.toString());

            setState(() {

              page += 1;
              totalPage = responseParsed['total_page'];
              currentPage = responseParsed['current_page'];
              pageSize = responseParsed['page_size'];

              responseParsed["data"].forEach((v) {
                contentList.add(Content.fromJson(v));
              });
            });
          } catch (e) {
            print(e.toString());
          }
        } else {
          var responseParsed = json.decode(value.body);
          print("GAGAL_ARTIKEL: " + responseParsed.toString());
        }
      });
    } else {
      print("LOAD HABIS");
    }
  }

  Future<List<Content>> fetchData() async {
    // Simulate data fetching delay
    if((page == 1) || (currentPage != totalPage)){
      ApiService.getContents(page, pageSize, sort, search, category, contentFormat).then((value) {
        if ((value.statusCode == 201) || (value.statusCode == 200)) {
          try {
            var responseParsed = json.decode(value.body);
            print("RESPON_ARTIKEL: " + responseParsed.toString());

            setState(() {

              page += 1;
              totalPage = responseParsed['total_page'];
              currentPage = responseParsed['current_page'];
              pageSize = responseParsed['page_size'];
            });

            responseParsed["data"].forEach((v) {
              contentList.add(Content.fromJson(v));
            });

            return contentList;
          } catch (e) {
            print(e.toString());
            return contentList;
          }
        } else {
          var responseParsed = json.decode(value.body);
          print("GAGAL_ARTIKEL: " + responseParsed.toString());
          return contentList;
        }
      });
    } else {
      print("LOAD HABIS");
      return contentList;
    }
    return contentList;
  }

  @override
  Widget build(BuildContext context) {
    size = Screen(MediaQuery.of(context).size);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: Text("Education",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF333333),
            fontSize: size.getHeightPx(10),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              child: Row(
                children: [
                  Icon(Icons.tune_outlined, color: Color(0xFF04A9AC)),
                  SizedBox(width: size.getWidthPx(1)),
                  Text("Filter",
                    style: TextStyle(
                      fontSize: size.getHeightPx(8),
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF04A9AC)
                    ),
                  )
                ],
              ),
            ),
          )
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: const Color(0xFFEEEEEE),
              height: 1.0,
            )),
      ),
      body: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  height: 76,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_outlined, color: Color(0xFF0074C9)),
                      SizedBox(width: size.getWidthPx(5)),
                      Text("Cari topik yang kamu mau di sini.",
                        style: TextStyle(
                            color: Color(0xFF979797)
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Expanded(
              //     child: FutureBuilder(
              //       future: fetchData(),
              //       builder: (context, snapshot) {
              //         if (snapshot.connectionState == ConnectionState.waiting) {
              //           return ShimmerList(); // Shimmer effect while loading
              //         } else if (snapshot.hasError) {
              //           return Center(
              //             child: Text('Error: ${snapshot.error}'),
              //           );
              //         } else {
              //           return WidgetData(data: snapshot.data!);
              //         }
              //       },
              //     )
              // ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  shrinkWrap: true,
                  controller: controller,
                  scrollDirection: Axis.vertical,
                  itemCount: contentList.length,
                  itemBuilder: (BuildContext context, int i) =>
                      // InkWell(
                      //   onTap: (){
                      //     // Navigator.push(
                      //     //   context,
                      //     //   MaterialPageRoute(builder: (context) => DetailArtikelPage(
                      //     //     slug: contentList[index].slug.toString(),
                      //     //     postingDate: Utils.convertDateToAgo(contentList[index].postingDate.toString()),
                      //     //   )
                      //     //   ),
                      //     // );
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right:20),
                      //     child: Column(
                      //       children: [
                      //         Text(contentList[index].seoTitle==""?contentList[index].name:contentList[index].seoTitle)
                      //       ],
                      //     )
                      //   ),
                      // ),
                  Container(
                    height: 150,
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        border: Border.all(color: Color(0xFFEEEEEE))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.wp(55),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(contentList[i].contentFormat.capitalize(),
                                    style: TextStyle(
                                      color: Color(0xFF707070)
                                    ),
                                  ),
                                  SizedBox(width: size.getWidthPx(10)),
                                  Icon(Icons.circle, color: Color(0xFF707070), size: 10,),
                                  SizedBox(width: size.getWidthPx(10)),
                                  Text(contentList[i].category.capitalize(),
                                    style: TextStyle(
                                        color: Color(0xFF707070)
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: size.getHeightPx(3)),
                              Text(contentList[i].name.length > 40 ? contentList[i].name.substring(0,39)+"..." : contentList[i].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700
                                ),
                              ),
                              SizedBox(height: size.getHeightPx(3)),
                              Text(contentList[i].publishedAt,
                                style: TextStyle(
                                  color: Color(0xFF707070)
                                ),
                              )
                            ],
                          ),
                        ),
                        CachedNetworkImage(
                          imageUrl: contentList[i].image.toString(),
                          imageBuilder: (context, imageProvider) => Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(15),
                                      bottomRight: Radius.circular(15),
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15)
                                  ),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.fill,
                                  ))),
                          placeholder: (context, url) => const CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}