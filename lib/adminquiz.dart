import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_app/admin_page.dart';

import 'package:quiz_app/login.dart'; // ✨ ADD THIS IMPORT

class Adminquiz extends StatelessWidget {
  final String joinCode;

  const Adminquiz({super.key, required this.joinCode});

  // --- UI BUILD (UPDATED FOR CONSISTENCY) ---
  @override
  Widget build(BuildContext context) {
    // ✨ CHANGED HERE: Replaced Scaffold with QuizPageTemplate
    return QuizPageTemplate(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildJoinCodeCard(context),
            const SizedBox(height: 24),

            _buildStartButton(context),
          ],
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---
  Widget _buildJoinCodeCard(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Use this code to Start:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  joinCode,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy, color: Colors.grey),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: joinCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Code copied!")),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.play_arrow),
      label: const Text("Home"),
      onPressed: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AdminPage()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        disabledBackgroundColor: Colors.grey.shade600,
      ),
    );
  }
}
