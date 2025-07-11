import 'package:flutter/material.dart';
import 'change_password.dart';
import '../services/auth_service.dart'; // Added import for AuthService

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  bool _isEditing = false;
  bool _showSuccessBanner = false;
  String? _errorMessage;
  late String _originalUsername;
  late String _originalEmail;
  late String _originalPhone;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    _originalUsername = '';
    _originalEmail = '';
    _originalPhone = '';
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await AuthService.getUserData();
    print('Loaded user data:');
    print('Username: \'${userData['username']}\'');
    print('Email: \'${userData['email']}\'');
    print('Phone: \'${userData['phone']}\'');
    setState(() {
      usernameController.text = userData['username'] ?? '';
      emailController.text = userData['email'] ?? '';
      phoneController.text = userData['phone'] ?? '';
      _originalUsername = userData['username'] ?? '';
      _originalEmail = userData['email'] ?? '';
      _originalPhone = userData['phone'] ?? '';
    });
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void _handleSaveProfile() {
    setState(() {
      _originalUsername = usernameController.text;
      _originalEmail = emailController.text;
      _originalPhone = phoneController.text;
      _isEditing = false;
      _showSuccessBanner = true;
      _errorMessage = null;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showSuccessBanner = false;
        });
      }
    });
  }

  void _handleCancelEdit() {
    setState(() {
      usernameController.text = _originalUsername;
      emailController.text = _originalEmail;
      phoneController.text = _originalPhone;
      _isEditing = false;
      _errorMessage = null;
    });
  }

  Widget buildEditableField(String label, TextEditingController controller, {bool readOnly = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue[900]),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Color(0xFF0057B8),
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text('User Info', style: TextStyle(fontFamily: 'Poppins', fontSize: 16)),
                const SizedBox(height: 20),
                buildEditableField('Username:', usernameController, readOnly: !_isEditing),
                const SizedBox(height: 15),
                buildEditableField('Email Address:', emailController, readOnly: !_isEditing),
                const SizedBox(height: 15),
                buildEditableField('Phone Number:', phoneController, readOnly: !_isEditing),
                const SizedBox(height: 15),
                if (_isEditing)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _handleSaveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _handleCancelEdit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: const Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (_errorMessage != null)
                  Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                ElevatedButton(
                  onPressed: () {
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
                    'Profile updated successfully!',
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