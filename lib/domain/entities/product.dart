import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String title;
  final double price;
  final double originalPrice;
  final String description;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String category;
  final bool isWishlisted;

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.originalPrice,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.category,
    this.isWishlisted = false,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    price,
    originalPrice,
    description,
    imageUrl,
    rating,
    reviewCount,
    category,
    isWishlisted,
  ];

  Product copyWith({
    int? id,
    String? title,
    double? price,
    double? originalPrice,
    String? description,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    String? category,
    bool? isWishlisted,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      category: category ?? this.category,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }
}
