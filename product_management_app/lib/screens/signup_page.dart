import 'package:flutter/material.dart';
import '../service/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        backgroundColor: const Color(0xFFD8A7B8),  
      ),
      body: Container(
        width: double.infinity,  
        height: double.infinity,  
        decoration: const BoxDecoration(
          color: Color(0xFFF6E6E9),  
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Your Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA1887F), 
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Color(0xFFA1887F)), 
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,  
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Color(0xFFA1887F)),  
                  border: OutlineInputBorder(),
                  fillColor: Colors.white,
                  filled: true,  
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _authService.signUp(emailController.text, passwordController.text);
                    Navigator.pushReplacementNamed(context, '/login');  
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD8A7B8),  
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');  // ไปที่หน้าล็อกอิน
                  },
                  child: const Text(
                    "Already have an account? Login",
                    style: TextStyle(color: Color(0xFFD8A7B8)),  
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
