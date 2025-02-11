import 'package:flutter/material.dart';
import 'auth.dart';

class SigninPage extends StatefulWidget {
  static const String routeName = '/login';
  const SigninPage({super.key});
  
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your email';
                  return null;
                },
                onChanged: (value) {
                  _email = value.trim();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter your password';
                  return null;
                },
                onChanged: (value) {
                  _password = value.trim();
                },
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _setLoading(true);
                          await _auth.signInWithEmailAndPassword(_email, _password, context);
                          _setLoading(false);
                        }
                      },
                      child: const Text('Sign In'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
