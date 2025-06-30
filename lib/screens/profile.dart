import 'package:flutter/material.dart';
import 'change_password.dart'; // Make sure this path is correct

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Text controllers for input fields
  late final TextEditingController usernameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    // Sample default data
    usernameController = TextEditingController(text: "John Doe");
    emailController = TextEditingController(text: "john@example.com");
    phoneController = TextEditingController(text: "+123456789");
  }

  @override
  void dispose() {
    // Dispose controllers to avoid memory leaks
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with back button
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue[900]),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
            fontSize: 18,
          ),
        ),
      ),

      // Page content
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Profile picture with edit icon
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, size: 40, color: Colors.white),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.edit, color: Colors.white, size: 14),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Text('User Info', style: TextStyle(fontFamily: 'Poppins', fontSize: 16)),
            const SizedBox(height: 20),

            // Editable text fields
            buildEditableField('Username:', usernameController),
            const SizedBox(height: 15),
            buildEditableField('Email Address:', emailController),
            const SizedBox(height: 15),
            buildEditableField('Phone Number:', phoneController),
            const SizedBox(height: 30),

            // Change password button
            ElevatedButton(
              onPressed: () {
                // Navigate to Change Password screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              child: const Text(
                'Change Password',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable widget for editable fields
  Widget buildEditableField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'Poppins')),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.edit, color: Colors.blue),
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
