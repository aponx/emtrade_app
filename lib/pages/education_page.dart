import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emtrade/models/content_model.dart';
import 'package:emtrade/utils/string_extension.dart';
import 'package:emtrade/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../api/api_services.dart';
import '../utils/placeholder.dart';

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
  bool _isLoading = false;

  late TextEditingController textEditingController;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
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
      setState(() {
        _isLoading = true;
      });
      ApiService.getContents(page, pageSize, sort, search, category, contentFormat).then((value) {
        // Loading.dismiss(context);
        setState(() {
          _isLoading = false;
        });
        if ((value.statusCode == 201) || (value.statusCode == 200)) {
          try {
            var responseParsed = json.decode(value.body);
            print("RESPON_ARTIKEL: " + responseParsed.toString());

            setState(() {

              if(responseParsed['total_page'] == 0){
                page = 0;
              } else {
                page += 1;
              }

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
      }).catchError((e){
        setState(() {
          _isLoading = false;
        });
        print("GAGAL_ARTIKEL: " + e.toString());
      });
    } else {
      print("LOAD HABIS");
    }
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
              child: category == "" ? Row(
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
              ) : Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 3, bottom: 3),
                decoration: BoxDecoration(
                    color: Color(0xFFE6F7F7),
                    borderRadius:
                    BorderRadius.circular(25.0),
                    border: Border.all(
                        width: 2.0,
                        color: const Color(0xFF04A9AC))),
                child: Row(
                  children: [
                    Image.asset("images/ic_tune_badge.png"),
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
              onTap: (){
                _filterDialog(context);
                // _filterPopup(context);
              },
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
              Container(
                padding: EdgeInsets.all(20),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  controller: textEditingController,
                  readOnly: _isLoading,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Color(0xFFF5F5F5),
                    prefixIcon: Icon(Icons.search_outlined, color: Color(0xFF0074C9)),
                    hintText: "Cari topik yang kamu mau di sini.",
                    hintStyle: TextStyle(
                        color: Color(0xFF979797),
                      fontWeight: FontWeight.w400
                    ),
                    suffixIcon: textEditingController.text == "" ? null : GestureDetector(
                      child: Image.asset("images/ic_clear.png"),
                      onTap: (){
                        setState(() {
                          textEditingController.text = "";
                          contentList = <Content>[];
                          search = "";
                          page  = 1;
                          pageSize = 10;
                          totalPage = 0;
                          currentPage = 1;
                          getContents();
                        });
                      },
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(50),
                    ),

                  ),

                  onChanged: (v) {
                    if(v.length > 2){
                      setState(() {
                        contentList = <Content>[];
                        search = v;
                        page  = 1;
                        pageSize = 10;
                        totalPage = 0;
                        currentPage = 1;
                        getContents();
                      });
                    }
                  },
                ),
              ),
              Visibility(
                  visible: search.length > 0,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(left: 20, right: 20,bottom: 20),
                    child: Text("Hasil Pencarian \"$search\"", style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16
                    )),
                  )
              ),
              Expanded(
                // child: anyData(),

                child: _isLoading && page < 2 ? shimmerLoad() : (contentList.isNotEmpty ? anyData() : noData()),
              ),
            ],
          )
      ),
    );
  }

  Widget shimmerLoad() {
    return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              BannerPlaceholder(),
              BannerPlaceholder(),
              BannerPlaceholder(),
              BannerPlaceholder(),
              BannerPlaceholder(),
              BannerPlaceholder(),
              BannerPlaceholder(),
              BannerPlaceholder(),
              BannerPlaceholder(),
              BannerPlaceholder(),
            ],
          ),
        ));
  }

  Widget noData() {
    return Container(
      color: Colors.white,
      child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("images/not_found.png", width: 300, fit: BoxFit.fill),
              SizedBox(height: size.hp(3)),
              Text("Hasil Tidak Ditemukan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700
                ),
              ),
              SizedBox(height: size.hp(2)),
              Text("Harap periksa kembali pencarian kamu.")
            ],
          )
      ),
    );
  }

  Widget anyData() {
    return ListView.builder(
      padding: EdgeInsets.only(left: 20, right: 20),
      shrinkWrap: true,
      controller: controller,
      scrollDirection: Axis.vertical,
      itemCount: contentList.length,
      itemBuilder: (BuildContext context, int i) =>
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
                          Text(contentList[i].category.length > 17 ? contentList[i].category.substring(0,16).capitalize()+"..." : contentList[i].category.capitalize(),
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
    );
  }

  void _filterDialog(BuildContext context){

    String oldCategory = category;
    showDialog(
      context: context,
        barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          alignment: Alignment.bottomCenter,
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.all(20.0),
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  padding: EdgeInsets.all(20),
                  child: Wrap(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Filter",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18
                            ),
                          ),
                          GestureDetector(
                            child: Text("Reset",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFF9441)
                              ),
                            ),
                            onTap: (){
                              setState(() {
                                category = "";
                              });
                            },
                          )
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                      Divider(
                        height: 1,
                        color: Color(0xFFEEEEEE),
                      ),
                      Container(
                        height: 15,
                      ),
                      Text("Category",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16
                        ),
                      ),
                      Container(
                        height: 5,
                      ),
                      Wrap(
                        spacing: 4.0,
                        runSpacing: 10.0,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if(category.contains(RegExp("insight"))){
                                  category = category.replaceAll("|insight", "");
                                  category = category.replaceAll("insight", "");
                                } else {
                                  if(category != "") category += "|";
                                  category += "insight";
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                  color: category.contains(RegExp("(insight)"))
                                      ? const Color(0xFFFFF4EC)
                                      : Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(25.0),
                                  border: Border.all(
                                      width: 2.0,
                                      color: category.contains(RegExp("(insight)"))
                                          ? const Color(0xFFFFF4EC)
                                          : const Color(0xFFEEEEEE))),
                              child: Text(
                                "Insight",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: category.contains(RegExp("(insight)"))
                                        ? const Color(0xFFFF9441)
                                        : Colors.black,
                                    fontSize: 14
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if(category.contains(RegExp("pemula"))){
                                  category = category.replaceAll("|pemula", "");
                                  category = category.replaceAll("pemula", "");
                                } else {
                                  if(category != "") category += "|";
                                  category += "pemula";
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                  color: category.contains(RegExp("(pemula)"))
                                      ? const Color(0xFFFFF4EC)
                                      : Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(25.0),
                                  border: Border.all(
                                      width: 2.0,
                                      color: category.contains(RegExp("(pemula)"))
                                          ? const Color(0xFFFFF4EC)
                                          : const Color(0xFFEEEEEE))),
                              child: Text(
                                "Pemula",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: category.contains(RegExp("(pemula)"))
                                        ? const Color(0xFFFF9441)
                                        : Colors.black,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if(category.contains(RegExp("perencanaan-keuangan"))){
                                  category = category.replaceAll("|perencanaan-keuangan", "");
                                  category = category.replaceAll("perencanaan-keuangan", "");
                                } else {
                                  if(category != "") category += "|";
                                  category += "perencanaan-keuangan";
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 8),
                              decoration: BoxDecoration(
                                  color: category.contains(RegExp("(perencanaan-keuangan)"))
                                      ? const Color(0xFFFFF4EC)
                                      : Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(25.0),
                                  border: Border.all(
                                      width: 2.0,
                                      color: category.contains(RegExp("(perencanaan-keuangan)"))
                                          ? const Color(0xFFFFF4EC)
                                          : const Color(0xFFEEEEEE))),
                              child: Text(
                                "Perencanaan Keuangan",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: category.contains(RegExp("(perencanaan-keuangan)"))
                                        ? const Color(0xFFFF9441)
                                        : Colors.black,
                                    fontSize: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 15,
                      ),
                      Divider(
                        height: 1,
                        color: Color(0xFFEEEEEE),
                      ),
                      Container(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                contentList = <Content>[];
                                category = oldCategory;
                                page  = 1;
                                pageSize = 10;
                                totalPage = 0;
                                currentPage = 1;
                                getContents();
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 8),
                              width: size.wp(40),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(25.0),
                                  border: Border.all(
                                      width: 2.0,
                                      color: const Color(0xFFEEEEEE))),
                              child: Text(
                                "Batal",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState((){
                                if(category == "|") category = "";
                                contentList = <Content>[];
                                page  = 1;
                                pageSize = 10;
                                totalPage = 0;
                                currentPage = 1;
                                getContents();
                                Navigator.pop(context);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, top: 8, bottom: 8),
                              width: size.wp(40),
                              decoration: BoxDecoration(
                                  color: const Color(0xFFFFF4EC),
                                  borderRadius:
                                  BorderRadius.circular(25.0),
                                  border: Border.all(
                                      width: 2.0,
                                      color: const Color(0xFFFFF4EC)
                                  )
                              ),
                              child: Text(
                                "Simpan",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: const Color(0xFFFF9441),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }),
        );
      },
    );
  }
}