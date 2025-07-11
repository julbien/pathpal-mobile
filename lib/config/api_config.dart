class ApiConfig {
  // Set this to your web app's API URL
  static const String baseUrl = 'http://192.168.1.16:3000/api/auth';

  static const String signUpEndpoint = '/register';
  static const String signInEndpoint = '/login';
  static const String userProfileEndpoint = '/profile';
  static const String forgotPasswordEndpoint = '/forgot-password/';
  static const String verifyOtpEndpoint = '/verify-otp';
  static const String resetPasswordEndpoint = '/reset-password';
  static const String healthEndpoint = '/health'; // Placeholder for connection testing

  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const bool debugMode = true;
} 