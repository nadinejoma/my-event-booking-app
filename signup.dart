import 'package:event_booking_app/services/auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isLoading = false;

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await AuthMethods().signInWithGoogle(context);
    } catch (e) {
      print("Error signing in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Error signing in: ${e.toString()}',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      );
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
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => _handleSignIn(context),
                child: Column(
                  children: [
                    Image.asset('images/onboarding.png'),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Unlock the Future of ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Event Booking App ',
                      style: TextStyle(
                        color: Color.fromARGB(255, 217, 112, 8),
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    const Text(
                      'Discover, book, and experience unforgettable moments effortlessly!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 23.0),
                    ),
                    const SizedBox(height: 30.0),
                    GestureDetector(
                      onTap: _isLoading ? null : () => _handleSignIn(context),
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: _isLoading 
                              ? Colors.grey 
                              : const Color.fromARGB(255, 217, 112, 8),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!_isLoading) Image.asset(
                              'images/google.png',
                              height: 30,
                              width: 30,
                              fit: BoxFit.cover,
                            ),
                            if (!_isLoading) const SizedBox(width: 10.0),
                            _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Sign in with Google',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
