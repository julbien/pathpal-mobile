class ApiConfig {
  // IMPORTANT: Palitan mo ito ng URL ng web app mo
  // 
  // Para sa development:
  // 1. Kung Android emulator gamit mo: http://10.0.2.2:3000/api
  // 2. Kung physical device sa same network: http://[IP_ADDRESS]:3000/api
  // 3. Para malaman ang IP address ng computer mo:
  //    - Windows: ipconfig sa Command Prompt
  //    - Mac/Linux: ifconfig sa Terminal
  // 
  // Para sa production:
  // - Gamitin ang actual domain ng web app mo
  
  // Development URLs (uncomment the one you need)
  
  // For Android emulator (most common for development)
  static const String baseUrl = 'http://192.168.18.10:3000/api/auth';
  
  // For physical device on same network (replace with your computer's IP)
  // static const String baseUrl = 'http://192.168.1.100:3000/api';
  
  // For iOS simulator
  // static const String baseUrl = 'http://localhost:3000/api';
  
  // For production (replace with your actual domain)
  // static const String baseUrl = 'https://yourdomain.com/api';
  
  // API endpoints - make sure these match your web app's endpoints
  static const String signUpEndpoint = '/register';
  static const String signInEndpoint = '/login';
  static const String userProfileEndpoint = '/profile';
  static const String forgotPasswordEndpoint = '/forgot-password/';
  static const String verifyOtpEndpoint = '/verify-otp';
  static const String resetPasswordEndpoint = '/reset-password';
  static const String healthEndpoint = '/health'; // Optional: for connection testing
  
  // Timeout settings
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  
  // Debug mode - set to true to see detailed API logs
  static const bool debugMode = true;
} 