import 'dart:math';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/terms_and_conditions.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import 'dashboard.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  final FocusNode _passwordFocusNode = FocusNode();
  bool _showPasswordRequirements = false;
  int _num1 = 0;
  int _num2 = 0;
  int _mathAnswer = 0;
  final TextEditingController _captchaController = TextEditingController();
  String? _captchaError;
  bool _showSuccessBanner = false;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode.addListener(() {
      setState(() {
        _showPasswordRequirements = _passwordFocusNode.hasFocus;
      });
    });
    _generateCaptcha();
  }

  void _generateCaptcha() {
    final rand = Random();
    _num1 = rand.nextInt(10) + 1;
    _num2 = rand.nextInt(10) + 1;
    _mathAnswer = _num1 + _num2;
    _captchaController.clear();
    setState(() {
      _captchaError = null;
    });
  }

  @override
  void dispose() {
    _captchaController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must agree to the terms and conditions.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (int.tryParse(_captchaController.text) != _mathAnswer) {
      setState(() {
        _captchaError = 'Incorrect answer. Please try again.';
      });
      _generateCaptcha();
      return;
    }
    setState(() {
      _isLoading = true;
      _captchaError = null;
    });
    try {
      final response = await ApiService.signUp(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
      );
      if (response['token'] != null) {
        await AuthService.saveToken(response['token']);
        
        // Debug: Print the response to see the structure
        print('Signup response: $response');
        print('User data in response: ${response['user']}');
        
        // Always use the phone number from the form, regardless of API response
        String phoneNumber = _phoneController.text.trim();
        
        // Check if API returned a different phone number (in case it was formatted)
        if (response['user']?['phone'] != null) {
          phoneNumber = response['user']['phone'].toString();
        } else if (response['user']?['phone_number'] != null) {
          phoneNumber = response['user']['phone_number'].toString();
        } else if (response['user']?['phoneNumber'] != null) {
          phoneNumber = response['user']['phoneNumber'].toString();
        }
        
        print('Phone number from form: ${_phoneController.text.trim()}');
        print('Phone number from API: ${response['user']?['phone']}');
        print('Phone number to save: $phoneNumber');
        
        await AuthService.saveUserData(
          userId: response['user']['id'] ?? '',
          email: response['user']['email'] ?? '',
          username: response['user']['username'] ?? _usernameController.text.trim(),
          phone: phoneNumber,
        );
        
        // Verify the data was saved
        final savedData = await AuthService.getUserData();
        print('Saved user data: $savedData');
        if (mounted) {
          setState(() {
            _showSuccessBanner = true;
          });
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            setState(() {
              _showSuccessBanner = false;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  bool _isPasswordValid(String password) {
    return password.length >= 8 &&
           RegExp(r'(?=.*[a-z])').hasMatch(password) &&
           RegExp(r'(?=.*[A-Z])').hasMatch(password) &&
           RegExp(r'(?=.*[0-9])').hasMatch(password) &&
           RegExp(r'(?=.*[!@#\$%^&*(),.?":{}|<>])').hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF0057B8)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0057B8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your account',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter username';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Email Address',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    focusNode: _passwordFocusNode,
                    onChanged: (value) {
                      setState(() {
                        // Trigger rebuild to update password requirements text
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (!_isPasswordValid(value)) {
                        return 'Password does not meet requirements';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  if (_passwordController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Password must be at least 8 characters with uppercase, lowercase, number, and special character.',
                        style: TextStyle(
                          color: _isPasswordValid(_passwordController.text) ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _captchaController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Answer required';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: '$_num1 + $_num2 = ?',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: _generateCaptcha,
                      ),
                    ],
                  ),
                  if (_captchaError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _captchaError!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeToTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeToTerms = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'I agree to the ',
                            style: const TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Terms and Conditions',
                                style: const TextStyle(
                                  color: Color(0xFF0057B8),
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const TermsAndConditionsScreen(),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0057B8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleSignUp,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Sign Up',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_showSuccessBanner)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Center(
                  child: Text(
                    'Account created successfully!',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}