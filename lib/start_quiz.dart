import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiz_app/auth/live_quizservice.dart';

import 'package:quiz_app/login.dart';
import 'package:quiz_app/quiz_created.dart';

class StartQuizCodeScreen extends StatefulWidget {
  const StartQuizCodeScreen({super.key});

  @override
  State<StartQuizCodeScreen> createState() => _StartQuizCodeScreenState();
}

class _StartQuizCodeScreenState extends State<StartQuizCodeScreen> {
  // --- STATE ---
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _codeController.dispose();

    super.dispose();
  }

  Future<void> _saveQuizAndHost() async {
    if (_codeController.text.trim().isEmpty) {
      _showErrorDialog('Code cannot be empty.');
      return;
    }

    try {
      final sessionData = await LiveSessionService.instance.createSession(
        quizId: _codeController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => HostLobbyScreen(
              sessionId: sessionData['sessionId'],
              hostKey: sessionData['hostKey'],
              joinCode: sessionData['code'],
            ),
          ),
        );
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  // --- UI FEEDBACK ---
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Failed to Join'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return QuizPageTemplate(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Start a Game',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                TextFormField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    hintText: 'Enter quiz id',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return "Code cannot be empty.";
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveQuizAndHost,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : const Text('START', style: TextStyle(fontSize: 17)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
