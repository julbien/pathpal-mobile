import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DevicePage(),
    );
  }
}

class DevicePage extends StatelessWidget {
  const DevicePage({super.key});

  // Show link or edit dialog depending on isUpdate value
  void showLinkOrEditDialog(BuildContext context, {required bool isUpdate}) {
    showDialog(
      context: context,
      barrierDismissible: false, // Don't close when tapping outside
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog title
                Text(
                  isUpdate ? 'Update Device' : 'Link Device',
                  style: TextStyle(
                      color: Colors.blue[900], fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Device name input
                const Align(alignment: Alignment.centerLeft, child: Text("Device Name:")),
                const SizedBox(height: 4),
                const TextField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),

                const SizedBox(height: 12),

                // Serial number input (readonly if updating)
                const Align(alignment: Alignment.centerLeft, child: Text("Serial Number:")),
                const SizedBox(height: 4),
                TextField(
                  readOnly: isUpdate,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: isUpdate ? "PPSC-00001" : "Enter 5-digit number",
                    helperText: isUpdate ? null : "Enter 5-digit number (will be prefixed with PPSC-)",
                    fillColor: isUpdate ? Colors.grey.shade200 : null,
                    filled: isUpdate,
                  ),
                ),

                const SizedBox(height: 12),

                // User type dropdown
                const Align(alignment: Alignment.centerLeft, child: Text("User Type:")),
                const SizedBox(height: 4),
                DropdownButtonFormField<String>(
                  value: 'Admin',
                  items: const [
                    DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                    DropdownMenuItem(value: 'User', child: Text('User')),
                    DropdownMenuItem(value: 'Guest', child: Text('Guest')),
                  ],
                  onChanged: (_) {},
                  decoration: const InputDecoration(border: OutlineInputBorder()),
                ),

                const SizedBox(height: 20),

                // Cancel and Save buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(backgroundColor: Colors.grey),
                      child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showConfirmationDialog(context);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Show confirmation dialog before saving
  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning, color: Colors.orange, size: 48),
              const SizedBox(height: 16),
              const Text('Are you sure?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              const Text('Do you want to save this device?',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
              const SizedBox(height: 24),

              // No and Yes buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showSuccessDialog(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show confirmation before unlinking a device
  void showUnlinkConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.warning, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text('Are you sure?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              const Text('Do you really want to unlink this device?',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showPasswordDialog(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Ask for password before completing unlink
  void showPasswordDialog(BuildContext context) {
    TextEditingController passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter Password', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password'),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      showSuccessDialog(context);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Show success message after action is completed
  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 36),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Success', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text('Action completed successfully.', style: TextStyle(fontSize: 14)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // App bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue[900]),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Devices',
            style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold, fontSize: 20)),
      ),

      // Main body content
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          children: [
            // Header + Link button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('All Linked Devices',
                    style: TextStyle(fontSize: 14, color: Colors.black)),
                ElevatedButton.icon(
                  onPressed: () => showLinkOrEditDialog(context, isUpdate: false),
                  icon: const Icon(Icons.add, size: 18, color: Colors.white),
                  label: const Text('Link Device', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Example device card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Device info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Lolo Julio',
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      const SizedBox(height: 4),
                      const Text('PPSC-00001',
                          style: TextStyle(color: Colors.black54, fontSize: 13)),
                    ],
                  ),

                  // Edit and Unlink buttons
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => showLinkOrEditDialog(context, isUpdate: true),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[900]),
                        child: const Text('Edit', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () => showUnlinkConfirmationDialog(context),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Unlink', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
