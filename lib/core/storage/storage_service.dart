import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

abstract class StorageService {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> remove(String key);
  Future<void> clear();
  // Add token-specific methods
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearToken();
  Future<bool> hasValidToken();
}

class StorageServiceImpl implements StorageService {
  final SharedPreferences sharedPreferences;

  StorageServiceImpl({required this.sharedPreferences});

  @override
  Future<void> saveString(String key, String value) async {
    await sharedPreferences.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return sharedPreferences.getString(key);
  }

  @override
  Future<void> remove(String key) async {
    await sharedPreferences.remove(key);
  }

  @override
  Future<void> clear() async {
    await sharedPreferences.clear();
  }

  // JWT Token specific methods
  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(AppConstants.tokenKey, token);
    // Also save timestamp for token expiry checking
    await sharedPreferences.setInt('token_timestamp', DateTime.now().millisecondsSinceEpoch);
    print('🔐 Token saved successfully');
  }

  @override
  Future<String?> getToken() async {
    final token = sharedPreferences.getString(AppConstants.tokenKey);
    print('🔐 Retrieved token: ${token?.substring(0, 20)}...');
    return token;
  }

  @override
  Future<void> clearToken() async {
    await sharedPreferences.remove(AppConstants.tokenKey);
    await sharedPreferences.remove('token_timestamp');
    print('🔐 Token cleared');
  }

  @override
  Future<bool> hasValidToken() async {
    final token = await getToken();
    if (token == null || token.isEmpty) {
      print('🔐 No token found');
      return false;
    }

    // Check if token is expired (optional - you can validate with your backend)
    final timestamp = sharedPreferences.getInt('token_timestamp');
    if (timestamp != null) {
      final tokenAge = DateTime.now().millisecondsSinceEpoch - timestamp;
      final maxAge = 30 * 24 * 60 * 60 * 1000; // 30 days in milliseconds

      if (tokenAge > maxAge) {
        print('🔐 Token expired');
        await clearToken();
        return false;
      }
    }

    print('🔐 Valid token found');
    return true;
  }
}
