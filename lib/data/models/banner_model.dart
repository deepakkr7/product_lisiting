import '../../domain/entities/banner.dart';

class BannerModel extends Banner {
  const BannerModel({
    required int id,
    required String title,
    required String subtitle,
    required String imageUrl,
    required String actionUrl,
    required String offerText,
  }) : super(
    id: id,
    title: title,
    subtitle: subtitle,
    imageUrl: imageUrl,
    actionUrl: actionUrl,
    offerText: offerText,
  );

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id']?.toInt() ?? 0,
      title: json['title'] ?? json['name'] ?? 'Special Offer',
      subtitle: json['subtitle'] ?? json['description'] ?? json['caption'] ?? '',
      imageUrl: json['image'] ?? json['banner_image'] ?? json['featured_image'] ?? '',
      actionUrl: json['action_url'] ?? json['link'] ?? '',
      offerText: json['offer_text'] ?? json['offer'] ?? json['discount'] ?? 'Special Deal!',
    );
  }
}
