import 'package:flutter/material.dart';

class HowToPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('How To')),
      body: Center(
        child: Text(
          'This is the How To Page',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
