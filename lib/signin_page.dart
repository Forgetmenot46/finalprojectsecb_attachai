import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//เรียกใช้หน้า auth.dart
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
      appBar: AppBar(
        title: const Text('Login / Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
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
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _password = value.trim();
                  },
                ),
                const SizedBox(height: 16),
                if (_isLoading)
                  const CircularProgressIndicator() // แสดง Loading Indicator
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _setLoading(true);
                            try {
                              await _auth.signInWithEmailAndPassword(
                                  _email, _password, context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Login failed: $e'),
                                ),
                              );
                            } finally {
                              _setLoading(false);
                            }
                          }
                        },
                        child: const Text('Sign In'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _setLoading(true);
                            try {
                              await _auth.registerWithEmailAndPassword(
                                  _email, _password, context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Sign up failed: $e'),
                                ),
                              );
                            } finally {
                              _setLoading(false);
                            }
                          }
                        },
                        child: const Text('Sign Up'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_email.isNotEmpty) {
                            _setLoading(true);
                            try {
                              // เรียกใช้ฟังก์ชัน resetPassword จาก AuthService
                              await _auth.resetPassword(_email, context);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Reset password failed: $e'),
                                ),
                              );
                            } finally {
                              _setLoading(false);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('กรุณากรอกอีเมล์ก่อน'),
                              ),
                            );
                          }
                        },
                        child: const Text('Forget My Password'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
