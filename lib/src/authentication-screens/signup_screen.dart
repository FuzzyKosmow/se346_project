import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:se346_project/src/authentication-screens/detail_signup_screen.dart';
import 'package:se346_project/src/data/global_data.dart' as globals;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _loginForm = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  final dio = Dio();

  void _submit() async {
    final response = await dio
        .get("${globals.baseUrl}/user/checkEmail/${_emailTextController.text}");

    if (response.toString() == 'Email already exists' && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email already exists'),
          // backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DetailSignUpScreen(
            email: _emailTextController.text,
            password: _passwordTextController.text,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4CA414),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Let\'s get started!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create a new account and start your journey.',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              _buildLoginForm(),
              const SizedBox(
                height: 40,
              ),
              _buildAnimatedButton(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text.rich(
                  TextSpan(
                    style: TextStyle(color: Colors.white),
                    children: [
                      TextSpan(text: 'Already have an account? '),
                      TextSpan(
                          text: 'Sign In.',
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginForm,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Email',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _emailTextController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintText: 'Enter your email',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Your email format is incorrect';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Password',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _passwordTextController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintText: 'Enter your password',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Confirm Password',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _confirmPasswordTextController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintText: 'Confirm your password',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordTextController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedButton() {
    return GestureDetector(
      onTap: () {
        if (_loginForm.currentState!.validate()) {
          _submit();
        }
      },
      child: Container(
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF3C7C0C),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Sign Up",
                style: TextStyle(
                  letterSpacing: 3,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
