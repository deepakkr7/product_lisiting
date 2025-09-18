import 'dart:ui';

class AppConstants {
  // API Constants
  static const String baseUrl = 'https://skilltestflutter.zybotechlab.com/api';
  static const String verifyUserEndpoint = '$baseUrl/verify/';
  static const String loginRegisterEndpoint = '$baseUrl/login-register/';
  static const String productsEndpoint = '$baseUrl/products/';
  static const String bannersEndpoint = '$baseUrl/banners/';
  static const String userDataEndpoint = '$baseUrl/user-data/';
  static const String wishlistEndpoint = '$baseUrl/wishlist/';
  static const String addRemoveWishlistEndpoint = '$baseUrl/add-remove-wishlist/';
  static const String searchEndpoint = '$baseUrl/search/';

  // Storage Keys
  static const String tokenKey = 'jwt_access_token';
  static const String refreshTokenKey = 'jwt_refresh_token';
  static const String userKey = 'user_data';
  static const String phoneKey = 'phone_number';
  static const String isLoggedInKey = 'is_logged_in';

  //Colors
  static const Color primaryPurple = Color(0xFF6C63FF);
  static const Color secondaryPurple = Color(0xFF9C88FF);
  static const Color backgroundGrey = Color(0xFFF8F9FA);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const int otpLength = 4;
  static const int otpTimeoutSeconds = 120;
}
