class Content {
  late int id;
  late bool isPremiumContent;
  late String contentFormat;
  late String name;
  late String slug;
  late String shortContent;
  late String publishedAt;
  late String publishedAtDetail;
  late String image;
  late String thumbnail;
  late String seoTitle;
  late String seoDescription;
  late String seoKeyword;
  late String seoSlug;
  late String seoImageUrl;
  late String category;
  late String categoryIcon;
  late String videoDuration;
  late String updatedAt;
  late String updatedAtDetail;

  Content(
      {required this.id,
        required this.isPremiumContent,
        required this.contentFormat,
        required this.name,
        required this.slug,
        required this.shortContent,
        required this.publishedAt,
        required this.publishedAtDetail,
        required this.image,
        required this.thumbnail,
        required this.seoTitle,
        required this.seoDescription,
        required this.seoKeyword,
        required this.seoSlug,
        required this.seoImageUrl,
        required this.category,
        required this.categoryIcon,
        required this.videoDuration,
        required this.updatedAt,
        required this.updatedAtDetail});

  Content.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isPremiumContent = json['is_premium_content'];
    contentFormat = json['content_format'];
    name = json['name'];
    slug = json['slug'];
    shortContent = json['short_content'];
    publishedAt = json['published_at'];
    publishedAtDetail = json['published_at_detail'];
    image = json['image'];
    thumbnail = json['thumbnail'];
    seoTitle = json['seo_title'];
    seoDescription = json['seo_description'];
    seoKeyword = json['seo_keyword'];
    seoSlug = json['seo_slug'];
    seoImageUrl = json['seo_image_url'];
    category = json['category'];
    categoryIcon = json['category_icon'];
    videoDuration = json['video_duration'];
    updatedAt = json['updated_at'];
    updatedAtDetail = json['updated_at_detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_premium_content'] = this.isPremiumContent;
    data['content_format'] = this.contentFormat;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['short_content'] = this.shortContent;
    data['published_at'] = this.publishedAt;
    data['published_at_detail'] = this.publishedAtDetail;
    data['image'] = this.image;
    data['thumbnail'] = this.thumbnail;
    data['seo_title'] = this.seoTitle;
    data['seo_description'] = this.seoDescription;
    data['seo_keyword'] = this.seoKeyword;
    data['seo_slug'] = this.seoSlug;
    data['seo_image_url'] = this.seoImageUrl;
    data['category'] = this.category;
    data['category_icon'] = this.categoryIcon;
    data['video_duration'] = this.videoDuration;
    data['updated_at'] = this.updatedAt;
    data['updated_at_detail'] = this.updatedAtDetail;
    return data;
  }
}