import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/create_new_password.dart';
import '../services/api_service.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  const OTPVerificationScreen({super.key, required this.email});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerifyOTP() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await ApiService.verifyOtp(
        email: widget.email,
        otp: _otpController.text,
      );
      if (mounted) {
        if (response['success'] == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateNewPasswordScreen(email: widget.email, otp: _otpController.text),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response['message'] ?? 'Invalid OTP'}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: ${e.toString()}'),
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
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('An OTP has been sent to ${widget.email}. Please enter it below.'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                validator: (value) {
                  if (value == null || value.length < 4) {
                    return 'Please enter the 4-digit OTP';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'OTP',
                  counterText: '',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleVerifyOTP,
                child: _isLoading ? const CircularProgressIndicator() : const Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 