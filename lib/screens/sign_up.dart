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
  final _captchaController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  final FocusNode _passwordFocusNode = FocusNode();
  bool _showPasswordRequirements = false;
  int _captchaNum1 = 0;
  int _captchaNum2 = 0;

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
    final random = Random();
    setState(() {
      _captchaNum1 = random.nextInt(10) + 1;
      _captchaNum2 = random.nextInt(10) + 1;
      _captchaController.clear();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    _captchaController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    final userAnswer = int.tryParse(_captchaController.text);
    if (userAnswer == null || userAnswer != (_captchaNum1 + _captchaNum2)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Incorrect captcha answer. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
      _generateCaptcha();
      return;
    }

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

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.signUp(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        password: _passwordController.text,
      );

      // Save user data and token
      if (response['token'] != null) {
        await AuthService.saveToken(response['token']);
        await AuthService.saveUserData(
          userId: response['user']['id'] ?? '',
          email: response['user']['email'] ?? '',
        );

        if (mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully!'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Safe padding around the screen
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Logo at the top
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

                  // Welcome texts
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

                  // Username field
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

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
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

                  // Phone number field
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

                  // Password field
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) {
                        return 'Password must contain a lowercase letter';
                      }
                      if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
                        return 'Password must contain an uppercase letter';
                      }
                      if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
                        return 'Password must contain a number';
                      }
                      if (!RegExp(r'(?=.*[!@#\$%^&*(),.?":{}|<>])').hasMatch(value)) {
                        return 'Password must contain a special character';
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
                  const SizedBox(height: 8),
                  if (_showPasswordRequirements)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Password must contain:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text('• At least 8 characters'),
                          Text('• At least one uppercase letter (A-Z)'),
                          Text('• At least one lowercase letter (a-z)'),
                          Text('• At least one number (0-9)'),
                          Text('• At least one special character (!@#\$%^&*)'),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Captcha
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'What is $_captchaNum1 + $_captchaNum2 ?',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
                          controller: _captchaController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Answer',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Terms and conditions
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
                            style: const TextStyle(color: Colors.black54),
                            children: [
                              TextSpan(
                                text: 'Terms and Conditions',
                                style: const TextStyle(
                                  color: Color(0xFF0057B8),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TermsAndConditionsScreen()),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Sign Up button
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

                  // Link to go back to login page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Sign In here',
                          style: TextStyle(
                            color: Color(0xFF0057B8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
