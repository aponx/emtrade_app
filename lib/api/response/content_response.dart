import 'package:emtrade/models/content_model.dart';

class ContentResponse {
  late String message;
  late int pageSize;
  late int currentPage;
  late int totalPage;
  late int nextPage;
  late int totalRecord;
  late List<Content> data;

  ContentResponse(
      {required this.message,
        required this.pageSize,
        required this.currentPage,
        required this.totalPage,
        required this.nextPage,
        required this.totalRecord,
        required this.data});

  ContentResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    pageSize = json['page_size'];
    currentPage = json['current_page'];
    totalPage = json['total_page'];
    nextPage = json['next_page'];
    totalRecord = json['total_record'];
    if (json['data'] != null) {
      data = <Content>[];
      json['data'].forEach((v) {
        data!.add(new Content.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['page_size'] = this.pageSize;
    data['current_page'] = this.currentPage;
    data['total_page'] = this.totalPage;
    data['next_page'] = this.nextPage;
    data['total_record'] = this.totalRecord;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
