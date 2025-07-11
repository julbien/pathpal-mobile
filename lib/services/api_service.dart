import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ApiService {
  // Sign up method
  static Future<Map<String, dynamic>> signUp({
    required String username,
    required String email,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      print('Attempting to sign up with email: $email');
      print('API URL: ${ApiConfig.baseUrl}${ApiConfig.signUpEndpoint}');
      
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.signUpEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'email': email,
          'phone': phoneNumber,
          'password': password,
        }),
      ).timeout(
        Duration(milliseconds: ApiConfig.connectionTimeout),
      );

      print('Sign up response status: ${response.statusCode}');
      print('Sign up response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Sign up successful: $responseData');
        return responseData;
      } else {
        final errorBody = response.body;
        print('Sign up failed with status ${response.statusCode}: $errorBody');
        throw Exception('Failed to sign up: $errorBody');
      }
    } catch (e) {
      print('Sign up error: $e');
      if (e.toString().contains('SocketException')) {
        throw Exception('Network connection failed. Please check your internet connection and make sure the web app is running.');
      }
      throw Exception('Network error: $e');
    }
  }

  // Sign in method
  static Future<Map<String, dynamic>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting to sign in with email: $email');
      print('API URL: ${ApiConfig.baseUrl}${ApiConfig.signInEndpoint}');
      
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.signInEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'usernameOrEmail': email,
          'password': password,
        }),
      ).timeout(
        Duration(milliseconds: ApiConfig.connectionTimeout),
      );

      print('Sign in response status: ${response.statusCode}');
      print('Sign in response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Sign in successful: $responseData');
        return responseData;
      } else {
        final errorBody = response.body;
        print('Sign in failed with status ${response.statusCode}: $errorBody');
        throw Exception('Failed to sign in: $errorBody');
      }
    } catch (e) {
      print('Sign in error: $e');
      if (e.toString().contains('SocketException')) {
        throw Exception('Network connection failed. Please check your internet connection and make sure the web app is running.');
      }
      throw Exception('Network error: $e');
    }
  }

  // Forgot password method
  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      print('Attempting to send password reset for email: $email');
      print('API URL: ${ApiConfig.baseUrl}${ApiConfig.forgotPasswordEndpoint}');
      
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.forgotPasswordEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email}),
      ).timeout(
        Duration(milliseconds: ApiConfig.connectionTimeout),
      );

      print('Forgot password response status: ${response.statusCode}');
      print('Forgot password response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Forgot password request successful: $responseData');
        return responseData;
      } else {
        final errorBody = response.body;
        print('Forgot password failed with status ${response.statusCode}: $errorBody');
        throw Exception('Failed to send password reset: $errorBody');
      }
    } catch (e) {
      print('Forgot password error: $e');
      if (e.toString().contains('SocketException')) {
        throw Exception('Network connection failed. Please check your internet connection and make sure the web app is running.');
      }
      throw Exception('Network error: $e');
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>> getUserProfile(String token) async {
    try {
      print('Attempting to get user profile');
      print('API URL: ${ApiConfig.baseUrl}${ApiConfig.userProfileEndpoint}');
      
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.userProfileEndpoint}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        Duration(milliseconds: ApiConfig.connectionTimeout),
      );

      print('Get profile response status: ${response.statusCode}');
      print('Get profile response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Get profile successful: $responseData');
        return responseData;
      } else {
        final errorBody = response.body;
        print('Get profile failed with status ${response.statusCode}: $errorBody');
        throw Exception('Failed to get profile: $errorBody');
      }
    } catch (e) {
      print('Get profile error: $e');
      if (e.toString().contains('SocketException')) {
        throw Exception('Network connection failed. Please check your internet connection and make sure the web app is running.');
      }
      throw Exception('Network error: $e');
    }
  }

  // Test connection method
  static Future<bool> testConnection() async {
    try {
      print('Testing connection to: ${ApiConfig.baseUrl}');
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/health'), // Assuming your web app has a health endpoint
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(
        Duration(milliseconds: 5000), // Shorter timeout for connection test
      );

      print('Connection test response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('Connection test failed: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.verifyOtpEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
        }),
      ).timeout(
        Duration(milliseconds: ApiConfig.connectionTimeout),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.resetPasswordEndpoint}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        }),
      ).timeout(
        Duration(milliseconds: ApiConfig.connectionTimeout),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Check if device is available and not already linked
  static Future<Map<String, dynamic>> checkDeviceAvailable(String serialNumber) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/devices/check'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'serial_number': serialNumber}),
      ).timeout(
        Duration(milliseconds: ApiConfig.connectionTimeout),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateProfile({
    required String userId,
    required String username,
    required String email,
    required String phone,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/api/auth/update-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'user_id': userId,
          'username': username,
          'email': email,
          'phone': phone,
        }),
      );
      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Fetch user profile
  static Future<Map<String, dynamic>> fetchUserProfile() async {
    try {
      final token = await AuthService.getToken();
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        Duration(milliseconds: ApiConfig.connectionTimeout),
      );
      return jsonDecode(response.body);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Verify current password
  static Future<Map<String, dynamic>> verifyCurrentPassword({
    required String token,
    required String currentPassword,
  }) async {
    try {
      print('Attempting to verify current password');
      print('API URL: ${ApiConfig.baseUrl}/auth/verify-password');
      
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/verify-password'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
        }),
      ).timeout(
        Duration(milliseconds: ApiConfig.connectionTimeout),
      );

      print('Verify password response status: ${response.statusCode}');
      print('Verify password response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Verify password successful: $responseData');
        return responseData;
      } else {
        final errorBody = response.body;
        print('Verify password failed with status ${response.statusCode}: $errorBody');
        throw Exception('Failed to verify password: $errorBody');
      }
    } catch (e) {
      print('Verify password error: $e');
      if (e.toString().contains('SocketException')) {
        throw Exception('Network connection failed. Please check your internet connection and make sure the web app is running.');
      }
      throw Exception('Network error: $e');
    }
  }
} 


