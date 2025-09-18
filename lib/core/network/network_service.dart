import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import '../ errors/failures.dart';
import '../storage/storage_service.dart';

abstract class NetworkService {
  Future<Either<Failure, Map<String, dynamic>>> post(
      String url,
      Map<String, dynamic> body,
      );
  Future<Either<Failure, dynamic>> get(String url);
}

class NetworkServiceImpl implements NetworkService {
  final http.Client client;
  final StorageService storageService; // Add this

  NetworkServiceImpl({
    required this.client,
    required this.storageService, // Add this
  });

  @override
  Future<Either<Failure, Map<String, dynamic>>> post(
      String url,
      Map<String, dynamic> body,
      ) async {
    try {
      print('🌐 Making POST request to: $url');
      print('📦 Request body: ${json.encode(body)}');

      // Get stored token for authenticated requests
      final token = await storageService.getToken();

      // Prepare headers
      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Add Authorization header if token exists and it's not login/register endpoints
      if (token != null && token.isNotEmpty &&
          !url.contains('verify') && !url.contains('login-register')) {
        headers['Authorization'] = 'Bearer $token';
        print('🔐 Added Authorization header');
      }

      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(body),
      ).timeout(const Duration(seconds: 15));

      print('📱 Response status: ${response.statusCode}');
      print('📄 Raw response body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');

      // Handle token expiration
      if (response.statusCode == 401) {
        print('🔐 Token expired - clearing local data');
        await storageService.clearToken();
        return const Left(AuthFailure('Session expired. Please login again.'));
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          return const Left(ServerFailure('Empty response from server'));
        }

        try {
          final dynamic parsedResponse = json.decode(response.body);
          print('🔍 Parsed response type: ${parsedResponse.runtimeType}');

          if (parsedResponse is Map<String, dynamic>) {
            return Right(parsedResponse);
          } else if (parsedResponse is bool) {
            return Right({
              'success': parsedResponse,
              'message': parsedResponse ? 'Operation successful' : 'Operation failed',
              'user_exists': false,
            });
          } else {
            return Right({
              'success': true,
              'message': 'Response received',
              'data': parsedResponse,
            });
          }
        } catch (e) {
          print('🔴 JSON parsing error: $e');
          return Right({
            'success': true,
            'message': response.body,
            'raw_response': response.body,
          });
        }
      } else {
        return Left(ServerFailure('Server error: ${response.statusCode}'));
      }
    } on SocketException catch (e) {
      print('🔴 Socket Exception: $e');
      return const Left(NetworkFailure('No internet connection'));
    } on HttpException catch (e) {
      print('🔴 HTTP Exception: $e');
      return Left(NetworkFailure('HTTP error: ${e.message}'));
    } on FormatException catch (e) {
      print('🔴 Format Exception: $e');
      return Left(ServerFailure('Invalid response format: ${e.message}'));
    } catch (e) {
      print('🔴 General Exception: $e');
      return Left(NetworkFailure('Unexpected error: $e'));
    }
  }
  @override
  Future<Either<Failure, dynamic>> get(String url) async {
    try {
      print('🌐 Making GET request to: $url');

      final token = await storageService.getToken();

      final headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
        print('🔐 Added Authorization header');
      }

      final response = await client.get(
        Uri.parse(url),
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      print('📱 Response status: ${response.statusCode}');
      print('📄 Raw response body: ${response.body.substring(0, response.body.length > 200 ? 200 : response.body.length)}...');

      if (response.statusCode == 401) {
        print('🔐 Token expired - clearing local data');
        await storageService.clearToken();
        return const Left(AuthFailure('Session expired. Please login again.'));
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          return const Left(ServerFailure('Empty response from server'));
        }

        try {
          final dynamic parsedResponse = json.decode(response.body);
          print('🔍 Parsed response type: ${parsedResponse.runtimeType}');
          return Right(parsedResponse);
        } catch (e) {
          print('🔴 JSON parsing error: $e');
          return Left(ServerFailure('Invalid JSON response: $e'));
        }
      } else {
        return Left(ServerFailure('Server error: ${response.statusCode}'));
      }
    } on SocketException catch (e) {
      print('🔴 Socket Exception: $e');
      return const Left(NetworkFailure('No internet connection'));
    } catch (e) {
      print('🔴 General Exception: $e');
      return Left(NetworkFailure('Unexpected error: $e'));
    }
  }
}