import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        backgroundColor: const Color(0xFF0057B8),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last updated: ${'2023-10-27'}', // Placeholder Date
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please read these terms and conditions carefully before using Our Service.',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('1. Interpretation and Definitions'),
            _buildSectionContent(
              'The words of which the initial letter is capitalized have meanings defined under the following conditions. The following definitions shall have the same meaning regardless of whether they appear in singular or in plural.'
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('2. Acknowledgment'),
            _buildSectionContent(
              'These are the Terms and Conditions governing the use of this Service and the agreement that operates between You and the Company. These Terms and Conditions set out the rights and obligations of all users regarding the use of the Service.'
            ),
             const SizedBox(height: 24),
            _buildSectionTitle('3. User Accounts'),
            _buildSectionContent(
              'When You create an account with Us, You must provide Us information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms, which may result in immediate termination of Your account on Our Service.'
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('4. Termination'),
            _buildSectionContent(
              'We may terminate or suspend Your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if You breach these Terms and Conditions.'
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSectionContent(String content) {
    return Text(
      content,
      style: const TextStyle(fontSize: 16, height: 1.5),
    );
  }
} 