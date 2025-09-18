import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required int id,
    required String title,
    required double price,
    required double originalPrice,
    required String description,
    required String imageUrl,
    required double rating,
    required int reviewCount,
    required String category,
    required List<String> images,
    required String caption,
    required int stock,
    required String productType,
    required String discount,
    bool isWishlisted = false,
  }) : super(
    id: id,
    title: title,
    price: price,
    originalPrice: originalPrice,
    description: description,
    imageUrl: imageUrl,
    rating: rating,
    reviewCount: reviewCount,
    category: category,
    isWishlisted: isWishlisted,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final List<String> productImages = json['images'] != null
        ? List<String>.from(json['images'])
        : [];

    return ProductModel(
      id: json['id']?.toInt() ?? 0,
      title: json['name'] ?? '',
      price: (json['sale_price']?.toDouble()) ?? 0.0,
      originalPrice: (json['mrp']?.toDouble()) ?? 0.0,
      description: json['description'] ?? '',
      imageUrl: json['featured_image'] ?? (productImages.isNotEmpty ? productImages[0] : ''),
      rating: (json['avg_rating']?.toDouble()) ?? 0.0,
      reviewCount: 0, // Not provided in API
      category: json['category']?.toString() ?? '',
      images: productImages,
      caption: json['caption'] ?? '',
      stock: json['stock']?.toInt() ?? 0,
      productType: json['product_type'] ?? '',
      discount: json['discount']?.toString() ?? '0.00',
      isWishlisted: json['in_wishlist'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'sale_price': price,
      'mrp': originalPrice,
      'description': description,
      'featured_image': imageUrl,
      'avg_rating': rating,
      'category': category,
      'in_wishlist': isWishlisted,
    };
  }
}