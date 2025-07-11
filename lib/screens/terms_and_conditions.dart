import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Terms and Conditions',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text(
                'Welcome to PathPal!\nBy using this app, you agree to the following terms. Please read them carefully.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text('1. Who Can Use PathPal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 6),
              Text('• Anyone who can operate and understand the app is allowed to use PathPal. There is no specific age limit as long as the user can responsibly use the features.'),
              Text('• You agree to use the app properly and not for any harmful or illegal purpose.'),
              SizedBox(height: 16),
              Text('2. Location and Emergency Features', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 6),
              Text('• Real-time location tracking works only when your device has signal and location services are enabled.'),
              Text('• The emergency message will only be sent if the device (e.g., a smart cane or phone) has an active mobile signal at the time of sending.'),
              Text('• PathPal cannot guarantee tracking or message delivery if the device has no signal or loses connection.'),
              SizedBox(height: 16),
              Text('3. Privacy and Data Use', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 6),
              Text('• Your personal information and location data are only used to provide the service.'),
              Text('• We do not share your personal data with third parties without your consent.'),
              Text('• You can request to delete your account and data at any time.'),
              SizedBox(height: 16),
              Text('4. Changes to the Service', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 6),
              Text('• PathPal may change or update features and policies at any time.'),
              Text('• We will notify users of major changes through the app.'),
              Text('• Continuing to use the app means you accept any updated terms.'),
              SizedBox(height: 16),
              Text('5. Limitation of Liability', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 6),
              Text('• We are not responsible for any delays, inconvenience, or harm caused by signal loss, inaccurate location, or failed emergency alerts.'),
              Text('• The app relies on the functionality of your device and network coverage.'),
              SizedBox(height: 16),
              Text('6. Contact Us', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 6),
              Text('If you have any questions or concerns, you may reach us at:'),
              Text('📧 support@pathpal.com'),
              Text('📞 (+63) 976-667-3179'),
              SizedBox(height: 20),
              Text(
                'By using PathPal, you agree to these Terms and Conditions.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 