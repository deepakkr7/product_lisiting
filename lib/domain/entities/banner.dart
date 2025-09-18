import 'package:equatable/equatable.dart';

class Banner extends Equatable {
  final int id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String actionUrl;
  final String offerText;

  const Banner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.actionUrl,
    required this.offerText,
  });

  @override
  List<Object?> get props => [id, title, subtitle, imageUrl, actionUrl, offerText];
}