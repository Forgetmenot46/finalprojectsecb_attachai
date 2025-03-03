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
  bool _obscurePassword = true;

  void _setLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'เข้าสู่ระบบ / สมัครสมาชิก',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(3, 70, 148, 1),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'อีเมล',
                        prefixIcon: Icon(Icons.email,
                            color: Color.fromRGBO(3, 70, 148, 1)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(3, 70, 148, 1), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกอีเมล';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'กรุณากรอกอีเมลให้ถูกต้อง';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _email = value.trim();
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'รหัสผ่าน',
                        prefixIcon: Icon(Icons.lock,
                            color: Color.fromRGBO(3, 70, 148, 1)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Color.fromRGBO(3, 70, 148, 1),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(3, 70, 148, 1), width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณากรอกรหัสผ่าน';
                        }
                        if (value.length < 6) {
                          return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        _password = value.trim();
                      },
                    ),
                    SizedBox(height: 30),
                    if (_isLoading)
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromRGBO(3, 70, 148, 1)),
                      )
                    else
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _setLoading(true);
                                  try {
                                    await _auth.signInWithEmailAndPassword(
                                        _email, _password, context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('เข้าสู่ระบบไม่สำเร็จ: $e'),
                                        backgroundColor: const Color.fromARGB(
                                            255, 255, 255, 255),
                                      ),
                                    );
                                  } finally {
                                    _setLoading(false);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(3, 70, 148, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                'เข้าสู่ระบบ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _setLoading(true);
                                  try {
                                    await _auth.registerWithEmailAndPassword(
                                        _email, _password, context);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('สมัครสมาชิกไม่สำเร็จ: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  } finally {
                                    _setLoading(false);
                                  }
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: Color.fromRGBO(3, 70, 148, 1),
                                    width: 2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'สมัครสมาชิก',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(3, 70, 148, 1),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          TextButton(
                            onPressed: () async {
                              if (_email.isNotEmpty) {
                                _setLoading(true);
                                try {
                                  await _auth.resetPassword(_email, context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'ส่งลิงก์รีเซ็ตรหัสผ่านไปที่อีเมลของคุณแล้ว'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('รีเซ็ตรหัสผ่านไม่สำเร็จ: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                } finally {
                                  _setLoading(false);
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('กรุณากรอกอีเมล์ก่อน'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              'ลืมรหัสผ่าน?',
                              style: TextStyle(
                                color: Color.fromRGBO(3, 70, 148, 1),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
