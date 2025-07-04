import 'package:flutter/material.dart';
import 'api_service.dart';
import '../config/api_config.dart';

class ConnectionTest {
  // Test connection to web app
  static Future<bool> testWebAppConnection(BuildContext context) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text('Testing connection to web app...'),
              ],
            ),
          );
        },
      );

      // Test connection
      final isConnected = await ApiService.testConnection();
      
      // Hide loading dialog
      Navigator.of(context).pop();

      if (isConnected) {
        _showSuccessDialog(context);
        return true;
      } else {
        _showErrorDialog(context);
        return false;
      }
    } catch (e) {
      // Hide loading dialog
      Navigator.of(context).pop();
      _showErrorDialog(context, error: e.toString());
      return false;
    }
  }

  static void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connection Successful!'),
          content: Text('Successfully connected to web app at:\n${ApiConfig.baseUrl}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void _showErrorDialog(BuildContext context, {String? error}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Connection Failed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Unable to connect to web app.'),
              const SizedBox(height: 10),
              Text('Current URL: ${ApiConfig.baseUrl}'),
              const SizedBox(height: 10),
              const Text('Please check:'),
              const Text('• Web app is running'),
              const Text('• URL is correct'),
              const Text('• Network connection'),
              if (error != null) ...[
                const SizedBox(height: 10),
                Text('Error: $error'),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Get network info for debugging
  static String getNetworkInfo() {
    return '''
Network Configuration:
Base URL: ${ApiConfig.baseUrl}
Sign Up Endpoint: ${ApiConfig.signUpEndpoint}
Sign In Endpoint: ${ApiConfig.signInEndpoint}
User Profile Endpoint: ${ApiConfig.userProfileEndpoint}
Connection Timeout: ${ApiConfig.connectionTimeout}ms
Debug Mode: ${ApiConfig.debugMode}
''';
  }
} 

// git clone https://github.com/julbien/PathPal-Flutter.git